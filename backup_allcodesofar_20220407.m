
PsychStartup: Adding path of installed GStreamer runtime to library path. [C:\gstreamer\1.0\msvc_x86_64\bin]
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

%%%% Universal
ExpInfo.TrialperCondition = 6;
ExpInfo.NumConditions = 4;

%%%% Pre-train phase
ExpInfo.RepCondPretrain = 1; % number of repetition of the block of conditions per run in the pre-train phase
ExpInfo.RepRunPretrain = 1; % number of repetition of runs in the pre-train phase

%%%% Main phase

ExpInfo.RepCondMain = 2; % number of repetition of the block of conditions per run in the MAIN phase
ExpInfo.RepRunMain = 8; % number of repetition of runs in the MAIN phase

%%%% Post-test phase

ExpInfo.TrialperConditionPost = 8;
ExpInfo.RepCondPost = 2; % number of repetition of the block of conditions per run in the post phase, respectively corresponding to new and old sentences
ExpInfo.RepRunPost = 1; % number of repetition of runs in the post phase

%%% num of Trials

ExpInfo.numPretrain = ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain*ExpInfo.RepRunPretrain; %%% num of pre-train trials
ExpInfo.numMain = ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain*ExpInfo.RepRunMain; %%% num of main trials
ExpInfo.numPosttest = ExpInfo.TrialperConditionPost*ExpInfo.NumConditions*ExpInfo.RepCondPost*ExpInfo.RepRunPost; %%% num of posttest trials

ExpInfo.numTrialTotal = ExpInfo.numPretrain+ExpInfo.numMain+ExpInfo.numPosttest;
numTrialTotal = ExpInfo.numTrialTotal;
numPretrainMain = ExpInfo.numPretrain+ExpInfo.numMain;

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

ExpInfo.Theta = NaN(ExpInfo.numPretrain+ExpInfo.numMain,1);

p = 0;

while p < 0.999
    
    ExpInfo.Theta = ExpInfo.PosInit + (ExpInfo.PosEnd-ExpInfo.PosInit).*rand(ExpInfo.numPretrain+ExpInfo.numMain,1);
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
PTB-INFO: Multi-display setup in explicit multi-display mode detected. Using the following mapping:
PTB-INFO: Screen 0 corresponds to the full Windows desktop area. Useful for stereo presentations in stereomode=4 ...
PTB-INFO: Screen 1 corresponds to the display area of the monitor with the Windows-internal name \\.\DISPLAY1 ...
PTB-INFO: Screen 2 corresponds to the display area of the monitor with the Windows-internal name \\.\DISPLAY2 ...

PTB-INFO: Your version of Matlab 64-Bit is global system DPI aware. On Windows-8 or later, fullscreen onscreen windows will only work 
PTB-INFO: properly timing-wise when displayed on displays with the same pixel density as your systems primary display monitor.
PTB-INFO: For your multi-display setup the stimulus display monitor must have a DPI of (96, 96), matching that of
PTB-INFO: your primary display monitor. Ideally you will only display on the primary display in the first place.
PTB-INFO: Displaying on anything with a different DPI will cause mysterious visual timing problems, sync failures etc.
PTB-INFO: Read 'help RetinaDisplay' for more info on this topic.
%% Set up

% Initialise

%%% BlockInfo - These will be kept here.

BlockData.Sequence =  transpose(1:numTrialTotal);
BlockData.Session = strings([numTrialTotal,1]);
BlockData.Run = NaN(numTrialTotal, 1);
BlockData.Block = strings([numTrialTotal,1]);
BlockData.Sentence = strings([numTrialTotal,1]);
BlockData.Keyword1 = strings([numTrialTotal,1]);
BlockData.Keyword2 = strings([numTrialTotal,1]);
BlockData.Keyword3 = strings([numTrialTotal,1]);
BlockData.Keyword4 = strings([numTrialTotal,1]);
BlockData.AudDur = NaN(numTrialTotal, 1);
BlockData.Orientation = NaN(numPretrainMain, 1);
BlockData.Image = strings([numPretrainMain,1]);
BlockData.TargetPresence = NaN(numPretrainMain, 1);
BlockData.GaborLoc = ExpInfo.Theta;
BlockData.TD = NaN(numPretrainMain, 1);


% Fill in Session

session = {'pretrain'; 'main'; 'posttest'};
BlockData.Session = repelem(session,[ExpInfo.numPretrain,ExpInfo.numMain,ExpInfo.numPosttest]);

% Fill in Run

runPretrain = transpose(repelem(ExpInfo.RepRunPretrain,ExpInfo.numPretrain/ExpInfo.RepRunPretrain));
runMain = transpose(repelem(ExpInfo.RepRunPretrain+1:ExpInfo.RepRunPretrain+ExpInfo.RepRunMain,ExpInfo.numMain/ExpInfo.RepRunMain));
runPosttest = transpose(repelem(ExpInfo.RepRunPretrain+ExpInfo.RepRunMain+1:ExpInfo.RepRunPretrain+ExpInfo.RepRunMain+ExpInfo.RepRunPost,...
    ExpInfo.numPosttest/ExpInfo.RepRunPost));
BlockData.Run = [runPretrain; runMain; runPosttest];

% Fill in Block

block = transpose(1:4);
blockPrenMain = repmat(block,ExpInfo.RepCondPretrain*ExpInfo.RepRunPretrain+ExpInfo.RepCondMain*ExpInfo.RepRunMain,1);
blockPrenMain(1:ExpInfo.NumConditions,1) = Shuffle(blockPrenMain(1:ExpInfo.NumConditions,1));
blockMain_reshape = reshape(blockPrenMain(ExpInfo.NumConditions*ExpInfo.RepCondPretrain*ExpInfo.RepRunPretrain+1:length(blockPrenMain)),...
    ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);

tempBlock = [0 0];
tempBlock_norep = 0;

