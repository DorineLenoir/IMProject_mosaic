function tileFeatures = computeTileFeatures_luminance(tiles)
%Extract luminance-based features for each tile.

    N = numel(tiles);
    tileFeatures = zeros(N, 5);

    for k = 1:N
        T = tiles{k};
      
        R = T(:,:,1); G = T(:,:,2); B = T(:,:,3);
        meanR = mean(R(:));
        meanG = mean(G(:));
        meanB = mean(B(:));
     
        Y=0.2989 * R + 0.5870 * G + 0.1140 * B;
        meanY=mean(Y(:));
        stdY  = std(Y(:)); 

        tileFeatures(k, :)= [meanR meanG meanB meanY stdY];
    end
end