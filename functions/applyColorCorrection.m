function tileOut = applyColorCorrection(tile, targetBlock)
%APPLYCOLORCORRECTION Shift-and-scale color correction (Finkelstein & Range 1998).
%
%   tileOut = applyColorCorrection(tile, targetBlock) returns a corrected
%   version of `tile` whose Y (luminance) channel has been shift-and-scaled
%   so that its mean matches the mean of the targetBlock's luminance.
%   The I and Q chrominance channels are taken from the original tile,
%   following Section 4.4 / Figure 3 of:
%       Finkelstein, A. & Range, M. "Image Mosaics", Princeton TR-574-98, 1998.
%
%   Inputs:
%       tile        : HxWx3 double in [0,1]
%       targetBlock : HxWx3 double in [0,1] (same size as tile)
%   Output:
%       tileOut     : HxWx3 double in [0,1], color-corrected
%
%   Course link: color spaces (YIQ), point operations on intensities
%   (Image Enhancement chapter).

    % --- RGB -> YIQ (standard NTSC matrix, BT.601-related) ---
    rgb2yiq = [0.299  0.587  0.114;
               0.596 -0.274 -0.322;
               0.211 -0.523  0.312];

    yiq2rgb = inv(rgb2yiq);

    sz   = size(tile);
    flat = reshape(tile,        [], 3) * rgb2yiq.';   % Nx3 in YIQ
    tgt  = reshape(targetBlock, [], 3) * rgb2yiq.';   % Nx3 in YIQ

    Y  = flat(:,1);
    a_t = mean(Y);                       % tile mean Y
    a   = mean(tgt(:,1));                % target mean Y
    m_t = min(Y);                        % tile min Y

    % Shift-and-scale rule from the paper
    if m_t > a_t - a
        Ycorr = Y + (a - a_t);                          % pure shift
    else
        Ycorr = a .* (Y - m_t) ./ (a_t - m_t + eps);    % shift + scale
    end

    % Clamp into [0,1] just in case
    Ycorr = max(0, min(1, Ycorr));

    % Keep I, Q from the tile (preserves tile colour identity)
    flat(:,1) = Ycorr;

    % Back to RGB
    rgbOut = flat * yiq2rgb.';
    rgbOut = max(0, min(1, rgbOut));
    tileOut = reshape(rgbOut, sz);
end