while length(tempBlock_norep)<length(tempBlock)
    for iBlock = 1:length(blockMain_reshape)
        blockMain_reshape(:,iBlock)= Shuffle(blockMain_reshape(:,iBlock));
    end
    tempBlock = transpose([blockPrenMain(1:ExpInfo.NumConditions,1);reshape(blockMain_reshape,numel(blockMain_reshape),1)]);
    tempBlock_norep = tempBlock([true diff(tempBlock)~=0]);
end

BlockData.Block = transpose(repelem(tempBlock,ExpInfo.TrialperCondition));
%% Extract the speech stimuli

% read the stimuli

spRaw = readtable('sentence_raw_withdur.csv'); % read raw speech spreadsheet
sp_keywords= [spRaw.filename,spRaw.keyword_1,spRaw.keyword_2,spRaw.keyword_3,spRaw.keyword_4,num2cell(spRaw.audio_dur)]; % pull out the keywords columns


% sample "new sentences" used for the posttest

[sp_sample_postnew{1,1},idx_sample_postnew{1,1}] = datasample(sp_keywords, ExpInfo.numPosttest/2, 'Replace', false);

% the pool of sentences left for the pre-train and main phases

idx_prenmain = setdiff(1:height(spRaw),idx_sample_postnew{1,1});
num_prenmain = length(sp_keywords(idx_prenmain,:)); % num of unique sentences for pretrain and main phases
[sp_prenmain{1,1},idx_prenmain_cell{1,1}] = datasample(sp_keywords(idx_prenmain,:), num_prenmain, 'Replace', false); % Note the index is based on the prenmain set, not the whole set.


% sample a set of sentences for pre-train and main phases that has lowest
% duplicates of keywords.

iSample = 1;

num_duplicate = ExpInfo.numPretrain+ExpInfo.numMain-num_prenmain; % num of residual sentences in pretrain and main phases.


fprintf('Started sampling to find the pretrain and main sentences...\n\n');
tic % set up a stopwatch

% Sample several sets of stimuli for the pre-train and main phases.
while iSample <= 2*10^5
    [sp_sample_prenmain{1,iSample},idx_sample_prenmain{1,iSample}] = datasample(sp_prenmain{1,1}(:,2:5),num_duplicate,'Replace',false); % Note that only col 2:5 were pulled out to save memory use.
    
    sp_sample_prenmain_merge{1,iSample} = [sp_prenmain{1,1}(:,2:5);sp_sample_prenmain{1,iSample}];
    idx_sample_prenmain_merge{1,iSample} = [idx_prenmain_cell{1,1},idx_sample_prenmain{1,iSample}];
   
    [uWords,ia,ic] = unique(lower(sp_sample_prenmain_merge{1,iSample}));
    emp_uWordsIdx = cellfun('isempty',uWords);
    fWords_thissample = accumarray(ic,1); % count the frequency of occurence of each keyword.
    fWords_thissample = fWords_thissample(~emp_uWordsIdx);
    fWords_allsample{1,iSample} = fWords_thissample;
    %fWords_sample_prenmainMax(iSample,1) = mean(fWords_allsample{1,iSample});
    fWords_sample_premainUniRate(iSample,1) = length(uWords(~emp_uWordsIdx))/sum(fWords_allsample{1,iSample});

    iSample = iSample +1;
end

fprintf('Maximum unique rate among the samples is: %.4f\n\n',max(fWords_sample_premainUniRate));
toc % End the stop watch
hist(fWords_sample_premainUniRate) % Show the distribution of the proportion of unique keywords across all samples

%idx_minSample = find(fWords_sample_premainUniRate == min(fWords_sample_premainUniRate));
idx_maxSample = find(fWords_sample_premainUniRate == max(fWords_sample_premainUniRate)); % find the most 'unique' samples.


fWords_sample_prenmainMax = NaN(1,length(idx_maxSample));

for idx = 1:length(idx_maxSample)
    fWords_sample_prenmainMax(1,idx) = max(fWords_allsample{1,idx_maxSample(idx)});
end

idx_minSample = find(fWords_sample_prenmainMax == min(fWords_sample_prenmainMax)); % Within the most 'unique samples', find the one with the least maximum repetition of keywords
idx_outputPrenMainSample = idx_sample_prenmain_merge{1,idx_maxSample(idx_minSample(1))};

sp_prenmain{1,2} = sp_prenmain{1,1}(idx_outputPrenMainSample,:); % Store the most 'unique' pre- and main sample.

% clear large variables to save memory storage.

dumped_vars = {'fWords_allsample','fWords_sample_premainUniRate','idx_sample_prenmain','idx_sample_prenmain_merge',...
    'sp_sample_prenmain','sp_sample_prenmain_merge'};
clear(dumped_vars{:});
Started sampling to find the pretrain and main sentences...

Maximum unique rate among the samples is: 0.3922

Elapsed time is 463.378100 seconds.
sp_prenmain_sentence = sp_prenmain{1,2}(:,1);
length(unique(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))

ans =

    24

length(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))

ans =

    24

while length(unique(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);
end
ExpInfo.NumConditions*ExpInfo.RepCondPretrain*ExpInfo.RepRunPretrain

ans =

     4

sum(idx_outputPrenMainSample)

ans =

       62146

ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain*ExpInfo.RepRunPretrain+1

ans =

    25

ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain

ans =

    48

ExpInfo.RepRunMain

ans =

     8

sp_main_run_unicount = [];

idxInitMain = ExpInfo.numPretrain+1;

while sum(sp_main_run_unicount)~=48 % change the number here too
    
    idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence))...
        = sp_prenmain_sentence(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    
    for iRun = 1:8 % change '8' to variables
      sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
    end
    
    sp_main_sentence_reshape = reshape(sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence)),...
        ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);
    
end
Unrecognized function or variable 'idx_prenmain_reord'.
 
sp_prenmain_sentence = sp_prenmain{1,2}(:,1);

%%% Check the pre-train phase
while length(unique(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);
end
sp_prenmain_sentence = sp_prenmain{1,2}(:,1);

idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);

