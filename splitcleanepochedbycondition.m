clearvars;
clc;

% -------- FILE NAMES --------
epoched_file = 'JD0802_epochedandcleanedwithICA.bdf.set';
label_file   = 'JD0802_labels.mat';

% -------- LOAD CLEAN EPOCHED DATASET --------
EEG = pop_loadset('filename', epoched_file);

EEG.icaact = [];
EEG = eeg_checkset(EEG);

% -------- LOAD LABELS --------
load(label_file, 'response_labels', 'condition_labels');

% -------- SANITY CHECK --------
fprintf('EEG trials: %d\n', EEG.trials);
fprintf('Response labels: %d\n', length(response_labels));
fprintf('Condition labels: %d\n', length(condition_labels));

if EEG.trials ~= length(response_labels) || EEG.trials ~= length(condition_labels)
    error('Mismatch between EEG trials and label vectors.');
end

% -------- DEFINE INDICES --------
massed_on  = find(condition_labels == 1 & response_labels == 31);
massed_imw = find(condition_labels == 1 & response_labels == 32);
massed_umw = find(condition_labels == 1 & response_labels == 33);

spaced_on  = find(condition_labels == 2 & response_labels == 31);
spaced_imw = find(condition_labels == 2 & response_labels == 32);
spaced_umw = find(condition_labels == 2 & response_labels == 33);

% -------- PRINT COUNTS --------
fprintf('\n==== Trial Counts ====\n');
fprintf('Massed On-task: %d\n', length(massed_on));
fprintf('Massed IMW:     %d\n', length(massed_imw));
fprintf('Massed UMW:     %d\n', length(massed_umw));
fprintf('Spaced On-task: %d\n', length(spaced_on));
fprintf('Spaced IMW:     %d\n', length(spaced_imw));
fprintf('Spaced UMW:     %d\n', length(spaced_umw));
fprintf('======================\n\n');

% -------- SAFE SPLITTING --------

if isempty(massed_on)
    fprintf('[INFO] JD0802_massed_on.set → 0 trials (NOT saved)\n');
else
    EEG_massed_on = pop_select(EEG, 'trial', massed_on);
    pop_saveset(EEG_massed_on, 'filename', 'JD0802_massed_on.set');
    fprintf('[SAVED] JD0802_massed_on.set → %d trials\n', length(massed_on));
end

if isempty(massed_imw)
    fprintf('[INFO] JD0802_massed_imw.set → 0 trials (NOT saved)\n');
else
    EEG_massed_imw = pop_select(EEG, 'trial', massed_imw);
    pop_saveset(EEG_massed_imw, 'filename', 'JD0802_massed_imw.set');
    fprintf('[SAVED] JD0802_massed_imw.set → %d trials\n', length(massed_imw));
end

if isempty(massed_umw)
    fprintf('[INFO] JD0802_massed_umw.set → 0 trials (NOT saved)\n');
else
    EEG_massed_umw = pop_select(EEG, 'trial', massed_umw);
    pop_saveset(EEG_massed_umw, 'filename', 'JD0802_massed_umw.set');
    fprintf('[SAVED] JD0802_massed_umw.set → %d trials\n', length(massed_umw));
end

if isempty(spaced_on)
    fprintf('[INFO] JD0802_spaced_on.set → 0 trials (NOT saved)\n');
else
    EEG_spaced_on = pop_select(EEG, 'trial', spaced_on);
    pop_saveset(EEG_spaced_on, 'filename', 'JD0802_spaced_on.set');
    fprintf('[SAVED] JD0802_spaced_on.set → %d trials\n', length(spaced_on));
end

if isempty(spaced_imw)
    fprintf('[INFO] JD0802_spaced_imw.set → 0 trials (NOT saved)\n');
else
    EEG_spaced_imw = pop_select(EEG, 'trial', spaced_imw);
    pop_saveset(EEG_spaced_imw, 'filename', 'JD0802_spaced_imw.set');
    fprintf('[SAVED] JD0802_spaced_imw.set → %d trials\n', length(spaced_imw));
end

if isempty(spaced_umw)
    fprintf('[INFO] JD0802_spaced_umw.set → 0 trials (NOT saved)\n');
else
    EEG_spaced_umw = pop_select(EEG, 'trial', spaced_umw);
    pop_saveset(EEG_spaced_umw, 'filename', 'JD0802_spaced_umw.set');
    fprintf('[SAVED] JD0802_spaced_umw.set → %d trials\n', length(spaced_umw));
end

fprintf('\nAll splitting complete.\n');

% --------------

clearvars;
clc;


epoched_file_block1 = 'ST2604_block1_epochedandcleanedwithICA.bdf.set';
epoched_file_block2 = 'ST2604_block2_epochedandcleanedwithICA.bdf.set';

% Load block 1
EEG1 = pop_loadset('filename', epoched_file_block1);
EEG1.icaact = [];
EEG1 = eeg_checkset(EEG1);

% Load block 2
EEG2 = pop_loadset('filename', epoched_file_block2);
EEG2.icaact = [];
EEG2 = eeg_checkset(EEG2);

fprintf('Block 1 epochs: %d\n', EEG1.trials);
fprintf('Block 2 epochs: %d\n', EEG2.trials);

% Append epoched datasets
EEG = pop_mergeset(EEG1, EEG2);

