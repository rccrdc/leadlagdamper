%% Static Equilibrium.
% Symbolic equilibrium equation
F_eq = K * sin( xi ) +  1 / 2 * rhoA * CD * MAC * ( ( L^2 / 2 ) * ...
      ( l0 * Omega * cos( xi ) )^2 + ...
      ( L^4 / 4 ) * ( Omega )^2 + l0 * Omega * cos( xi ) * ...
      ( 2 / 3 * L^3 ) * ( Omega ) );

% Replacement of constant parameters within the previous symbolic function.
Feq = eval( subs( F_eq , ...
    [       K ,          rhoA ,             CD ,             MAC ,             L ,             l0 ,             Omega ] , ...
    [ Param.K , Param.Air.rho , Param.Blade.CD , Param.Blade.MAC , Param.Blade.L , Param.Blade.l0 , Param.Blade.Omega ] ) );

% Conversion of the previous symbolic function into an anonymous function.
F_eq_handle = matlabFunction( Feq );

%% Zeros
xi_eq = fzero( F_eq_handle , 0 );