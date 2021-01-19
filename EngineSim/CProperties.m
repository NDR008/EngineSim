 function [ Cv, M, R ] = CProperties( T, species )
% [ Cv, molarM, R ] = CProperties( T, species )
%   
%  Can evaluate properties of:
%  CO2, H20, N2, O2, CO, H2, H, O, OH, NO
%   and
%  gasoline, diesel, isooctane, propane

% Data taken and adapted from 
% David R. Buttsworth, 2002, "Spark Ignition Internal Combustion Engine
%       Modelling using Matlab", who took the data from:
% 1. Ferguson C.R., 1986, "Internal Combustion Engines", Wiley; 
% 2. Heywood J.B., 1988, "Internal Combustion Engine Fundamentals", 
%    McGraw-Hill; 
% 3. Raine R. R., 2000, "ISIS_319 User Manual", Oxford Engine Group.

ACO2l= [0.24007797E+01 0.87350957E-02 -0.66070878E-05 0.20021861E-08 0.63274039E-15 -0.48377527E+05 0.96951457E+01];
AH2Ol= [0.40701275E+01 -0.11084499E-02 0.41521180E-05 -0.29637404E-08 0.80702103E-12 -0.30279722E+05 -0.32270046E+00];
AN2l = [0.36748261E+01 -0.12081500E-02 0.23240102E-05 -0.63217559E-09 -0.22577253E-12 -0.10611588E+04 0.23580424E+0];
AO2l = [0.36255985E+01 -0.18782184E-02 0.70554544E-05 -0.67635137E-08 0.21555993E-11 -0.10475226E+04 0.43052778E+01];
ACOl = [0.37100928E+01 -0.16190964E-02 0.36923594E-05 -0.20319674E-08 0.23953344E-12 -0.14356310E+05 0.29555350E+01];
AH2l = [0.30574451E+01 0.26765200E-02 -0.58099162E-05 0.55210391E-08 -0.18122739E-11 -0.98890474E+03 -0.22997056E+01];
AHl  = [0.25000000E+01 0.00000000E+00 0.00000000E+00 0.00000000E+00 0.00000000E+00 0.25471627E+05 -0.46011762E+00];
AOl  = [0.29464287E+01 -0.16381665E-02 0.24210316E-05 -0.16028432E-08 0.38906964E-12 0.29147644E+05 0.29639949E+01];
AOHl = [0.38375943E+01 -0.10778858E-02 0.96830378E-06 0.18713972E-09 -0.22571094E-12 0.36412823E+04 0.49370009E+00];
ANOl = [0.40459521E+01 -0.34181783E-02 0.79819190E-05 -0.61139316E-08 0.15919076E-11 0.97453934E+04 0.29974988E+01];

ACO2h= [0.44608041E+01 0.30981719E-02 -0.12392571E-05 0.22741325E-09 -0.15525954E-13 -0.48961442E+05 -0.98635982E+00];
AH2Oh= [0.27167633E+01 0.29451374E-02 -0.80224374E-06 0.10226682E-09 -0.48472145E-14 -0.29905826E+05 0.66305671E+01];
AN2h = [0.28963194E+01 0.15154866E-02 -0.57235277E-06 0.99807393E-10 -0.65223555E-14 -0.90586184E+03 0.61615148E+01];
AO2h = [0.36219535E+01 0.73618264E-03 -0.19652228E-06 0.36201558E-10 -0.28945627E-14 -0.12019825E+04 0.36150960E+01];
ACOh = [0.29840696E+01 0.14891390E-02 -0.57899684E-06 0.10364577E-09 -0.69353550E-14 -0.14245228E+05 0.63479156E+01];
AH2h = [0.31001901E+01 0.51119464E-03 0.52644210E-07 -0.34909973E-10 0.36945345E-14 -0.87738042E+03 -0.19629421E+01];
AHh  = [0.25000000E+01 0.00000000E+00 0.00000000E+00 0.00000000E+00 0.00000000E+00 0.25471627E+05 -0.46011763E+00];
AOh  = [0.25420596E+01 -0.27550619E-04 -0.31028033E-08 0.45510674E-11 -0.43680515E-15 0.29230803E+05 0.49203080E+01];
AOHh = [0.29106427E+01 0.95931650E-03 -0.19441702E-06 0.13756646E-10 0.14224542E-15 0.39353815E+04 0.54423445E+01];
ANOh = [0.31890000E+01 0.13382281E-02 -0.52899318E-06 0.95919332E-10 -0.64847932E-14 0.98283290E+04 0.67458126E+01];


Adiesel    = [-9.1063 246.97 -143.74 32.329 0.0518 -50.128];
Agasoline  = [-24.078 256.63 -201.68 64.750 0.5808 -27.562];
Aisooctane = [-0.55313 181.62 -97.787 20.402 -0.03095 -60.751];
Apropane   = [-1.4867 74.339 -39.065 8.0543 0.01219 -27.313];

if strcmp(species, 'diesel') == 1
    A = Adiesel;
    T = T/1000;
    molM = 148.6;
    R = 8314.5/molM;
    Cp = sum(A*[1 T T^2 T^3 T^-2 0]')*4187/molM;
elseif strcmp(species, 'gasoline') == 1
    A = Agasoline;
    T = T/1000;
    molM = 114.8;
    R = 8314.5/molM;
    Cp = sum(A*[1 T T^2 T^3 T^-2 0]')*4187/molM;
elseif strcmp(species, 'isooctane') == 1
    A = Aisooctane;
    T = T/1000;
    molM = 114.2;
    R = 8314.5/molM;
    Cp = sum(A*[1 T T^2 T^3 T^-2 0]')*4187/molM;
elseif strcmp(species, 'propane') == 1
    A = Apropane;
    T = T/1000;
    molM = 44.1;
    R = 8314.5/molM;
    Cp = sum(A*[1 T T^2 T^3 T^-2 0]')*4187/molM;
else
    if T < 1000
        switch species
            case 'CO2'
                A = ACO2l;
                molM = 44;
            case 'H2O'
                A = AH2Ol;
                molM = 18;
            case 'N2'
                A = AN2l;
                molM = 28.16; %atmospheric Nitrogen;
            case 'O2'
                A = AO2l;
                molM = 32;
            case 'CO'
                A = ACOl;
                molM = 28;
            case 'H2'
                A = AH2l;
                molM = 2;
            case 'H'
                A = AHl;
                molM = 1;
            case 'O'
                A = AOl;
                molM = 16;
            case 'OH'
                A = AOHl;
                molM = 17;
            case 'NO'
                A = ANOl;
                molM = 44.16; 
        end
    else 
        switch species
            case 'CO2'
                A = ACO2h;
                molM = 44;
            case 'H2O'
                A = AH2Oh;
                molM = 18;
            case 'N2'
                A = AN2h;
                molM = 28.16; %atmospheric Nitrogen;
            case 'O2'
                A = AO2h;
                molM = 32;
            case 'CO'
                A = ACOh;
                molM = 28;
            case 'H2'
                A = AH2h;
                molM = 2;
            case 'H'
                A = AHh;
                molM = 1;
            case 'O'
                A = AOh;
                molM = 16;
            case 'OH'
                A = AOHh;
                molM = 17;
            case 'NO'
                A = ANOh;
                molM = 44.16; 
        end
    end
    R = 8314.5/molM; % kJ / kmolK
    Cp = sum(A*[1 T T^2 T^3 T^4 0 0]')*R; % J / kgK
end
    M = molM;
    Cv = Cp - R; % kJ /  kgK
end
