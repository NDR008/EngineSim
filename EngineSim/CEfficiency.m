function [ efficiency ] = CEfficiency( fueltype, equiv )
% [ efficiency ] = CEfficiency( fueltype, equiv )
%   Gives a ratio of combustion efficiency based on fuel type and equiv
%   ratio


if strcmp(fueltype, 'diesel') == 1
    if ( ( equiv >= 0.4 ) && ( equiv <= 1.0 ) )
        efficiency = 0.98;
    elseif ( ( equiv >= 0.2 ) && ( equiv < 0.4 ) )
        efficiency = 0.3*equiv + 0.86;
    else
        efficiency = 0;
        
    end
else
     if ( ( equiv > 0.62) && ( equiv <= 0.78 ) )
         efficiency = 0.375*equiv + 0.6875;
     elseif ( ( equiv >= 0.78) && ( equiv <= 1 ) )
        efficiency = 0.98;
     elseif ( ( equiv > 1) && ( equiv <= 1.4 ) )
        efficiency = -0.95*equiv + 1.93;
     else
         efficiency = 0;
     end
end        

end

