function tileOut = applyBlending(tile, targetBlock, alpha)
%Alpha-blend the selected tile with the original target block

    alpha = max(0, min(1, alpha));
    tileOut = (1 - alpha) .* tile + alpha .* targetBlock;
end