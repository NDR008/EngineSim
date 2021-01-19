function [ P T V CrA xb nTH Error ] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy, varargin )
%  	[ P, T, V, CrA, xb ] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy, [optional parameters] )
%  	[] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy )
%  	[] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy, N (rpm), equiv, duration, ign, fueltype=gasoline/isooctane/propane, property_type=2 )
%  	[] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy, N (rpm),	equiv, duration, ign, fueltype=gasoline/isooctane/propane, property_type=1, Cv_u, Cv_b )
%  	[] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy, N (rpm), equiv, duration, ign, fueltype=diesel, ignition delay, property_type=2)
%  	[] = ESim( B, l, a, CR, PInit, TInit, motoring, res, accuracy, N (rpm), equiv, duration, ign, fueltype=diesel, ignition delay, property_type=1,	Cv_u, Cv_b )  

%   Outputs
%   P:      Pressure
%   T:      Temperature
%   V:      Volume
%   CrA:    Crank Angle
%   xb:     Fraction burn
%   Error:  Error measure of approximation

step = 360/res; % number of steps for a complete revolution
%step is used to pre-assign variables and/or maximum loop counters

NOr = 3.773; %Heywood

CrA(res) = 0;
V(res) = 0;
xb(res) = 0;
T(res) = 0;
P(res) = 0;
Error(res) = 0;

[ Ratio_RC Vc   ] = GRelations( B, l, a, CR);

if motoring == 1
   flag = 0;
else
    equiv  = varargin{1};
    N = varargin{2};
    duration = varargin{3};
    ign = varargin{4};
    fueltype = varargin{5};

    if strcmp(fueltype, 'diesel') == 1
            flag = 1;  
    elseif strcmp(fueltype, 'gasoline') == 1
            flag = 2;
    elseif strcmp(fueltype, 'isooctane') == 1
            flag = 3;
    elseif strcmp(fueltype, 'propane') == 1
            flag = 4;
    end
    h = HFuel(fueltype);
    Efficiency = CEfficiency(fueltype, equiv);
end
if flag == 1
    ign_delay_ms = varargin{6};
    propertytype = varargin{7};
    if propertytype == 1    
        Cv_u = varargin{8};
        Cv_b = varargin{9};
    else
        Cv_mix(res)=0;
        Cv_air(res) = 0;
    end
elseif flag > 1
    propertytype = varargin{6};
    if propertytype == 1    
        Cv_u = varargin{7};
        Cv_b = varargin{8};
    end
        Cv_mix(res)=0;
        Cv_air(res) = 0;
end
        

