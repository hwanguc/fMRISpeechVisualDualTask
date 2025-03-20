function runBlockExperiment(subj,session,numTrialTotal,ExpInfo,BlockData)


%% Set up

% Initialise

BlockData.SentencePresence = NaN(numTrialTotal,1);
BlockData.WavfileDir = strings([numTrialTotal,1]);

BlockData.TriggerFixFlipTime = NaN(numTrialTotal, 1);
BlockData.TriggerFixFlipEnd = NaN(numTrialTotal, 1);

BlockData.FixFlipTime = NaN(numTrialTotal, 1);
BlockData.FixFlipEnd = NaN(numTrialTotal, 1);
BlockData.FixClearFlipTime= NaN(numTrialTotal, 1);
BlockData.FixClearFlipEnd = NaN(numTrialTotal, 1);

BlockData.DurAudOnset = NaN(numTrialTotal, 1);
BlockData.StimAudOnset = NaN(numTrialTotal, 1);
BlockData.StimAudFlipTime = NaN(numTrialTotal, 1);
BlockData.StimHSOnset = NaN(numTrialTotal, 1); % only for pre-speech session
BlockData.StimHSFlipTime = NaN(numTrialTotal, 1); % only for pre-speech session
BlockData.StimHSFlipEnd = NaN(numTrialTotal, 1); % only for pre-speech session
BlockData.DurGbOnset = NaN(numTrialTotal, 1);
BlockData.StimGbOnset = NaN(numTrialTotal, 1);
BlockData.StimGbFlipTime = NaN(numTrialTotal, 1);
BlockData.StimGbFlipEnd = NaN(numTrialTotal, 1);
BlockData.GbClearFlipTime = NaN(numTrialTotal, 1);
BlockData.GbClearFlipEnd = NaN(numTrialTotal, 1);
BlockData.HSClearFlipTime = NaN(numTrialTotal, 1); % only for pre-speech session
BlockData.HSClearFlipEnd = NaN(numTrialTotal, 1); % only for pre-speech session
BlockData.endAudPositionSecs = NaN(numTrialTotal, 1);
BlockData.estAudStopTime = NaN(numTrialTotal, 1);
BlockData.Resp1PrmptTime = NaN(numTrialTotal, 1);
BlockData.Resp1FlipTime = NaN(numTrialTotal, 1);
BlockData.Resp1FlipEnd = NaN(numTrialTotal, 1);
BlockData.Resp1ScrClearTime = NaN(numTrialTotal, 1);
BlockData.Resp1ClearFlipTime = NaN(numTrialTotal, 1); % only recorded in the post test session
BlockData.Resp1ClearFlipEnd = NaN(numTrialTotal, 1); % only recorded in the post test session
BlockData.Resp2FlipTime = NaN(numTrialTotal, 1);
BlockData.Resp2FlipEnd = NaN(numTrialTotal, 1);
BlockData.Resp2ScrClearTime = NaN(numTrialTotal, 1);
BlockData.TrialDuration = NaN(numTrialTotal, 1);
BlockData.EndPromptFlipTime = NaN(numTrialTotal, 1);
BlockData.EndPromptFlipEnd = NaN(numTrialTotal, 1);
BlockData.SentenceOnset = NaN(numTrialTotal, 1); %
BlockData.SentenceFlipTime = NaN(numTrialTotal, 1);
BlockData.SentenceFlipEnd = NaN(numTrialTotal, 1);

BlockData.RunStartTime = NaN(numTrialTotal, 1);
BlockData.BlockStartTime = NaN(numTrialTotal, 1);
BlockData.BlockEndTime = NaN(numTrialTotal, 1);
BlockData.BlockDur = NaN(numTrialTotal, 1);
% BlockData.RunEndnTriggerStartTime = NaN(numTrialTotal, 1);
BlockData.RunDur = NaN(numTrialTotal, 1);
BlockData.RunEndTime = NaN(numTrialTotal, 1);
% BlockData.EndTriggerDur = NaN(numTrialTotal, 1);

BlockData.RespAud = NaN(numTrialTotal, 1);
BlockData.AccAud = NaN(numTrialTotal, 1);
BlockData.RtAbsAud = NaN(numTrialTotal, 1); % Absolute RT
BlockData.RTAud = NaN(numTrialTotal, 1);% RT relative to simulus onset
BlockData.RespGb = NaN(numTrialTotal, 1);
BlockData.AccGb = NaN(numTrialTotal, 1);
BlockData.RtAbsGb = NaN(numTrialTotal, 1); % Absolute RT
BlockData.RTGb = NaN(numTrialTotal, 1);% RT relative to simulus onset
BlockData.RespMemory = NaN(numTrialTotal, 1);
BlockData.AccMemory = NaN(numTrialTotal, 1);
BlockData.RtAbsMemory = NaN(numTrialTotal, 1); % Absolute RT
BlockData.RTMemory = NaN(numTrialTotal, 1);% RT relative to simulus onset



%% Fill in some columns

%%% Sentence presence

for iPresence = ExpInfo.numTrialPretrainMain+1:numTrialTotal
    if isnan(BlockData.Block(iPresence))
        BlockData.SentencePresence(iPresence) = 0;
    else
        BlockData.SentencePresence(iPresence) = 1;
    end
end



%%% WavfileDir
for iDir = 1:ExpInfo.numTrialPretrainMain
    BlockData.WavfileDir(iDir,1) = string(strcat(pwd,'\audiostim\main\',BlockData.AudFile(iDir)));
end


%% Loop through trials

for iTrial = ExpInfo.TrialIdx(1) : ExpInfo.TrialIdx(end)
    
    BlockData = runTrial(session,ExpInfo, BlockData, iTrial);
    
end

% Save block data


save([pwd '\Data\' subj '\Experiment\BlockDataSession' num2str(session) '.mat'], 'BlockData');

writetable(struct2table(BlockData),string(strcat(pwd,'\Data\',subj,'\Experiment\BlockDataSession', ...
    num2str(session),'.csv')));


