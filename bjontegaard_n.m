function avg_diff = bjontegaard_n(R1, PSNR1, R2, PSNR2, mode)
%BJONTEGAARD_FIXED Calculated Bjontegaard metric with Overlap Fix
%   Computes average PSNR gain or percentage bitrate saving between two 
%   rate-distortion curves.
%
%   Fixes the integration interval bug found in older implementations
%   by strictly limiting integration to the overlapping range of the 
%   two curves.
%
%   R1, PSNR1 - Vectors of Bitrate and PSNR for curve 1
%   R2, PSNR2 - Vectors of Bitrate and PSNR for curve 2
%   mode      - 'dsnr' (avg PSNR diff) or 'rate' (avg rate saving %)
%

    % convert rates to logarithmic units
    lR1 = log(R1);
    lR2 = log(R2);

    switch lower(mode)
        case 'dsnr'
            % --- BD-PSNR ---
            % Fit 3rd order polynomial: PSNR = f(logRate)
            p1 = polyfit(lR1, PSNR1, 3);
            p2 = polyfit(lR2, PSNR2, 3);

            % FIX: Determine intersection (overlap) of the two ranges
            min_int = max(min(lR1), min(lR2));
            max_int = min(max(lR1), max(lR2));

            % Check if overlap exists
            if min_int >= max_int
                warning('Curves do not overlap in Bitrate. Returning NaN.');
                avg_diff = NaN;
                return;
            end

            % Integrate polynomials over the overlap
            p_int1 = polyint(p1);
            p_int2 = polyint(p2);

            int1 = polyval(p_int1, max_int) - polyval(p_int1, min_int);
            int2 = polyval(p_int2, max_int) - polyval(p_int2, min_int);

            % Average difference
            avg_diff = (int2 - int1) / (max_int - min_int);

        case 'rate'
            % --- BD-Rate ---
            % Fit 3rd order polynomial: logRate = f(PSNR)
            p1 = polyfit(PSNR1, lR1, 3);
            p2 = polyfit(PSNR2, lR2, 3);

            % FIX: Determine intersection (overlap) of the two ranges
            min_int = max(min(PSNR1), min(PSNR2));
            max_int = min(max(PSNR1), max(PSNR2));

            % Check if overlap exists
            if min_int >= max_int
                warning('Curves do not overlap in PSNR. Returning NaN.');
                avg_diff = NaN;
                return;
            end

            % Integrate polynomials over the overlap
            p_int1 = polyint(p1);
            p_int2 = polyint(p2);

            int1 = polyval(p_int1, max_int) - polyval(p_int1, min_int);
            int2 = polyval(p_int2, max_int) - polyval(p_int2, min_int);

            % Average difference in log-domain
            avg_exp_diff = (int2 - int1) / (max_int - min_int);
            
            % Convert back to percentage
            avg_diff = (exp(avg_exp_diff) - 1) * 100;
            
        otherwise
            error('Unknown mode. Use "dsnr" or "rate".');
    end
end