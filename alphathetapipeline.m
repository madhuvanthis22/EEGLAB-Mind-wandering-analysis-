clearvars;
clc;

% -------------------------
% FILES
% -------------------------
epoched_file = 'JD0802_epochedandcleanedwithICA.bdf.set';
label_file   = 'JD0802_labels.mat';

% -------------------------
% LOAD CLEAN FULL EPOCHED DATASET
% -------------------------
EEG = pop_loadset('filename', epoched_file);

EEG.icaact = [];
EEG = eeg_checkset(EEG);

load(label_file, 'response_labels', 'condition_labels');

% -------------------------
% CHECK STEP
% -------------------------
fprintf('EEG trials: %d\n', EEG.trials);
fprintf('Response labels: %d\n', length(response_labels));
fprintf('Condition labels: %d\n', length(condition_labels));

if EEG.trials ~= length(response_labels) || EEG.trials ~= length(condition_labels)
    error('Mismatch between EEG trials and label vectors.');
end

% -------------------------
% DEFINE 6 CONDITIONS
% -------------------------
massed_on  = find(condition_labels == 1 & response_labels == 31);
massed_imw = find(condition_labels == 1 & response_labels == 32);
massed_umw = find(condition_labels == 1 & response_labels == 33);

spaced_on  = find(condition_labels == 2 & response_labels == 31);
spaced_imw = find(condition_labels == 2 & response_labels == 32);
spaced_umw = find(condition_labels == 2 & response_labels == 33);

fprintf('\n==== Trial Counts ====\n');
fprintf('Massed On-task: %d\n', length(massed_on));
fprintf('Massed IMW:     %d\n', length(massed_imw));
fprintf('Massed UMW:     %d\n', length(massed_umw));
fprintf('Spaced On-task: %d\n', length(spaced_on));
fprintf('Spaced IMW:     %d\n', length(spaced_imw));
fprintf('Spaced UMW:     %d\n', length(spaced_umw));
fprintf('======================\n\n');

% -------------------------
% CHANNEL INDICES
% -------------------------
Fz_index  = find(strcmp({EEG.chanlocs.labels}, 'Fz'));
FCz_index = find(strcmp({EEG.chanlocs.labels}, 'FCz'));
Pz_index  = find(strcmp({EEG.chanlocs.labels}, 'Pz'));
POz_index = find(strcmp({EEG.chanlocs.labels}, 'POz'));

fprintf('Channel indices found: Fz=%d, FCz=%d, Pz=%d, POz=%d\n', ...
    Fz_index, FCz_index, Pz_index, POz_index);

% -------------------------
% TIME WINDOW: -5 to 0 SEC
% -------------------------
fs = EEG.srate;

% EEG.xmin should be -5 and EEG.xmax should be +7 for my epoched dataset
fprintf('Epoch limits: xmin = %.3f sec, xmax = %.3f sec\n', EEG.xmin, EEG.xmax);

timevec = linspace(EEG.xmin, EEG.xmax, EEG.pnts);
time_idx = find(timevec >= -5 & timevec <= 0);

fprintf('Selected %d time points for -5 to 0 sec window\n', length(time_idx));

% -------------------------
% COMPUTE POWER FOR A CONDITION
% -------------------------
% Lets store NaN if a condition has 0 trials
theta = struct();
alpha = struct();

condition_names = {'massed_on','massed_imw','massed_umw', ...
                   'spaced_on','spaced_imw','spaced_umw'};

condition_trials = {massed_on, massed_imw, massed_umw, ...
                    spaced_on, spaced_imw, spaced_umw};

for c = 1:length(condition_names)

    cond_name = condition_names{c};
    trials = condition_trials{c};

    if isempty(trials)
        fprintf('[INFO] %s has 0 trials -> setting NaN\n', cond_name);
        theta.(cond_name) = NaN;
        alpha.(cond_name) = NaN;
        continue;
    end

    % -------- THETA: Fz, FCz --------
    data_theta = EEG.data([Fz_index FCz_index], time_idx, trials);

    % reshape to [channels x all_timepoints_across_trials]
    data_theta = reshape(data_theta, size(data_theta,1), []);

    [pxx_theta, f_theta] = pwelch(data_theta', [], [], [], fs);

    theta_band = f_theta >= 4 & f_theta <= 8;
    theta_val = mean(mean(pxx_theta(theta_band, :)));

    % -------- ALPHA: Pz, POz --------
    data_alpha = EEG.data([Pz_index POz_index], time_idx, trials);

    data_alpha = reshape(data_alpha, size(data_alpha,1), []);

    [pxx_alpha, f_alpha] = pwelch(data_alpha', [], [], [], fs);

    alpha_band = f_alpha >= 8 & f_alpha <= 12;
    alpha_val = mean(mean(pxx_alpha(alpha_band, :)));

    theta.(cond_name) = theta_val;
    alpha.(cond_name) = alpha_val;

    fprintf('[DONE] %s -> Theta: %.4f | Alpha: %.4f\n', ...
        cond_name, theta_val, alpha_val);
end

% -------------------------
% DISPLAY RESULTS
% -------------------------
fprintf('\n==== FINAL THETA RESULTS ====\n');
disp(theta)

fprintf('\n==== FINAL ALPHA RESULTS ====\n');
disp(alpha)

% -------------------------
% SAVE RESULTS
% -------------------------
save('JD0802_theta_alpha_results.mat', 'theta', 'alpha', ...
     'massed_on', 'massed_imw', 'massed_umw', ...
     'spaced_on', 'spaced_imw', 'spaced_umw');

fprintf('\nResults saved successfully.\n');

trial_counts = struct();

trial_counts.massed_on  = length(massed_on);
trial_counts.massed_imw = length(massed_imw);
trial_counts.massed_umw = length(massed_umw);

trial_counts.spaced_on  = length(spaced_on);
trial_counts.spaced_imw = length(spaced_imw);
trial_counts.spaced_umw = length(spaced_umw);

save('JD0802_theta_alpha_results.mat', ...
     'theta', 'alpha', 'trial_counts', ...
     'massed_on', 'massed_imw', 'massed_umw', ...
     'spaced_on', 'spaced_imw', 'spaced_umw');
