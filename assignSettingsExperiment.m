function ExpInfo = assignSettingsExperiment(session,dryrun,ExpInfo)
% Assign all the Data.Settings which are universal to all trials, and specifics of
% the set up.

%% Basics

% Seed the random numbr generator
rng('shuffle');
ExpInfo.RandGenerator = rng;



% Set up the computer
Priority(1);
HideCursor();
% [ExpInfo.KbIDs, ExpInfo.KbNames] = GetKeyboardIndices; % gives names and indices for all connected keyboards.
% PsychHID('devices')
ListenChar(1);
KbName('UnifyKeyNames');

% Keyboard setup for scanner

ExpInfo.DryRun = dryrun;

% dryrun = 1; %%%%%%%%%%%%%%%%%%% change to 0 at scanner
ExpInfo.TriggerCode = 't';
ExpInfo.TriggerKeyCode = KbName(ExpInfo.TriggerCode);
ExpInfo.KeyList(1:256) = 0; % set all to 0
ExpInfo.KeyList(23) = 1; % set 23 to 1 for scanner trigger (t)
% button_list(1:256) = 0; % set all to 0
% button_list(35:39) = 1; % RH: (35:39), LH: (30:34) - 67890 (RH), 12345(LH)


%%% Get the correct ids for the trigger and button box:

if dryrun == 1
    % ExpInfo.ButtonDevice = ExpInfo.KbIDs(1); % id(1) for keyboard
    % ExpInfo.TriggerDevice = ExpInfo.KbIDs(2); % id(2) for the Arduino (to send in the triggers).
    % screendim = [0 0 640 480]; % [0 0 640 480];
    windowPtr = 0;% 0 for de-bugging, 1 for scanner projector
else
    % ExpInfo.ButtonDevice = ExpInfo.KbIDs(2); % 1 should always be mac keyboard. 2 or 3 would be the trigger and button device.
    % ExpInfo.TriggerDevice = ExpInfo.KbIDs(3);  % 3  
    %%%% button box serial no. = 6127060; trig serial no. = 2981970 %%%%
    % screendim = [];
    % Screen('Preference', 'SkipSyncTests', 1);
    windowPtr = 0; % 1 for scanner projector
end

% %%% Flush events when starting script again. 
% KbEventFlush
% KbQueueCreate
% KbQueueFlush
% KbQueueRelease
% disp('events flushed') 


%% Psychtoolbox Data.Settings


% Create and open a blank window


[ExpInfo.Win, ExpInfo.WinArea] = Screen('OpenWindow', windowPtr); 

ExpInfo.ScreenCenter = [ ExpInfo.WinArea(3)/2 ; ExpInfo.WinArea(4)/2 ]; 


% Test that the refresh rate is as expected
ExpInfo.RefreshRate = Screen('NominalFrameRate', ExpInfo.Win);


% if ExpInfo.RefreshRate ~= 60 || ...
%     ~isequal(ExpInfo.WinArea, [0 0 1920 1080])
%     
%     sca
%     error('Error: Unexpected refresh rate or screen size.')
%     
%     
% end


% Set the colours to use
ExpInfo.Colour.Base = [0.5 0.5 0.5]*255;


% Fill screen with background colour
Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);

% Set the "hear speech" image for the pre-speech session
ExpInfo.HearSpeechIM = imread([pwd '\Image\hear_speech.png']);

ExpInfo.HearSpeechIMwid = 384;
ExpInfo.HearSpeechIMht = 312;

ExpInfo.HearSpeechSquare = [((ExpInfo.WinArea(3)-ExpInfo.HearSpeechIMwid)/2), ...
    (ExpInfo.WinArea(4)/2-ExpInfo.HearSpeechIMht/2), ...
    ((ExpInfo.WinArea(3)-ExpInfo.HearSpeechIMwid)/2+ExpInfo.HearSpeechIMwid), ...
    (ExpInfo.WinArea(4)/2+ExpInfo.HearSpeechIMht/2)];

% Set text sizes
ExpInfo.Text.Size2 = 20;

% Set response prompt
ExpInfo.ResponsePromptAud = "Gist?";
ExpInfo.ResponsePromptGb = "45 degrees?";
ExpInfo.ResponsePromptMemory = "Did you hear the sentence in the main experiment?";

