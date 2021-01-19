function [ xb ] = BModel( duration, CrA, ign, Ne, fueltype, varargin )
%   [ xb ] = BModel( duartion, CrA, ign, Ne, fueltype [equiv] [ign_delay_ms] )
%
%   equiv and ign_delay_ms needed if fuel type is diesel.
%
%   BModel calculates the fraction burn. The model used depends on the fuel
%   type, for diesel, a diesel burning model. For other fuel types, the
%   generic gasoline model is used.
%   
%   Diesel additional inputs: equivilance ratio, and ignition delay

if strcmp(fueltype, 'diesel') == 1
    
    numvarargs = size(varargin, 2);
    if numvarargs ~= 2
        error('equivilance ratio needed for diesel combustion model and ignition delay');
    end
    
    equiv = varargin{1};
    
    ign_delay_ms = varargin{2};
    
    a = 0.8;
    % 0.8 < a < 0.95
    b = 0.45;
    % 0.25 < b < 0.45
    c = 0.25;
    % 0.25 < c < 0.5

    beta = 1 - (a*equiv^b)/(ign_delay_ms^c);

    temp = CrA - (360-ign);
    if temp < 0;
        xb = 0;
    
    elseif ((temp >= 0) && (temp < duration))
        K1 = 2 + 1.25 * (10^-8)*(ign_delay_ms * Ne)^2.4;
        K2 = 5000;
        K3 = 14.2/(equiv^0.644);
        K4 = 0.79*K3^0.25;

        tdash = temp/duration;
        f2 = 1 - exp(-K3*tdash^K4);
        f1 = 1 - (1 - tdash^K1)^K2;
        xb = beta*f1 + (1 - beta)*f2;
    
    else
        xb = 1;
    end   
else
    temp = CrA - (360-ign);
    if temp < 0;
        xb = 0;
    
    elseif ((0 <= temp)) 
        a = 5;
        m = 2;
        xb = 1 - exp(-a*((temp)/duration)^(m+1));
    else
        xb = 1;
    end
end

end