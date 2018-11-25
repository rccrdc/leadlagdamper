clear; close all; clc;
%% Inizialization
Installing;

%% Load the Data.
Data_Model;

%% Kinematics & Dynamics Computation.
Script_KinematicsDynamics;

%% Jacobian and eigen value.
Script_JacobianEigvalues;

%% Initial Contitions and simulation time
% Simulation time.
tspan = [ 0 , 3 ];

% Initial conditions.
X0 = [             xi_eq ; ...          % Initial displacement [deg].
                       0 ; ...          % Initial velocity [deg/s].
       Param.Actuator.Pc ; ...          % Initial 1st chamber pressure [Pa].
       Param.Actuator.Pc ; ...          % Initial 2nd chamber pressure [Pa].
                       0 ; ...          % Initial displacement of the upper valve [m].
                       0 ; ...          % Initial velocity of the upper valve [m/s].
                       0 ; ...          % Initial displacement of the lower valve [m].
                       0 ];             % Initial velocity of the lower valve [m/s].

%% Forcing Term Configuration.
% Choice of input for the perturbation (simple initial displacement 
% "Disp", impulse force "Imp", sinusoidal force "Sin" and sinusoidal force 
% limited in time "Simp")
Param.FlagF = 'Disp'; 

switch Param.FlagF
    case { 'Disp' }                         % Initial displacement (No forces)
        xi0 = 15;                                    % Initial Displacement value [deg].
        X0  = [ deg2rad( xi0 ) ; ...                 % Modifying the initial conditions
                 X0( 2 : end ) ];
    case { 'Imp' }                          % Initial Impulse
        Param.F_max = 200;                           % Intensity of the impulse [N].
        Param.t_imp = 0.1;                           % Duration of the impulse [s].
        
    case { 'Sin' }                          % Sinusoidal force
        Param.F_max = 200;                          % Maximum amplitude of the force [N].
    	Param.freq  = 4;                            % Frequency of the force [Hz].
        
    case { 'Simp' }                         % Sinusoidal force active in an interval of time
        Param.F_max = 200;                          % Maximum amplitude of the force [N].
    	Param.freq  = 4;                            % Frequency of the force [Hz].
        Param.t_imp = 0;                            % Time interval to the start of the sinusoidal perturbation[s].
        Param.t_dur = 2;                            % Duration of the sinusoidal perturbation [s].
    
    otherwise
        error( 'error: Input not valid (FlagF).' );
end

%% Optimization of the Relief Valve chrateristichs.
% Script_Optimization;

%% Integration
% Integration of the complete system with active relief valve.
tic
[ t_ode , X , T , h ] = ODE_RV( tspan , X0 , Param );
ODERunTime = toc;
disp( [ 'The run time of the ode numerical intergration is: ' num2str( ODERunTime , '%10.3f' ) ' second' ] );

% System integration without relief valve.
x0 = X0( 1 : 4 );
[ t_NoRV , X_NoRV ] = ODENoRV( tspan , x0 , Param );

% System integration without lead-lag damper (only occurs for sinosoidal 
% perturbations).
if strcmp( Param.FlagF , 'Sin' ) == 1 || strcmp( Param.FlagF , 'Simp' ) == 1
    x_0 = X0( 1 : 2 );
    [ t_NoDam , X_NoDam ] =  ODENoRV_NoDam( tspan , x_0 , Param );
    
end

%%
F = Param.Dynam.F( X( : , 3 ) , X( : , 4 ) );                   % Force on the piston of the lead-lag damper: [N].
F_NoRV = Param.Dynam.F( X_NoRV( : , 3 ) , X_NoRV( : , 4 ) );    % Force having no relief valves: [N].
b = Param.Kine.b( X( : , 1 ) );                                 % Displacement of the lead-lag damper piston: [m].
a_d = Param.Kine.a_d( X( : , 1 ) , X( : , 2 ) );                % Piston speed of the lead-lag damper: [m/s].

[ ~ , idx_a_d_optim ] = max( abs( a_d ) );                      % Maximum speed value on the piston [m/s].
F_Max_b_max_optim = abs( F( idx_a_d_optim ) );                  % Value of the force on the piston at the maximum speed value [N].
F_Max_optim = max( abs( F ) );                                  % Maximum force value on the piston [N].
        

%% Plots
Plot_Model;

%% Uninstall
% UnInstalling;
