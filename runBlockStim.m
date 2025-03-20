function runBlockStim(ExpInfo, numTrialTotal,numTrialPretrainMain,subj)

%% Set up

% Initialise

%%% BlockInfo - These will be kept here.

BlockData.Participant = strings([numTrialTotal,1]);
BlockData.Sequence =  transpose(1:numTrialTotal);
BlockData.Session = strings([numTrialTotal,1]);
BlockData.Run = NaN(numTrialTotal, 1);
BlockData.Block = NaN([numTrialTotal,1]);
BlockData.Sentence = strings([numTrialTotal,1]);
BlockData.SpContent = strings([numTrialTotal,1]);
BlockData.Keyword1 = strings([numTrialTotal,1]);
BlockData.Keyword2 = strings([numTrialTotal,1]);
BlockData.Keyword3 = strings([numTrialTotal,1]);
BlockData.Keyword4 = strings([numTrialTotal,1]);
BlockData.AudDur = NaN(numTrialTotal, 1);
BlockData.AudFile = strings([numTrialTotal,1]);
BlockData.Orientation = NaN(numTrialTotal, 1);
%BlockData.Image = strings([numTrialPretrainMain,1]);
BlockData.TargetPresence = NaN(numTrialTotal, 1);
BlockData.GaborLoc = NaN(numTrialTotal, 1);
BlockData.GaborLoc(ExpInfo.numPreSp+1:numTrialPretrainMain) = ExpInfo.Theta; % This is only useful when we change the Gabor locations per trial
BlockData.TD = NaN(numTrialTotal, 1);

% Fill in Participant

BlockData.Participant = transpose(repelem({subj},numTrialTotal));

% Fill in Session

session = {'pretrain'; 'main'; 'posttest'};
BlockData.Session = repelem(session,[ExpInfo.numPreSp+ExpInfo.numPreDual,ExpInfo.numMainTrain+ExpInfo.numMain,ExpInfo.numPosttest]);

% Fill in Run

runPreSp = transpose(repelem(ExpInfo.RepRunPreSp,ExpInfo.numPreSp/ExpInfo.RepRunPreSp));
runPreDual = transpose(repelem(ExpInfo.RepRunPreSp+ExpInfo.RepRunPreDual,ExpInfo.numPreDual/ExpInfo.RepRunPreDual));
runMaintrain = transpose(repelem(ExpInfo.RepRunPreSp+ExpInfo.RepRunPreDual+1,ExpInfo.numMainTrain/ExpInfo.RepRunMainTrain));
runMain = transpose(repelem(ExpInfo.RepRunPreSp+ExpInfo.RepRunPreDual+ExpInfo.RepRunMainTrain+1:ExpInfo.RepRunPreSp+ExpInfo.RepRunPreDual+ExpInfo.RepRunMainTrain+ExpInfo.RepRunMain,...
    ExpInfo.numMain/ExpInfo.RepRunMain));
runPosttest = transpose(repelem(ExpInfo.RepRunPreSp+ExpInfo.RepRunPreDual+ExpInfo.RepRunMainTrain+ExpInfo.RepRunMain+1:ExpInfo.RepRunPreSp+ExpInfo.RepRunPreDual+ExpInfo.RepRunMainTrain+ExpInfo.RepRunMain+ExpInfo.RepRunPost,...
    ExpInfo.numPosttest/ExpInfo.RepRunPost));
BlockData.Run = [runPreSp; runPreDual; runMaintrain; runMain; runPosttest];

% Fill in Block (Pre-train and Main)

%%% Block numbers: 1 = splo_imlo; 2 = splo_imhi; 3 = sphi_imlo; 4 =
%%% sphi_imhi; In Pre-speech session only: 1 = splo; 3 = sphi.

block = transpose(1:4); % our conditions are coded as 1:4.

blockPreSp = repelem(Shuffle([block(1);block(3)]),ExpInfo.TrialperCondPreSp); % generate a list of conditions for the speech training condition.
blockPreDual = repmat(block,ExpInfo.RepCondPreDual*ExpInfo.RepRunPreDual,1); % generate a list of conditions for the dual-task training.
blockMainTrain = repmat(block,ExpInfo.RepCondMainTrain*ExpInfo.RepRunMainTrain,1); % generate a list of conditions for the main task training (in scanner).
blockMain = repmat(block,ExpInfo.RepCondMain*ExpInfo.RepRunMain,1); % generate a list of conditions for the main task.


% blockPrenMain = repmat(block,ExpInfo.RepCondPreDual*ExpInfo.RepRunPreDual+...
%     ExpInfo.RepCondMainTrain*ExpInfo.RepRunMainTrain+...
%     ExpInfo.RepCondMain*ExpInfo.RepRunMain,1);
% blockPrenMain(1:ExpInfo.NumConditions,1) = Shuffle(blockPrenMain(1:ExpInfo.NumConditions,1));

blockMain_reshape = reshape(blockMain,...
    ExpInfo.NumCondMain*ExpInfo.RepCondMain,ExpInfo.RepRunMain); % reshape the blockMain to 8*8 as we only want to shuffle conditions within each run.

tempBlock = [0 0]; % This list will save the shuffled list of conditions from all pre- and main sessions.
tempBlock_norep = 0; % This list will save the shuffled list above, but without the repeated adjacent elements.

