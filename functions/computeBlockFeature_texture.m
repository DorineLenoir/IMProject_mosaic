function blockFeature = computeBlockFeature_texture(block)
%COMPUTEBLOCKFEATURE_TEXTURE Extract Sobel-based texture feature for one block.
%
%   blockFeature = computeBlockFeature_texture(block) returns a 1x5 row
%   vector [meanR meanG meanB meanGrad stdGrad] for the input block,
%   matching the format of computeTileFeatures_texture.
%
%   Input : block - HxWx3 double image in [0,1]
%   Output: blockFeature - 1x5 double row vector
%
%   See also: computeTileFeatures_texture, matchTile

    R = block(:,:,1); G = block(:,:,2); B = block(:,:,3);
    meanR = mean(R(:));
    meanG = mean(G(:));
    meanB = mean(B(:));

    Y  = 0.2989 * R + 0.5870 * G + 0.1140 * B;
    hx = [-1 0 1; -2 0 2; -1 0 1];
    hy = hx.';
    Gx = imfilter(Y, hx, 'replicate', 'same');
    Gy = imfilter(Y, hy, 'replicate', 'same');
    Gmag = sqrt(Gx.^2 + Gy.^2);
    
    meanGrad = mean(Gmag(:)) / 4;
    stdGrad  = std(Gmag(:)) / 4;
    blockFeature = [meanR, meanG, meanB, meanGrad, stdGrad];
end