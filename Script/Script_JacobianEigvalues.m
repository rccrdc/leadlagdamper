%% Jacobian and eigen value.
% Replacing time-dependent symbolic variables with integration variables.
P1_d_sym = subs( P1_d_sym , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ] , ...
    [    xi ,              xi_d ,                         xi_dd ] );

P2_d_sym = subs( P2_d_sym , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ] , ...
    [    xi ,              xi_d ,                         xi_dd ] );

%% Calculation of the jacobian matrix.
J = jacobian( [ xi_d , xi_dd , P1_d_sym , P2_d_sym , x_d_Up , x_dd_Up_sym , x_d_Down , x_dd_Down_sym ] , ...
              [   xi ,  xi_d ,       P1 ,       P2 ,   x_Up ,      x_d_Up ,   x_Down        x_d_Down ] );

%% Replacement of constant parameters within the previous symbolic function.
Jsubs = subs( J , ...
    [                A_orf ,                Cd ,             Beta ,           rho_0 ,                 V0 ,                A_c ,              d ,             c ,             a0 ,              P_10 ,              P_20 ,           I ,       K ,             L ,              CD ,             MAC ,             L ,             l0 ,             Omega ,          rhoA ,       m_RV ,       k_RV ,       r_RV ,          x_pr ,       Cd_RV ,          R_L ,          Lp ] , ...
    [ Param.Actuator.A_orf , Param.Actuator.Cd , Param.Fluid.Beta , Param.Fluid.rho ,  Param.Actuator.V0 , Param.Actuator.A_c , Param.Blade.a0 , Param.Blade.c , Param.Blade.a0 , Param.Actuator.Pc , Param.Actuator.Pc , Param.I_tot , Param.K , Param.Blade.L ,  Param.Blade.CD , Param.Blade.MAC , Param.Blade.L , Param.Blade.l0 , Param.Blade.Omega , Param.Air.rho , Param.RF.m , Param.RF.k , Param.RF.r , Param.RF.x_pr , Param.RF.Cd , Param.RF.R_L , Param.RF.Lp ] );

%% Evaluation of the jacobian matrix at the equilibrium point.
% Pressure difference due to the non-derivability of the equilibrium point.
DP = 1; % [Pa]

% Replacement and evaluation of the jacobian matrix in the first point of 
% equilibrium.
J1 = eval( subs( Jsubs , ...
    [ xi , xi_d ,                     P1 ,                     P2 , x_Up , x_d_Up , x_Down , x_d_Down ] , ...
    [  0 ,    0 , Param.Actuator.Pc + DP , Param.Actuator.Pc - DP ,    0 ,      0 ,      0 ,        0 ] ) );

% Replacement and evaluation of the jacobian matrix in the second point of 
% equilibrium.
J2 = eval( subs( Jsubs , ...
    [ xi , xi_d ,                     P1 ,                     P2 , x_Up , x_d_Up , x_Down , x_d_Down ] , ...
    [  0 ,    0 , Param.Actuator.Pc - DP , Param.Actuator.Pc + DP ,    0 ,      0 ,      0 ,        0 ] ) );

%% Calculation of eigenvalues for the two jacobian matrices.
[ eigvecP1HP2L , eigvalP1HP2L ] = eig( J1 );
eigvalP1HP2L = diag( eigvalP1HP2L );

[ eigvecP1LP2H , eigvalP1LP2H ] = eig( J2 );
eigvalP1LP2H = diag( eigvalP1LP2H );
