function idx = matchTile_histogram(blockFeature, tileFeatures, metric)
%MATCHTILE_HISTOGRAM Select best tile by histogram distance/similarity.
%
%   idx = matchTile_histogram(blockFeature, tileFeatures, metric) returns
%   the row index in tileFeatures whose histogram best matches
%   blockFeature, according to the chosen metric:
%
%     'l2'            : Euclidean distance      (min)
%     'chi2'          : symmetric chi-square    (min)  -- recommended
%     'intersection'  : histogram intersection  (MAX, it is a similarity)
%                       Reference: Swain & Ballard, IJCV 7(1):11-32, 1991.
%     'bhattacharyya' : Bhattacharyya distance  (min)
%
%   blockFeature  : 1 x D row vector (concatenated normalized histograms)
%   tileFeatures  : N x D matrix     (one tile per row)
%   metric        : char/string, see above
%
%   Course link: Image Enhancement chapter — comparing histograms is the
%   natural extension of histogram equalization / specification ideas.
%
%   See also: computeTileFeatures_histogram, computeBlockFeature_histogram

    if nargin < 3 || isempty(metric)
        metric = 'chi2';
    end

    % Replicate the block feature to all tiles for vectorized comparison
    N = size(tileFeatures, 1);
    B = repmat(blockFeature, N, 1);     % N x D

    switch lower(metric)

        case 'l2'
            % Plain Euclidean distance on histogram bins
            d = sqrt(sum((B - tileFeatures).^2, 2));
            [~, idx] = min(d);

        case 'chi2'
            % Symmetric chi-square : 0.5 * sum( (p-q)^2 / (p+q) )
            % - Pondère les écarts par la masse du bin (Pearson)
            % - Symétrique, donc utilisable comme distance
            num = (B - tileFeatures).^2;
            den = (B + tileFeatures) + eps;
            d   = 0.5 * sum(num ./ den, 2);
            [~, idx] = min(d);

        case 'intersection'
            % Histogram intersection (Swain & Ballard 1991)
            % SIMILARITY: bigger = better, so we take argmax
            s = sum(min(B, tileFeatures), 2);
            [~, idx] = max(s);

        case 'bhattacharyya'
            % Bhattacharyya distance on normalized histograms
            % B_coef = sum( sqrt(p*q) )  in [0,1]
            % d      = sqrt(1 - B_coef)  (Hellinger form, a proper metric)
            bc = sum(sqrt(max(B .* tileFeatures, 0)), 2);
            d  = sqrt(max(1 - bc / 3, 0));   % /3 because we concatenated 3 channels
            [~, idx] = min(d);

        otherwise
            error('matchTile_histogram:unknownMetric', ...
                'Unknown metric "%s". Use l2 | chi2 | intersection | bhattacharyya.', metric);
    end
end