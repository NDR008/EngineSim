function [ B ] = BComposition( Equiv, NOr, HCr, T )
%   [ Burned mole fraction array ] = BComposition( Equiv, NOr, HCr, T )
%   Where [ ... ] = [0 nO2 nN2 nCO2 nH2O nCO nH2];
%   
%   Inputs:
%   Equiv : Equivilance ratio for which the composition is calculated.
%   NOr   : Nitrogen to Oxygen ratio (usually 3.77)
%   HCr   : Hydrogen to Carbon ratio of fuel 
%   T     : Temperature at which process is calculated (approximate <1700K)

    eta = 4 / (4 + HCr);
    
if Equiv <= 1
    nCO2 = eta * Equiv;
    nH2O = 2*(1-eta)*Equiv;
    nCO = 0;
    nH2 = 0;
    nO2 = 1 - Equiv;
    nN2 = NOr;    
else
    K = exp(2.743 - 1.761E3/T - 1.611E6/T^2 + 0.2803E9/T^3);
    a = (K-1);
    b = -(K*(2*(Equiv - 1) + eta*Equiv) + 2*(1-eta*Equiv));  
    c = 2*K*eta*Equiv*(Equiv-1); 
    z = (-b-sqrt(b^2-4*a*c))/(2*a);
        
    nCO2 = eta * Equiv - z;
    nH2O = 2*(1-eta*Equiv) + z;
    nCO = z;
    nH2 = 2*(Equiv-1) - z;
    nO2 = 0;
    nN2 = NOr;       
end

%B = [nCO2 nH2O nCO nH2 nO2 nN2];
B = [0 nO2 nN2 nCO2 nH2O nCO nH2];
B = B ./ sum(B);

end