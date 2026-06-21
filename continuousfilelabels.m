clearvars;
clc;

continuous_file = 'JD0802_preprocessed.bdf.set';

EEG = pop_loadset('filename', continuous_file);

% convert event types to numeric if needed
for i = 1:length(EEG.event)
    if ischar(EEG.event(i).type)
        EEG.event(i).type = str2double(EEG.event(i).type);
    end
end

% find all probes
probe_indices = find([EEG.event.type] == 20);
n_probes = length(probe_indices);

fprintf('Total probes found: %d\n', n_probes);

% initialize
response_labels = nan(n_probes,1);   % 31/32/33
condition_labels = nan(n_probes,1);  % 1 = massed, 2 = spaced

for i = 1:n_probes
    
    probe_idx = probe_indices(i);
    
    % find next response after probe
    for j = probe_idx+1:length(EEG.event)
        if ismember(EEG.event(j).type, [31 32 33])
            response_labels(i) = EEG.event(j).type;
            break;
        end
    end
    
    % find most recent reading trigger before probe
    for j = probe_idx:-1:1
        if ismember(EEG.event(j).type, [11 12 13])
            condition_labels(i) = 1; % massed
            break;
        elseif ismember(EEG.event(j).type, [21 22 23])
            condition_labels(i) = 2; % spaced
            break;
        end
    end
end

fprintf('Missing response labels: %d\n', sum(isnan(response_labels)));
fprintf('Missing condition labels: %d\n', sum(isnan(condition_labels)));

disp('Response label counts:');
disp(tabulate(response_labels));

disp('Condition label counts (1=massed, 2=spaced):');
disp(tabulate(condition_labels));

save('JD0802_labels.mat', 'response_labels', 'condition_labels');



% ------- the following script is for one participant whose block data was collected in separate files ----- 
clearvars;
clc;

% -------------------------
% FILES
% -------------------------
participant = 'ST2604';   

continuous_file_block1 = 'ST2604_block1_preprocessed.bdf.set';
continuous_file_block2 = 'ST2604_block2_preprocessed.bdf.set';

% -------------------------
% GENERATE LABELS FOR BLOCK 1
% -------------------------
EEG = pop_loadset('filename', continuous_file_block1);

for i = 1:length(EEG.event)
    if ischar(EEG.event(i).type)
        EEG.event(i).type = str2double(EEG.event(i).type);
    end
end

probe_indices = find([EEG.event.type] == 20);
n_probes = length(probe_indices);

response_labels_b1 = nan(n_probes,1);
condition_labels_b1 = nan(n_probes,1);

for i = 1:n_probes
    probe_idx = probe_indices(i);

    for j = probe_idx+1:length(EEG.event)
        if ismember(EEG.event(j).type, [31 32 33])
            response_labels_b1(i) = EEG.event(j).type;
            break;
        end
    end

    for j = probe_idx:-1:1
        if ismember(EEG.event(j).type, [11 12 13])
            condition_labels_b1(i) = 1; % massed
            break;
        elseif ismember(EEG.event(j).type, [21 22 23])
            condition_labels_b1(i) = 2; % spaced
            break;
        end
    end
end

fprintf('\nBlock 1 probes: %d\n', n_probes);
fprintf('Block 1 missing responses: %d\n', sum(isnan(response_labels_b1)));
fprintf('Block 1 missing conditions: %d\n', sum(isnan(condition_labels_b1)));

% -------------------------
% GENERATE LABELS FOR BLOCK 2
% -------------------------
EEG = pop_loadset('filename', continuous_file_block2);

for i = 1:length(EEG.event)
    if ischar(EEG.event(i).type)
        EEG.event(i).type = str2double(EEG.event(i).type);
    end
end

probe_indices = find([EEG.event.type] == 20);
n_probes = length(probe_indices);

response_labels_b2 = nan(n_probes,1);
condition_labels_b2 = nan(n_probes,1);

for i = 1:n_probes
    probe_idx = probe_indices(i);

    for j = probe_idx+1:length(EEG.event)
        if ismember(EEG.event(j).type, [31 32 33])
            response_labels_b2(i) = EEG.event(j).type;
            break;
        end
    end

    for j = probe_idx:-1:1
        if ismember(EEG.event(j).type, [11 12 13])
            condition_labels_b2(i) = 1; % massed
            break;
        elseif ismember(EEG.event(j).type, [21 22 23])
            condition_labels_b2(i) = 2; % spaced
            break;
        end
    end
end

fprintf('\nBlock 2 probes: %d\n', n_probes);
fprintf('Block 2 missing responses: %d\n', sum(isnan(response_labels_b2)));
fprintf('Block 2 missing conditions: %d\n', sum(isnan(condition_labels_b2)));

% -------------------------
% COMBINE LABELS
% -------------------------
response_labels  = [response_labels_b1; response_labels_b2];
condition_labels = [condition_labels_b1; condition_labels_b2];

fprintf('\nCombined labels:\n');
fprintf('Total probes: %d\n', length(response_labels));
fprintf('Missing responses: %d\n', sum(isnan(response_labels)));
fprintf('Missing conditions: %d\n', sum(isnan(condition_labels)));

disp('Response label counts:');
disp(tabulate(response_labels));

disp('Condition label counts:');
disp(tabulate(condition_labels));

save('ST2604_labels.mat', ...
    'response_labels', 'condition_labels', ...
    'response_labels_b1', 'response_labels_b2', ...
    'condition_labels_b1', 'condition_labels_b2');

fprintf('\nSaved combined labels.\n');
