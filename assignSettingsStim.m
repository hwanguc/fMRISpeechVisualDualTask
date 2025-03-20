function ExpInfo = assignSettingsStim(subj)
% Assign all the Data.Settings which are universal to all trials, and specifics of
% the set up.

%% Basics

% Seed the random numbr generator
rng('shuffle');
ExpInfo.RandGenerator = rng;


% Set up the computer
Priority(1);
% HideCursor();
% ListenChar(1);
% KbName('UnifyKeyNames');


%% Psychtoolbox Data.Settings


% Create and open a blank window
% windowPtr = 0;
% 
% [ExpInfo.Win, ExpInfo.WinArea] = Screen('OpenWindow', windowPtr); 
% 
% ExpInfo.ScreenCenter = [ ExpInfo.WinArea(3)/2 ; ExpInfo.WinArea(4)/2 ]; 
% 
% 
% % Test that the refresh rate is as expected
% ExpInfo.RefreshRate = Screen('NominalFrameRate', ExpInfo.Win);
% 
% 
% if ExpInfo.RefreshRate ~= 60 || ...
%     ~isequal(ExpInfo.WinArea, [0 0 1920 1080])
%     
%     sca
%     error('Error: Unexpected refresh rate or screen size.')
%     
%     
% end
% 
% 
% % Set the colours to use
% ExpInfo.Colour.Base = [0.5 0.5 0.5]*255;
% 
% 
% % Fill screen with background colour
% Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
% 
% 
% % Set text sizes
% ExpInfo.Text.Size2 = 20;
% 
% 
% % Set font
% Screen('TextFont', ExpInfo.Win, 'Helvetica')

%% Experiment structure

%%%% Subject

ExpInfo.Subject = subj;

% %%%% Universal
% ExpInfo.TrialperCondition = 6;
% ExpInfo.NumConditions = 4;

%%%% Pre-train speech
ExpInfo.TrialperCondPreSp = 6;
ExpInfo.NumCondPreSp = 2;
ExpInfo.RepCondPreSp = 1; % number of repetition of the block of conditions per run in the pre-train phase
ExpInfo.RepRunPreSp = 1; % number of repetition of runs in the pre-train phase

%%%% Pre-train dual-task
ExpInfo.TrialperCondPreDual = 4;
ExpInfo.NumCondPreDual = 4;
ExpInfo.RepCondPreDual = 1; % number of repetition of the block of conditions per run in the pre-train phase
ExpInfo.RepRunPreDual = 1; % number of repetition of runs in the pre-train phase

%%%% Main phase (Training)
ExpInfo.TrialperCondMainTrain = 4;
ExpInfo.NumCondMainTrain = 4;
ExpInfo.RepCondMainTrain = 1; % number of repetition of the block of conditions per run in the pre-train phase
ExpInfo.RepRunMainTrain = 1; % number of repetition of runs in the pre-train phase

%%%% Main phase

ExpInfo.TrialperCondMain = 6;
ExpInfo.NumCondMain = 4;
ExpInfo.RepCondMain = 2; % number of repetition of the block of conditions per run in the MAIN phase
ExpInfo.RepRunMain = 6; % number of repetition of runs in the MAIN phase

%%%% Post-test phase

ExpInfo.TrialperCondPost = 24;
ExpInfo.NumCondPost = 4;
ExpInfo.RepCondPost = 1; % number of repetition of the block of conditions per run in the post phase, respectively corresponding to new and old sentences
ExpInfo.RepRunPost = 1; % number of repetition of runs in the post phase

%%% num of Trials

ExpInfo.numPreSp = ExpInfo.TrialperCondPreSp*ExpInfo.NumCondPreSp*ExpInfo.RepCondPreSp*ExpInfo.RepRunPreSp; %%% num of pre-train trials (speech only session)
ExpInfo.numPreDual = ExpInfo.TrialperCondPreDual*ExpInfo.NumCondPreDual*ExpInfo.RepCondPreDual*ExpInfo.RepRunPreDual; %%% num of pre-train trials (dual-task session)
ExpInfo.numMainTrain = ExpInfo.TrialperCondMainTrain*ExpInfo.NumCondMainTrain*ExpInfo.RepCondMainTrain*ExpInfo.RepRunMainTrain; %%% num of the training trials for the main session
ExpInfo.numMain = ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain*ExpInfo.RepRunMain; %%% num of main trials
ExpInfo.numPostOld = ExpInfo.TrialperCondPost*ExpInfo.NumCondPost*ExpInfo.RepCondPost; % number of old sentences in the post-test
ExpInfo.numPostNew = 32; % number of new sentences in the post-test
ExpInfo.numPosttest = (ExpInfo.numPostOld + ExpInfo.numPostNew)*ExpInfo.RepRunPost; %%% total num of posttest trials

ExpInfo.numTrialDual = ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain;
ExpInfo.numTrialPretrainMain = ExpInfo.numPreSp+ExpInfo.numTrialDual;
ExpInfo.numTrialTotal = ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain+ExpInfo.numPosttest;


