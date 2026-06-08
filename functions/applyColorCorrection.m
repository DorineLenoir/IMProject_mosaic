function tileOut = applyColorCorrection(tile, targetBlock)
%Shift-and-scale color correction (Finkelstein & Range 1998).

    rgb2yiq = [0.299  0.587  0.114;
               0.596 -0.274 -0.322;
               0.211 -0.523  0.312];

    yiq2rgb = inv(rgb2yiq);

    sz=size(tile);
    flat=reshape(tile,[], 3) * rgb2yiq.';
    tgt=reshape(targetBlock, [], 3) * rgb2yiq.';

    Y=flat(:,1);
    a_t=mean(Y);
    a=mean(tgt(:,1));
    m_t=min(Y);

    % Shift-and-scale rule from the paper
    if m_t> a_t - a
        Ycorr = Y + (a - a_t);
    else
        Ycorr = a .* (Y - m_t) ./ (a_t - m_t + eps);
    end

    Ycorr = max(0, min(1, Ycorr));
    flat(:,1) = Ycorr;

    rgbOut =flat * yiq2rgb.';
    rgbOut= max(0, min(1, rgbOut));
    tileOut= reshape(rgbOut, sz);
end