EEG.icaact = [];
EEG = eeg_checkset(EEG);

fprintf('Combined epochs: %d\n', EEG.trials);

% Check labels match
load('ST2604_labels.mat', 'response_labels', 'condition_labels');

fprintf('Labels: %d\n', length(response_labels));

if EEG.trials ~= length(response_labels) || EEG.trials ~= length(condition_labels)
    error('Mismatch: combined EEG epochs do not match combined label count.');
end

pop_saveset(EEG, 'filename', 'ST2604_epochedandcleanedwithICA_COMBINED.set');

fprintf('\nSaved combined clean epoched dataset.\n');


% --------------

clearvars;
clc;


% =========================
% FILE NAMES
% =========================
epoched_file = 'ST2604_epochedandcleanedwithICA_COMBINED.set';
label_file   = 'ST2604_labels.mat';

% =========================
% LOAD COMBINED CLEAN EPOCHED DATASET
% =========================
EEG = pop_loadset('filename', epoched_file);

EEG.icaact = [];
EEG = eeg_checkset(EEG);

% =========================
% LOAD COMBINED LABELS
% =========================
load(label_file, 'response_labels', 'condition_labels');

% =========================
% SANITY CHECK
% =========================
fprintf('EEG trials: %d\n', EEG.trials);
fprintf('Response labels: %d\n', length(response_labels));
fprintf('Condition labels: %d\n', length(condition_labels));

if EEG.trials ~= length(response_labels) || EEG.trials ~= length(condition_labels)
    error('Mismatch between EEG trials and label vectors.');
end

% =========================
% DEFINE 6 CONDITION INDICES
% =========================
massed_on  = find(condition_labels == 1 & response_labels == 31);
massed_imw = find(condition_labels == 1 & response_labels == 32);
massed_umw = find(condition_labels == 1 & response_labels == 33);

spaced_on  = find(condition_labels == 2 & response_labels == 31);
spaced_imw = find(condition_labels == 2 & response_labels == 32);
spaced_umw = find(condition_labels == 2 & response_labels == 33);

% =========================
% PRINT COUNTS
% =========================
fprintf('\n==== Trial Counts ====\n');
fprintf('Massed On-task: %d\n', length(massed_on));
fprintf('Massed IMW:     %d\n', length(massed_imw));
fprintf('Massed UMW:     %d\n', length(massed_umw));
fprintf('Spaced On-task: %d\n', length(spaced_on));
fprintf('Spaced IMW:     %d\n', length(spaced_imw));
fprintf('Spaced UMW:     %d\n', length(spaced_umw));
fprintf('======================\n\n');

% =========================
% SAFE SPLITTING
% =========================

if isempty(massed_on)
    fprintf('[INFO] ST2604_massed_on.set → 0 trials (NOT saved)\n');
else
    EEG_massed_on = pop_select(EEG, 'trial', massed_on);
    pop_saveset(EEG_massed_on, 'filename', 'ST2604_massed_on.set');
    fprintf('[SAVED] ST2604_massed_on.set -> %d trials\n', length(massed_on));
end

if isempty(massed_imw)
    fprintf('[INFO] ST2604_massed_imw.set → 0 trials (NOT saved)\n');
else
    EEG_massed_imw = pop_select(EEG, 'trial', massed_imw);
    pop_saveset(EEG_massed_imw, 'filename', 'ST2604_massed_imw.set');
    fprintf('[SAVED] ST2604_massed_imw.set → %d trials\n', length(massed_imw));
end

if isempty(massed_umw)
    fprintf('[INFO] ST2604_massed_umw.set → 0 trials (NOT saved)\n');
else
    EEG_massed_umw = pop_select(EEG, 'trial', massed_umw);
    pop_saveset(EEG_massed_umw, 'filename', 'ST2604_massed_umw.set');
    fprintf('[SAVED] ST2604_massed_umw.set → %d trials\n', length(massed_umw));
end

if isempty(spaced_on)
    fprintf('[INFO] ST2604_spaced_on.set → 0 trials (NOT saved)\n');
else
    EEG_spaced_on = pop_select(EEG, 'trial', spaced_on);
    pop_saveset(EEG_spaced_on, 'filename', 'ST2604_spaced_on.set');
    fprintf('[SAVED] ST2604_spaced_on.set → %d trials\n', length(spaced_on));
end

if isempty(spaced_imw)
    fprintf('[INFO] ST2604_spaced_imw.set → 0 trials (NOT saved)\n');
else
    EEG_spaced_imw = pop_select(EEG, 'trial', spaced_imw);
    pop_saveset(EEG_spaced_imw, 'filename', 'ST2604_spaced_imw.set');
    fprintf('[SAVED] ST2604_spaced_imw.set → %d trials\n', length(spaced_imw));
end

if isempty(spaced_umw)
    fprintf('[INFO] ST2604_spaced_umw.set → 0 trials (NOT saved)\n');
else
    EEG_spaced_umw = pop_select(EEG, 'trial', spaced_umw);
    pop_saveset(EEG_spaced_umw, 'filename', 'ST2604_spaced_umw.set');
    fprintf('[SAVED] ST2604_spaced_umw.set → %d trials\n', length(spaced_umw));
end

fprintf('\nAll splitting complete \n');