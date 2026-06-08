function tileFeatures = computeTileFeatures_texture(tiles)
%Extract Sobel-based texture features for tiles.

   N = numel(tiles);
    tileFeatures = zeros(N, 5);
    hx = [-1 0 1; -2 0 2; -1 0 1];
    hy = hx.';
    for k = 1:N
        T =tiles{k};
        R=T(:,:,1); G = T(:,:,2); B = T(:,:,3);
        Y = 0.2989*R + 0.5870*G + 0.1140*B;
        Gx= imfilter(Y, hx, 'replicate', 'same');
        Gy= imfilter(Y, hy, 'replicate', 'same');
        Gmag= sqrt(Gx.^2 + Gy.^2);

        meanGrad = mean(Gmag(:)) / 4;
        stdGrad  = std(Gmag(:))  / 4;
        tileFeatures(k, :) = [mean(R(:)) mean(G(:)) mean(B(:)) meanGrad stdGrad];
    end
end