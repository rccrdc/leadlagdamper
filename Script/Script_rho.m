%% Density in the chamber 1.
rho_1 = rho_0 * ( 1 + 1 / Beta * ( P1 - P_10 ) );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.rho_1 = eval( subs( rho_1 , ...
    [           rho_0 ,              P_10 ,             Beta ] , ...
    [ Param.Fluid.rho , Param.Actuator.Pc , Param.Fluid.Beta ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.rho_1 = matlabFunction( Param.Syms.funeva.rho_1 );

%% Density in the chamber 2.
rho_2 = rho_0 * ( 1 + 1 / Beta * ( P2 - P_20 ) );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.rho_2 = eval( subs( rho_2 , ...
    [           rho_0 ,              P_20 ,             Beta ] , ...
    [ Param.Fluid.rho , Param.Actuator.Pc , Param.Fluid.Beta ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Dynam.rho_2 = matlabFunction( Param.Syms.funeva.rho_2 );

%% Density of the Fluid Flow Through the Orifice
rho_sym = piecewise( P1 >= P2 , rho_1 , P2 > P1 , rho_2 );
% Param.Syms.fun.rho = rho_sym;
