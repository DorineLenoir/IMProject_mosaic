function tileFeatures = computeTileFeatures_combined(tiles, weights)
% Weighted concatenation of color + texture + luminance.


    if nargin < 2 || isempty(weights)
        % weights = [1 1 1];
        weights = [2 1 0.5];  
    end
    wColor = weights(1); wLum = weights(2); wTex = weights(3);

    N = numel(tiles);
    tileFeatures = zeros(N, 7);

    hx = [-1 0 1; -2 0 2; -1 0 1];
    hy = hx.';

    for k = 1:N
        T = tiles{k};
        R= T(:,:,1); G = T(:,:,2); B = T(:,:,3);
        Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;

        Gx =imfilter(Y, hx, 'replicate', 'same');
        Gy =imfilter(Y, hy, 'replicate', 'same');
        Gmag =sqrt(Gx.^2 + Gy.^2);

        tileFeatures(k, :) = [ ...
            wColor * mean(R(:))./4  wColor * mean(G(:))./4  wColor * mean(B(:))./4 ...
            wLum   * mean(Y(:))./4  wLum   * std(Y(:)./4)...
            wTex   * mean(Gmag(:))./4  wTex * std(Gmag(:))./4 ];
    end
end