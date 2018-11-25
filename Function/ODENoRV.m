%{
%-Abstract
%
%   ODENoRV: This function performs the numerical iteration of the system 
%            of differential equations that regulate the motion of the 
%            blade, the plunger of the lead-lag damper governed by the 
%            passage of fluid.
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
%      [ t , X ] = ODENoRV( tspan , x0 , Param );
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

function [ t , X ] = ODENoRV( tspan , x0 , Param )
%% Date

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
        P1   = x( 3 );	% Pressure in left chamber of the lead-lag damper [Pa].
        P2   = x( 4 );  % Pressure in right chamber of the lead-lag damper [Pa].
        
        % Setting of the selected perturbation case.
        switch Param.FlagF
            case { 'Disp' }
                F = 0;
            case { 'Imp' }
                F = 0;
                if t <= Param.t_imp
                    F = Param.F_max;
                end
            case { 'Sin' }
                F = Param.F_max * sin ( 2 * pi * Param.freq * t );
            case { 'Simp' }
                F = 0;
                if t >= Param.t_imp && t <= Param.t_imp + Param.t_dur
                   F = Param.F_max * sin ( 2 * pi * Param.freq * t );
                end   
            otherwise
                error( 'error: FlagF not valid.' );
        end
        
        % Setting and calculation of the density of the displaced fluid.
        if P2 > P1
            % Density, [kg/m^3].
            rho = Param.Dynam.rho_2( P2 );
        else
            % Density, [kg/m^3].
            rho = Param.Dynam.rho_1( P1 );
        end
        
        % Volumetric flow rate entering chamber 1-2, [m^3/s].
        Q_in = 0;
        
        % Volumetric flow outgoing from chamber 1-2, [m^3/s].
        Q_out = 0;
        
        x_d( 1 , 1 ) = xi_d;                                                            % Angular speed of the blade: [rad/s].
        x_d( 2 , 1 ) = Param.Dynam.xi_dd( F , P1 , P2  , xi , xi_d );                   % Angular acceleration of the blade: [rad/s^2].
        x_d( 3 , 1 ) = Param.Dynam.P1_d( P1 , P2 , Q_in , Q_out , rho , xi , xi_d );    % Time derivation of the pressure in the chamber 1: [Pa/s].
        x_d( 4 , 1 ) = Param.Dynam.P2_d( P1 , P2 , Q_in , Q_out , rho , xi , xi_d );    % Time derivation of the pressure in the chamber 2: [Pa/s].

    end

end