% Set prompt picture (left/right key layout)

if (dryrun == 0) && (ismember(session,3:9))
    ExpInfo.PromptIM = imread([pwd '\Image\buttonbox_left.png']);
else
    ExpInfo.PromptIM = imread([pwd '\Image\key_left_right.png']);
end

ExpInfo.PromptIMwid = 540;
ExpInfo.PromptIMht = 360;

ExpInfo.PromptSquare = [((ExpInfo.WinArea(3)-ExpInfo.PromptIMwid)/2), ...
    (ExpInfo.WinArea(4)/2+60), ...
    ((ExpInfo.WinArea(3)-ExpInfo.PromptIMwid)/2+ExpInfo.PromptIMwid), ...
    (ExpInfo.WinArea(4)/2+60+ExpInfo.PromptIMht)];

% Set prompt for left/right arrow key presses and wrong key press


if (dryrun == 0) && (ismember(session,3:9))
    ExpInfo.PromptLeftRight = "Button press recorded!";
    ExpInfo.PromptWrongkey = "Wrong button! Press FIRST or SECOND button to respond.";
else
    ExpInfo.PromptLeftRight = "Key press recorded!";
    ExpInfo.PromptWrongkey = "Wrong key! Press LEFT or RIGHT arrow key to respond.";
end


% Set prompt for the end for the run/pretrain/main, or the whole experiment

ExpInfo.PromptPretrainEnd = "This is the end of the current training session, please get the experimenter's attention!";
ExpInfo.PromptMaintrainEnd = "This is the end of the training session, please wait for the insturction!";
ExpInfo.PromptMainRunEnd = "Please now take some rest before the next session!";
ExpInfo.PromptMainEnd = "This is the end of the main experiment, please get the experimenter's attention!";
ExpInfo.PromptExperimentEnd = "This is the end of experiment, thanks so much for your time!";

% Set font
Screen('TextFont', ExpInfo.Win, 'Arial')

%% Experiment structure

ExpInfo.Session = session; % Current session

%%% Work out the indexs of the trials in the current run and the trials
%%% that need a rest
if session == 1 % Session pre-speech
    ExpInfo.TrialIdx = transpose(1:ExpInfo.numPreSp);
elseif session == 2 % Session pre-dual
    ExpInfo.TrialIdx = transpose(ExpInfo.numPreSp+1:ExpInfo.numPreSp+ExpInfo.numPreDual);
    ExpInfo.TrialIdxRunEnd = ExpInfo.TrialIdx(end); % No rest for the pre-dual session, so we define the TrialIdxRunEnd manually.
elseif session == 3 % Session main-train
    ExpInfo.TrialIdx = transpose(ExpInfo.numPreSp+ExpInfo.numPreDual+1:ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain);
    ExpInfo.TrialIdxSpecial = ExpInfo.TrialIdx(mod(ExpInfo.TrialIdx-ExpInfo.numPreSp-ExpInfo.numPreDual,ExpInfo.TrialperCondMainTrain) == 0);
    ExpInfo.TrialIdxCondInit = ExpInfo.TrialIdxSpecial-ExpInfo.TrialperCondMainTrain+1;
    ExpInfo.TrialIdxRest(:,1) = ExpInfo.TrialIdxSpecial(1:end-1);
    ExpInfo.TrialIdxRest(:,2) = 10 + (14-10).*rand(ExpInfo.NumCondMainTrain*ExpInfo.RepCondMainTrain-1,1); % duration of the rest period from an uniform distribution: min 10s, max 14s, 7 = number of rest block per run.
    ExpInfo.TrialIdxRunEnd = ExpInfo.TrialIdxSpecial(end);
