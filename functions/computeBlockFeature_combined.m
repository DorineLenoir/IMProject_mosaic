function blockFeature = computeBlockFeature_combined(block, weights)
%COMPUTEBLOCKFEATURE_COMBINED Matching companion for computeTileFeatures_combined.

    if nargin < 2 || isempty(weights)
        % weights = [1 1 1];
        weights = [2 1 0.5];  % [color luminance texture] — privilégie la couleur
    end
    wColor = weights(1); wLum = weights(2); wTex = weights(3);

    R = block(:,:,1); G = block(:,:,2); B = block(:,:,3);
    Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;

    hx = [-1 0 1; -2 0 2; -1 0 1];
    hy = hx.';
    Gx = imfilter(Y, hx, 'replicate', 'same');
    Gy = imfilter(Y, hy, 'replicate', 'same');
    Gmag = sqrt(Gx.^2 + Gy.^2);

    blockFeature = [ ...
        wColor * mean(R(:))./4  wColor * mean(G(:))./4  wColor * mean(B(:))./4 ...
        wLum   * mean(Y(:))./4  wLum   * std(Y(:)./4)                       ...
        wTex   * mean(Gmag(:))./4  wTex * std(Gmag(:))./4 ];
end