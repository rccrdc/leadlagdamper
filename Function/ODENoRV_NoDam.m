%{
%-Abstract
%
%   ODE_RV: This function performs the numerical iteration of the system of
%           differential equations that regulate the motion of the blade, 
%           the plunger of the lead-lag damper without the fluid.
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
%      tspan:   Vector containing the temporal moments in which we want to 
%               integrate.
%      x0:      Initial conditions for the differential service system.
%      Param:   Structure containing data and anonymous functions that 
%               allow evaluation of derivatives in order to perform 
%               numerical integration.
%
%   The call:
%      
%      [ t , X , T , h ] = ODE_RV( tspan , x0 , Param );
%
%   Returns:
%
%     t:    Temporal moments of integration.
%     X:	Vector containing the state variables at each time point 
%           defined in the previous vector.
%
%-Version
%
%  -Version 1.0.0, 20-JAN-2017.
%
%-&
%}

function [ t , X ] = ODENoRV_NoDam( tspan , x0 , Param )
%% Integrator
% Set of the propeties for the ODE function.
OdeOpt = odeset( 'AbsTol'     , 1e-10 , ... % Setting the absolute tolerance.
                 'RelTol'     , 1e-10 );    % Setting the Relative tolerance.

% Integration the O.D.E. system.
[ t , X ] = ode15s( @odeFun , tspan , x0 , OdeOpt );

%% Support Function.
% O.D.E. function for numerical integration.
    function [ x_d ] = odeFun( t , x )
        
        % Extraxt the variables from the vector x.
        xi   = x( 1 );  % Lead-lag angle [rad].
        xi_d = x( 2 );  % Lead-lag angular velocity [ras/s].
      
        % Setting of the selected perturbation case.
        if strcmp( Param.FlagF , 'Simp' ) == 1
            F = 0;
            if t >= Param.t_imp && t <= Param.t_imp + Param.t_dur
                F = Param.F_max * sin ( 2 * pi * Param.freq * t );
            end 
        else
            F = Param.F_max * sin ( 2 * pi * Param.freq * t );
        end 
        
        x_d( 1 , 1 ) = xi_d;                                                    % Angular speed of the blade: [rad/s].
        x_d( 2 , 1 ) = Param.Dynam.xi_dd_NoDam( F , xi , xi_d );                % Angular acceleration of the blade: [rad/s^2].
    end

end