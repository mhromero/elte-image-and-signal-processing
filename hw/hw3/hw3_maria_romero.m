function hist_equalization_demo()
    % Read test images (one gray, one color)
    Igray  = imread('pout.tif');   
    Icolor = imread('images/lena_color.png');

    % Ensure grayscale is single channel
    if size(Igray,3) == 3
        Igray = my_rgb2gray(Igray);
    end

    % GLOBAL EQ (grayscale)
    Igray_global = global_hist_eq_gray(Igray);

    % LOCAL EQ (grayscale)
    clip = 0.01;                  % 1% clipping
    alpha = 0.7; % empirical value (I tested different ones with different images)
    
    nTilesY = 8;                  % 8x8 tiles (typical CLAHE choice)
    nTilesX = 8;
    
    Igray_local = clahe_interp_gray(Igray, nTilesY, nTilesX, clip);

    % GLOBAL EQ (color, RGB, keep color balance)
    Icolor_global = global_hist_eq_color(Icolor, alpha);

    % LOCAL EQ (color, RGB, keep color balance)
    Icolor_local  = local_hist_eq_color(Icolor, nTilesY, nTilesX, clip, alpha);

    % SHOW RESULTS
    figure;
    % avoid using imshow() from toolbox
    subplot(2,4,1); imagesc(Igray); colormap gray; axis image off; title('Original');
    subplot(2,4,2); imagesc(Igray_global); colormap gray; axis image off; title('Global HE');
    subplot(2,4,3); imagesc(Igray_local); colormap gray; axis image off; title('CLAHE (tiles+interp)');
    
    subplot(2,4,5); image(Icolor); axis image off; title('Color original');
    subplot(2,4,6); image(Icolor_global); axis image off; title('Color global HE');
    subplot(2,4,7); image(Icolor_local); axis image off; title('CLAHE (tiles+interp)');


end

% ============================================================
%  GLOBAL HISTOGRAM EQUALIZATION – GRAYSCALE
% ============================================================
function Ieq = global_hist_eq_gray(I)
    % I: uint8 grayscale
    if ~isa(I,'uint8')
        error('Input must be uint8 grayscale image.');
    end

    L = 256;                    % 0..255
    I_vec = double(I(:));       % column vector

    % Histogram using accumarray (no histeq)
    h = accumarray(I_vec+1, 1, [L 1]);   % counts for each gray level

    % PMF and CDF
    p   = h / numel(I_vec);
    cdf = cumsum(p);

    % Map function
    T = round((L-1) * cdf);     % T(k+1) is new value for old value k

    % Apply mapping to every pixel
    Ieq_vec = T(I_vec+1);
    Ieq = uint8(reshape(Ieq_vec, size(I))); % reshape image
end
% ============================================================
%  AUXILIARY FUNCTIONS (NO TOOLBOX)
% ============================================================
function hsv = my_rgb2hsv(rgb)
% Convert an RGB image in [0,1] to HSV (hue, saturation, value) without toolbox.
% rgb : MxNx3 array, double, values in [0,1]
% hsv : MxNx3 array, double, values in [0,1]
    
    % Extract RGB channels
    R = rgb(:,:,1);
    G = rgb(:,:,2);
    B = rgb(:,:,3);

    % Get max and min of the three channels
    Cmax = max(rgb, [], 3);  
    Cmin = min(rgb, [], 3);

    % Calculate chroma: difference between max and min
    Delta = Cmax - Cmin;

    % Initialize output (HSV channels)
    H = zeros(size(R));
    S = zeros(size(R));

    % Value is the maximum RGB component
    V = Cmax;

    % --- Hue calculation
    % only where chroma != 0 because otherwise it's grayscale
    % if R = G = B, the color is grayscale and hue is undefined
    mask = Delta ~= 0;

    % Red is max
    idx = (Cmax == R) & mask;
    H(idx) = mod((G(idx) - B(idx)) ./ Delta(idx), 6);

    % Green is max
    idx = (Cmax == G) & mask;
    H(idx) = ((B(idx) - R(idx)) ./ Delta(idx)) + 2;

    % Blue is max
    idx = (Cmax == B) & mask;
    H(idx) = ((R(idx) - G(idx)) ./ Delta(idx)) + 4;

    H = H / 6;   % scale hue from [0,6) to [0,1]

    % --- Saturation calculation
    % Saturation is chroma normalized by brightness
    % zero when Cmax = 0 (black pixels)
    S(Cmax ~= 0) = Delta(Cmax ~= 0) ./ Cmax(Cmax ~= 0);
    
    % Combine channels into HSV image
    hsv = cat(3, H, S, V);
end

