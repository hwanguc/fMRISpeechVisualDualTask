while KbCheck(); end


%Wait until a key is pressed
pressed = false;
idx = 1;

while ~pressed
    [pressed, ~, keyCode] = KbCheck();
    if pressed
        keycodes(idx) = find(keyCode);
        if keycodes(idx) == 13
            break;
        end
        idx = idx+1;
        pressed = false;
    end
end

keycode_out = keycodes([true diff(keycodes)~=0]);