%%% Check the pre-train phase
while length(unique(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);
end
sp_main_run_unicount = [];

idxInitMain = ExpInfo.numPretrain+1;

while sum(sp_main_run_unicount)~=48 % change the number here too
    
    idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence))...
        = sp_prenmain_sentence(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    
    for iRun = 1:8 % change '8' to variables
      sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
    end
    
    sp_main_sentence_reshape = reshape(sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence)),...
        ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);
    
end
Unrecognized function or variable 'sp_main_sentence_reshape'.
 
%% Reorder the speech stimuli (so that sentences are unique per run in the pre-train and main phases)

sp_prenmain_sentence = sp_prenmain{1,2}(:,1);

idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);

%%% Check the pre-train phase
while length(unique(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);
end

%%% Check the main phase

sp_main_run_unicount = [];

idxInitMain = ExpInfo.numPretrain+1;

while sum(sp_main_run_unicount)~=48 % change the number here too
    
    idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence))...
        = sp_prenmain_sentence(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    
    sp_main_sentence_reshape = reshape(sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence)),...
        ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);
    
    for iRun = 1:8 % change '8' to variables
      sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
    end

end
87  index = repmat(index,1,num_bind) ...
sum(sp_main_run_unicount)

ans =

   131

sp_main_run_unicount

sp_main_run_unicount =

    16
    16
    17
    16
    16
    17
    17
    16

sp_prenmain_sentence = sp_prenmain{1,2}(:,1);

idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);

%%% Check the pre-train phase
while length(unique(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence = sp_prenmain_sentence(idx_prenmain_reord);
end
sp_main_run_unicount = [];

idxInitMain = ExpInfo.numPretrain+1;
min(idx_prenmain_reord)

ans =

     1

max(idx_prenmain_reord)

ans =

   408

idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) 

ans =

  Columns 1 through 30

   187   291     8   309    40   139   407   244   290   174   408    85   234   259   262   363   321   393   245   185   178   391   146   165   318   227   398   136   361   190

  Columns 31 through 60

   237   157   369   405   341   287   208   298    96   365   404   319   195    51   248    15   149   317   384    55   148   199   328   375    20    10   378   155   198   156

  Columns 61 through 90

    24   135   175   402   236   134    50   302   193   131   122   172   299   356    99   102   137   348   220   270    31   159   377   118   140   216   389   400   264   246

  Columns 91 through 120

   240    69    28    41   274    59     9   232   202   340   275   362   124   368   383   279   310    43   255   225   374   323    26    89    22   349   269   167   386    35

  Columns 121 through 150

   249   206   263     4   179   343   203   313   231    52   390   294   235     7   324    60   333   360   194   397   160   176   112   284   311    93   335   116   273   114

  Columns 151 through 180

   359    29   197    34   388   183   296   385    19   345   325   394   381   152   373   162   372   109   336   217   399   121   395   154   182    92   247   366   117   163

  Columns 181 through 210

   138   301    82   239    57    67     5   119   277   129   276   295    61   200   168    71   252    64     6   332    46   305   210   161    90    94   304   192   266   358

  Columns 211 through 240

    83   260   288   181   169   125    12   355   189    13   278    18   364   320   207   250   218    73   211   115   338   127    58    76    84   251   315   342   406   108

  Columns 241 through 270

   242   346   133    56   334   403   344   170    77   308   316   380   339     3   111    44    95    48   184   376    54    11   103   196   226   401    88   141   219   331

  Columns 271 through 300

   101    68    63    72   180    49    30   142   283   293    14   257   144   104    47   265    78   352     2   228    53   350    33    81    80    75   370   351   191   241

  Columns 301 through 330

     1   327   126   371   330   229   177   166   303   171   314    62   286   128   164    45   201    27   123    23   337   143   268   322   382   289   110   209    98   147

  Columns 331 through 360

   173   222   223    36   292   153   158    38   230   392   254   281    91    66   329   186   307   238   253   258   297    17   214   272   326   215   213    74   105    16

  Columns 361 through 384

   256   282   233   212   261   300   100    97   285   130   151    87   106    32   150   280    86   113    37    65   387   188   132    42

length(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) )

ans =

   384

Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)))

ans =

  Columns 1 through 30

    74   344   335   395    99    75    36   230   375     3   366   264   143    16   364   304   133   252   134    47   136   256   248   263   241   297   281   337   207   315

  Columns 31 through 60

   270    51    45   121   117    61   163   130   147   258   183    48    69   319   219   351    94   407   247   288   316   239    66   122   376    11   390   280   226   177

  Columns 61 through 90

   189   148    93    63    82    80   386   327   174    58   167   294   180    32    62    29   290   128   113   231    72   229   179     8   360   131   361   359   355   228

  Columns 91 through 120

   398    85   212    30   406     7   144   199   238   103   170   126   374   234   349    34     4    10   324   286     9   225   345    95   393   404   193   185   100    35

  Columns 121 through 150

   341    90    50   284   292   242   153     6   232   114   257    33   217   402    64   138    56   154   176    28   291   220   123   127   150   346   191   160    81    53

  Columns 151 through 180

   169   236   323    77   184   391    96   282   253   340   303   265    13   408   295   405   363   192   352   275   213   201   277   326    60   299   305    38   173     5

  Columns 181 through 210

    59   211   215    65   209    55   235   342   377   343    26   388    98   222   268   293   400   102   149   320   151   223   307    92   369   198   111   161   195   356

  Columns 211 through 240

    86   283   146   237   328   112    89   322   190   298    18   384   152   368   325   262   372   137   338   135   125   261   274   332   168   289   318    15    54   276

  Columns 241 through 270

    41   218    87    76    97   132    91   348   266   249   197   269    71   260   370   104   157   254   101   158   171   210    14   314   203   246    17    24   371   186

  Columns 271 through 300

   385   273   129   378    73   278   109    22   175   194    52   333   245   202    19   142   118    43    42    57    83   279   196   380    23   105   216   339   106   200

  Columns 301 through 330

   139   334   181   155   300   373   330   308    27   227   331   110   255   164   182   188    37    88   296   302   166   244   272   116   214   382   403   313   287   119

  Columns 331 through 360

   387     2   206   389   381    12   350   208   240   251   301   156   165   394   383   141     1   159    31   401    40   162   397   124   285   178   140   317   250   365

  Columns 361 through 384

   311   187   233   392   358   172    68   310    67   108    84    44   309   399   336    46   321   329    20   115   362   259    78    49

