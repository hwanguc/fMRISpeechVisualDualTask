function BlockData = runTrialPretrainMain(session,ExpInfo, BlockData, trialNum,trialStart)


scCenter = ExpInfo.ScreenCenter;
fixationScale = ExpInfo.FixationScale;

%% Wait for trigger if this is the first trial of the run

if (ismember(session,3:9)) && (trialNum == ExpInfo.TrialIdx(1))
    
    if ExpInfo.DryRun == 0
        
        Screen('DrawLines', ExpInfo.Win, ...
            [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
            (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
            fixationScale*(6/15), ExpInfo.FeedbackColour);

        [BlockData.TriggerFixFlipTime(trialNum), ~, ...
            BlockData.TriggerFixFlipEnd(trialNum), ~, ~] = ...
            Screen('Flip', ExpInfo.Win);


        KbName('UnifyKeyNames');
        DisableKeysForKbCheck(40); % return key is a 'stuck' key. Disable it.
        trigger_count = 0;  
        disp('Waiting for trigger')

        % Wait for 5 TRs to pass before moving on to the task - these scans will be
        % discarded. 


        while 1
            [pressed, ~, keyCode] = KbCheck();
            if pressed && keyCode(ExpInfo.TriggerKeyCode)
                while KbCheck(); end
                trigger_count = trigger_count+1;
                disp(strcat("Dummy:",string(trigger_count)))

                if trigger_count == 5 % four dummies
                    break
                end
            end
        end

        disp('end of dummy scans')
    end
    
    BlockData.RunStartTime(trialNum) = GetSecs;
end

if (ismember(session,3:9)) && (ismember(trialNum,ExpInfo.TrialIdxCondInit(:,1)))
    BlockData.BlockStartTime(trialNum) = GetSecs-BlockData.RunStartTime(ExpInfo.TrialIdx(1));
end

%% Present fixation cross


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


% Work out when to make the AUDIO stimulus appear

BlockData.DurAudOnset(trialNum) = (ExpInfo.StimDuration - BlockData.AudDur(trialNum)/1000)/2; % Express Audio duration in seconds

BlockData.StimAudOnset(trialNum) = ...
    BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime + BlockData.DurAudOnset(trialNum)-0.0220; % 0.0220 is the latency for audio playback in the Chandler House TMS lab.

% Wait to start playing audio

[BlockData.StimAudFlipTime(trialNum), pahandle_main] = presentSound(BlockData.WavfileDir(trialNum),ExpInfo.Repetitions,BlockData.StimAudOnset(trialNum));
    

% All time measurements, apart from the fixation appear time, will be relative
% to the fixation appear time.
BlockData.StimAudFlipTime(trialNum) = ...
    BlockData.StimAudFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);

% Work out when to show the GABOR patch

BlockData.DurGbOnset(trialNum) = (ExpInfo.StimDuration - ExpInfo.GbDuration)/2;

BlockData.StimGbOnset(trialNum) = ...
    BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime + BlockData.DurGbOnset(trialNum); % Think about if we need a latency correction of 0.005s.

% Draw the Gabor stimulus
if ExpInfo.randGaborPos == 1
    drawGabors(ExpInfo, ExpInfo.GaborSquare(trialNum), BlockData.Orientation(trialNum))
else
    drawGabors(ExpInfo, ExpInfo.GaborSquare(1), BlockData.Orientation(trialNum))
end

% Wait to flip 
[BlockData.StimGbFlipTime(trialNum), ~, ...
    BlockData.StimGbFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.StimGbOnset(trialNum));
    
% Timestamp for the Gabor flip
BlockData.StimGbFlipTime(trialNum) = ...
    BlockData.StimGbFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.StimGbFlipEnd(trialNum) = ...
    BlockData.StimGbFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);

% Clear the Gabor stimuli

gbClearTime = BlockData.FixFlipTime(trialNum) + BlockData.StimGbFlipTime(trialNum) + ExpInfo.GbDuration;

[BlockData.GbClearFlipTime(trialNum), ~, ...
    BlockData.GbClearFlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, gbClearTime);

BlockData.GbClearFlipTime(trialNum) = ...
    BlockData.GbClearFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
BlockData.GbClearFlipEnd(trialNum)= ...
    BlockData.GbClearFlipEnd(trialNum)- BlockData.FixFlipTime(trialNum);

% Stop the audio stimulus

AudStopTime =BlockData.FixFlipTime(trialNum)+BlockData.StimAudFlipTime(trialNum)+BlockData.AudDur(trialNum);

