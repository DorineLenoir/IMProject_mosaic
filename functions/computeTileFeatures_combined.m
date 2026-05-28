function tileFeatures = computeTileFeatures_combined(tiles, weights)
%COMPUTETILEFEATURES_COMBINED Weighted concatenation of color + texture + luminance.
%
%   tileFeatures = computeTileFeatures_combined(tiles, weights) builds a
%   compact feature combining the three families:
%       [ w(1)*meanR  w(1)*meanG  w(1)*meanB   ...    % color (3D)
%         w(2)*meanY  w(2)*stdY                ...    % luminance (2D)
%         w(3)*meanGrad  w(3)*stdGrad ]               % texture  (2D)
%
%   The weights vector w = [wColor wLum wTex] lets the user tune the
%   relative importance of each cue (default = [1 1 1]). A GUI slider
%   can map directly to these three weights.
%
%   Course link: this is essentially the "combination of these methods"
%   that Finkelstein & Range (1998, Sec 4.3) suggest as a possible matching
%   strategy.
%
%   Input : tiles   - 1xN cell array of HxWx3 double images in [0,1]
%           weights - 1x3 vector [wColor wLum wTex], default [1 1 1]
%   Output: tileFeatures - Nx7 double matrix

    if nargin < 2 || isempty(weights)
        % weights = [1 1 1];
        weights = [2 1 0.5];  % [color luminance texture] — privilégie la couleur
    end
    wColor = weights(1); wLum = weights(2); wTex = weights(3);

    N = numel(tiles);
    tileFeatures = zeros(N, 7);

    hx = [-1 0 1; -2 0 2; -1 0 1];
    hy = hx.';

    for k = 1:N
        T = tiles{k};
        R = T(:,:,1); G = T(:,:,2); B = T(:,:,3);
        Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;

        Gx = imfilter(Y, hx, 'replicate', 'same');
        Gy = imfilter(Y, hy, 'replicate', 'same');
        Gmag = sqrt(Gx.^2 + Gy.^2);

        tileFeatures(k, :) = [ ...
            wColor * mean(R(:))./4  wColor * mean(G(:))./4  wColor * mean(B(:))./4 ...
            wLum   * mean(Y(:))./4  wLum   * std(Y(:)./4)                       ...
            wTex   * mean(Gmag(:))./4  wTex * std(Gmag(:))./4 ];
    end
end