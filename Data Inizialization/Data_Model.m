% clear;  close all; clc;
%% Damper Data
Param.Damper.F = 150;                                               % Damper, Threshold Force [N].

%% Actuator Design Parameters
Param.Actuator.L   = 0.12;                                          % Design Parameter - Actuator Chamber Length [m] .
Param.Actuator.k1  = 0.30;                                          % Proportionality coefficient for actuator chamber diameter wrt chamber length
Param.Actuator.k2  = 0.03;                                          % Proportionality coefficient for orifice diameter wrt chamber length

%% Actuator Data
% Cross-sectional Area
Param.Actuator.D   = Param.Actuator.k1 * Param.Actuator.L;          % Actuator Chamber Diameter [m].
Param.Actuator.A_c = pi * ( Param.Actuator.D / 2 )^2;               % Hydraulic actuator, Chambers cross-sectional area: [m^2].

% Volumes
Param.Actuator.Vc  = Param.Actuator.A_c * Param.Actuator.L;         % Hydraulic actuator, Chambers volume: [m^3].
Param.Actuator.V0  = Param.Actuator.Vc / 2;                         % Volume of each chamber of the damper for null lead-lag angle[m^3].

% Orifice
Param.Actuator.D_orf = Param.Actuator.k2 * Param.Actuator.L;        % Orifice Diameter [m]
Param.Actuator.A_orf = pi * ( Param.Actuator.D_orf / 2 )^2;         % Hydraulic actuator, Orifices section area: [m^2].
Param.Actuator.Cd    = 0.611;                                       % Hydraulic actuator, Orifices discharge coefficient: [-].
Param.Actuator.Pc    = 1e6;                                         % Hydraulic actuator, Hydraulic circuit background pressure: [Pa].
 
%% Relief Valve.
% If you do not want to use the optimized values, comment out line (28) 
% if you want to use them uncomment line (28).
OptmCase = 'on';

if exist( 'OptmCase' , 'var' ) == 0
    Param.RF.R_L    = 5e-3;                                                % Left side poppet radius of the relief valve: [m].
else
    Param.RF.R_L    = 0.00339018373391647;                                 % Optim Left side poppet radius of the relief valve: [m].
end
Param.RF.R_R    = sqrt ( 2 ) * Param.RF.R_L;                               % Right side poppet radius of the relief valve: [m].
Param.RF.Cd     = 0.611;                                                   % Discharge coefficient of the relief valve: [-].
Param.RF.Lp     = 5e-3;                                                    % Length of the poppet for the relief valve: [m].
Param.RF.rho_p  = 7500;                                                    % Density of steel
Param.RF.Vp     = pi * Param.RF.Lp * ( Param.RF.R_L + Param.RF.R_R );      % Volume of the poppet of the relief valves. {m^3}
Param.RF.m      = Param.RF.Vp * Param.RF.rho_p;                            % Poppet mass of the relief valve: [kg].
if exist( 'OptmCase' , 'var' ) == 0
	Param.RF.k      = 2e4;                                                 % Spring stiffness of the relief valve: [N/m].
else
    Param.RF.k      = 141.123149297227;                                    % Optim Spring stiffness of the relief valve: [N/m].
end
Param.RF.cc     = 2 * sqrt( Param.RF.k * Param.RF.m );                     % Critical damping coefficient: [N-s/m].
if exist( 'OptmCase' , 'var' ) == 0
    Param.RF.z      = 0.8;                                                 % Damping ratio: [-].
else
    Param.RF.z      = 1.69284824607997;                                    % Optim Damping ratio: [-].
end
Param.RF.r      = Param.RF.z * Param.RF.cc;                                % Sructural damping of the relief valve: [N-s/m].
Param.RF.l      = 3e-2;                                                    % Maximum displacement of the poppet [m]
Param.RF.E      = 210e9;                                                   % Young modulus of steel [Pa]
Param.RF.geo    = mean( [ Param.RF.R_L Param.RF.R_R ] );                   % Geometrical parameter for the contact force [m]
Param.RF.k_s    = 2 * Param.RF.geo * Param.RF.E;                           % Contact force stiffness [N/m]
Param.RF.cc_s   = 2 * sqrt( Param.RF.k_s * Param.RF.m );                   % Critical damping for contact 
Param.RF.z_s    = 0.2;                                                     % Damping ratio for contact
Param.RF.r_s    = Param.RF.z_s * Param.RF.cc_s;                            % Contact force damping

