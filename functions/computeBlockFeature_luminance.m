function blockFeature = computeBlockFeature_luminance(block)
%COMPUTEBLOCKFEATURE_LUMINANCE Extract luminance feature vector for one block.
%
%   blockFeature = computeBlockFeature_luminance(block) returns a 1x5 row
%   vector [meanR meanG meanB meanY stdY] for the input block.
%
%   This MUST match the tile feature format produced by
%   computeTileFeatures_luminance so matchTile (Euclidean) works directly.
%
%   Input : block - HxWx3 double image in [0,1]
%   Output: blockFeature - 1x5 double row vector
%
%   See also: computeTileFeatures_luminance, matchTile

    R = block(:,:,1); G = block(:,:,2); B = block(:,:,3);
    meanR = mean(R(:));
    meanG = mean(G(:));
    meanB = mean(B(:));

    Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;   % BT.601 luminance
    meanY = mean(Y(:));
    stdY  = std(Y(:));

    blockFeature = [meanR meanG meanB meanY stdY];
end