function rgb = my_hsv2rgb(hsv)
% Convert HSV (hue, saturation, value) image in [0,1] to RGB without toolbox.
% hsv must be double in [0,1], size MxNx3.
    
    % --- Extract HSV channels
    H = hsv(:,:,1) * 6;  
    % scale  H from [0,1] to [0,6), corresponding to 6 color sectors
    S = hsv(:,:,2);
    V = hsv(:,:,3);
    % saturation and value remain in [0,1]
    
    % --- Calculate chroma (color intensity) and intermediate values
    % C (chroma) represents the difference between max and min RGB values
    C = V .* S;
    % X is the second-largest RGB component
    X = C .* (1 - abs(mod(H, 2) - 1));
    % m is used to match the correct brightness (value)
    m = V - C;

    % --- Initialize RGB channels
    % Prepare zero arrays
    R = zeros(size(V));
    G = zeros(size(V));
    B = zeros(size(V));

    % --- Assign RGB values based on hue sector
    % 6 regions of hue
    % Sector 0: 0 <= H < 1  (Red -> Yellow)
    idx = (0 <= H) & (H < 1);
    R(idx) = C(idx); 
    G(idx) = X(idx); 
    B(idx) = 0;
    
    % Sector 1: 1 <= H < 2  (Yellow -> Green)
    idx = (1 <= H) & (H < 2);
    R(idx) = X(idx); 
    G(idx) = C(idx); 
    B(idx) = 0;
    
    % Sector 2: 2 <= H < 3  (Green -> Cyan)
    idx = (2 <= H) & (H < 3);
    R(idx) = 0; 
    G(idx) = C(idx); 
    B(idx) = X(idx);

    % Sector 3: 3 <= H < 4  (Cyan -> Blue)
    idx = (3 <= H) & (H < 4);
    R(idx) = 0; 
    G(idx) = X(idx); 
    B(idx) = C(idx);
    
    % Sector 4: 4 <= H < 5  (Blue -> Magenta)
    idx = (4 <= H) & (H < 5);
    R(idx) = X(idx); 
    G(idx) = 0; 
    B(idx) = C(idx);
    
    % Sector 5: 5 <= H < 6  (Magenta -> Red)
    idx = (5 <= H) & (H < 6);
    R(idx) = C(idx); 
    G(idx) = 0; 
    B(idx) = X(idx);

    % Add the offset m to match the correct brightness
    % Combine channels and add m to each component
    rgb = cat(3, R+m, G+m, B+m);
end

function Igray = my_rgb2gray(Irgb)
    % Irgb: uint8 MxNx3
    % extract color channels and convert to double
    R = double(Irgb(:,:,1));
    G = double(Irgb(:,:,2));
    B = double(Irgb(:,:,3));
    % calculate the weighted sum to get the perceived brightness
    % (I used the standard weights) 
    Igray_d = 0.2989*R + 0.5870*G + 0.1140*B;  
    % convert to uint8
    Igray = uint8(round(Igray_d));
end

% ============================================================
%  GLOBAL HISTOGRAM EQUALIZATION – COLOR (RGB, keep balance)
% ============================================================
function Ieq = global_hist_eq_color(Irgb, alpha)
    % alpha: 0 = original brightness, 1 = full HE
    if nargin < 2
        alpha = 1.0; % default alpha
    end
    
    % transform rgb image to hsv
    % avoid using im2double
    Irgb_d = double(Irgb) / 255;
    Ihsv   = my_rgb2hsv(Irgb_d);
    
    % get the value channel (brightness)
    V   = Ihsv(:,:,3);
    V8 = uint8(round(255 * min(max(V,0),1)));
    
    % apply transformation to value channel
    V8_eq = global_hist_eq_gray(V8);  
    
    V_eq  = double(V8_eq) / 255;          % 0..1

    % blend original and equalized brightness
    V_new = (1-alpha)*V + alpha*V_eq;

    % insert equalized brightness
    Ihsv(:,:,3) = V_new;
    % transform the image back to rgb format
    rgb_out = my_hsv2rgb(Ihsv);
    % convert to uint8
    Ieq = uint8(round(255 * min(max(rgb_out,0),1)));
end

% ============================================================
%  LOCAL HISTOGRAM EQUALIZATION – COLOR (RGB, keep balance)
% ============================================================
function Ieq = local_hist_eq_color(Irgb, nTilesY, nTilesX, clip_limit_frac, alpha)
    if nargin < 5
        alpha = 1.0; % default
    end

    % transform image to hsv format
    Irgb_d = double(Irgb) / 255;
    Ihsv   = my_rgb2hsv(Irgb_d);
    
    % get the brigthness channel
    V   = Ihsv(:,:,3);
    % transform to unit8 (avoid using toolbox im2unit8)
    V8 = uint8(round(255 * min(max(V,0),1)));


    % use tile-based CLAHE on the V channel
    V8_eq = clahe_interp_gray(V8, nTilesY, nTilesX, clip_limit_frac);

    V_eq = double(V8_eq) / 255;

    % blend original and equalized brightness
    V_new = (1-alpha)*V + alpha*V_eq;
    % insert equalized brightness
    Ihsv(:,:,3) = V_new;
    % transform the image back to rgb format
    rgb_out = my_hsv2rgb(Ihsv);                 % double in [0,1]
    % convert to uint8
    Ieq = uint8(round(255 * min(max(rgb_out,0),1)));

