function [ Cv M R ] = MProperties ( T, varargin )
%   [ Cv M R ] = MProperties ( T, component, component ratio, ... )
%   Example MProperties(350, 'O2', 1) 
%   gives the Cp and Molecular Mass of O2 at 350K
%
%   Example MProperties(350, 'O2', 0.21, 'N2', 0.79) 
%   gives the Cp and Molecular Mass of air at 350K
%
%   The ratios are normalised, i.e.:
%   MProperties(350, 'O2', 0.21, 'N2', 0.79)
%   is equal to:
%   MProperties(350, 'O2', 1, 'N2', 3.7619)


numvarargs = size(varargin, 2);
    if (mod(numvarargs, 2) == 1)
        error('Requires component and mole fraction for each component');
    end
    
index_m = numvarargs/2;

tempCp = zeros(1, index_m);
tempM = zeros(1, index_m);
ratio = zeros(1, index_m);

index = 1;
for cnt = 1:2:numvarargs
    [tempCv(index) tempM(index)] = CProperties(T, varargin{cnt});
    ratio(index) = varargin{cnt+1};
    index = index +1;
end

norm = sum(ratio);
M = sum(tempM .* ratio)/norm;
Cv = sum(tempCv .* tempM .* ratio./norm) /M;
R = 8314.5 / M; %Eastop & McConkey kJ /kmolK

end
