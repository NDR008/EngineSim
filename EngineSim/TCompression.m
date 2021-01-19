function [ T2 ] = TCompression( mode, T1, P1, V1, V2, mc, Cv, varargin )
%   [ T_i+1 ] = TCompression( mode=1, T_i, P_i, V_i, V_i+1, mc, Cv, [optional parameters] )
%   [ T_i+1 ] = TCompression( mode=1, T_i, P_i, V_i, V_i+1, mc, Cv_u, Cv_b, xb)
%   or
%   [ T_i+1 ] = TCompression( mode=2, T_i, P_i, V_i, V_i+1, mc, Cv)
%
%   TCompression estimates the temperature after a given change in volume.
%   Mode = 1: Frozen mixture composition for fresh air/air-fuel mix and
%   exhaust gases, thus two specific heats (Cv_u, Cv_b) are required as
%   well as a fraction burn (xb).
%   Mode = 2: The mixture properties are calculated external of this
%   function and hence one specific heat is expected (Cv) and no fraction 
%   burn is expected.
%
%   Other Inputs:
%   T_i: Temperature at step i
%   P_i: Pressure at step i
%   V_i: Volume at step i
%   V_i+1:  Volume at step i+1
%   mc: Mass of charge
%
%   Outputs:
%   T_i+1: Temperature at step i+1

if mode == 1;
    numvarargs = size(varargin, 2);
    if (numvarargs ~= 2 )
        error('Requires Cv for the burned mixture');
    end
    Cv_b = varargin{1};
    xb = varargin{2};
    Cv_u = Cv;
    T2 = T1 - P1*(V2-V1)/(mc*((1-xb)*Cv_u+xb*Cv_b));
else
    T2 = T1 - P1*(V2-V1)/(mc*Cv);
end

end