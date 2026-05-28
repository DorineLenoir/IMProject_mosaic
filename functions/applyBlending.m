function tileOut = applyBlending(tile, targetBlock, alpha)
%APPLYBLENDING Alpha-blend the selected tile with the original target block.
%
%   tileOut = applyBlending(tile, targetBlock, alpha) returns
%       tileOut = (1 - alpha) * tile + alpha * targetBlock
%   with alpha in [0,1]:
%     alpha = 0  -> pure tile (no blending, default mosaic behaviour)
%     alpha = 1  -> the original target block (no mosaic effect)
%     alpha ~0.2 -> visually softens block boundaries and improves
%                   global coherence (typical setting)
%
%   Course link: point operations / linear combination of images
%   (Image Enhancement chapter).
%
%   Inputs:
%       tile        : HxWx3 double in [0,1]
%       targetBlock : HxWx3 double in [0,1] (same size as tile)
%       alpha       : scalar in [0,1]

    alpha = max(0, min(1, alpha));
    tileOut = (1 - alpha) .* tile + alpha .* targetBlock;
end