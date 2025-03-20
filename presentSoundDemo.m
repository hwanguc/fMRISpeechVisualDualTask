%---------------
% For testing only
%---------------

wavfilename = [pwd '\audiostim\main\bkbg2011_4ch.wav']; % clear demo
wavfilename = [pwd '\audiostim\debug\chain_clear_48000.wav']; % clear demo
wavfilename = [pwd '\audiostim\debug\chain_4ch_48000.wav']; % 4ch demo


%---------------
% Sound Setup
%---------------

% Initialize Sounddriver
InitializePsychSound(1);

% Number of channels and Frequency of the sound
nrchannels = 2;
freq = 48000;

% How many times do we wish to play the sound
repetitions = 1;


% Start immediately (0 = immediately)
% startCue = 0;

% Should we wait for the device to really start (1 = yes)
% INFO: See help PsychPortAudio
waitForDeviceStart = 1;


% Read WAV file from filesystem:
[y, freq] = psychwavread(wavfilename);
wavedata = y';
nrchannels = size(wavedata,1); % Number of rows == number of channels.

% Make sure we have always 2 channels stereo output.

if nrchannels < 2
    wavedata = [wavedata ; wavedata];
    nrchannels = 2;
end

% Open Psych-Audio port, with the follow arguements
% (1) [] = default sound device
% (2) 1 = sound playback only
% (3) 1 = default level of latency
% (4) Requested frequency in samples per second
% (5) 2 = stereo putput
pahandle = PsychPortAudio('Open', [], [], 1, freq, nrchannels);

% Fill the audio playback buffer with the audio data, doubled for stereo
% presentation
PsychPortAudio('FillBuffer', pahandle, wavedata)

% Play sound
startAudTime = PsychPortAudio('Start', pahandle, repetitions, 0, waitForDeviceStart);

% Stop sound

PsychPortAudio('Stop',pahandle,1);
PsychPortAudio('Close', pahandle);



% % Done.
% fprintf('Demo finished, bye!\n');