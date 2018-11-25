%{
%-Abstract
%
%   RVEval: This function performs the numerical evaluation (replacement of
%           the constants in the symbolic functions) for the mathematical 
%           relations referred to the relief valve.
%
%-Disclaimer
% 
%   THIS SOFTWARE AND ANY RELATED MATERIALS WERE CREATED BY CANOLA RICCARDO
%   NICOLI MATTEO e PRATO MATTEO.
%
%-I/O
%
%   Given:
%      
%      Param:   This variable is a structure containing the symbolic 
%               functions of the relief valve and the numerical constants 
%               associated with it.
%
%   The call:
%      
%      [ Param ] = RVEval( Param );
%
%   Returns:
%
%     Param: This variable is a structure containing the simbolic functions
%            of the relief valve and the numerical constants associated 
%            with it, as well as the anonymous functions that will allow 
%            evaluation.
%
%-Version
%
%  -Version 1.0.0, 20-JAN-2017.
%
%-&
%}

function [ Param ] = RVEval( Param )
% Declaration of the symbolic variables that have been previously allocated
% so that it is possible to replace them.
syms rho

x     = Param.RV.Syms.x;
x_d   = Param.RV.Syms.x_d;
m_RV  = Param.RV.Syms.m_RV;
r_RV  = Param.RV.Syms.r_RV;
k_RV  = Param.RV.Syms.k_RV;
Cd_RF = Param.RV.Syms.Cd_RF;
P_L   = Param.RV.Syms.P_L;
P_R   = Param.RV.Syms.P_R;
A_RF  = Param.RV.Syms.A_RF;
R_L   = Param.RV.Syms.R_L;
Lp    = Param.RV.Syms.Lp;
x_pr  = Param.RV.Syms.x_pr;
F_s   = Param.RV.Syms.F_s;

%% Evaluate Left Area of the Relief Valve.
Param.RF.A_L = eval( subs( Param.RV.Syms.A_L , ...
    [          R_L ] , ...
    [ Param.RF.R_L ] ) );

%% Evaluate Right Area of the Relief Valve.
Param.RF.A_R = eval( subs( Param.RV.Syms.A_R , ...
    [          R_L ] , ...
    [ Param.RF.R_L ] ) );

%% Evaluate the Time Variation Area of the Relief Valve.
% Replacement of constant parameters within the previous symbolic function 
% of the relief valve area.
A_rffcnEva = eval( subs( Param.RV.Syms.A_rf , ...
    [          R_L ,          Lp ] , ...
    [ Param.RF.R_L , Param.RF.Lp ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.RF.A = matlabFunction( A_rffcnEva );

%% Evaluate the Maximum Area of the Relief Valve.
Param.RF.A_max = Param.RF.A_L;

%% Evaluate the Pre-Load of the Sping in the Relief Valve.
% Evaluate and allocate the espressione of the pre-load of the spring in the
% relief valve in anonymus function.
Param.RF.Fp = eval( subs( Param.RV.Syms.Fp , ...
    [          R_L ] , ...
    [ Param.RF.R_L ] ) );

%% Evaluate the Pre-Load Displacement of the Spring in the Relief Valve.
Param.RF.x_pr = Param.RF.Fp / Param.RF.k ;

%% Evaluate the Volume Flow Rate Through the Relief Valve.
% Replacement of constant parameters within the previous symbolic function 
% of the volume flow rate through the relief valve.
Q_RFfcnEva = eval( subs( Param.RV.Syms.Q , ...
    [             Cd_RF ] , ...
    [ Param.Actuator.Cd ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.RF.Q = matlabFunction( Q_RFfcnEva );

%% Evaluate the Acceleration of the Relief Valve.
% Replacement of constant parameters within the previous symbolic function 
% of the acceleration of the relief valve.
xddfcnEva = eval( subs( Param.RV.Syms.x_dd , ...
    [       m_RV ,       r_RV ,       k_RV ,          R_L ,          x_pr ] , ...
    [ Param.RF.m , Param.RF.r , Param.RF.k , Param.RF.R_L , Param.RF.x_pr ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.RF.x_dd = matlabFunction( xddfcnEva );

end