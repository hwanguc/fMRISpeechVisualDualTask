% Author: Han Wang
%% This script is the main script to run the experiment. Run this script to start the experiment. Please make sure you have generated the spreadsheet for the experiment using runStim.m before running this script.
%% Put 0 for 'dry run' for running on a scanner, otherwise put 1 for collecting behaivioural responses only.

function runExperiment(session)

% Check if "session" is in the correct range

if (session>10) || (session<0) || (mod(session,1)~=0)
   fprintf('Session does not match with the experimental design!\n(1 = pre-speech, 2 = pre-dual, 3 = main-train, 4-9 = main, 10 = post-test)\nCheck again!\n\n');
   return
end


% Check if the spreadsheet was generated
subj = input('Subject identifier (Initial+YYMMDD)? ', 's');

if ~exist([pwd '\Data\' subj], 'dir')
   fprintf('Spreadsheet for the experiment not generated yet!\n\n');
   return
end

% Various checks for the Experiment folder

if (session == 1)
    
    if (~exist([pwd '\Data\' subj '\Experiment'], 'dir'))
        mkdir([pwd '\Data\' subj],'Experiment');
    elseif exist([pwd '\Data\' subj '\Experiment\ExpInfoSession' num2str(session) '.mat'], 'file')
        sessionCheck = input('Experiment data from the current session already exists! Do you want to continue (Put 0 if NOT)? ');
        if sessionCheck == 0
            return
        end
    end
        
elseif ismember(session,2:10)
    if (~exist([pwd '\Data\' subj '\Experiment'], 'dir'))
        sessionCheck = input('Experiment folder does not exist! Do you want to create one and continue anyway or quit (Put 0 if NOT)? ');
        if sessionCheck == 0
            return
        else
            mkdir([pwd '\Data\' subj],'Experiment');
        end
    elseif ~exist([pwd '\Data\' subj '\Experiment\ExpInfoSession' num2str(session-1) '.mat'], 'file') % If the previous session ExpInfo doesn't exist, show error message.
        sessionCheck = input('Experiment data from the previous session not found! Do you want to continue? ');
        if sessionCheck == 0
            return
        end
    end
    
    if exist([pwd '\Data\' subj '\Experiment\ExpInfoSession' num2str(session) '.mat'], 'file')
        sessionCheck = input('Experiment data from the current session already exists! Do you want to continue (Put 0 if NOT)? ');
        if sessionCheck == 0
            return
        end
    end
end


% Dry run?
if ismember(session,3:9)
    dryrun = input('Is this a dry run? (1 = Y, 0 = N) ');
else
    dryrun = 1;
end


%%% Run further check if this is a dry run.

if (ismember(session,[1:2,10])) && (dryrun == 0)
   fprintf('This is a behavioural session, which has to be a dry run!\n\n');
   return
end
    
% Assign settings

ExpInfo = load([pwd '\Data\' subj '\Stim\ExpInfo']);
ExpInfo = ExpInfo.ExpInfo;
ExpInfo = assignSettingsExperiment(session,dryrun,ExpInfo);

BlockData = load([pwd '\Data\' subj '\Stim\BlockData']);
% BlockData.AudFile = strrep(BlockData.AudFile,'4ch','6ch'); % Check if we
% want to replace the 4ch speech with 6ch ones if the participants feeling
% it's too difficult.
BlockData = BlockData.BlockData;
        
% Save experiment details

save([pwd '\Data\' subj '\Experiment\ExpInfoSession' num2str(session) '.mat'], 'ExpInfo');


%% Experiment

%%% Show instruction

%%%% Set the instruction set for each run (from one of the for sets)

if session==1
    instructionSet = 1;
elseif session==2
    instructionSet = 2;
elseif session==3
    instructionSet = 3;
elseif session==4
    instructionSet = 4;
elseif ismember(session,5:9)
    instructionSet = 5;
elseif session == 10
    instructionSet = 6;
end


displayInstructions(ExpInfo,instructionSet)

numTrialTotal = ExpInfo.numTrialTotal; % Move to "runExperiment"
runBlockExperiment(subj,session,numTrialTotal,ExpInfo,BlockData);

%% Merge all behavioural log files (if it's the post-test)

% split = 0;
% 
% if session == 10 && split == 0
%     
%     for iSession = 1:10
%         
%         if iSession == 1
%             tableCurrentIdx = transpose(1:ExpInfo.numPreSp);
%         elseif iSession == 2
%             tableCurrentIdx = transpose(ExpInfo.numPreSp+1:ExpInfo.numPreSp+ExpInfo.numPreDual);
%         elseif iSession == 3
%             tableCurrentIdx = transpose(ExpInfo.numPreSp+ExpInfo.numPreDual+1:ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain);
%         elseif ismember(iSession,4:9)
%             tableCurrentIdx = transpose((iSession-4)*ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain+1+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain:...
%                 (iSession-3)*ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain);
%         else
%             tableCurrentIdx = transpose(ExpInfo.numTrialPretrainMain+1:ExpInfo.numTrialTotal);
%         end
%         
%         tableCurrent = readtable(string(strcat(pwd,'\Data\',subj,'\Experiment\BlockDataSession', num2str(iSession),'.csv')));
%         tableMerge(tableCurrentIdx,:) = tableCurrent(tableCurrentIdx,:);
%     end
%     writetable(tableMerge,string(strcat(pwd,'\Data\',subj,'\Experiment\BlockDataAllSession.csv')));
%     
%     
% elseif session == 9 && split == 1
%     
%     for iSession = 3:9
%         
%         if iSession == 3
%             tableCurrentIdx = transpose(ExpInfo.numPreSp+ExpInfo.numPreDual+1:ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain);
%         elseif ismember(iSession,4:9)
%             tableCurrentIdx = transpose((iSession-4)*ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain+1+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain:...
%                 (iSession-3)*ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain+ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain);
%         end
%         
%         tableCurrent = readtable(string(strcat(pwd,'\Data\',subj,'\Experiment\BlockDataSession', num2str(iSession),'.csv')));
%         tableMerge(tableCurrentIdx,:) = tableCurrent(tableCurrentIdx,:);
%     end
%     writetable(tableMerge,string(strcat(pwd,'\Data\',subj,'\Experiment\BlockDataAllSession.csv')));
%         
% end


%% Finish up

% Close down
Priority(0);
sca
ListenChar(1);
