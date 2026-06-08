function blockFeature = computeBlockFeature_histogram(block, nBins)
%Per-channel normalized RGB histogram for one block.

    if nargin < 2 || isempty(nBins)
        nBins = 8;
    end

    hR =imhist(block(:,:,1), nBins);
    hG =imhist(block(:,:,2), nBins);
    hB =imhist(block(:,:,3), nBins);

    hR= hR /(sum(hR) + eps);
    hG =hG / (sum(hG) + eps);
    hB = hB /(sum(hB) + eps);

    blockFeature =[hR(:); hG(:); hB(:)].';
end