end

% ============================================================
%  LOCAL HISTOGRAM EQUALIZATION – GRAYSCALE 
% ============================================================
function Ieq = clahe_interp_gray(I, nTilesY, nTilesX, clip_limit_frac)
% CLAHE-like local histogram equalization using tile-based interpolation.
    if ~isa(I,'uint8')
        error('Input must be uint8 grayscale image.');
    end
    if nargin < 4
        clip_limit_frac = 0.01;
    end

    [H,W] = size(I);
    L = 256;

    % define tile centers
    cy = ((0:nTilesY-1) + 0.5) * H / nTilesY;   % tile center rows
    cx = ((0:nTilesX-1) + 0.5) * W / nTilesX;   % tile center cols

    % calculate lookup table T(:,ty,tx) for each tile from its region
    % it stores the histogram equalization mapping for tile (ty,tx)
    T = zeros(L, nTilesY, nTilesX, 'double');

    % define tile boundaries
    tileH = ceil(H / nTilesY);
    tileW = ceil(W / nTilesX);
    
    % process each tile
    for ty = 1:nTilesY
        for tx = 1:nTilesX
            % tile pixel indices (clamped to image boundaries)
            y_start = (ty-1)*tileH + 1;
            y_end   = min(ty*tileH, H);
            x_start = (tx-1)*tileW + 1;
            x_end   = min(tx*tileW, W);
            
            % extract pixels from tile and flatten them
            tile = I(y_start:y_end, x_start:x_end);
            tile_vec = double(tile(:));

            % calculate raw histogram for this tile
            h = accumarray(tile_vec+1, 1, [L 1]);

            % --- Apply CLAHE-style clipping
            Ntile = numel(tile_vec);
            clip_count = clip_limit_frac * Ntile;
            extra = 0; % store excess counts
            % clip bins that exceed the limit
            for k = 1:L
                if h(k) > clip_count
                    extra = extra + (h(k) - clip_count);
                    h(k) = clip_count;
                end
            end
            h = h + extra / L;   % redistribute excess

            % calculate PMF
            p   = h / sum(h);
            % calculate CDF
            cdf = cumsum(p);

            % normalized CDF
            idx_nonzero = find(cdf > 0, 1, 'first');
            cdf_min     = cdf(idx_nonzero);
            Ttmp = (cdf - cdf_min) / (1 - cdf_min);
            Ttmp(Ttmp < 0) = 0;
            % store LUT for current tile
            T(:,ty,tx) = 255 * Ttmp;   % keep as double for interpolation
        end
    end

    % prepare output image
    Ieq = zeros(H,W,'uint8');

    % for each pixel, interpolate between neighboring tiles
    for y = 1:H
        % find vertical neighbors (ty1, ty2) and weights (wy1, wy2)
        [ty2, ty1, wy2, wy1] = find_interp_indices_and_weights(y, cy);

        for x = 1:W
            % horizontal neighbors (tx1, tx2) and weights (wx1, wx2)
            [tx2, tx1, wx2, wx1] = find_interp_indices_and_weights(x, cx);

            % original gray value
            g = double(I(y,x)) + 1;  % index 1..256

            % get mapped value from neighboring tiles
            v11 = T(g, ty1, tx1);  % top-left
            v21 = T(g, ty2, tx1);  % bottom-left
            v12 = T(g, ty1, tx2);  % top-right
            v22 = T(g, ty2, tx2);  % bottom-right

            % bilinear interpolation
            % linear / nearest at borders
            v_top    = wx1 * v11 + wx2 * v12;
            v_bottom = wx1 * v21 + wx2 * v22;
            v_interp = wy1 * v_top + wy2 * v_bottom;
            
            % final equalized pixel value
            Ieq(y,x) = uint8(round(v_interp));
        end
    end
end

% -------------------------------------------------------------------------
function [i2, i1, w2, w1] = find_interp_indices_and_weights(pos, centers)
% given a coordinate and tile center positions,
% find indices i1, i2 (neighbors-closest tiles) and interpolation weights w1, w2
% (at the borders this collapses to linear / nearest)

    n = numel(centers);

    if pos <= centers(1)
        % before first center: use only first
        i1 = 1; i2 = 1;
        w1 = 1; w2 = 0;
        return;
    elseif pos >= centers(end)
        % after last center: use only last
        i1 = n; i2 = n;
        w1 = 1; w2 = 0;
        return;
    else
        % inside: find closest centers around pos
        i2 = find(centers >= pos, 1, 'first');
        i1 = i2 - 1;
        c1 = centers(i1);
        c2 = centers(i2);

        if c2 == c1
            % just in case
            w1 = 1;
            w2 = 0;
        else
            % linear interpolation weights based on distance
            t  = (pos - c1) / (c2 - c1);  % in [0,1]
            w2 = t;
            w1 = 1 - t;
        end
    end
end

%% run the code 
hist_equalization_demo()
