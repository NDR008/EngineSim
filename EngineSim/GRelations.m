function [ Ratio_RC Vc ] = GRelations( B, l, a, CR )
%   [ L Ratio_RC PA Vs Vc ] = GRelations( B, l, a, CR )
%   Gives the stroke (L), ratio of con rod length to crank radius (Ratio_RC),
%   piston area (PA), swept volume and maximum volume (Vmax)

%   As defined by Heywood J.B., 1988, "Internal Combustion Engine 
%   Fundamentals", McGraw-Hill; 

L = 2 * a;
Ratio_RC = l/a;
PA = pi*B^2/4;
Vs = L * PA;
Vc = Vs /(CR-1);

end