[~,BlockData.endAudPositionSecs(trialNum),~,BlockData.estAudStopTime(trialNum)] = PsychPortAudio('Stop',pahandle_main,ExpInfo.WaitForEndOfPlayback,[],[],AudStopTime);
PsychPortAudio('Close', pahandle_main);


%% Collect response

% Prepare to monitor for a response (Audio)
relevantKeyPress = false;
whichresp = 1; % record as the first response (audio)
drawResponseWin(ExpInfo,ExpInfo.ResponsePromptAud,[],whichresp,0)

BlockData.Resp1PrmptTime (trialNum) = BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime + ExpInfo.StimDuration;

% Wait to flip for the first response screen
[BlockData.Resp1FlipTime(trialNum), ~, ...
    BlockData.Resp1FlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.Resp1PrmptTime (trialNum));


BlockData.Resp1FlipTime(trialNum) = BlockData.Resp1FlipTime(trialNum)-BlockData.FixFlipTime(trialNum);
BlockData.Resp1FlipEnd(trialNum) = BlockData.Resp1FlipEnd(trialNum)-BlockData.FixFlipTime(trialNum);

% Work out when to clear the first response screen (and show the next response screen)
BlockData.Resp1ScrClearTime(trialNum) = BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime + ExpInfo.StimDuration + ExpInfo.SpResponseDur;

% Monitor for response 1 (Aud)

while ~relevantKeyPress && (GetSecs < BlockData.Resp1ScrClearTime(trialNum))
    
    [relevantKeyPress, BlockData] = checkForResp(ExpInfo,BlockData, trialNum, whichresp); % added a check for wrong keys within the function
     
end


% Prepare to monitor for a response (Gabor)
relevantKeyPress = false;
whichresp = 2; % record as the second response (Gabor)
drawResponseWin(ExpInfo,ExpInfo.ResponsePromptGb,[],whichresp,0)

% Filp to show the response screen

[BlockData.Resp2FlipTime(trialNum), ~, ...
    BlockData.Resp2FlipEnd(trialNum), ~, ~] = ...
    Screen('Flip', ExpInfo.Win, BlockData.Resp1ScrClearTime(trialNum));

BlockData.Resp2FlipTime(trialNum) = BlockData.Resp2FlipTime(trialNum)-BlockData.FixFlipTime(trialNum);
BlockData.Resp2FlipEnd(trialNum) = BlockData.Resp2FlipEnd(trialNum)-BlockData.FixFlipTime(trialNum);

% Work out when to clear the first response screen (and show the next response screen)
BlockData.Resp2ScrClearTime(trialNum) = BlockData.FixFlipTime(trialNum) + ExpInfo.FixTime + ExpInfo.StimDuration + ExpInfo.SpResponseDur + ExpInfo.GbResponseDur;

% Monitor for response 2 (Gabor)

while ~relevantKeyPress && (GetSecs < BlockData.Resp2ScrClearTime(trialNum))
    
    [relevantKeyPress, BlockData] = checkForResp(ExpInfo,BlockData, trialNum, whichresp); % added a check for wrong keys within the function
     
end




%% Finish up

%%% For rest blocks, show the rest screen for about 10-14s; For the last
%%% rest block in each run, show the End Welcome.

if (ismember(session,3:9)) && (ismember(trialNum,ExpInfo.TrialIdxRest(:,1)))
    
    %feedbackColour = [86, 180, 233]; % this is blue, but we need green
    % feedbackColour = [113, 239, 107]; % this is green
    
    Screen('DrawLines', ExpInfo.Win, ...
        [scCenter(1) scCenter(1) (fixationScale)+scCenter(1) (-fixationScale)+scCenter(1);
        (fixationScale)+scCenter(2) (-fixationScale)+scCenter(2) scCenter(2) scCenter(2)],...
        fixationScale*(6/15), ExpInfo.FeedbackColour);

    [BlockData.EndPromptFlipTime(trialNum), ~, ...
        BlockData.EndPromptFlipEnd(trialNum), ~, ~] = ...
        Screen('Flip', ExpInfo.Win, BlockData.Resp2ScrClearTime(trialNum));
    
    BlockData.TrialDuration(trialNum) = toc(trialStart);
    BlockData.EndPromptFlipTime(trialNum) = BlockData.EndPromptFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
    BlockData.EndPromptFlipEnd(trialNum) = BlockData.EndPromptFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);
    BlockData.BlockEndTime(trialNum) = GetSecs-BlockData.RunStartTime(ExpInfo.TrialIdx(1));
    
    if session == 3
        BlockData.BlockDur(trialNum) = BlockData.BlockEndTime(trialNum)-BlockData.BlockStartTime(trialNum-ExpInfo.TrialperCondMainTrain+1);
    else
        BlockData.BlockDur(trialNum) = BlockData.BlockEndTime(trialNum)-BlockData.BlockStartTime(trialNum-ExpInfo.TrialperCondMain+1);
    end
    
    WaitSecs(ExpInfo.TrialIdxRest(ExpInfo.TrialIdxRest(:,1) == trialNum,2))
    
