function drawWord(ExpInfo)

% draw a word on the centre of the screen with the specified orientation

% First, we make a rectangle texture to hold the word
% textureRect = ones(ceil((ExpInfo.textBounds{wordLocation}(4) - ExpInfo.textBounds{wordLocation}(2)) * 1.1),...
%     ceil((ExpInfo.textBounds{wordLocation}(3) - ExpInfo.textBounds{wordLocation}(1)) * 1.1)) .* ExpInfo.TextureWhite;
% textTexture = Screen('MakeTexture', ExpInfo.Win, textureRect);

% Set the text size of the texture
% Screen('TextSize', textTexture, ExpInfo.TextSize);

% Draw the word in the texture, but don't flip the screen yet.

formattedWord = strcat('<font=Courier New><size=40>',word);

[~,~,~,cache,~]=DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.ScreenCenter(2),'xalign','center','yalign','center','baseColor',ExpInfo.TextColour,'cacheOnly',true);
DrawFormattedText2(cache);

% Draw the predrawn texture on the screen, don't flip yet. Add a negative
% sign to the angle to account for the reversed rotation (clockwise as
% positive) by the DrawTextures function.
% Screen('DrawTextures', ExpInfo.Win, textTexture, [], [], -circ_rad2ang(wordOrientation));