%% Relief Valve Optimization
% Possible values of R_L for the damping ratio iterpolation: [m].
Param.Opt.R_L = [ 5 , 4.5 , 4 , 3.5 , 3 , 2.5 ] * 1e-3;

% Possible values of k for the damping ratio iterpolation: [N/m].
Param.Opt.k = [  1e5 , 9e4 ,   8e4 ,  7e4 ,  6e4 , 5e4 ,  4e4 ,  3e4 ,  2e4 ,  1e4 ,  9e3 ,  8e3 ,  7e3 ,  6e3 ,  5e3 ,  4e3 ,  3e3 ,   2e3 , 1e3 ,  900 ,  800 , 700 ,  600 ,  500 , 400 , 300 , 200 , 100 ,  90 ,  80 ,  70 ,  60 ,  50 ,  40 , 30 , 20 , 10 ,  9 ,  8 ,  7 ,  6 ,    5 ,  4 ,    3 ,  2 ,  1 ];

% Values of the damping ratio for iterpolation: [-].
Param.Opt.z = [ 0.49 , 0.5 , 0.525 , 0.55 , 0.58 , 0.6 , 0.62 , 0.65 , 0.68 , 0.72 , 0.75 , 0.77 , 0.79 , 0.82 , 0.87 , 0.91 , 1.05 , 1.225 , 1.6 , 1.75 , 1.83 , 1.9 , 2.07 , 2.25 , 2.4 , 2.9 , 3.5 , 4.9 , 5.1 , 5.4 , 5.8 , 6.3 , 6.9 , 7.7 ,  9 , 11 , 15 , 16 , 17 , 18 , 20 , 21.5 , 24 , 27.5 , 34 , 48 ; ...
      0.5 , 0.504 , 0.509 , 0.515 , 0.522 , 0.529 , 0.545 , 0.56 , 0.58 , 0.625 , 0.655 , 0.66 , 0.67 , 0.68 , 0.72 , 0.77 , 0.85 , 0.95 , 1.24 , 1.29 , 1.37 , 1.45 , 1.55 , 1.7 , 1.9 , 2.1 , 2.6 , 3.7 , 3.9 , 4.1 , 4.4 , 4.8 , 5.1 , 5.7 , 6.5 , 8.2 , 11.5 , 12.3 , 13.1 , 14 , 15 , 16.5 , 18 , 21 , 26 , 37 ; ...
      0.43 , 0.44 , 0.45 , 0.455 , 0.46 , 0.47 , 0.48 , 0.49 , 0.5 , 0.51 , 0.52 , 0.53 , 0.545 , 0.57 , 0.6 , 0.65 , 0.7 , 0.85 , 1.12 , 1.18 , 1.23 , 1.3 , 1.4 , 1.5 , 1.7 , 1.9 , 2.25 , 3.2 , 3.4 , 3.6 , 3.9 , 4.2 , 4.5 , 5 , 5.75 , 7 , 10 , 10.5 , 11.3 , 11.9 , 12.3 , 13.5 , 15 , 18 , 23 , 30 ; ...
      0.397 , 0.3975 , 0.397 , 0.398 , 0.4 , 0.403 , 0.407 , 0.412 , 0.417 , 0.423 , 0.435 , 0.45 , 0.48 , 0.52 , 0.57 , 0.62 , 0.68 , 0.75 , 0.88 , 0.9 , 0.93 , 0.97 , 1.03 , 1.1 , 1.2 , 1.3 , 1.5 , 2.1 , 2.17 , 2.25 , 2.35 , 2.5 , 2.7 , 3 , 3.5 , 4.5 , 6 , 6.3 , 6.7 , 7.1 , 7.6 , 8.5 , 9.5 , 11 , 14 , 19 ; ...
      0.398 , 0.44 , 0.4425 , 0.445 0.4475 0.45 , 0.455 0.46 , 0.47 , 0.48 , 0.49 , 0.51 , 0.53 , 0.54 , 0.55 , 0.6 , 0.70 , 0.75 , 0.8 , 0.85 , 0.9 , 0.95 , 1 , 1.05 , 1.1 , 1.15 , 1.2 , 1.41 , 1.49 , 1.58 , 1.68 , 1.8 , 1.95 , 2.25 , 2.6 , 3.2 , 4.55 , 4.75 , 4.95 , 5.2 , 5.7 , 6.3 , 7 , 8.3 , 10 , 14 ; ...
      0.466 , 0.468 , 0.47 , 0.4725 , 0.475 , 0.4775 , 0.48 , 0.485 , 0.49 , 0.4975 , 0.505 , 0.5125 , 0.52 , 0.53 , 0.54 , 0.55 , 0.56 , 0.569 , 0.575 , 0.583 , 0.59 , 0.6 , 0.615 , 0.625 , 0.65 , 0.675 , 0.75 , 0.81 , 0.84 , 0.86 , 0.875 , 0.9 , 0.97 , 1.1 , 1.25 , 1.55 , 2.2 , 2.3 , 2.5 , 2.75 , 3 , 3.25 , 3.5 , 4 , 5 , 7.5 ];

