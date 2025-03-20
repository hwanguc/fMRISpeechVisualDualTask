function drawResponseWin(ExpInfo,questionPrompt,feedbackPrompt,whichresp,drawFeedback)

%%% whichresp = 1 -> Gist, whichresp = 2 -> Gabor; whichresp,
%%% whichresp = 3 -> Post-test
%%% controls the text colour of the questionPrompt

% draw questionPrompt

formattedWord = strcat('<font=Arial><size=40><i>',questionPrompt);
% [~,~,~,cache,~]=DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/3,'xalign','center','yalign','center','baseColor',ExpInfo.TextColour,'cacheOnly',true);
% DrawFormattedText2(cache);
if whichresp == 1
    DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/3,'xalign','center','yalign','center','baseColor',ExpInfo.TextColourGist);
elseif whichresp == 2
    DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/3,'xalign','center','yalign','center','baseColor',ExpInfo.TextColourGabor);
elseif whichresp == 3
    DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/3.6,'xalign','center','yalign','center','baseColor',ExpInfo.TextColourGist);
end
    


% draw feedbackPrompt

if drawFeedback
    
    formattedWord = strcat('<font=Arial><size=35><i>',feedbackPrompt);
    if whichresp == 1
        DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2.4,'xalign','center','yalign','center','baseColor',ExpInfo.TextColourGist);
    elseif whichresp == 2
        DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/2.4,'xalign','center','yalign','center','baseColor',ExpInfo.TextColourGabor);
    elseif whichresp == 3
        DrawFormattedText2(convertStringsToChars(formattedWord),'win',ExpInfo.Win,'sx',ExpInfo.ScreenCenter(1),'sy',ExpInfo.WinArea(4)/3.6+70,'xalign','center','yalign','center','baseColor',ExpInfo.TextColourGist);
    end
end

% draw image (left/right)

imPrmptTexture = Screen('MakeTexture', ExpInfo.Win, ExpInfo.PromptIM);
Screen('DrawTexture',ExpInfo.Win,imPrmptTexture,[], ExpInfo.PromptSquare);

if drawFeedback
    Screen('Flip', ExpInfo.Win); % display the components
end