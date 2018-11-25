%% Volume flow rate of the fluid through the orifice in chamber 1.
% (taking into account the constraints of the fluid density domain).
Q1_orf_sym = - A_orf * Cd * sqrt( 2 * abs( P1 - P2 ) / rho_sym ) * sign( P1 - P2 );

% (without taking into account the constraints of the fluid density domain 
% but using an auxiliary variable).
Q1_orf = - A_orf * Cd * sqrt( 2 * abs( P1 - P2 ) / rho ) * sign( P1 - P2 );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.Q1_orf = eval( subs( Q1_orf , ...
    [                A_orf ,                Cd ] , ...
    [ Param.Actuator.A_orf , Param.Actuator.Cd ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.Q1_orf = matlabFunction( Param.Syms.funeva.Q1_orf );

%% Volume flow rate of the fluid through the orifice in chamber 2.
% (taking into account the constraints of the fluid density domain).
Q2_orf_sym = - Q1_orf_sym;

% (without taking into account the constraints of the fluid density domain 
% but using an auxiliary variable).
Q2_orf = - Q1_orf;

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.Q2_orf = eval( subs( Q2_orf , ...
    [                A_orf ,                Cd ] , ...
    [ Param.Actuator.A_orf , Param.Actuator.Cd ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.Q2_orf = matlabFunction( Param.Syms.funeva.Q2_orf );

%% Time derivatives of the pressure in the chamber 1.
% Taking into account the constraints on fluid density.
P1_d_sym = ( Beta / ( ( V0 + A_c * b ) * rho_0 ) ) * ( rho_sym * ( ( Q1_rv_Up_sym + Q1_rv_Down_sym ) + Q1_orf_sym ) - rho_1 * A_c * d_a );

% Without taking into account the constraints on the density of the fluid, 
% but taking advantage of the auxiliary variables for density and flow 
% through the relief valve.
P1_d = ( Beta / ( ( V0 + A_c * b ) * rho_0 ) ) * ( rho * ( Q1_in - Q1_out + Q1_orf ) - rho_1 * A_c * d_a );

% Replacing time-dependent symbolic variables with integration variables.
P1_d = subs( P1_d , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ] , ...
    [    xi ,              xi_d ,                        xi_dd ] );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.P1_d = eval( subs( P1_d , ...
    [                A_orf ,                Cd ,             Beta ,           rho_0 ,                 V0 ,                A_c ,              d ,             c ,             a0 ,              P_10 ,              P_20 ] , ...
    [ Param.Actuator.A_orf , Param.Actuator.Cd , Param.Fluid.Beta , Param.Fluid.rho ,  Param.Actuator.V0 , Param.Actuator.A_c , Param.Blade.a0 , Param.Blade.c , Param.Blade.a0 , Param.Actuator.Pc , Param.Actuator.Pc ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.P1_d = matlabFunction( Param.Syms.funeva.P1_d );

%% Time derivatives of the pressure in the chamber 2.
% Taking into account the constraints on fluid density.
P2_d_sym = ( Beta / ( ( V0 - A_c * b ) * rho_0 ) ) * ( rho_sym * ( ( Q2_rv_Up_sym + Q2_rv_Down_sym ) + Q2_orf_sym ) + rho_2 * A_c * d_a );

% Without taking into account the constraints on the density of the fluid, 
% but taking advantage of the auxiliary variables for density and flow 
% through the relief valve.
P2_d = ( Beta / ( ( V0 - A_c * b ) * rho_0 ) ) * ( rho * ( Q2_in - Q2_out + Q2_orf ) + rho_2 * A_c * d_a );

% Replacing time-dependent symbolic variables with integration variables.
P2_d = subs( P2_d , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ] , ...
    [    xi ,              xi_d ,                         xi_dd ] );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.P2_d = eval( subs( P2_d , ...
    [                A_orf ,                Cd ,             Beta ,           rho_0 ,                 V0 ,                A_c ,              d ,             c ,             a0 ,              P_10 ,              P_20 ] , ...
    [ Param.Actuator.A_orf , Param.Actuator.Cd , Param.Fluid.Beta , Param.Fluid.rho ,  Param.Actuator.V0 , Param.Actuator.A_c , Param.Blade.a0 , Param.Blade.c , Param.Blade.a0 , Param.Actuator.Pc , Param.Actuator.Pc ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.P2_d = matlabFunction( Param.Syms.funeva.P2_d );
