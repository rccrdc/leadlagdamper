%{
%-Abstract
%
%   FLUIDPROP: This function resists the kinematic viscosity, density and 
%              bulk modulus of the hydraulic mineral oil ML-H-5606 function
 %             of the temperature expressed in Kelvin.
%
%-Disclaimer
% 
%   THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY CANOLA RICCARDO
%   NICOLI MATTEO e PRATO MATTEO.
%
%-I/O
%
%   Given:
%      
%      T:   Temperature [K].
%
%   The call:
%      
%      [ viscosity , density , bulk_modulus ] = FluidProp( T );
%
%   Returns:
%
%     viscosity:    Kinematic Viscosity [m^2/s].
%     density:      Density [kg/m^3].
%     bulk_modulus: Bulk Modulus [Pa].
%
%-Version
%
%  -Version 1.0.0, 23-OCT-2017.
%
%-&
%}

function [ viscosity , density , bulk_modulus ] = FluidProp( T )

info = sh_stockfluidproperties;

[ viscosity , density , bulk_modulus ] = info.f_5606.prop( T - 273.15 );

end