function [ dT ] = TCombustion( mode, mf, mc, xb1, xb2, h, Cv, varargin )
%   [ dT ] = TCombustion( mode, mf, mc, xb1, xb2, h, Cv, [options] )
%   dT = TCombustion( mode=1, mf, mc, xb_i, xb_i+1, h, Cv_u, Cv_b )
%   or
%   dT = TCombustion( mode=2, mf, mc, xb_i, xb_i+1, h, Cv )
%
%   TCombustion estimates the temperature rise for a given change in
%   fraction burn (xb_i to xb_i+1)
%   Mode = 1: Frozen mixture composition for fresh air/air-fuel mix and
%   exhaust gases, thus two specific heats (Cv_u, Cv_b).
%   Mode = 2: The mixture properties are calculated external of this
%   function and hence one specific heat is expected (Cv).
%
%   Other Inputs:
%   mf : total mass of fuel
%   mc : mass of charge
%   h  : J/kg energy content of fuel
%
%   Outputs:
%   dT: Temperature rise

Ef = mf * h; % Calculate energy of the mass of fuel


if (xb2 < xb1) % Check xb is increasing
    disp('xb_i+1 < xb_i, is this expected?');
end

if mode == 1;
    numvarargs = size(varargin, 2);
    if (numvarargs ~=1 )
        error('Requires Cv for the burned mixture');
    end
    Cv_b = varargin{1};
    Cv_u = Cv;
    dT = (Ef*(xb2-xb1))/(mc*((1-xb2)*Cv_u+xb2*Cv_b));
else
    dT = (Ef*(xb2-xb1))/(mc*Cv);
end

end