% read the stimuli

clear;
clc;

stim_raw = readtable('sp_result_final_selected183_script_version_a_dur1k3_1k8.csv');
sp_keywords = [stim_raw.keyword_1,stim_raw.keyword_2,stim_raw.keyword_3];

iSample = 1;

while iSample <= 10^4
    [sp_sample{1,iSample},idx_sample{1,iSample}] = datasample(sp_keywords, 164, 'Replace', false);
    [uWords,ia,ic] = unique(lower(sp_sample{1,iSample}));
    fWords_thissample = accumarray(ic,1); % count the frequency of occurence of each keyword.
    fWords_allsample{1,iSample} = fWords_thissample;
    fWords_sampleMax(iSample,1) = max(fWords_allsample{1,iSample});

    iSample = iSample +1;
end

fprintf('Min upper limit of duplicates in all samples is %d\n\n',min(fWords_sampleMax));

idx_minSample = find(fWords_sampleMax == min(fWords_sampleMax));
idx_outputSample = idx_sample{1,idx_minSample(1)};
idx_removedStim = setdiff(1:height(stim_raw),idx_outputSample);

stim_output = stim_raw(idx_outputSample,:);
stim_removed = stim_raw(idx_removedStim,:);

disp('The removed stimuli are: ')
disp(stim_removed);

writetable(stim_output, "sp_result_final_selected164_script_version_a_maintask.csv")
writetable(stim_removed, "sp_result_final_removed19_script_version_a_memorytask.csv")

    