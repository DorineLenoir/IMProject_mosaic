function blockFeature = computeBlockFeature_luminance(block)
%Extract luminance feature vector for one block.
    R = block(:,:,1); G = block(:,:,2); B = block(:,:,3);
    meanR =mean(R(:));
    meanG= mean(G(:));
    meanB =mean(B(:));

    Y = 0.2989 * R + 0.5870 * G + 0.1140 * B;% BT.601 luminance
    meanY = mean(Y(:));
    stdY  = std(Y(:));


    blockFeature=[meanR meanG meanB meanY stdY];
end