while length(tempBlock_norep)<length(tempBlock) % while repeated item still exists
    blockPreDual = Shuffle(blockPreDual); % shuffle pre-dual conditions
    blockMainTrain = Shuffle(blockMainTrain); % shuffle main-train conditions
    
    for iBlock = 1:size(blockMain_reshape,2) % 1:num_of_col in blockMain_reshape
        blockMain_reshape(:,iBlock)= Shuffle(blockMain_reshape(:,iBlock)); % shuffle main conditions
    end
    
    tempBlock = transpose([blockPreDual;blockMainTrain;reshape(blockMain_reshape,numel(blockMain_reshape),1)]); % concatenate the list
    tempBlock_norep = tempBlock([true diff(tempBlock)~=0]); % remove repeated items from the list
end

blockPreDual = repelem(blockPreDual,ExpInfo.TrialperCondPreDual); % repeat for trials for the pre-dual conditions
blockMainTrain = repelem(blockMainTrain,ExpInfo.TrialperCondMainTrain); % repeat for trials for the main-train conditions
blockMain = repelem(reshape(blockMain_reshape,numel(blockMain_reshape),1),ExpInfo.TrialperCondMain); % repeat for trials for the main conditions

BlockData.Block(1:ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain) = [blockPreSp;blockPreDual;blockMainTrain;blockMain];


% Fill in TargetPresence (Pretrain and Main)

secondresp = [0;1]; % two occasions, 0 - not a target, 1 - a target.

%%% Find an order for the Pre-dual session

targetpredual = [zeros(ExpInfo.numPreDual/2,1); ones(ExpInfo.numPreDual/2,1)];

while any(diff([0 find(diff(transpose(targetpredual))) numel(transpose(targetpredual))])>2)
    targetpredual = Shuffle(targetpredual);
end


%%% Find an order for the Main-Train session

targetmaintrain = [zeros(ExpInfo.numMainTrain/2,1); ones(ExpInfo.numMainTrain/2,1)];

while any(diff([0 find(diff(transpose(targetmaintrain))) numel(transpose(targetmaintrain))])>2)
    targetmaintrain = Shuffle(targetmaintrain);
end


%%% Find an order for main TargetPresence

targetmain = repmat(repelem(secondresp,ExpInfo.TrialperCondMain*ExpInfo.NumCondMain*ExpInfo.RepCondMain/2),1,ExpInfo.RepRunMain);

for iRun2 = 1:ExpInfo.RepRunMain
    while any(diff([0 find(diff(transpose(targetmain(:,iRun2)))) numel(transpose(targetmain(:,iRun2)))])>2)
        targetmain(:,iRun2) = Shuffle(targetmain(:,iRun2));
    end
end

%%%% Fill in BlockData

BlockData.TargetPresence(ExpInfo.numPreSp+1:...
    ExpInfo.numPreSp+ExpInfo.numPreDual+ExpInfo.numMainTrain+ExpInfo.numMain) = [targetpredual;targetmaintrain;reshape(targetmain,numel(targetmain),1)];

% Run and fill in speech info

[BlockData, idx_sampledpostold, idx_post] = runSpStim(ExpInfo,BlockData,numTrialTotal,numTrialPretrainMain);

% Run and fill in Gabor info

fprintf('Started generating Gabor orientations...\n\n');
tic

for iTrial = ExpInfo.numPreSp+1 : numTrialPretrainMain
    
    BlockData = runGaborStim(ExpInfo, BlockData, iTrial);
     
end

fprintf('Gabor patches generated!\n\n');
toc

% Fill in post old sentences for Orientation, GaborLoc, TD

BlockData.Orientation(numTrialPretrainMain+1:numTrialPretrainMain+ExpInfo.numPostNew) = NaN; % Initial labels of Orientation for new sentences.
BlockData.Orientation(numTrialPretrainMain+ExpInfo.numPostNew+1:numTrialTotal) = BlockData.Orientation(idx_sampledpostold); % Initial labels of Orientation for old sentences
BlockData.Orientation(numTrialPretrainMain+1:numTrialTotal) = BlockData.Orientation(idx_post);

BlockData.GaborLoc(numTrialPretrainMain+1:numTrialPretrainMain+ExpInfo.numPostNew) = NaN; % Initial labels of GaborLoc for new sentences.
BlockData.GaborLoc(numTrialPretrainMain+ExpInfo.numPostNew+1:numTrialTotal) = BlockData.GaborLoc(idx_sampledpostold); % Initial labels of GaborLoc for old sentences
BlockData.GaborLoc(numTrialPretrainMain+1:numTrialTotal) = BlockData.GaborLoc(idx_post);

BlockData.TD(numTrialPretrainMain+1:numTrialPretrainMain+ExpInfo.numPostNew) = NaN; % Initial labels of TD for new sentences.
BlockData.TD(numTrialPretrainMain+ExpInfo.numPostNew+1:numTrialTotal) = BlockData.TD(idx_sampledpostold); % Initial labels of TD for old sentences
BlockData.TD(numTrialPretrainMain+1:numTrialTotal) = BlockData.TD(idx_post);

% Save block data

    
save([pwd '\Data\' subj '\Stim\BlockData.mat'], ...
    'BlockData');

writetable(struct2table(BlockData),string(strcat(pwd,'\Data\',subj,'\Stim\StimSpreadsheet.csv')));
fprintf('BlockData and spreadsheet saved under the subject folder!\n\n');









    