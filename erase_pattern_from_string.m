for i = 1:556
    if contains(BlockData.SpContent(i),'.')
        BlockData.SpContent(i) = erase(BlockData.SpContent(i),'.');
    end
end

save([pwd '\Data\' subj '\Stim\BlockData.mat'], ...
    'BlockData');