elseif ismember(session,4:9) % Session main
    ExpInfo.TrialIdx = transpose((session-4)*ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain+1+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain:...
        (session-3)*ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain);
    ExpInfo.TrialIdxSpecial = ExpInfo.TrialIdx(mod(ExpInfo.TrialIdx-ExpInfo.numPreSp-ExpInfo.numPreDual-ExpInfo.numMainTrain,ExpInfo.TrialperCondMain) == 0); % 6 = number of trials per block
    ExpInfo.TrialIdxCondInit = ExpInfo.TrialIdxSpecial-ExpInfo.TrialperCondMain+1;
    ExpInfo.TrialIdxRest(:,1) = ExpInfo.TrialIdxSpecial(1:end-1);
    ExpInfo.TrialIdxRest(:,2) = 10 + (14-10).*rand(ExpInfo.NumCondMain*ExpInfo.RepCondMain-1,1); % duration of the rest period from an uniform distribution: min 10s, max 14s, 7 = number of rest block per run.
    ExpInfo.TrialIdxRunEnd = ExpInfo.TrialIdxSpecial(end);
elseif session == 10 % Session post-test
    ExpInfo.TrialIdx = transpose(ExpInfo.numTrialPretrainMain+1:ExpInfo.numTrialTotal);
end


%% Timing

ExpInfo.FixTime = 0.200; % Duration of the fixation cross
ExpInfo.StimDuration = 2.000;
ExpInfo.GbDuration = 0.300;
ExpInfo.SpResponseDur = 1.500;
ExpInfo.GbResponseDur = 1.500;
ExpInfo.ISI = ExpInfo.FixTime + ExpInfo.StimDuration + ExpInfo.SpResponseDur + ExpInfo.GbResponseDur;
ExpInfo.RestDur = 12.000;
ExpInfo.MemoryStimDuration = 3.000;


%% Audio playback

ExpInfo.WavfilenameDemo = [pwd '\audiostim\demo\bkbt1113_4ch_maltese.wav'];
ExpInfo.Repetitions = 1;
ExpInfo.WaittoStartDemo = 0;
ExpInfo.WaitForEndOfPlayback = 1;

%% Display

% Set size of fixation cross
ExpInfo.FixationScale = 10;

% Set colour for rest and trigger waiting fixation cross
ExpInfo.FeedbackColour = [113, 239, 107]; % this is green

% Set the colour for response prompt text

ExpInfo.TextColour  = [255 255 255]; % Colour for most text: white
%ExpInfo.TextColourGist = [43 217 217]; % Colour for speech "Gist?" prompt
ExpInfo.TextColourGist = [35 194 211]; % Colour for speech "Gist?" prompt
ExpInfo.TextColourGabor = [255 217 102]; % Colour for the "45 degrees?" prompt



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Here, define the squares on the screen to contain the Gabor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Specify the radius of the circle on which the Gabors will be located
ExpInfo.RGabor = 196;


% Compute the displacement from screen center to the Gabors
xDisp = ExpInfo.RGabor * sin(ExpInfo.Theta);
yDisp = ExpInfo.RGabor * cos(ExpInfo.Theta);


% Compute the locations on the screen in Psychtoolbox coords
x = round(xDisp) + ExpInfo.ScreenCenter(1);
y = -round(yDisp) + ExpInfo.ScreenCenter(2);


ExpInfo.randGaborPos = 0; % Do we need to change Gabor position per trial? (1 = yes, 0 = no)

if ExpInfo.randGaborPos == 1
    ExpInfo.GaborCenters = [x, y];
else
    ExpInfo.GaborCenters = ExpInfo.ScreenCenter;
end

% Define the squares in which the Gabors will be placed
ExpInfo.GaborSD = 20; % Original GaborSD = 10.
ExpInfo.GaborSquareWidth = (10 * ExpInfo.GaborSD) +1; %In pixels
halfWidth = (1/2) * (ExpInfo.GaborSquareWidth -1);

if ExpInfo.randGaborPos == 1
    for iGabor = 1 : length(ExpInfo.Theta)

        center = ExpInfo.GaborCenters(iGabor, :);

        ExpInfo.GaborSquare{iGabor} = [(center(1) - halfWidth -1), ...
            (center(2) - halfWidth -1), ...
            (center(1) + halfWidth), ...
            (center(2) + halfWidth)];
    end
else
    ExpInfo.GaborSquare{1} = [(ExpInfo.GaborCenters(1) - halfWidth -1), ...
        (ExpInfo.GaborCenters(2) - halfWidth -1), ...
        (ExpInfo.GaborCenters(1) + halfWidth), ...
        (ExpInfo.GaborCenters(2) + halfWidth)];
end
    
    


