function [ B ] = UComposition( EquivilanceRatio, NOr, HCr, T, Mf, xb )
%   [ Unburned Mole Fraction Array ] = UComposition( EquivilanceRatio, NOr, HCr, T, Mf, xb )
%   Where [...] = [ nFuel nO2 nN2 nCO2 nH2O nCO nH2 ]

    eta = 4 / (4 + HCr);
    
if EquivilanceRatio <= 1
    nFuel = 4*(1-xb)*(1 + 2*eta)*EquivilanceRatio / Mf;
    nO2 = 1-xb*EquivilanceRatio;
    nN2 = NOr;
    nCO2 = xb*eta*EquivilanceRatio;
    nH2O = 2*xb*(1 - eta) * EquivilanceRatio;
    nCO = 0;
    nH2 = 0;

else
    K = exp(2.743 - 1.761E3/T - 1.611E6/T^2 + 0.2803E9/T^3);
    a = (K-1);
    b = -(K*(2*(EquivilanceRatio - 1) + eta*EquivilanceRatio) + 2*(1-eta*EquivilanceRatio));  
    c = 2*K*eta*EquivilanceRatio*(EquivilanceRatio-1); 
    z = (-b-sqrt(b^2-4*a*c))/(2*a);

    nFuel = 4*(1-xb)*(1 + 2*eta)*EquivilanceRatio / Mf;
    nO2 = 1-xb;
    nN2 = NOr;
    nCO2 = xb*(eta*EquivilanceRatio - z);
    nH2O = xb*(2*(1 - eta*EquivilanceRatio) + z);
    nCO = xb*z;
    nH2 = xb*(2*(EquivilanceRatio - 1) - z);     
end
B = [nFuel nO2 nN2 nCO2 nH2O nCO nH2];
n = sum(B);
B = B ./ n;
end