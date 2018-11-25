syms x x_d ...
     m_RV r_RV k_RV ...
     AL_RF AR_RF ...
     Cd_RF ...
     P_L P_R ...
     A_RF ...
     R_L Lp x_pr F_s ...
     x_Up x_d_Up ...
     x_Down x_d_Down ...
     Cd_RV

Param.RV.Syms.x = x;
Param.RV.Syms.x_d = x_d;
Param.RV.Syms.m_RV = m_RV;
Param.RV.Syms.r_RV = r_RV;
Param.RV.Syms.k_RV = k_RV;
Param.RV.Syms.Cd_RF = Cd_RF;
Param.RV.Syms.P_L = P_L;
Param.RV.Syms.P_R = P_R;
Param.RV.Syms.A_RF = A_RF;
Param.RV.Syms.R_L = R_L;
Param.RV.Syms.Lp = Lp;
Param.RV.Syms.x_pr = x_pr;
Param.RV.Syms.F_s = F_s;

%% Geometric features
%% Right Radius of the Relief Valve.
R_R = sqrt( 2 ) * R_L;

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.R_R = R_R;

%% Left Area of the Relief Valve.
A_L = pi * R_L^2;

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.A_L = A_L;

%% Right Area of the Relief Valve.
A_R = pi * R_R^2;

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.A_R = A_R;

%% Radius variation of the Relief Valve.
R = ( ( R_L - R_R ) / Lp) * x + R_R;

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.R = R;

%% Area variation of the Relief Valve.
A_rf = pi * R_R^2 - pi * R^2;

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.A_rf = A_rf;

%% Pre-Load of the Sping in the Relief Valve.
Fp  = ((Param.Actuator.Pc+(Param.Damper.F/(2*Param.Actuator.A_c)))*A_L...
     -(Param.Actuator.Pc-(Param.Damper.F/(2*Param.Actuator.A_c)))*A_R);

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.Fp = Fp;

%% Equations in the case where the fluid passes through the Relife Valve.
% Volume flow rate of the fluid through the relif valve.
Q_RF = A_RF * Cd_RF * sqrt( 2 * abs( P_L - P_R ) / rho );

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.Q = Q_RF;

%% Relief Valve Dynamics.
x_dd = ( - r_RV * x_d - k_RV * ( x + x_pr ) + P_L * A_L - P_R * A_R - F_s ) / m_RV;

% Allocation of the previous function and then make the change within the 
% "RVEval" function.
Param.RV.Syms.x_dd = x_dd;

%% Evaluate Previus Expression.
[ Param ] = RVEval( Param );

%% Relief Valve Up.
Script_ReliefValve_Up_Syms;

%% Relief Valve Down.
Script_ReliefValve_Down_Syms;