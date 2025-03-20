function displayInstructions(ExpInfo, instructionSet)
% Loads images containing the participant instructions and displays them.

% INPUTS
% instructionSet        Specifies which set of instructions to display.


% Specify the first and final slide in each set
set1 = {1, 5}; % pre-speech instruction
set2 = {6, 11}; % pre-dual insturction
set3 = {12, 13}; % main-train instruction
set4 = {14, 16}; % main instruction (first time)
set5 = {17, 17}; % main instuction (second time onwards)
set6 = {18, 19}; % post-test instruction
setSpecificaiton = {set1, set2, set3,set4,set5,set6};


% Display the slides in turn
instructFinished = false;
firstSlide = setSpecificaiton{instructionSet}{1};
finalSlide = setSpecificaiton{instructionSet}{2};


iSlide = firstSlide;


while ~instructFinished
    
    % Load the images
    if ExpInfo.DryRun == 1
        instructIm = imread([pwd '\instructions\dry_run\Slide' num2str(iSlide) '.png']);
    else
        instructIm = imread([pwd '\instructions\fmri_run\Slide' num2str(iSlide) '.png']);
    end
    
    % Display the images
    instrctTexture = Screen('MakeTexture', ExpInfo.Win, instructIm);
    Screen('FillRect', ExpInfo.Win, [254, 254, 254]);
    Screen('DrawTexture', ExpInfo.Win, instrctTexture, [], ExpInfo.WinArea);
    Screen('Flip', ExpInfo.Win)
    
    
    % Do we want to overlay a video of stimulus examples?
    if iSlide == 2 % the slide where maltese demo is played.
        
        waitForInput('enter',ExpInfo.DryRun);
        
        [~,pahandle_demo] = presentSound(ExpInfo.WavfilenameDemo,ExpInfo.Repetitions,ExpInfo.WaittoStartDemo);
        % Stop playback:
%         [~,endAudPositionSecs,~,estAudStopTime] = PsychPortAudio('Stop', pahandle,waitForEndOfPlayback);
        PsychPortAudio('Stop', pahandle_demo,ExpInfo.WaitForEndOfPlayback);

        % Close the audio device:
        PsychPortAudio('Close', pahandle_demo);
        
        
    end
    
    
    response = waitForInput('lr',ExpInfo.DryRun);
    
    
    if strcmp(response, 'l')
        
        iSlide = iSlide - 1;
        iSlide(iSlide < firstSlide) = firstSlide;
        
        
    elseif strcmp(response, 'r')
        
        if iSlide == finalSlide
            
            instructFinished = true;
            
            
        end
        
        
        iSlide = iSlide + 1;
        
        
    end
    
    
end

Screen('FillRect', ExpInfo.Win, ExpInfo.Colour.Base);
Screen('Flip', ExpInfo.Win);
