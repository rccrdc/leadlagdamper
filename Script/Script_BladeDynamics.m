%% Compute the force acting on the plunger [N].
F = A_c * ( P2 - P1 )  ;

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.F = eval( subs( F , ...
    [                A_c ] , ...
    [ Param.Actuator.A_c ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.F = matlabFunction( Param.Syms.funeva.F );

%% Compute the aerodynamic torque acting on the blade [N*m].
C = 1 / 2 * rhoA * CD * MAC * ( ( L^2 / 2 ) * ( l0 * Omega * cos( xi ) )^2 + ...
    ( L^4 / 4 ) * ( Omega + xi_d )^2 + l0 * Omega * cos( xi ) * ...
    ( 2 / 3 * L^3 ) * ( Omega *xi_d ) );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.C = eval( subs( C , ...
    [             CD ,             MAC ,             L ,             l0 ,             Omega ,          rhoA ] , ...
    [ Param.Blade.CD , Param.Blade.MAC , Param.Blade.L , Param.Blade.l0 , Param.Blade.Omega , Param.Air.rho ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.C = matlabFunction( Param.Syms.funeva.C );

%% Compute the acceleration of the lead-lag angle 
xi_dd = ( - F * d_a_dxi - C - K * sin( xi ) + F_imp * L ) / I;

% Replacing time-dependent symbolic variables with integration variables.
xi_ddxi = subs( xi_dd , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ] , ...
    [    xi ,              xi_d ,                        xi_dd ] );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.xi_dd = eval( subs( xi_dd , ...
	[             d ,             c ,                A_c ,            I ,       K ,             L ,             CD ,             MAC ,             L ,             l0 ,             Omega ,          rhoA  ] , ...
	[ Param.Blade.d , Param.Blade.c , Param.Actuator.A_c ,  Param.I_tot , Param.K , Param.Blade.L ,  Param.Blade.CD , Param.Blade.MAC , Param.Blade.L , Param.Blade.l0 , Param.Blade.Omega , Param.Air.rho ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.xi_dd = matlabFunction( Param.Syms.funeva.xi_dd );

%% Compute the acceleration of the lead-lag angle in the system without damper
xi_dd_NoDam = ( - C - K * sin( xi ) + F_imp * L ) / I;

% Replacing time-dependent symbolic variables with integration variables.
xi_ddxi_NoDam = subs( xi_dd_NoDam , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ] , ...
    [    xi ,              xi_d ,                        xi_dd ] );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.xi_dd_NoDam = eval( subs( xi_dd_NoDam , ...
	[             d ,             c ,                A_c ,            I ,       K ,             L ,             CD ,             MAC ,             L ,             l0 ,             Omega ,          rhoA  ] , ...
	[ Param.Blade.d , Param.Blade.c , Param.Actuator.A_c ,  Param.I_tot , Param.K , Param.Blade.L ,  Param.Blade.CD , Param.Blade.MAC , Param.Blade.L , Param.Blade.l0 , Param.Blade.Omega , Param.Air.rho ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.xi_dd_NoDam = matlabFunction( Param.Syms.funeva.xi_dd_NoDam );
