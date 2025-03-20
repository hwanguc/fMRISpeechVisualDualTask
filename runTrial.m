function BlockData = runTrial(session,ExpInfo, BlockData, trialNum)

%% Set up

% Measure trial duration for debugging 
trialStart = tic;


% Wait for all buttons to be released
while KbCheck ~= 0; end


%% Present stimuli, collect responses, and finish up (splitted routines for PRETRAIN/MAIN and POSTTEST)
if session == 1
    BlockData = runTrialPreSpeech(ExpInfo, BlockData, trialNum,trialStart);
elseif ismember(session,2:9)
    BlockData = runTrialPretrainMain(session,ExpInfo, BlockData, trialNum,trialStart);
elseif session == 10
    BlockData = runTrialPost(ExpInfo, BlockData, trialNum,trialStart);
end
    
% Tidy up
Screen('Close')

% Clear screen
Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
Screen('Flip', ExpInfo.Win);

