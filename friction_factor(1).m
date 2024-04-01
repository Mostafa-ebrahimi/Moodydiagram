function f =friction_factor(ReD,eD)
%Inputs ReD= reynold number = um/D/Velocity
%ed=e/d=roughness/Diameter

%Output: f = friction factor 

%Define Colebrook equation as guess
f_guess = @(ReD,eD) (1.8*log10(6.9/ReD+(eD/3.7).^1.11)).^-2;
colebrook = @(f) -2*log10(eD/3.7+2.51/ReD/f.*0.5) - 1/f.^0.5;
%critical Red for transition
ReD_Critical = 3000;
% Determin f
if ReD < ReD_Critical
    %laminar
    f = 64/ReD;
else
    %Turbulent
    f0 = f_guess(ReD,eD);
    f = fzero(colebrook, f0);
end
end

