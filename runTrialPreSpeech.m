function BlockData = runTrialPreSpeech(ExpInfo, BlockData, trialNum,trialStart)


%% Present fixation cross

scCenter = ExpInfo.ScreenCenter;
fixationScale = ExpInfo.FixationScale;


Screen('DrawLines', ExpInfo.Win, ...
    [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
    (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
    fixationScale*(6/15), [255 255 255]);


[BlockData.FixFlipTime(trialNum), ~, ...
    BlockData.FixFlipEnd(trialNum), ~, ~] = Screen('Flip', ExpInfo.Win);


%% First clear the fixation cross (but don't do this in the post-test session)

%%% Clear screen 
fixClearTime = BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime;

[BlockData.FixClearFlipTime(trialNum), ~, ...
    BlockData.FixClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, fixClearTime);

BlockData.FixClearFlipTime(trialNum) = ...
    BlockData.FixClearFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.FixClearFlipEnd(trialNum) = ...
    BlockData.FixClearFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);


%% Present stimulus


% When to play the audio (This needs to be immediate after the fixation
% cross disappears).

BlockData.StimAudOnset(trialNum) = BlockData.FixFlipTime(trialNum) + BlockData.FixClearFlipTime(trialNum) - 0.0800; % 0.0800 is the latency for audio play in the pre-speech task on the lenovo laptop; 0.0220 is the latency for audio playback in the Chandler House TMS lab.

[BlockData.StimAudFlipTime(trialNum), pahandle_presp] = presentSound(BlockData.WavfileDir(trialNum),ExpInfo.Repetitions,BlockData.StimAudOnset(trialNum));

% All time measurements, apart from the fixation appear time, will be relative
% to the fixation appear time.
BlockData.StimAudFlipTime(trialNum) = ...
    BlockData.StimAudFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);

% Work out when to show the HearSpeech prompt

BlockData.StimHSOnset(trialNum) = ...
    BlockData.FixFlipTime(trialNum) + BlockData.FixClearFlipTime(trialNum); % Think about if we need a latency correction of 0.005s.

% Draw the HearSpeech prompt

imHearSpeechTexture = Screen('MakeTexture', ExpInfo.Win, ExpInfo.HearSpeechIM);
Screen('DrawTexture',ExpInfo.Win,imHearSpeechTexture,[], ExpInfo.HearSpeechSquare);

% Wait to flip to show the HearSpeech prompt
[BlockData.StimHSFlipTime(trialNum), ~, ...
    BlockData.StimHSFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.StimHSOnset(trialNum));

% Timestamp for the HearSpeech flip
BlockData.StimHSFlipTime(trialNum) = ...
    BlockData.StimHSFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.StimHSFlipEnd(trialNum) = ...
    BlockData.StimHSFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);

% Clear the HearSpeech prompt

hsClearTime = BlockData.FixFlipTime(trialNum) + BlockData.StimAudFlipTime(trialNum)+BlockData.AudDur(trialNum)/1000; % clear the prompt once the 

[BlockData.HSClearFlipTime(trialNum), ~, ...
    BlockData.HSClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, hsClearTime);

BlockData.HSClearFlipTime(trialNum) = ...
    BlockData.HSClearFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.HSClearFlipEnd(trialNum)= ...
    BlockData.HSClearFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);

% Stop the audio stimulus

AudStopTime =BlockData.FixFlipTime(trialNum)+BlockData.HSClearFlipTime(trialNum);

[~,BlockData.endAudPositionSecs(trialNum),~,BlockData.estAudStopTime(trialNum)] = PsychPortAudio('Stop',pahandle_presp,ExpInfo.WaitForEndOfPlayback,[],[],AudStopTime);
PsychPortAudio('Close', pahandle_presp);

%% Collect response

% Prepare to monitor for a response (Audio)
relevantKeyPress = false;
whichresp = 1; % record as the first response (audio)
drawResponseWin(ExpInfo,ExpInfo.ResponsePromptAud,[],whichresp,0)


BlockData.Resp1PrmptTime (trialNum) = AudStopTime;

% Wait to flip for the first response screen
[BlockData.Resp1FlipTime(trialNum), ~, ...
    BlockData.Resp1FlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.Resp1PrmptTime (trialNum));

BlockData.Resp1FlipTime(trialNum) = BlockData.Resp1FlipTime(trialNum)-BlockData.FixFlipTime(trialNum);
BlockData.Resp1FlipEnd(trialNum) = BlockData.Resp1FlipEnd(trialNum)-BlockData.FixFlipTime(trialNum);

% Work out when to clear the response screen
BlockData.Resp1ScrClearTime(trialNum) = BlockData.FixFlipTime(trialNum) + BlockData.Resp1FlipTime(trialNum)+ExpInfo.SpResponseDur;


% Monitor for response 1 (Aud)

while ~relevantKeyPress && (GetSecs < BlockData.Resp1ScrClearTime(trialNum))
    
    [relevantKeyPress, BlockData] = checkForResp(ExpInfo,BlockData, trialNum, whichresp); % added a check for wrong keys within the function
     
end

% Clear screen 
[BlockData.Resp1ClearFlipTime(trialNum), ~, ...
    BlockData.Resp1ClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.Resp1ScrClearTime(trialNum));

BlockData.TrialDuration(trialNum) = toc(trialStart);

BlockData.Resp1ClearFlipTime(trialNum) = ...
    BlockData.Resp1ClearFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.Resp1ClearFlipEnd(trialNum) = ...
    BlockData.Resp1ClearFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);

%% Finish up

if trialNum == ExpInfo.TrialIdx(end)
    
    formattedWord = strcat('<font=Arial><size=35><i>',ExpInfo.PromptPretrainEnd);
    DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
    
    [BlockData.EndPromptFlipTime(trialNum), ~, ...
        BlockData.EndPromptFlipEnd(trialNum), ~, ~] = ...
        Screen('Flip', ExpInfo.Win);
    
    BlockData.EndPromptFlipTime(trialNum) = BlockData.EndPromptFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
    BlockData.EndPromptFlipEnd(trialNum) = BlockData.EndPromptFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);
    
   
    WaitSecs(2.0)
    
end

