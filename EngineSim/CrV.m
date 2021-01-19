function [ V ] = CrV( CrA, Vc, CR, Ratio_RC )
%   [ V ] = CrV( Angle, Vc, CR, Ratio_RC )
%   Returns the cylinder volume for a given:
%       CrA     : Crank Angle in degrees
%       Vc      : Clearane Volume
%       CR      : Compression Ratio
%       Ratio_RC: Ratio of Connectin Rod to crank radius

V  = Vc * (1 + 0.5.*(CR - 1).*(Ratio_RC + 1 - cosd(CrA) - sqrt(Ratio_RC.^2 - (sind(CrA)).^2)));

end