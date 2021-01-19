function [ HC_ratio ] = HCr( fueltype )
%   [ HC_ratio ] = HCr( fueltype )
%   HCR(fueltype) gives H to C ratio for a given fuel

switch(fueltype)
    case 'isooctane' % Heywood
       C=8; H=18;
    case 'diesel' % Heywood
       C=10.8; H=18.7;
    case 'gasoline' % Heywood
       C=8.26; H=15.5;
    case 'propane' % Heywood
       C=3; H=8;
end

HC_ratio = H / C;


