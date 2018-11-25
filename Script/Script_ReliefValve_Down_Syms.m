%% Radius Time Variation of the Down Relief Valve in Simbolic variables: [m].
R_Down_syms = ( ( R_L - R_R ) / Lp ) * x_Down + R_R;


%% Variation of the radius of the relief valve Down defined on different 
% domains in order to take into account the maximum area: [m].
R_c_Down = piecewise( 0 <= x_Down <= Lp , R_Down_syms , x_Down > Lp , R_L , 0 );

%% Variation of the relief valve area taking into account the previous 
% radius constraints: [m^2].
A_rv_Down = pi * R_R^2 - pi * R_c_Down.^2;

%% Equations in the case where the fluid passes through the Relife Valve.
% Volume flow rate of the fluid through the relif valve: [m^3/s].
Q1_rv_Down_sym = - A_rv_Down * Cd_RV * sqrt( 2 * abs( P1 - P2 ) / rho_sym ) * sign( P1 - P2 );

% Volume flow rate of the fluid through the relif valve show w.r.t the 
% other chamber: [m^3/s].
Q2_rv_Down_sym = - Q1_rv_Down_sym;

%% Relife Valve Dynamics.
% Contact force in case the valve impacts with its seat: [N].
F_s_Down1 = Param.RF.k_s * ( x_Down ) + Param.RF.r_s * ( x_d_Down );

% Contact force in case the valve reaches the maximum size of the valve 
% itself [N].
F_s_Down2 = Param.RF.k_s * ( x_Down - Param.RF.l );

% Acceleration of the valua keeping in mind the previous constraints: [m/s^2].
x_dd_Down_sym = ( - r_RV * x_d_Down - k_RV * ( x_Down + x_pr ) + P1 * A_L - P2 * A_R - F_s ) / m_RV ;