min(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)))

ans =

     1

max(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)))

ans =

   408

mean(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)))

ans =

  203.1875

mean(idx_prenmain_reord)

ans =

  204.5000

mean(Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence))))

ans =

  203.1875

sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence))

ans =

  384×1 cell array

    {'bkbf0407'}
    {'bkbf0105'}
    {'bkbf1510'}
    {'bkbf0115'}
    {'bkbf0110'}
    {'bkbf1213'}
    {'bkbf0105'}
    {'bkbf2113'}
    {'bkbf1808'}
    {'bkbf0805'}
    {'bkbf1413'}
    {'bkbf2106'}
    {'bkbf0306'}
    {'bkbf1108'}
    {'bkbf0602'}
    {'bkbf1706'}
    {'bkbf2101'}
    {'bkbf0815'}
    {'bkbf0401'}
    {'bkbf1301'}
    {'bkbf2002'}
    {'bkbf1201'}
    {'bkbf0303'}
    {'bkbf1201'}
    {'bkbf1310'}
    {'bkbf1206'}
    {'bkbf1405'}
    {'bkbf1903'}
    {'bkbf0514'}
    {'bkbf1015'}
    {'bkbf1906'}
    {'bkbf0614'}
    {'bkbf0613'}
    {'bkbf1415'}
    {'bkbf0501'}
    {'bkbf0309'}
    {'bkbf1507'}
    {'bkbf0514'}
    {'bkbf1408'}
    {'bkbf1511'}
    {'bkbf0202'}
    {'bkbf0101'}
    {'bkbf1513'}
    {'bkbf1704'}
    {'bkbf1709'}
    {'bkbf1712'}
    {'bkbf2006'}
    {'bkbf0209'}
    {'bkbf1901'}
    {'bkbf1006'}
    {'bkbf1008'}
    {'bkbf1416'}
    {'bkbf1702'}
    {'bkbf0805'}
    {'bkbf1809'}
    {'bkbf1602'}
    {'bkbf1508'}
    {'bkbf0112'}
    {'bkbf1112'}
    {'bkbf1614'}
    {'bkbf1502'}
    {'bkbf1915'}
    {'bkbf1010'}
    {'bkbf2114'}
    {'bkbf1304'}
    {'bkbf2014'}
    {'bkbf1907'}
    {'bkbf1406'}
    {'bkbf0909'}
    {'bkbf1801'}
    {'bkbf1807'}
    {'bkbf0716'}
    {'bkbf1612'}
    {'bkbf1714'}
    {'bkbf1107'}
    {'bkbf1401'}
    {'bkbf0609'}
    {'bkbf0602'}
    {'bkbf1412'}
    {'bkbf2015'}
    {'bkbf1806'}
    {'bkbf0201'}
    {'bkbf0309'}
    {'bkbf2005'}
    {'bkbf1909'}
    {'bkbf1715'}
    {'bkbf1002'}
    {'bkbf2108'}
    {'bkbf2101'}
    {'bkbf0212'}
    {'bkbf0604'}
    {'bkbf0714'}
    {'bkbf1910'}
    {'bkbf1403'}
    {'bkbf1103'}
    {'bkbf1803'}
    {'bkbf1013'}
    {'bkbf0304'}
    {'bkbf0701'}
    {'bkbf1503'}
    {'bkbf1509'}
    {'bkbf0708'}
    {'bkbf1703'}
    {'bkbf1412'}
    {'bkbf0315'}
    {'bkbf0506'}
    {'bkbf0302'}
    {'bkbf1407'}
    {'bkbf0811'}
    {'bkbf0704'}
    {'bkbf0802'}
    {'bkbf0511'}
    {'bkbf1404'}
    {'bkbf2007'}
    {'bkbf0808'}
    {'bkbf1613'}
    {'bkbf2108'}
    {'bkbf1414'}
    {'bkbf1810'}
    {'bkbf2115'}
    {'bkbf1204'}
    {'bkbf1902'}
    {'bkbf0103'}
    {'bkbf0515'}
    {'bkbf0608'}
    {'bkbf0806'}
    {'bkbf1901'}
    {'bkbf1510'}
    {'bkbf2104'}
    {'bkbf1202'}
    {'bkbf1716'}
    {'bkbf0416'}
    {'bkbf1905'}
    {'bkbf1211'}
    {'bkbf2016'}
    {'bkbf2010'}
    {'bkbf1204'}
    {'bkbf0509'}
    {'bkbf1911'}
    {'bkbf1709'}
    {'bkbf1514'}
    {'bkbf0415'}
    {'bkbf0806'}
    {'bkbf0712'}
    {'bkbf2009'}
    {'bkbf0812'}
    {'bkbf1304'}
    {'bkbf1316'}
    {'bkbf1706'}
    {'bkbf1610'}
    {'bkbf2003'}
    {'bkbf1001'}
    {'bkbf1009'}
    {'bkbf1601'}
    {'bkbf0316'}
    {'bkbf0115'}
    {'bkbf0603'}
    {'bkbf0808'}
    {'bkbf2004'}
    {'bkbf1306'}
    {'bkbf0803'}
    {'bkbf1408'}
    {'bkbf2014'}
    {'bkbf1713'}
    {'bkbf1711'}
    {'bkbf0912'}
    {'bkbf1007'}
    {'bkbf2016'}
    {'bkbf1203'}
    {'bkbf0307'}
    {'bkbf1601'}
    {'bkbf1109'}
    {'bkbf0103'}
    {'bkbf1307'}
    {'bkbf1305'}
    {'bkbf0613'}
    {'bkbf0915'}
    {'bkbf1301'}
    {'bkbf0513'}
    {'bkbf1209'}
    {'bkbf0711'}
    {'bkbf0404'}
    {'bkbf1908'}
    {'bkbf0910'}
    {'bkbf0512'}
    {'bkbf1615'}
    {'bkbf1604'}
    {'bkbf2013'}
    {'bkbf0813'}
    {'bkbf1701'}
    {'bkbf0202'}
    {'bkbf1007'}
    {'bkbf1508'}
    {'bkbf0116'}
    {'bkbf1114'}
    {'bkbf1804'}
    {'bkbf1409'}
    {'bkbf1306'}
    {'bkbf0108'}
    {'bkbf2105'}
    {'bkbf1516'}
    {'bkbf0911'}
    {'bkbf0101'}
    {'bkbf0908'}
    {'bkbf1613'}
    {'bkbf0807'}
    {'bkbf1606'}
    {'bkbf0810'}
    {'bkbf1705'}
    {'bkbf1501'}
    {'bkbf0106'}
    {'bkbf1311'}
    {'bkbf1314'}
    {'bkbf1815'}
    {'bkbf0111'}
    {'bkbf0104'}
    {'bkbf1512'}
    {'bkbf0102'}
    {'bkbf0204'}
    {'bkbf1812'}
    {'bkbf0902'}
    {'bkbf0206'}
    {'bkbf1202'}
    {'bkbf1212'}
    {'bkbf0410'}
    {'bkbf1611'}
    {'bkbf1913'}
    {'bkbf1003'}
    {'bkbf1203'}
    {'bkbf1415'}
    {'bkbf1015'}
    {'bkbf0207'}
    {'bkbf0501'}
    {'bkbf0308'}
    {'bkbf1016'}
    {'bkbf1609'}
    {'bkbf1715'}
    {'bkbf1014'}
    {'bkbf0601'}
    {'bkbf2114'}
    {'bkbf0911'}
    {'bkbf1008'}
    {'bkbf0803'}
    {'bkbf0916'}
    {'bkbf0412'}
    {'bkbf2102'}
    {'bkbf1605'}
    {'bkbf1113'}
    {'bkbf0802'}
    {'bkbf0713'}
    {'bkbf0515'}
    {'bkbf0909'}
    {'bkbf0813'}
    {'bkbf1004'}
    {'bkbf1810'}
    {'bkbf0703'}
    {'bkbf0809'}
    {'bkbf1110'}
    {'bkbf1816'}
    {'bkbf1103'}
    {'bkbf0816'}
    {'bkbf2009'}
    {'bkbf0107'}
    {'bkbf0611'}
    {'bkbf0405'}
    {'bkbf1903'}
    {'bkbf0411'}
    {'bkbf0409'}
    {'bkbf0516'}
    {'bkbf1406'}
    {'bkbf0109'}
    {'bkbf0403'}
    {'bkbf0901'}
    {'bkbf0509'}
    {'bkbf1105'}
    {'bkbf1205'}
    {'bkbf1813'}
    {'bkbf1210'}
    {'bkbf0713'}
    {'bkbf1102'}
    {'bkbf1308'}
    {'bkbf2110'}
    {'bkbf1012'}
    {'bkbf0504'}
    {'bkbf1214'}
    {'bkbf0312'}
    {'bkbf0209'}
    {'bkbf0405'}
    {'bkbf0210'}
    {'bkbf2008'}
    {'bkbf0214'}
    {'bkbf1803'}
    {'bkbf0814'}
    {'bkbf0412'}
    {'bkbf2011'}
    {'bkbf2107'}
    {'bkbf1906'}
    {'bkbf1708'}
    {'bkbf2116'}
    {'bkbf1014'}
    {'bkbf1616'}
    {'bkbf0313'}
    {'bkbf1503'}
    {'bkbf1812'}
    {'bkbf0916'}
    {'bkbf1708'}
    {'bkbf0102'}
    {'bkbf0215'}
    {'bkbf0605'}
    {'bkbf0913'}
    {'bkbf2002'}
    {'bkbf0804'}
    {'bkbf0505'}
    {'bkbf0315'}
    {'bkbf0313'}
    {'bkbf0114'}
    {'bkbf1711'}
    {'bkbf0203'}
    {'bkbf0302'}
    {'bkbf0311'}
    {'bkbf1909'}
    {'bkbf0310'}
    {'bkbf1411'}
    {'bkbf0905'}
    {'bkbf1616'}
    {'bkbf2112'}
    {'bkbf1410'}
    {'bkbf0905'}
    {'bkbf0914'}
    {'bkbf1215'}
    {'bkbf0211'}
    {'bkbf0601'}
    {'bkbf1115'}
    {'bkbf0610'}
    {'bkbf1413'}
    {'bkbf1405'}
    {'bkbf0708'}
    {'bkbf2111'}
    {'bkbf1504'}
    {'bkbf0801'}
    {'bkbf0615'}
    {'bkbf0706'}
    {'bkbf1511'}
    {'bkbf0406'}
    {'bkbf1101'}
    {'bkbf0709'}
    {'bkbf0409'}
    {'bkbf1212'}
    {'bkbf1302'}
    {'bkbf1101'}
    {'bkbf0815'}
    {'bkbf0707'}
    {'bkbf0511'}
    {'bkbf1303'}
    {'bkbf1807'}
    {'bkbf1607'}
    {'bkbf1707'}
    {'bkbf1002'}
    {'bkbf1605'}
    {'bkbf1805'}
    {'bkbf1505'}
    {'bkbf1315'}
    {'bkbf0316'}
    {'bkbf1207'}
    {'bkbf0606'}
    {'bkbf1501'}
    {'bkbf0414'}
    {'bkbf1914'}
    {'bkbf2003'}
    {'bkbf0408'}
    {'bkbf2012'}
    {'bkbf0907'}
    {'bkbf1312'}
    {'bkbf0502'}
    {'bkbf0710'}
    {'bkbf2103'}
    {'bkbf2105'}
    {'bkbf1116'}
    {'bkbf2102'}
    {'bkbf1310'}
    {'bkbf0701'}
    {'bkbf0216'}
    {'bkbf0607'}
    {'bkbf0507'}

