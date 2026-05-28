function tileFeatures = computeTileFeatures_texture(tiles)
%COMPUTETILEFEATURES_TEXTURE Extract Sobel-based texture features for tiles.
%
%   tileFeatures = computeTileFeatures_texture(tiles) returns an Nx5 matrix
%   where each row is [meanR meanG meanB meanGrad stdGrad]:
%     - meanR, meanG, meanB : average color (so we don't lose chromatic info)
%     - meanGrad            : mean Sobel gradient magnitude on luminance
%     - stdGrad             : std of Sobel gradient magnitude (texture richness)
%
%   Course link: edge detection / Sobel operator (Image Segmentation
%   chapters), spatial filtering (Image Enhancement chapter).
%
%   Input : tiles - 1xN cell array of HxWx3 double images in [0,1]
%   Output: tileFeatures - Nx5 double matrix
%
%   See also: computeBlockFeature_texture, matchTile, imgradient, fspecial

   N = numel(tiles);
    tileFeatures = zeros(N, 5);
    hx = [-1 0 1; -2 0 2; -1 0 1];
    hy = hx.';

    for k = 1:N
        T = tiles{k};
        R = T(:,:,1); G = T(:,:,2); B = T(:,:,3);
        Y = 0.2989*R + 0.5870*G + 0.1140*B;
        Gx = imfilter(Y, hx, 'replicate', 'same');
        Gy = imfilter(Y, hy, 'replicate', 'same');
        Gmag = sqrt(Gx.^2 + Gy.^2);

        % NORMALISATION : Gmag peut aller jusqu'à ~4 sur image en [0,1].
        % On le ramène en [0,1] pour qu'il soit comparable à mean(R/G/B).
        meanGrad = mean(Gmag(:)) / 4;
        stdGrad  = std(Gmag(:))  / 4;

        tileFeatures(k, :) = [mean(R(:)) mean(G(:)) mean(B(:)) meanGrad stdGrad];
    end
end