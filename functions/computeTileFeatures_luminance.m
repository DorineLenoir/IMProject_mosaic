function tileFeatures = computeTileFeatures_luminance(tiles)
%COMPUTETILEFEATURES_LUMINANCE Extract luminance-based features for each tile.
%
%   tileFeatures = computeTileFeatures_luminance(tiles) returns an Nx5
%   feature matrix where each row is [meanR meanG meanB meanY stdY]:
%     - meanR, meanG, meanB : average color (kept for chromatic disambiguation)
%     - meanY               : mean luminance (BT.601 weights, 0.299/0.587/0.114)
%     - stdY                : standard deviation of luminance (local contrast)
%
%   Course link: ITU-R BT.601 luminance formula (color spaces / image
%   enhancement chapter). Same coefficients as MATLAB's rgb2gray.
%
%   Input : tiles - 1xN cell array of HxWx3 double images in [0,1]
%   Output: tileFeatures - Nx5 double matrix
%
%   See also: computeBlockFeature_luminance, matchTile

    N = numel(tiles);
    tileFeatures = zeros(N, 5);

    for k = 1:N
        T = tiles{k};
        % Average RGB (chromatic component, kept to avoid color collapse)
        R = T(:,:,1); G = T(:,:,2); B = T(:,:,3);
        meanR = mean(R(:));
        meanG = mean(G(:));
        meanB = mean(B(:));

        % Luminance via ITU-R BT.601 weights (identical to rgb2gray)
        % Y = 0.2989 R + 0.5870 G + 0.1140 B
        Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;
        meanY = mean(Y(:));
        stdY  = std(Y(:));   % captures local contrast / "brightness spread"

        tileFeatures(k, :) = [meanR meanG meanB meanY stdY];
    end
end