elseif (ismember(session,2:9)) && (trialNum == ExpInfo.TrialIdxRunEnd)
    
    if session == 2
        formattedWord = strcat('<font=Arial><size=35><i>',ExpInfo.PromptPretrainEnd);
    elseif session == 3
        formattedWord = strcat('<font=Arial><size=35><i>',ExpInfo.PromptMaintrainEnd);
    elseif ismember(session,4:8)
        formattedWord = strcat('<font=Arial><size=35><i>',ExpInfo.PromptMainRunEnd);
    else
        formattedWord = strcat('<font=Arial><size=35><i>',ExpInfo.PromptMainEnd);
    end
    
    DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour);
    
    [BlockData.EndPromptFlipTime(trialNum), ~, ...
        BlockData.EndPromptFlipEnd(trialNum), ~, ~] = ...
        Screen('Flip', ExpInfo.Win, BlockData.Resp2ScrClearTime(trialNum));
    
    BlockData.TrialDuration(trialNum) = toc(trialStart);
    BlockData.EndPromptFlipTime(trialNum) = BlockData.EndPromptFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
    BlockData.EndPromptFlipEnd(trialNum) = BlockData.EndPromptFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);
    
    if ismember(session,3:9)
    
%         KbName('UnifyKeyNames');
%         DisableKeysForKbCheck(40); % return key is a 'stuck' key. Disable it.
%         trigger_count = 0;
%         disp('Waiting for 10 triggers')

        BlockData.RunEndTime(trialNum) = GetSecs - BlockData.RunStartTime(ExpInfo.TrialIdx(1));
        BlockData.RunDur(trialNum) = BlockData.RunEndTime(trialNum);
        BlockData.BlockEndTime(trialNum) = BlockData.RunEndTime(trialNum);
        
        if session == 3
            BlockData.BlockDur(trialNum) = BlockData.BlockEndTime(trialNum)-BlockData.BlockStartTime(trialNum-ExpInfo.TrialperCondMainTrain+1);
        else
            BlockData.BlockDur(trialNum) = BlockData.BlockEndTime(trialNum)-BlockData.BlockStartTime(trialNum-ExpInfo.TrialperCondMain+1);
        end
        
%         while 1
%             [waitcmd, ~, ~, keypressed] = KbQueueCheck(ExpInfo.TriggerDevice);
%             if waitcmd
%                 keypressed = string(KbName(keypressed));
% 
%                 if keypressed == ExpInfo.TriggerCode
%                     WaitSecs(0.1);
%                     KbQueueFlush(ExpInfo.TriggerDevice);
%                     trigger_count = trigger_count+1;
%                     disp(strcat("Dummy:",string(trigger_count)))
% 
%                     if trigger_count == 10
%                         BlockData.EndTriggerEndTime(trialNum) = GetSecs - BlockData.RunStartTime(ExpInfo.TrialIdx(1));
%                         BlockData.EndTriggerDur(trialNum) = BlockData.EndTriggerEndTime(trialNum) - BlockData.RunEndTime(trialNum);
%                         break
%                     end
% 
%                 end
%             end
%         end
% 
%         KbQueueStop(ExpInfo.TriggerDevice)
%         KbQueueFlush(ExpInfo.TriggerDevice)
%         KbQueueRelease(ExpInfo.TriggerDevice)
    end
    
   
    WaitSecs(2.0)

else
    
    [BlockData.EndPromptFlipTime(trialNum), ~, ...
        BlockData.EndPromptFlipEnd(trialNum), ~, ~] = ...
        Screen('Flip', ExpInfo.Win, BlockData.Resp2ScrClearTime(trialNum));
    
    BlockData.TrialDuration(trialNum) = toc(trialStart);
    BlockData.EndPromptFlipTime(trialNum) = BlockData.EndPromptFlipTime(trialNum) - BlockData.FixFlipTime(trialNum);
    BlockData.EndPromptFlipEnd(trialNum) = BlockData.EndPromptFlipEnd(trialNum) - BlockData.FixFlipTime(trialNum);
    
end