% Matrix of the square of the values of R_L for interpolation.
Param.Opt.R_L_mat = ( Param.Opt.R_L .* ones( length( Param.Opt.k ) , length( Param.Opt.R_L ) ) )';

% Matrix of the square of the values of k for interpolation.
Param.Opt.k_mat = Param.Opt.k .* ones( length( Param.Opt.R_L ) , length( Param.Opt.k ) );

%% Air Data
Param.Air.rho        = 1.225;                                       % Air density [kg/m^3] - Standard atmosphere

%% Blade Data
Param.Blade.L        = 0.8;                                         % Length of the balde [m].
Param.Blade.c        = 0.08;                                        % Length of the horn [m].
Param.Blade.a0       = 0.24;                                        % Initial extension of the actuator [m].
Param.Blade.d        = Param.Blade.a0;                              % Distance between horn and lead-lag hinge [m].
Param.Blade.l0       = 0.1;                                         % Length from hub to led-lag hinge [m].
Param.Blade.rho      = 2.4;                                         % Mass of the blade per unit length [kg/m].
Param.Blade.M_b      = Param.Blade.L * Param.Blade.rho;             % Mass of the blade [kg].
Param.Blade.M_H      = Param.Blade.c * Param.Blade.rho;             % Mass of the horn [kg].
Param.Blade.M        = 10;                                          % Mass of the blade tip [kg].
Param.Blade.Omega    = ( 250 * 2 * pi ) / 60;                       % Angular velocity of the balde (250 rpm) [rad/s].
Param.Blade.MAC      = 0.06;                                        % Mean aerodinamic chord [m].
Param.Blade.CD       = 0.02;                                        % Drag coefficient of the NACA 0012 aerodynamic profile.

%% Fluid Data (MIL-PRF-5606)
Param.Fluid.T        = 273.15 + 20;                                 % Work Temperature of the fluid [K].

[ viscosity , density , bulk_modulus ] = FluidProp( Param.Fluid.T );
Param.Fluid.ni       = viscosity;                                   % Kinematic viscosity of the fluid [m^2/s].
Param.Fluid.rho      = density;                                     % Density of the fluid [kg/m^3].
Param.Fluid.Beta     = bulk_modulus;                                % Bulk moduls of the fluid [Pa].

%% Compute the Support Parameter
% Compute the total rotational inerzia of the blade [kg*m^2].
Param.I_tot =          Param.Blade.M_b * Param.Blade.L^2 / 4 + ...
                       Param.Blade.M_H * Param.Blade.c^2     + ...
                       Param.Blade.M   * Param.Blade.L^2     + ...
              1 / 12 * Param.Blade.M_b * Param.Blade.L^2;

% Compute the "rotational stiffness" of the blade [kg*m^2*rad^2/s^2].
Param.K     = ( Param.Blade.M_b * Param.Blade.L / 2 + ...
                Param.Blade.M_H * Param.Blade.c^2   + ...
                Param.Blade.M   * Param.Blade.L^2   ) * Param.Blade.l0 * Param.Blade.Omega^2;
