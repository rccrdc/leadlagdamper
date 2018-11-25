%% Radius Time Variation of the Up Relief Valve in Simbolic variables: [m].
R_Up_syms = ( ( R_L - R_R ) / Lp ) * x_Up + R_R;


%% Variation of the radius of the relief valve Up defined on different 
% domains in order to take into account the maximum area: [m].
R_c_Up = piecewise( 0 <= x_Up <= Lp , R_Up_syms , x_Up > Lp , R_L , 0 );

%% Variation of the relief valve area taking into account the previous 
% radius constraints: [m^2].
A_rv_Up = pi * R_R^2 - pi * R_c_Up.^2;

%% Equations in the case where the fluid passes through the Relife Valve.
% Volume flow rate of the fluid through the relif valve: [m^3/s].
Q1_rv_Up_sym = - A_rv_Up * Cd_RV * sqrt( 2 * abs( P1 - P2 ) / rho_sym ) * sign( P1 - P2 );

% Volume flow rate of the fluid through the relif valve show w.r.t the 
% other chamber: [m^3/s].
Q2_rv_Up_sym = - Q1_rv_Up_sym;


%% Relife Valve Dynamics.
% Contact force in case the valve impacts with its seat: [N].
F_s_Up1 = Param.RF.k_s * ( x_Up ) + Param.RF.r_s * ( x_d_Up );

% Contact force in case the valve reaches the maximum size of the valve 
% itself [N].
F_s_Up2 = Param.RF.k_s * ( x_Up - Param.RF.l );

% Acceleration of the valve keeping in mind the previous constraints: [m/s^2].
% x_dd_Up_sym = ( - r_RV * x_d_Up - k_RV * ( x_Up + x_pr ) + P1 * A_L - P2 * A_R - F_s_Up1 .* ( x_Up < 0 )  + F_s_Up2 .* ( x_Up > Param.RF.l )  ) / m_RV ;
x_dd_Up_sym = ( - r_RV * x_d_Up - k_RV * ( x_Up + x_pr ) + P1 * A_L - P2 * A_R - F_s ) / m_RV ;

