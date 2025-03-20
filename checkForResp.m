function [relevantKeyPress, BlockData] = checkForResp(ExpInfo,BlockData, trialNum,whichresp)


% Flag
relevantKeyPress = false;
DisableKeysForKbCheck(ExpInfo.TriggerKeyCode); % Don't monitor for key responses but not 't's.
[keyDown, responseTime, keyCode] = KbCheck();


% Is the 'l' pressed indicating a target?
if or((keyDown && keyCode(37) && ExpInfo.DryRun == 1),(keyDown && keyCode(49) && ExpInfo.DryRun == 0)) % change key code for button box
    
    relevantKeyPress = true;
    
    if whichresp == 1
        %Screen('Flip', ExpInfo.Win) % clean the screen
        drawResponseWin(ExpInfo,ExpInfo.ResponsePromptAud,ExpInfo.PromptLeftRight,whichresp,1)
        BlockData.RespAud(trialNum) = 1;
    elseif whichresp == 2
        %Screen('Flip', ExpInfo.Win) % clean the screen
        drawResponseWin(ExpInfo,ExpInfo.ResponsePromptGb,ExpInfo.PromptLeftRight,whichresp,1)
        BlockData.RespGb(trialNum) = 1;
    elseif whichresp == 3
        %Screen('Flip', ExpInfo.Win) % clean the screen
        formattedWord = strcat('<font=Arial><size=35><i>',BlockData.SpContent(trialNum));
        DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
        drawResponseWin(ExpInfo,ExpInfo.ResponsePromptMemory,ExpInfo.PromptLeftRight,whichresp,1)
        BlockData.RespMemory(trialNum) = 1;
    end
   
 
% Is the 'r' pressed indicating a non-target?
elseif or((keyDown && keyCode(39) && ExpInfo.DryRun == 1),(keyDown && keyCode(50) && ExpInfo.DryRun == 0)) % change key code for button box
    
    relevantKeyPress = true;
    
    if whichresp == 1
        %Screen('Flip', ExpInfo.Win) % clean the screen
        drawResponseWin(ExpInfo,ExpInfo.ResponsePromptAud,ExpInfo.PromptLeftRight,whichresp,1)
        BlockData.RespAud(trialNum) = 0;
    elseif whichresp == 2
        %Screen('Flip', ExpInfo.Win) % clean the screen
        drawResponseWin(ExpInfo,ExpInfo.ResponsePromptGb,ExpInfo.PromptLeftRight,whichresp,1)
        BlockData.RespGb(trialNum) = 0;
    elseif whichresp == 3
        %Screen('Flip', ExpInfo.Win) % clean the screen
        formattedWord = strcat('<font=Arial><size=35><i>',BlockData.SpContent(trialNum));
        DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
        drawResponseWin(ExpInfo,ExpInfo.ResponsePromptMemory,ExpInfo.PromptLeftRight,whichresp,1)
        BlockData.RespMemory(trialNum) = 0;
    end
    
    
elseif or((keyDown && and(~keyCode(37),~keyCode(39)) && ExpInfo.DryRun == 1),(keyDown && and(~keyCode(49),~keyCode(50)) && ExpInfo.DryRun == 0)) % change key code for button box
    
    relevantKeyPress = false;
    
        if whichresp == 1
            %Screen('Flip', ExpInfo.Win) % clean the screen
            drawResponseWin(ExpInfo,ExpInfo.ResponsePromptAud,ExpInfo.PromptWrongkey,whichresp,1)
            %BlockData.RespAud(trialNum) = 0;
        elseif whichresp == 2
            %Screen('Flip', ExpInfo.Win) % clean the screen
            drawResponseWin(ExpInfo,ExpInfo.ResponsePromptGb,ExpInfo.PromptWrongkey,whichresp,1)
            %BlockData.RespGb(trialNum) = 0;
        elseif whichresp == 3
            %Screen('Flip', ExpInfo.Win) % clean the screen
            formattedWord = strcat('<font=Arial><size=35><i>',BlockData.SpContent(trialNum));
            DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
            drawResponseWin(ExpInfo,ExpInfo.ResponsePromptMemory,ExpInfo.PromptWrongkey,whichresp,1)
            %BlockData.RespMemory(trialNum) = 0;
        end
    
 
end


% If any relevant key is pressed store RTs
if keyDown && relevantKeyPress

    if whichresp == 1
        
        BlockData.RtAbsAud(trialNum) = responseTime;
        BlockData.RTAud(trialNum) = ...
            BlockData.RtAbsAud(trialNum) ...
            - BlockData.FixFlipTime(trialNum) - BlockData.Resp1FlipTime(trialNum);

        BlockData.AccAud(trialNum) = BlockData.RespAud(trialNum) == 1;
        
    elseif whichresp == 2
        
        BlockData.RtAbsGb(trialNum) = responseTime;
        BlockData.RTGb(trialNum) = ...
            BlockData.RtAbsGb(trialNum) ...
            - BlockData.FixFlipTime(trialNum) - BlockData.Resp2FlipTime(trialNum);

        BlockData.AccGb(trialNum) = BlockData.RespGb(trialNum) == BlockData.TargetPresence(trialNum);
        
    elseif whichresp ==3
        
        BlockData.RtAbsMemory(trialNum) = responseTime;
        BlockData.RTMemory(trialNum) = ...
            BlockData.RtAbsMemory(trialNum) ...
            - BlockData.SentenceFlipTime(trialNum); % This line needs to be changed if we decide to show the fixation cross.

        BlockData.AccMemory(trialNum) = BlockData.RespMemory(trialNum) == BlockData.SentencePresence(trialNum);
    end
else
    if whichresp == 1
        BlockData.RTAud(trialNum) = 9999;
        BlockData.AccAud(trialNum) = 0;
    elseif whichresp == 2
        BlockData.RTGb(trialNum) = 9999;
        BlockData.AccGb(trialNum) = 0;
    elseif whichresp == 3
        BlockData.RTMemory(trialNum) = 9999;
        BlockData.AccMemory(trialNum) = 0;
    end
end
