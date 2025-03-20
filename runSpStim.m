function [BlockData, idx_sampledpostold, idx_post] = runSpStim(ExpInfo, BlockData, numTrialTotal,numTrialPretrainMain)

%% Extract the speech stimuli (Pre-speech, Pre-dual, Main-train, Main, all stored in one list order randomised)

% read the stimuli

spRaw = readtable('stimulus_allsentence_withdur.csv'); % read raw speech spreadsheet
sp_keywords= [spRaw.filename,spRaw.keyword_1,spRaw.keyword_2,spRaw.keyword_3,spRaw.keyword_4,num2cell(spRaw.audio_dur)]; % pull out the keywords columns


% sample a pool of sentences used for the experiment (a complete list, ofc not including the "old sentences" in the post-test)

iSample = 1;
numUniSentences = ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain+ExpInfo.numPostNew;

fprintf('Started sampling to find the pretrain and main sentences...\n\n');
tic % set up a stopwatch

while iSample <= 2*10^5
    
    [sp_sample_pre_main_postnew{1,iSample},idx_sample_pre_main_postnew{1,iSample}] = datasample(sp_keywords(:,2:5),numUniSentences,'Replace',false); % Note that only col 2:5 were pulled out to save memory use.
    
%     sp_sample_prenmain_merge{1,iSample} = [sp_prenmain{1,1}(:,2:5);sp_sample_prenmain{1,iSample}];
%     idx_sample_prenmain_merge{1,iSample} = [idx_prenmain_cell{1,1},idx_sample_prenmain{1,iSample}];
   
    [uWords,ia,ic] = unique(lower(sp_sample_pre_main_postnew{1,iSample}));
    emp_uWordsIdx = cellfun('isempty',uWords);
    fWords_thissample = accumarray(ic,1); % count the frequency of occurence of each keyword.
    fWords_thissample = fWords_thissample(~emp_uWordsIdx);
    fWords_allsample{1,iSample} = fWords_thissample;
    %fWords_sample_prenmainMax(iSample,1) = mean(fWords_allsample{1,iSample});
    fWords_sample_pre_main_postnew_UniRate(iSample,1) = length(uWords(~emp_uWordsIdx))/sum(fWords_allsample{1,iSample});

    iSample = iSample +1;
end

fprintf('Sample found!\nMaximum unique rate among the samples is: %.4f\n\n',max(fWords_sample_pre_main_postnew_UniRate));
toc % End the stop watch
hist(fWords_sample_pre_main_postnew_UniRate) % Show the distribution of the proportion of unique keywords across all samples

idx_maxSample = find(fWords_sample_pre_main_postnew_UniRate == max(fWords_sample_pre_main_postnew_UniRate)); % find the most 'unique' samples.


fWords_sample_pre_main_postnew_Max = NaN(1,length(idx_maxSample));

for idx = 1:length(idx_maxSample)
    fWords_sample_pre_main_postnew_Max(1,idx) = max(fWords_allsample{1,idx_maxSample(idx)});
end

idx_minSample = find(fWords_sample_pre_main_postnew_Max == min(fWords_sample_pre_main_postnew_Max)); % Within the most 'unique samples', find the one with the least maximum repetition of a keyword
idx_outputPrenMainPostnewSample = idx_sample_pre_main_postnew{1,idx_maxSample(idx_minSample(1))};

sp_pre_main_postnew{1,1} = sp_keywords(idx_outputPrenMainPostnewSample,:); % Store the most 'unique' pre- and main sample.

% clear large variables to save memory storage.

dumped_vars = {'fWords_allsample','fWords_sample_pre_main_postnew_UniRate','idx_sample_pre_main_postnew',...
    'sp_sample_pre_main_postnew'};
clear(dumped_vars{:});


%% Sample the sentences for the post-test

fprintf('Started sampling old sentences for posttest...\n\n');
tic

%%% Sample the "old" sentences

