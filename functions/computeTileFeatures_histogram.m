function tileFeatures = computeTileFeatures_histogram(tiles, nBins)
%Per-channel RGB histograms for each tile.


    if nargin<2||isempty(nBins)
        nBins = 8;
    end

    N = numel(tiles);
    tileFeatures = zeros(N, 3 * nBins);

    for k = 1:N
        T = tiles{k};
       
        hR = imhist(T(:,:,1), nBins);
        hG = imhist(T(:,:,2), nBins);
        hB = imhist(T(:,:,3), nBins);
        hR = hR / (sum(hR) + eps);
        hG = hG / (sum(hG) + eps);
        hB = hB / (sum(hB) + eps);

        tileFeatures(k, :) = [hR(:); hG(:); hB(:)].';
    end
end