% %% Timing
% 
% ExpInfo.FixTime = 0.3; % Duration of the fixation cross
% ExpInfo.StimDuration = 0.200; 


%% Display

% % Set size of fixation cross
% ExpInfo.FixationScale = 6;


% Pick orientation statistics
ExpInfo.InitAngle = 0;
ExpInfo.MeanAngle = pi/4;
ExpInfo.DistractorKappa = 0; % Concentration parameter, one for each
ExpInfo.DistractorVar = 0.35;


% block type
% Determine Gabor center locations

% First specify the angles from verticle that want the Gabors

% The locations of the Gabors range in -pi to pi from the vertical.
ExpInfo.PosInit = -1;
ExpInfo.PosEnd = 1;

ExpInfo.Theta = NaN(ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain,1);

p = 0;

while p < 0.999
    
    ExpInfo.Theta = ExpInfo.PosInit + (ExpInfo.PosEnd-ExpInfo.PosInit).*rand(ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain,1);
    pd = makedist('uniform','lower',ExpInfo.PosInit,'upper',ExpInfo.PosEnd);
    [~,p] = kstest(ExpInfo.Theta,'cdf',pd);
    
end

ExpInfo.Theta = ExpInfo.Theta*pi;


% % Specify the radius of the circle on which the Gabors will be located
% ExpInfo.RGabor = 196;
% 
% 
% % Compute the displacement from screen center of the Gabors
% xDisp = ExpInfo.RGabor * sin(ExpInfo.Theta);
% yDisp = ExpInfo.RGabor * cos(ExpInfo.Theta);
% 
% 
% % Compute the locations on the screen in Psychtoolbox coords
% x = round(xDisp) + ExpInfo.ScreenCenter(1);
% y = -round(yDisp) + ExpInfo.ScreenCenter(2);
% 
% 
% ExpInfo.GaborCenters = [x, y];
% 
% 
% % Define the squares in which the Gabors will be placed
% ExpInfo.GaborSD = 10;
% ExpInfo.GaborSquareWidth = (10 * ExpInfo.GaborSD) +1; %In pixels
% halfWidth = (1/2) * (ExpInfo.GaborSquareWidth -1);
% 
% for iGabor = 1 : length(ExpInfo.Theta)
%     
%     center = ExpInfo.GaborCenters(iGabor, :);
%     
%     ExpInfo.GaborSquare{iGabor} = [(center(1) - halfWidth -1), ...
%         (center(2) - halfWidth -1), ...
%         (center(1) + halfWidth), ...
%         (center(2) + halfWidth)];
%     
%     
% end
% 
% 
% % Define the rectangle in which the screenshot will be taken
% 
% leftEdge = ExpInfo.ScreenCenter(1)-ExpInfo.RGabor;
% topEdge = ExpInfo.ScreenCenter(2)-ExpInfo.RGabor;
% rightEdge = ExpInfo.ScreenCenter(1)+ExpInfo.RGabor;
% buttomEdge = ExpInfo.ScreenCenter(2)+ExpInfo.RGabor;
% 
% ExpInfo.ImageSquare = [(leftEdge - 3*halfWidth -1), ...
%     (topEdge - 3*halfWidth -1), ...
%     (rightEdge + 3*halfWidth), ...
%     (buttomEdge + 3*halfWidth)];

% % Check there is no overlap of boxes
% gaborMaps = zeros(ExpInfo.WinArea(3), ExpInfo.WinArea(4));
% 
% 
% for iGabor = 1 : length(ExpInfo.Theta)
%     
%     xLocationOfSquare = ...
%         ExpInfo.GaborSquare{iGabor}(1) : ExpInfo.GaborSquare{iGabor}(3);
%     
%     yLocationOfSquare = ...
%         ExpInfo.GaborSquare{iGabor}(2) : ExpInfo.GaborSquare{iGabor}(4);
% 
%     
%     gaborMaps(xLocationOfSquare, yLocationOfSquare) = ...
%         gaborMaps(xLocationOfSquare, yLocationOfSquare) + 1;
%     
%      
% end
% 
% 
% if any(any(gaborMaps > 1)); error('Bug'); end 

% % T-D mean range for Gabors. Difficulty ranges from 1 to 7.
% 
% if diff == 1
%     ExpInfo.TDRange = [circ_ang2rad(0) circ_ang2rad(12)];
% elseif diff == 2
%     ExpInfo.TDRange = [circ_ang2rad(24) circ_ang2rad(36)];
% elseif diff == 3
%     ExpInfo.TDRange = [circ_ang2rad(48) circ_ang2rad(60)];
% else
%     error('Please enter correct difficulty (1-3)!')
% end

% % T-D mean range for Gabors, two difficulty levels; Easy: TDRange(1) and
% TD Range(2), Difficult: TDRange(3) and TDRange(4)

ExpInfo.TDRange = [circ_ang2rad(48) circ_ang2rad(60) circ_ang2rad(6) circ_ang2rad(18)];


