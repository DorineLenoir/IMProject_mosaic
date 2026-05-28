function tileFeatures = computeTileFeatures_histogram(tiles, nBins)
%COMPUTETILEFEATURES_HISTOGRAM Per-channel RGB histograms for each tile.
%
%   tileFeatures = computeTileFeatures_histogram(tiles, nBins) returns an
%   N x (3*nBins) matrix where each row is the concatenated normalized
%   histogram [Hr | Hg | Hb] of a tile, with nBins bins per channel.
%
%   Histograms are normalized so each per-channel histogram sums to 1,
%   making them comparable across tiles of different sizes (probability
%   distributions). This matches the convention from the histogram
%   equalization derivation in the course.
%
%   Course link: Image Enhancement chapter — histograms, histogram
%   equalization, histogram specification / matching.
%
%   Input : tiles - 1xN cell array of HxWx3 double images in [0,1]
%           nBins - scalar number of bins per channel (default 8)
%   Output: tileFeatures - N x (3*nBins) double matrix
%
%   See also: computeBlockFeature_histogram, matchTile_histogram, imhist

    if nargin < 2 || isempty(nBins)
        nBins = 8;          % small, course-appropriate default
    end

    N = numel(tiles);
    tileFeatures = zeros(N, 3 * nBins);

    for k = 1:N
        T = tiles{k};
        % imhist on a double image in [0,1] uses [0, 1] as its range
        hR = imhist(T(:,:,1), nBins);
        hG = imhist(T(:,:,2), nBins);
        hB = imhist(T(:,:,3), nBins);

        % Normalize each channel histogram to sum to 1 (probability mass)
        % => makes tiles of different pixel counts comparable.
        hR = hR / (sum(hR) + eps);
        hG = hG / (sum(hG) + eps);
        hB = hB / (sum(hB) + eps);

        tileFeatures(k, :) = [hR(:); hG(:); hB(:)].';
    end
end