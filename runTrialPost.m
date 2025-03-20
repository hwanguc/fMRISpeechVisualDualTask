function BlockData = runTrialPost(ExpInfo, BlockData, trialNum,trialStart)

%% Present stimulus and Collect response

% Prepare to monitor for a response (Sentence in memory block)
relevantKeyPress = false;
whichresp = 3; % record as the sentence response

% Draw the sentence and the response screen

formattedWord = strcat('<font=Arial><size=35><i>',BlockData.SpContent(trialNum));
DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
drawResponseWin(ExpInfo,ExpInfo.ResponsePromptMemory,[],whichresp,0)

% Flip the sentence 
[BlockData.SentenceFlipTime(trialNum), ~, ...
    BlockData.SentenceFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win);

%% Collect response

% Work out when to clear the response screen
BlockData.Resp1ScrClearTime(trialNum) = BlockData.SentenceFlipTime(trialNum) + ExpInfo.MemoryStimDuration;

% Monitor for responses

while ~relevantKeyPress && (GetSecs < BlockData.Resp1ScrClearTime(trialNum))
    
    [relevantKeyPress, BlockData] = checkForResp(ExpInfo,BlockData, trialNum, whichresp); % added a check for wrong keys within the function
     
end

% Clear screen 
[BlockData.Resp1ClearFlipTime(trialNum), ~, ...
    BlockData.Resp1ClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.Resp1ScrClearTime(trialNum));

BlockData.TrialDuration(trialNum) = toc(trialStart);

BlockData.Resp1ClearFlipTime(trialNum) = ...
    BlockData.Resp1ClearFlipTime(trialNum) - BlockData.SentenceFlipTime(trialNum);
BlockData.Resp1ClearFlipEnd(trialNum) = ...
    BlockData.Resp1ClearFlipEnd(trialNum) - BlockData.SentenceFlipTime(trialNum);




%% Finish up

if trialNum == ExpInfo.TrialIdx(end)
    
    formattedWord = strcat('<font=Arial><size=35><i>',ExpInfo.PromptExperimentEnd);
    DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
    
    [BlockData.EndPromptFlipTime(trialNum), ~, ...
        BlockData.EndPromptFlipEnd(trialNum), ~, ~] = ...
        Screen('Flip', ExpInfo.Win);
    
    BlockData.EndPromptFlipTime(trialNum) = BlockData.EndPromptFlipTime(trialNum) - BlockData.SentenceFlipTime(trialNum);
    BlockData.EndPromptFlipEnd(trialNum) = BlockData.EndPromptFlipEnd(trialNum) - BlockData.SentenceFlipTime(trialNum);
    
   
    WaitSecs(2.0)
    
end

    


