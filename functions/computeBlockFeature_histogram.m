function blockFeature = computeBlockFeature_histogram(block, nBins)
%COMPUTEBLOCKFEATURE_HISTOGRAM Per-channel normalized RGB histogram for one block.
%
%   blockFeature = computeBlockFeature_histogram(block, nBins) returns a
%   1 x (3*nBins) row vector [Hr | Hg | Hb], matching the format produced
%   by computeTileFeatures_histogram.
%
%   Input : block - HxWx3 double image in [0,1]
%           nBins - scalar (default 8)
%   Output: blockFeature - 1 x (3*nBins) double row vector

    if nargin < 2 || isempty(nBins)
        nBins = 8;
    end

    hR = imhist(block(:,:,1), nBins);
    hG = imhist(block(:,:,2), nBins);
    hB = imhist(block(:,:,3), nBins);

    hR = hR / (sum(hR) + eps);
    hG = hG / (sum(hG) + eps);
    hB = hB / (sum(hB) + eps);

    blockFeature = [hR(:); hG(:); hB(:)].';
end