length(sp_prenmain_sentence)

ans =

   408

unique(sp_prenmain_sentence)

ans =

  304×1 cell array

    {'bkbf0101'}
    {'bkbf0102'}
    {'bkbf0103'}
    {'bkbf0104'}
    {'bkbf0105'}
    {'bkbf0106'}
    {'bkbf0107'}
    {'bkbf0108'}
    {'bkbf0109'}
    {'bkbf0110'}
    {'bkbf0111'}
    {'bkbf0112'}
    {'bkbf0114'}
    {'bkbf0115'}
    {'bkbf0116'}
    {'bkbf0201'}
    {'bkbf0202'}
    {'bkbf0203'}
    {'bkbf0204'}
    {'bkbf0206'}
    {'bkbf0207'}
    {'bkbf0209'}
    {'bkbf0210'}
    {'bkbf0211'}
    {'bkbf0212'}
    {'bkbf0214'}
    {'bkbf0215'}
    {'bkbf0216'}
    {'bkbf0302'}
    {'bkbf0303'}
    {'bkbf0304'}
    {'bkbf0305'}
    {'bkbf0306'}
    {'bkbf0307'}
    {'bkbf0308'}
    {'bkbf0309'}
    {'bkbf0310'}
    {'bkbf0311'}
    {'bkbf0312'}
    {'bkbf0313'}
    {'bkbf0315'}
    {'bkbf0316'}
    {'bkbf0401'}
    {'bkbf0403'}
    {'bkbf0404'}
    {'bkbf0405'}
    {'bkbf0406'}
    {'bkbf0407'}
    {'bkbf0408'}
    {'bkbf0409'}
    {'bkbf0410'}
    {'bkbf0411'}
    {'bkbf0412'}
    {'bkbf0414'}
    {'bkbf0415'}
    {'bkbf0416'}
    {'bkbf0501'}
    {'bkbf0502'}
    {'bkbf0503'}
    {'bkbf0504'}
    {'bkbf0505'}
    {'bkbf0506'}
    {'bkbf0507'}
    {'bkbf0508'}
    {'bkbf0509'}
    {'bkbf0511'}
    {'bkbf0512'}
    {'bkbf0513'}
    {'bkbf0514'}
    {'bkbf0515'}
    {'bkbf0516'}
    {'bkbf0601'}
    {'bkbf0602'}
    {'bkbf0603'}
    {'bkbf0604'}
    {'bkbf0605'}
    {'bkbf0606'}
    {'bkbf0607'}
    {'bkbf0608'}
    {'bkbf0609'}
    {'bkbf0610'}
    {'bkbf0611'}
    {'bkbf0613'}
    {'bkbf0614'}
    {'bkbf0615'}
    {'bkbf0701'}
    {'bkbf0702'}
    {'bkbf0703'}
    {'bkbf0704'}
    {'bkbf0706'}
    {'bkbf0707'}
    {'bkbf0708'}
    {'bkbf0709'}
    {'bkbf0710'}
    {'bkbf0711'}
    {'bkbf0712'}
    {'bkbf0713'}
    {'bkbf0714'}
    {'bkbf0715'}
    {'bkbf0716'}
    {'bkbf0801'}
    {'bkbf0802'}
    {'bkbf0803'}
    {'bkbf0804'}
    {'bkbf0805'}
    {'bkbf0806'}
    {'bkbf0807'}
    {'bkbf0808'}
    {'bkbf0809'}
    {'bkbf0810'}
    {'bkbf0811'}
    {'bkbf0812'}
    {'bkbf0813'}
    {'bkbf0814'}
    {'bkbf0815'}
    {'bkbf0816'}
    {'bkbf0901'}
    {'bkbf0902'}
    {'bkbf0905'}
    {'bkbf0907'}
    {'bkbf0908'}
    {'bkbf0909'}
    {'bkbf0910'}
    {'bkbf0911'}
    {'bkbf0912'}
    {'bkbf0913'}
    {'bkbf0914'}
    {'bkbf0915'}
    {'bkbf0916'}
    {'bkbf1001'}
    {'bkbf1002'}
    {'bkbf1003'}
    {'bkbf1004'}
    {'bkbf1006'}
    {'bkbf1007'}
    {'bkbf1008'}
    {'bkbf1009'}
    {'bkbf1010'}
    {'bkbf1011'}
    {'bkbf1012'}
    {'bkbf1013'}
    {'bkbf1014'}
    {'bkbf1015'}
    {'bkbf1016'}
    {'bkbf1101'}
    {'bkbf1102'}
    {'bkbf1103'}
    {'bkbf1105'}
    {'bkbf1107'}
    {'bkbf1108'}
    {'bkbf1109'}
    {'bkbf1110'}
    {'bkbf1112'}
    {'bkbf1113'}
    {'bkbf1114'}
    {'bkbf1115'}
    {'bkbf1116'}
    {'bkbf1201'}
    {'bkbf1202'}
    {'bkbf1203'}
    {'bkbf1204'}
    {'bkbf1205'}
    {'bkbf1206'}
    {'bkbf1207'}
    {'bkbf1209'}
    {'bkbf1210'}
    {'bkbf1211'}
    {'bkbf1212'}
    {'bkbf1213'}
    {'bkbf1214'}
    {'bkbf1215'}
    {'bkbf1301'}
    {'bkbf1302'}
    {'bkbf1303'}
    {'bkbf1304'}
    {'bkbf1305'}
    {'bkbf1306'}
    {'bkbf1307'}
    {'bkbf1308'}
    {'bkbf1310'}
    {'bkbf1311'}
    {'bkbf1312'}
    {'bkbf1314'}
    {'bkbf1315'}
    {'bkbf1316'}
    {'bkbf1401'}
    {'bkbf1402'}
    {'bkbf1403'}
    {'bkbf1404'}
    {'bkbf1405'}
    {'bkbf1406'}
    {'bkbf1407'}
    {'bkbf1408'}
    {'bkbf1409'}
    {'bkbf1410'}
    {'bkbf1411'}
    {'bkbf1412'}
    {'bkbf1413'}
    {'bkbf1414'}
    {'bkbf1415'}
    {'bkbf1416'}
    {'bkbf1501'}
    {'bkbf1502'}
    {'bkbf1503'}
    {'bkbf1504'}
    {'bkbf1505'}
    {'bkbf1506'}
    {'bkbf1507'}
    {'bkbf1508'}
    {'bkbf1509'}
    {'bkbf1510'}
    {'bkbf1511'}
    {'bkbf1512'}
    {'bkbf1513'}
    {'bkbf1514'}
    {'bkbf1516'}
    {'bkbf1601'}
    {'bkbf1602'}
    {'bkbf1603'}
    {'bkbf1604'}
    {'bkbf1605'}
    {'bkbf1606'}
    {'bkbf1607'}
    {'bkbf1609'}
    {'bkbf1610'}
    {'bkbf1611'}
    {'bkbf1612'}
    {'bkbf1613'}
    {'bkbf1614'}
    {'bkbf1615'}
    {'bkbf1616'}
    {'bkbf1701'}
    {'bkbf1702'}
    {'bkbf1703'}
    {'bkbf1704'}
    {'bkbf1705'}
    {'bkbf1706'}
    {'bkbf1707'}
    {'bkbf1708'}
    {'bkbf1709'}
    {'bkbf1711'}
    {'bkbf1712'}
    {'bkbf1713'}
    {'bkbf1714'}
    {'bkbf1715'}
    {'bkbf1716'}
    {'bkbf1801'}
    {'bkbf1803'}
    {'bkbf1804'}
    {'bkbf1805'}
    {'bkbf1806'}
    {'bkbf1807'}
    {'bkbf1808'}
    {'bkbf1809'}
    {'bkbf1810'}
    {'bkbf1811'}
    {'bkbf1812'}
    {'bkbf1813'}
    {'bkbf1814'}
    {'bkbf1815'}
    {'bkbf1816'}
    {'bkbf1901'}
    {'bkbf1902'}
    {'bkbf1903'}
    {'bkbf1905'}
    {'bkbf1906'}
    {'bkbf1907'}
    {'bkbf1908'}
    {'bkbf1909'}
    {'bkbf1910'}
    {'bkbf1911'}
    {'bkbf1913'}
    {'bkbf1914'}
    {'bkbf1915'}
    {'bkbf2002'}
    {'bkbf2003'}
    {'bkbf2004'}
    {'bkbf2005'}
    {'bkbf2006'}
    {'bkbf2007'}
    {'bkbf2008'}
    {'bkbf2009'}
    {'bkbf2010'}
    {'bkbf2011'}
    {'bkbf2012'}
    {'bkbf2013'}
    {'bkbf2014'}
    {'bkbf2015'}
    {'bkbf2016'}
    {'bkbf2101'}
    {'bkbf2102'}
    {'bkbf2103'}
    {'bkbf2104'}
    {'bkbf2105'}
    {'bkbf2106'}
    {'bkbf2107'}
    {'bkbf2108'}
    {'bkbf2110'}
    {'bkbf2111'}
    {'bkbf2112'}
    {'bkbf2113'}
    {'bkbf2114'}
    {'bkbf2115'}
    {'bkbf2116'}

