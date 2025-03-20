function runStim()

% Store the subject name

subj=input('Subject identifier (Initial+YYMMDD)? ', 's'); 

if ~exist('Data', 'dir')
   mkdir('Data')
end

if ~exist([pwd '\Data\' subj], 'dir')
   mkdir([pwd '\Data\' subj],'Stim')
else
   fprintf('Found existing data for this subject, check manually!\n\n');
   return
end

% Assign settings
ExpInfo = assignSettingsStim(subj);


% Save experiment details
save([pwd '\Data\' subj '\Stim\ExpInfo.mat'], 'ExpInfo');
fprintf('ExpInfo saved under the subject folder!\n\n');


%% Experiment

numTrialTotal = ExpInfo.numTrialTotal; % Move to "runExperiment"
numTrialPretrainMain = ExpInfo.numTrialPretrainMain;
runBlockStim(ExpInfo,numTrialTotal,numTrialPretrainMain,subj);
        
        
       
%% Finish up

% Close down
Priority(0);
sca
ListenChar(1);


