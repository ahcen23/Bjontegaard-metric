% Codec A (Standard): Covers 100kbps to 1000kbps
Rate_A = [100, 250, 500, 750, 1000];
PSNR_A = [30,  33,  36,  38,  39.5];

% Codec B (New): Covers 300kbps to 1500kbps 
% (Notice the shift: it doesn't have low bitrate data, but goes higher)
Rate_B = [300, 550, 800, 1200, 1500];
PSNR_B = [34,  37,  39,  41,   42]; 

% --- Calculate Metrics ---

% 1. Calculate BD-PSNR (Quality gain at same bitrate)
bd_psnr = bjontegaard_n(Rate_A, PSNR_A, Rate_B, PSNR_B, 'dsnr');

% 2. Calculate BD-Rate (Bitrate savings at same quality)
bd_rate = bjontegaard_n(Rate_A, PSNR_A, Rate_B, PSNR_B, 'rate');

% --- Output Results ---
fprintf('--- Bjontegaard Metric Results (Fixed Version) ---\n');
fprintf('BD-PSNR Gain: %.4f dB\n', bd_psnr);
fprintf('BD-Rate Savings: %.4f %%\n', bd_rate);

% INTERPRETATION:
% BD-PSNR should be positive (Codec B is better).
% BD-Rate should be negative (Codec B saves bits).
% If we used the OLD code, it would try to guess Codec B's quality at 100kbps
% (extrapolation), potentially resulting in a wild, incorrect value.