for cnt=1:res
    CrA(cnt)= (cnt*step-step)+180;   
    V(cnt) = CrV(CrA(cnt), Vc, CR, Ratio_RC);
    

    if cnt == 1
        T(cnt) = TInit;
        P(cnt) = PInit;
        [ Cv_air(cnt), M_air R_air ] = MProperties(T(cnt), 'O2', 1, 'N2', NOr);
        mc = P(cnt)*V(cnt)/(R_air*T(cnt));
        xb(cnt) = 0;
        if flag ~= 0
            [ ~, M_fuel, ~ ] = CProperties(T(cnt), fueltype);
            [MoleFr] = UComposition(equiv, NOr, HCr(fueltype), T(cnt), M_fuel, 0);
            [ Cv_mix , ~, ~ ] = MProperties(T(cnt), fueltype, MoleFr(1), 'O2', MoleFr(2), 'N2', MoleFr(3), 'CO2', MoleFr(4), 'H2O', MoleFr(5), 'CO', MoleFr(6), 'H2', MoleFr(7));
            n_air = mc / M_air; % number of moles of air in cylinder
            n_fuel = MoleFr(1) * n_air / ( 1 - MoleFr(1)); % number of moles of fuel
            mfuel = n_fuel * M_fuel;
        else
            mfuel = 0;
        end
        
    else
        if flag == 0
            % Motoring
            xb(cnt) = 0;
            nTH = 0;
            %[ Cv_air(cnt) , ~, R_air ] = MProperties(T(cnt), 'O2', 1, 'N2', NOr);
            Cv_air(cnt) = 723.5325;
            T(cnt) = TCompression( 2, T(cnt-1), P(cnt-1), V(cnt-1), V(cnt), mc, Cv_air(cnt));
            P(cnt) = P(cnt-1)* V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
            Error(cnt) = mc*Cv_air(cnt)*T(cnt)- mc*Cv_air(cnt-1)*T(cnt-1) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1));
            cycle_count = 0;
            while (((Error(cnt) > accuracy) || (Error(cnt) < -1*accuracy)) && (cycle_count < 200))
                cycle_count = cycle_count + 1;
                T(cnt) = T(cnt) - Error(cnt)/(mc*Cv_air(cnt));
                P(cnt) = P(cnt-1) * V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
            %[ Cv_air(cnt) , ~, R_air ] = MProperties(T(cnt), 'O2', 1, 'N2', NOr);
            Cv_air(cnt) = 723.5325;
            Error(cnt) = mc*Cv_air(cnt)*T(cnt)- mc*Cv_air(cnt-1)*T(cnt-1) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1));
            end        
        elseif flag == 1                    
            % Diesel - No fuel in compression
            xb(cnt) = Efficiency * BModel( duration, CrA(cnt), ign, N, fueltype, equiv, ign_delay_ms );
            [MoleFr] = UComposition(equiv, NOr, HCr(fueltype), T(cnt), M_fuel, xb(cnt));
            
            if propertytype == 2       
                [ Cv_mix(cnt) , ~, ~ ] = MProperties(T(cnt-1), fueltype, 0, 'O2', MoleFr(2), 'N2', MoleFr(3), 'CO2', MoleFr(4), 'H2O', MoleFr(5), 'CO', MoleFr(6), 'H2', MoleFr(7));
                T(cnt) = TCompression(propertytype, T(cnt-1), P(cnt-1), V(cnt-1), V(cnt), mc, Cv_mix(cnt));
                T_comb = TCombustion(propertytype, mfuel, mc, xb(cnt-1), xb(cnt), h, Cv_mix(cnt));
                T(cnt) = T(cnt) + T_comb;
                P(cnt) = P(cnt-1)* V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                Error(cnt) = mc*Cv_mix(cnt)*T(cnt)- mc*Cv_mix(cnt-1)*T(cnt-1) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*Cv_mix(cnt-1);
                cycle_count = 0;
                while (((Error(cnt) > accuracy) || (Error(cnt) < -1*accuracy)) && (cycle_count < 200))
                    cycle_count = cycle_count + 1;
                    T(cnt) = T(cnt) - Error(cnt)/(mc*Cv_mix(cnt));
                    P(cnt) = P(cnt-1) * V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                    [MoleFr] = UComposition(equiv, NOr, HCr(fueltype), T(cnt), M_fuel, xb(cnt));
                    [ Cv_mix(cnt) , ~, ~ ] = MProperties(T(cnt-1), fueltype, 0, 'O2', MoleFr(2), 'N2', MoleFr(3), 'CO2', MoleFr(4), 'H2O', MoleFr(5), 'CO', MoleFr(6), 'H2', MoleFr(7));
                    Error(cnt) = mc*Cv_mix(cnt)*T(cnt)- mc*Cv_mix(cnt-1)*T(cnt-1) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*Cv_mix(cnt-1);
                end
            else
                T(cnt) = TCompression(propertytype, T(cnt-1), P(cnt-1), V(cnt-1), V(cnt), mc, Cv_u, Cv_b, xb(cnt));
                T_comb = TCombustion(propertytype, mfuel, mc, xb(cnt-1), xb(cnt), h, Cv_u, Cv_b);
                T(cnt) = T(cnt) + T_comb;
                P(cnt) = P(cnt-1)* V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                Error(cnt) =  mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b)*(T(cnt)- T(cnt-1)) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b);
                cycle_count = 0;
                while (((Error(cnt) > accuracy) || (Error(cnt) < -1*accuracy)) && (cycle_count < 200))
                    cycle_count = cycle_count + 1;
                    T(cnt) = T(cnt) - Error(cnt)/(mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b));
                    P(cnt) = P(cnt-1) * V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                    Error(cnt) =  mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b)*(T(cnt)- T(cnt-1)) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b);
                end
            end
        elseif ( (flag > 1) && (flag <=4) )  
            % Gasoline / Isooctane / Propane          
            xb(cnt) = Efficiency * BModel( duration, CrA(cnt), ign, N, fueltype );      
            [MoleFr] = UComposition(equiv, NOr, HCr(fueltype), T(cnt-1), M_fuel, xb(cnt));
            
            if propertytype == 2       
                [ Cv_mix(cnt) , ~, ~ ] = MProperties(T(cnt-1), fueltype, MoleFr(1), 'O2', MoleFr(2), 'N2', MoleFr(3), 'CO2', MoleFr(4), 'H2O', MoleFr(5), 'CO', MoleFr(6), 'H2', MoleFr(7));
                T(cnt) = TCompression(propertytype, T(cnt-1), P(cnt-1), V(cnt-1), V(cnt), mc, Cv_mix(cnt));
                T_comb = TCombustion(propertytype, mfuel, mc, xb(cnt-1), xb(cnt), h, Cv_mix(cnt));
                T(cnt) = T(cnt) + T_comb;
                P(cnt) = P(cnt-1)* V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                Error(cnt) = mc*Cv_mix(cnt)*T(cnt)- mc*Cv_mix(cnt-1)*T(cnt-1) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*Cv_mix(cnt-1);
                cycle_count = 0;
                while (((Error(cnt) > accuracy) || (Error(cnt) < -1*accuracy)) && (cycle_count < 200))
                    cycle_count = cycle_count + 1;
                    T(cnt) = T(cnt) - Error(cnt)/(mc*Cv_mix(cnt));
                    P(cnt) = P(cnt-1) * V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                    [MoleFr] = UComposition(equiv, NOr, HCr(fueltype), T(cnt), M_fuel, xb(cnt));
                    [ Cv_mix(cnt) , ~, ~ ] = MProperties(T(cnt-1), fueltype, MoleFr(1), 'O2', MoleFr(2), 'N2', MoleFr(3), 'CO2', MoleFr(4), 'H2O', MoleFr(5), 'CO', MoleFr(6), 'H2', MoleFr(7));
                    Error(cnt) = mc*Cv_mix(cnt)*T(cnt)- mc*Cv_mix(cnt-1)*T(cnt-1) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*Cv_mix(cnt-1);
                end
            else
                T(cnt) = TCompression(propertytype, T(cnt-1), P(cnt-1), V(cnt-1), V(cnt), mc, Cv_u, Cv_b, xb(cnt));
                T_comb = TCombustion(propertytype, mfuel, mc, xb(cnt-1), xb(cnt), h, Cv_u, Cv_b);
                T(cnt) = T(cnt) + T_comb;
                P(cnt) = P(cnt-1)* V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                %P(cnt) = mc*R_air*T(cnt)/V(cnt);
                Error(cnt) =  mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b)*(T(cnt)- T(cnt-1)) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b);
                cycle_count = 0;
                while (((Error(cnt) > accuracy) || (Error(cnt) < -1*accuracy)) && (cycle_count < 200))
                    cycle_count = cycle_count + 1;
                    T(cnt) = T(cnt) - Error(cnt)/(mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b));
                    P(cnt) = P(cnt-1) * V(cnt-1)*T(cnt)/(V(cnt)*T(cnt-1));
                    Error(cnt) =  mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b)*(T(cnt)- T(cnt-1)) + 0.5*(P(cnt)+P(cnt-1))*(V(cnt)-V(cnt-1)) - T_comb*mc*((1-xb(cnt))*Cv_u+xb(cnt)*Cv_b);
                end
            end
        end
    end
end
if flag > 0
    nTH = WDone(P,V)/(Efficiency*mfuel*h);
end

end