%[sp_sample_postold{1,1},idx_sample_postold{1,1}] = datasample(sp_prenmain{1,3}(ExpInfo.numPretrain+1:numTrialPretrainMain,:), ExpInfo.numPosttest/2, 'Replace', false);

% unique(sp_sample_postold{1,1}(:,1))


sumBlock1 = 0;
sumBlock2 = 0;
sumBlock3 = 0;
sumBlock4 = 0;
% sum(BlockData.Block(idx_sample_postold{1,1},1) ==3)

%testTargetPre1 = BlockData.TargetPresence(idx_sample_postold{1,1},1) ==1;
% testTargetPre0 = BlockData.TargetPresence(idx_sample_postold{1,1},1) ==0;

sumTargetBlock1 = 1;
sumTargetBlock2 = 1;
sumTargetBlock3 = 1;
sumTargetBlock4 = 1;


while (sumBlock1~=ExpInfo.numPostOld/ExpInfo.NumCondPost) || ...
        (sumBlock2~=ExpInfo.numPostOld/ExpInfo.NumCondPost) || ...
        (sumBlock3~=ExpInfo.numPostOld/ExpInfo.NumCondPost) || ...
        (sumBlock4~=ExpInfo.numPostOld/ExpInfo.NumCondPost) || ...
        (sumTargetBlock1~=sumBlock1/2) || ...
        (sumTargetBlock2~=sumBlock2/2) || ...
        (sumTargetBlock3~=sumBlock3/2) || ...
        (sumTargetBlock4~=sumBlock4/2)
    
    [sp_sample_postold{1,1},idx_sample_postold{1,1}] = datasample(sp_pre_main_postnew{1,1}(ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain+1:numTrialPretrainMain,:),...
        ExpInfo.numPostOld, 'Replace', false);
    idx_sample_postold{1,1} = idx_sample_postold{1,1}+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain; % update the indexes so they base on sp_pre_main_postnew{1,1}.
    idx_sampledpostold = idx_sample_postold{1,1};
    
    % run a bunch of tests
    
    
    %%% number of sentences extracted per block (should be all = 24)
    testBlock1 = BlockData.Block(idx_sample_postold{1,1},1) ==1;
    testBlock2 = BlockData.Block(idx_sample_postold{1,1},1) ==2;
    testBlock3 = BlockData.Block(idx_sample_postold{1,1},1) ==3;
    testBlock4 = BlockData.Block(idx_sample_postold{1,1},1) ==4;
    
    sumBlock1 = sum(testBlock1);
    sumBlock2 = sum(testBlock2);
    sumBlock3 = sum(testBlock3);
    sumBlock4 = sum(testBlock4);
    
    %%% number of sentences extracted per block per targetpresence (should be all = 4)
    testTargetPre1 = BlockData.TargetPresence(idx_sample_postold{1,1},1) ==1;
    sumTargetBlock1 = length(find((testBlock1==1) & (testTargetPre1==1)));
    sumTargetBlock2 = length(find((testBlock2==1) & (testTargetPre1==1)));
    sumTargetBlock3 = length(find((testBlock3==1) & (testTargetPre1==1)));
    sumTargetBlock4 = length(find((testBlock4==1) & (testTargetPre1==1)));
end

fprintf('Old sentences found for the posttest!\n\n');
toc

%%% Write the old sentences to BlockData

