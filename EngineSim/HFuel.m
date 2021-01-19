function [ h ] = HFuel( fueltype )
%   [ h ] = HFuel( fueltype )
%   
%   HFuel returns the lower heating value as J/kg
switch fueltype
    case 'diesel'
        h = 44.0E6;
    case 'gasoline'
        h = 42.0E6;
    case 'isooctane'
        h = 44.3E6;
    case'propane'
        h = 46.4E6;
end

end