length(unique(sp_prenmain_sentence))

ans =

   304

length(unique(sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence))))

ans =

   293

length(unique(sp_prenmain_sentence(25:74)))

ans =

    47

length(unique(sp_prenmain_sentence(25:75)))

ans =

    48

sp_main_sentence_reshape = reshape(sp_prenmain_sentence(idxInitMain:length(sp_prenmain_sentence)),...
        ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);
sp_main_sentence_reshape(:,1)

ans =

  48×1 cell array

    {'bkbf0407'}
    {'bkbf0105'}
    {'bkbf1510'}
    {'bkbf0115'}
    {'bkbf0110'}
    {'bkbf1213'}
    {'bkbf0105'}
    {'bkbf2113'}
    {'bkbf1808'}
    {'bkbf0805'}
    {'bkbf1413'}
    {'bkbf2106'}
    {'bkbf0306'}
    {'bkbf1108'}
    {'bkbf0602'}
    {'bkbf1706'}
    {'bkbf2101'}
    {'bkbf0815'}
    {'bkbf0401'}
    {'bkbf1301'}
    {'bkbf2002'}
    {'bkbf1201'}
    {'bkbf0303'}
    {'bkbf1201'}
    {'bkbf1310'}
    {'bkbf1206'}
    {'bkbf1405'}
    {'bkbf1903'}
    {'bkbf0514'}
    {'bkbf1015'}
    {'bkbf1906'}
    {'bkbf0614'}
    {'bkbf0613'}
    {'bkbf1415'}
    {'bkbf0501'}
    {'bkbf0309'}
    {'bkbf1507'}
    {'bkbf0514'}
    {'bkbf1408'}
    {'bkbf1511'}
    {'bkbf0202'}
    {'bkbf0101'}
    {'bkbf1513'}
    {'bkbf1704'}
    {'bkbf1709'}
    {'bkbf1712'}
    {'bkbf2006'}
    {'bkbf0209'}