BlockData.Block(numTrialPretrainMain+ExpInfo.numPostNew+1:numTrialPretrainMain+ExpInfo.numPostNew+ExpInfo.numPostOld) = BlockData.Block(idx_sample_postold{1,1}); % need randomisation
BlockData.Sentence = [sp_pre_main_postnew{1,1}(:,1);sp_sample_postold{1,1}(:,1)]; % need randomisation
BlockData.Keyword1 = [sp_pre_main_postnew{1,1}(:,2);sp_sample_postold{1,1}(:,2)]; % need randomisation
BlockData.Keyword2 = [sp_pre_main_postnew{1,1}(:,3);sp_sample_postold{1,1}(:,3)]; % need randomisation
BlockData.Keyword3 = [sp_pre_main_postnew{1,1}(:,4);sp_sample_postold{1,1}(:,4)]; % need randomisation
BlockData.Keyword4 = [sp_pre_main_postnew{1,1}(:,5);sp_sample_postold{1,1}(:,5)]; % need randomisation
BlockData.AudDur(1:numTrialTotal)= [cell2mat(sp_pre_main_postnew{1,1}(1:numTrialPretrainMain,6));NaN(ExpInfo.numPostNew,1);cell2mat(sp_sample_postold{1,1}(:,6))]; % only do prenmain and postold as we use written probe for the post test; need randomisation, If need duration for new sentences, add them to the end of this vector
BlockData.TargetPresence(numTrialPretrainMain+ExpInfo.numPostNew+1:numTrialTotal) = BlockData.TargetPresence(idx_sample_postold{1,1}); % need randomisation


%%% Randomise the trials in posttest phase.

fprintf('Started randomising trials in the posttest...\n\n');
tic

conti_nan_leng = 3; % initial value for the continuous repeition for new posttest sentences is 3, letting the while loop to start.

while (any(conti_nan_leng>1))

    BlockData.Block(numTrialPretrainMain+1:numTrialPretrainMain+ExpInfo.numPostNew) = NaN; % Initial labels of Block for new sentences.
    BlockData.Block(numTrialPretrainMain+ExpInfo.numPostNew+1:numTrialTotal) = BlockData.Block(idx_sample_postold{1,1}); % Initial labels of Block for old sentences

    
    idx_post = randperm(ExpInfo.numPosttest)+numTrialPretrainMain;

    
    conti_nan_check = diff([false,isnan(transpose(BlockData.Block(idx_post))),false]); % check continous repetition of nan (new posttest sentences)elements
    conti_nan_leng = find(conti_nan_check<0)-find(conti_nan_check>0);
    
end

fprintf('Post-test stimuli Randomised!\n\n');
toc

%%%% Write the randomised trials to the posttest phase in BlockData
BlockData.Block(numTrialPretrainMain+1:numTrialTotal) = BlockData.Block(idx_post);
BlockData.Sentence(numTrialPretrainMain+1:numTrialTotal) =  BlockData.Sentence(idx_post);
BlockData.Keyword1(numTrialPretrainMain+1:numTrialTotal) = BlockData.Keyword1(idx_post);
BlockData.Keyword2(numTrialPretrainMain+1:numTrialTotal) = BlockData.Keyword2(idx_post);
BlockData.Keyword3(numTrialPretrainMain+1:numTrialTotal) = BlockData.Keyword3(idx_post);
BlockData.Keyword4(numTrialPretrainMain+1:numTrialTotal) = BlockData.Keyword4(idx_post);
BlockData.AudDur(numTrialPretrainMain+1:numTrialTotal)= BlockData.AudDur(idx_post); % If need duration for new sentences, add them to the end of this vector
BlockData.TargetPresence(numTrialPretrainMain+1:numTrialTotal) = BlockData.TargetPresence(idx_post); % need randomisation

[~,idxSpContent] = ismember(BlockData.Sentence,spRaw.filename);
BlockData.SpContent = spRaw.sentence(idxSpContent);

%% Write the file names

for iFile  = 1:numTrialTotal
    if or(BlockData.Block(iFile) == 1, BlockData.Block(iFile) == 2)
        BlockData.AudFile(iFile) = strjoin([BlockData.Sentence(iFile) '_8ch.wav'],'');
    elseif or(BlockData.Block(iFile) == 3, BlockData.Block(iFile) == 4)
        BlockData.AudFile(iFile) = strjoin([BlockData.Sentence(iFile) '_4ch.wav'],'');
    else
        BlockData.AudFile(iFile) = '';
    end
end

fprintf('Speech stimuli were written to BlockData!\n\n');

%%%% remember to send output of idx_sample_postold{1,1} and idx_post to Gabor patch
%%%% generator so that we can add orientaiton and Gabor location for post
%%%% old sentences


