function idx = matchTile_histogram(blockFeature, tileFeatures, metric)
%Select best tile by Bhattacharyya histogram distance.

    if nargin < 3 || isempty(metric)
        metric = 'bhattacharyya';
    end

   % switch lower(metric)
   % 
   %      case 'l2'
   %          % Plain Euclidean distance on histogram bins
   %          d = sqrt(sum((B - tileFeatures).^2, 2));
   %          [~, idx] = min(d);
   % 
   %      case 'chi2'
   %          % Symmetric chi-square : 0.5 * sum( (p-q)^2 / (p+q) )
   %          % - Pondère les écarts par la masse du bin (Pearson)
   %          % - Symétrique, donc utilisable comme distance
   %          num = (B - tileFeatures).^2;
   %          den = (B + tileFeatures) + eps;
   %          d   = 0.5 * sum(num ./ den, 2);
   %          [~, idx] = min(d);
   % 
   %      case 'intersection'
   %          % Histogram intersection (Swain & Ballard 1991)
   %          % SIMILARITY: bigger = better, so we take argmax
   %          s = sum(min(B, tileFeatures), 2);
   %          [~, idx] = max(s);
   % 
   %      case 'bhattacharyya'
   %          % Bhattacharyya distance on normalized histograms
   %          % B_coef = sum( sqrt(p*q) )  in [0,1]
   %          % d      = sqrt(1 - B_coef)  (Hellinger form, a proper metric)
   %          bc = sum(sqrt(max(B .* tileFeatures, 0)), 2);
   %          d  = sqrt(max(1 - bc / 3, 0));   % /3 because we concatenated 3 channels
   %          [~, idx] = min(d);
   % 
   %      otherwise
   %          error('matchTile_histogram:unknownMetric', ...
   %              'Unknown metric "%s". Use l2 | chi2 | intersection | bhattacharyya.', metric);
   %  end

  
   N = size(tileFeatures, 1);
   B = repmat(blockFeature, N, 1);     % N x D

   % Bhattacharyya distance on normalized histograms
   % bc = sum of sqrt of products bin by bin, value in [0,1]
   % d  = sqrt(1 - bc) Hellinger form, a proper distance
   bc = sum(sqrt(max(B .* tileFeatures, 0)), 2);
   d  = sqrt(max(1 - bc / 3, 0));  
   [~, idx] = min(d);
end