length(unique(sp_main_sentence_reshape(:,1))
 length(unique(sp_main_sentence_reshape(:,1))
                                             ?
Error: Invalid expression. When calling a function or indexing a variable, use parentheses. Otherwise, check for mismatched delimiters.
 
Did you mean:
length(unique(sp_main_sentence_reshape(:,1)))

ans =

    45

length(unique(sp_main_sentence_reshape(:,1)))

ans =

    45

length(unique(sp_main_sentence_reshape(:,1)))

ans =

    45

length(unique(sp_main_sentence_reshape(:,2)))

ans =

    48

length(unique(sp_main_sentence_reshape(:,3)))

ans =

    46

length(unique(sp_main_sentence_reshape(:,4)))

ans =

    46

length(unique(sp_main_sentence_reshape(:,5)))

ans =

    48

length(unique(sp_main_sentence_reshape(:,6)))

ans =

    46

length(unique(sp_main_sentence_reshape(:,6)))

ans =

    46

length(unique(sp_main_sentence_reshape(:,7)))

ans =

    44

length(unique(sp_main_sentence_reshape(:,8)))

ans =

    47

sp_prenmain_sentence(25:74)

ans =

  50×1 cell array

    {'bkbf0407'}
    {'bkbf0105'}
    {'bkbf1510'}
    {'bkbf0115'}
    {'bkbf0110'}
    {'bkbf1213'}
    {'bkbf0105'}
    {'bkbf2113'}
    {'bkbf1808'}
    {'bkbf0805'}
    {'bkbf1413'}
    {'bkbf2106'}
    {'bkbf0306'}
    {'bkbf1108'}
    {'bkbf0602'}
    {'bkbf1706'}
    {'bkbf2101'}
    {'bkbf0815'}
    {'bkbf0401'}
    {'bkbf1301'}
    {'bkbf2002'}
    {'bkbf1201'}
    {'bkbf0303'}
    {'bkbf1201'}
    {'bkbf1310'}
    {'bkbf1206'}
    {'bkbf1405'}
    {'bkbf1903'}
    {'bkbf0514'}
    {'bkbf1015'}
    {'bkbf1906'}
    {'bkbf0614'}
    {'bkbf0613'}
    {'bkbf1415'}
    {'bkbf0501'}
    {'bkbf0309'}
    {'bkbf1507'}
    {'bkbf0514'}
    {'bkbf1408'}
    {'bkbf1511'}
    {'bkbf0202'}
    {'bkbf0101'}
    {'bkbf1513'}
    {'bkbf1704'}
    {'bkbf1709'}
    {'bkbf1712'}
    {'bkbf2006'}
    {'bkbf0209'}
    {'bkbf1901'}
    {'bkbf1006'}

sp_prenmain_sentence(25:72)

ans =

  48×1 cell array

    {'bkbf0407'}
    {'bkbf0105'}
    {'bkbf1510'}
    {'bkbf0115'}
    {'bkbf0110'}
    {'bkbf1213'}
    {'bkbf0105'}
    {'bkbf2113'}
    {'bkbf1808'}
    {'bkbf0805'}
    {'bkbf1413'}
    {'bkbf2106'}
    {'bkbf0306'}
    {'bkbf1108'}
    {'bkbf0602'}
    {'bkbf1706'}
    {'bkbf2101'}
    {'bkbf0815'}
    {'bkbf0401'}
    {'bkbf1301'}
    {'bkbf2002'}
    {'bkbf1201'}
    {'bkbf0303'}
    {'bkbf1201'}
    {'bkbf1310'}
    {'bkbf1206'}
    {'bkbf1405'}
    {'bkbf1903'}
    {'bkbf0514'}
    {'bkbf1015'}
    {'bkbf1906'}
    {'bkbf0614'}
    {'bkbf0613'}
    {'bkbf1415'}
    {'bkbf0501'}
    {'bkbf0309'}
    {'bkbf1507'}
    {'bkbf0514'}
    {'bkbf1408'}
    {'bkbf1511'}
    {'bkbf0202'}
    {'bkbf0101'}
    {'bkbf1513'}
    {'bkbf1704'}
    {'bkbf1709'}
    {'bkbf1712'}
    {'bkbf2006'}
    {'bkbf0209'}

for iRun = 1:8 % change '8' to variables
    sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
end
idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
sp_prenmain_sentence = sp_prenmain{1,2}(:,1);

idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
sp_prenmain_sentence_n = sp_prenmain_sentence(idx_prenmain_reord);

%%% Check the pre-train phase
while length(unique(sp_prenmain_sentence_n(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence_n(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence_n = sp_prenmain_sentence(idx_prenmain_reord);
end
sp_main_run_unicount = [];

idxInitMain = ExpInfo.numPretrain+1;

while sum(sp_main_run_unicount)~=48*8 % change the number here too
    
    idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    sp_prenmain_sentence_n(idxInitMain:length(sp_prenmain_sentence_n))...
        = sp_prenmain_sentence(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    
    sp_main_sentence_reshape = reshape(sp_prenmain_sentence_n(idxInitMain:length(sp_prenmain_sentence_n)),...
        ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);
    
    for iRun = 1:8 % change '8' to variables
      sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
    end

end
runSpStim
%% Reorder the speech stimuli (so that sentences are unique per run in the pre-train and main phases)

sp_prenmain_sentence = sp_prenmain{1,2}(:,1);

idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
sp_prenmain_sentence_n = sp_prenmain_sentence(idx_prenmain_reord);

%%% Check the pre-train phase
while length(unique(sp_prenmain_sentence_n(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain)))~=...
        length(sp_prenmain_sentence_n(1:ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondPretrain))
    idx_prenmain_reord = randperm(length(sp_prenmain_sentence));
    sp_prenmain_sentence_n = sp_prenmain_sentence(idx_prenmain_reord);
end

%%% Check the main phase

sp_main_run_unicount = [];

idxInitMain = ExpInfo.numPretrain+1;

while sum(sp_main_run_unicount)~=48*8 % change the number here too
    
    idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)) = Shuffle(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    sp_prenmain_sentence_n(idxInitMain:length(sp_prenmain_sentence_n))...
        = sp_prenmain_sentence(idx_prenmain_reord(idxInitMain:length(sp_prenmain_sentence)));
    
    sp_main_sentence_reshape = reshape(sp_prenmain_sentence_n(idxInitMain:length(sp_prenmain_sentence_n)),...
        ExpInfo.TrialperCondition*ExpInfo.NumConditions*ExpInfo.RepCondMain,ExpInfo.RepRunMain);
    
    for iRun = 1:8 % change '8' to variables
      sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
    end

end
    
for iRun = 1:8 % change '8' to variables
    sp_main_run_unicount(iRun,1) = length(unique(sp_main_sentence_reshape(:,iRun)));
end
131     if flaginds(2) && flaginds(3)
sp_prenmain_sentence = sp_prenmain{1,2}(:,1);