%{
%-Abstract
%
%   RVOptim: This function performs a constrained, local numeric 
%            minimization process in order to obtain the value of the valve
%            radius and rigidity so as to minimize the force acting on the 
%            piston, by constraining the spring preload to be less than 20 
%            cm.
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
%      tspan:   Vector containing the temporal moments in which we want to 
%               integrate.
%      x0:      Initial conditions for the differential service system.
%      Param:   Structure containing data and anonymous functions that 
%               allow evaluation of derivatives in order to perform 
%               numerical integration.
%
%   The call:
%      
%      [ Param ] = RVOptim( tspan , X0 , Param );
%
%   Returns:
%
%     Param:   Structure containing data and anonymous functions that 
%              allow evaluation of derivatives in order to perform 
%              numerical integration and the upgrade data after the 
%              optimization process.
%
%-Version
%
%  -Version 1.0.0, 29-JAN-2017.
%
%-&
%}

function [ Param ] = RVOptim( tspan , X0 , Param )
idx = 0;
%% Options of the minimization problem.
Opts = optimoptions( 'fmincon' ,...                                        % Type of algorithm used for optimization.
                     'Display'             , 'off' , ...                   % Option to print optimization results.
                     'ConstraintTolerance' , 1e-12  , ...                  % Tolerance on the constraint violation.
                     'FunctionTolerance'   , 1e-12  , ...                  % Termination tolerance on the function value.
                     'OptimalityTolerance' , 1e-12  , ...                  % Termination tolerance on the first-order optimality.
                     'UseParallel'         , 1     );                      % Estimates gradients in parallel.

%% Problem
Problem.solver      = 'fmincon';                                           % Type of algorithm used for optimization.
Problem.objective   = @Function;                                           % Objective function.
% Problem.x0          = [ 3.7e-3 , 2 ];
% Problem.x0          = [ 3.52e-3 , log(1.5e2) ];
Problem.x0          = [ 3.5e-3 , log( 1.5e2 ) ];                           % Initial point.
Problem.A           = [  ];                                                % Matrix for linear inequality constraints.
Problem.b           = [  ];                                                % Vector for linear inequality constraints.
Problem.Aeq         = [  ];                                                % Matrix for linear equality constraints.
Problem.beq         = [  ];                                                % Vector for linear equality constraints.
Problem.lb          = [ 3.1e-3 ,         1 ];                              % Vector of lower bounds.
Problem.ub          = [ 3.9e-3 , log( 1e5 ) ];                             % Vector of upper bounds.
Problem.nonlcon     = @NonlinearConstraintAlgorithm;                       % Nonlinear constraint function.
Problem.options     = Opts;                                                % Options.

%% Minimizazione
% Find minimum of constrained nonlinear multivariable function.
[ x_f ] = fmincon( Problem );

Param.RF.R_L = x_f( 1 );                                                   % Left side poppet radius of the relief valve: [m].
Param.RF.R_R = sqrt( 2 ) * Param.RF.R_L;                                   % Right side poppet radius of the relief valve: [m].
Param.RF.Vp  = pi * Param.RF.Lp * ( Param.RF.R_L + Param.RF.R_R );
Param.RF.m   = Param.RF.Vp * Param.RF.rho_p;                               % Poppet mass of the relief valve: [kg].
Param.RF.k   = exp( x_f( 2 ) );                                            % Spring stiffness of the relief valve: [N/m].
Param.RF.cc  = 2 * sqrt( Param.RF.k * Param.RF.m );                        % Critical damping coefficient: [N-s/m].
Param.RF.z   = interp2( log( Param.Opt.k_mat ) , Param.Opt.R_L_mat , Param.Opt.z , log( Param.RF.k ) , Param.RF.R_L );  % Damping ratio: [-].
Param.RF.r   = Param.RF.z * Param.RF.cc;                                   % Sructural damping factor of the relief valve: [N-s/m].

% Evaluate Previus Expression.
[ Param ] = RVEval( Param );

%% Function
% Objective function for minimization.
    function [ Jfun ] = Function( x )
        idx = idx + 1;
        
        Param.RF.R_L = x( 1 );                                             % Left side poppet radius of the relief valve: [m].
        Param.RF.R_R = sqrt( 2 ) * Param.RF.R_L;                           % Right side poppet radius of the relief valve: [m].
        Param.RF.Vp  = pi * Param.RF.Lp * ( Param.RF.R_L + Param.RF.R_R ); 
        Param.RF.m   = Param.RF.Vp * Param.RF.rho_p;                       % Poppet mass of the relief valve: [kg].
        Param.RF.k   = exp( x( 2 ) );                                      % Spring stiffness of the relief valve: [N/m].
        Param.RF.cc  = 2 * sqrt( Param.RF.k * Param.RF.m );                % Critical damping coefficient: [N-s/m].
        Param.RF.z   = interp2( log( Param.Opt.k_mat ) , Param.Opt.R_L_mat , Param.Opt.z , log( Param.RF.k ) , Param.RF.R_L );  % Damping ratio: [-].
        Param.RF.r   = Param.RF.z * Param.RF.cc;                           % Sructural damping factor of the relief valve: [N-s/m].
        
        % Evaluate Previus Expression.
        [ Param ] = RVEval( Param );
        
        % Integration of the complete system with active relief valve.
        [ ~ , X ] = ODE_RV( tspan , X0 , Param );
        
        % Absolute value of the force on the piston at each moment of time 
        % [N].
        F = abs( Param.Dynam.F( X( : , 3 ) , X( : , 4 ) ) );
        
        % Absolute value of the speed on the piston at each moment of time 
        % [m/s].
        a_d = abs( Param.Kine.a_d( X( : , 1 ) , X( : , 2 ) ) );
        
        % Maximum speed value on the piston [m/s].
        [ ~ , idx_a_d ] = max( a_d );
        
        % Value of the force on the piston at the maximum speed value [N].
        Jfun = abs( F( idx_a_d ) );
        
        disp( [ num2str( idx , '%10.0f' ) ' iter.: max abs F: ' num2str( Jfun , '%10.4f' ) ' Newton' ] );
        
    end

% Function associated with non-linear constraints for the problem. of 
% minimization.
    function [ c , ceq ] = NonlinearConstraintAlgorithm( x )
        
        Param.RF.R_L = x( 1 );                                             % Left side poppet radius of the relief valve: [m].
        Param.RF.R_R = sqrt( 2 ) * Param.RF.R_L;                           % Right side poppet radius of the relief valve: [m].
        Param.RF.Vp  = pi * Param.RF.Lp * ( Param.RF.R_L + Param.RF.R_R ); 
        Param.RF.m   = Param.RF.Vp * Param.RF.rho_p;                       % Poppet mass of the relief valve: [kg].
        Param.RF.k   = exp( x( 2 ) );                                      % Spring stiffness of the relief valve: [N/m].
        Param.RF.cc  = 2 * sqrt( Param.RF.k * Param.RF.m );                % Critical damping coefficient: [N-s/m].
        Param.RF.z   = interp2( log( Param.Opt.k_mat ) , Param.Opt.R_L_mat , Param.Opt.z , log( Param.RF.k ) , Param.RF.R_L );  % Damping ratio: [-].
        Param.RF.r   = Param.RF.z * Param.RF.cc;                           % Sructural damping factor of the relief valve: [N-s/m].
        
        % Evaluate Previus Expression.
        [ Param ] = RVEval( Param );
        
        c = [ abs( Param.RF.x_pr ) - 0.2 ];                                % Vector for linear inequality constraints.
        ceq = [  ];                                                        % Vector for linear equality constraints.
        
    end

end