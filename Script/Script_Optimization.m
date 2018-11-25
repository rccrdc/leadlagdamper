%% Optimization of the Relief Valve chrateristichs.
% tic
% % Numerical integration of the dynamics of the system with the initial 
% % data.
% [ t_ode_NoOptm , X_NoOptm ] = ODE_RV( tspan , X0 , Param );
% toc
% F_NoOptm = Param.Dynam.F( X_NoOptm( : , 3 ) , X_NoOptm( : , 4 ) );         % Force on the piston of the lead-lag damper of the data not optimized: [N].
% a_d_NoOptm = Param.Kine.a_d( X_NoOptm( : , 1 ) , X_NoOptm( : , 2 ) );      % Piston speed of the lead-lag damper of the data not optimized: [m/s].
% 
% R_Lvet = linspace( 2.5e-3 , 5e-3 , 50 );                                   % Vector of the possible radius of the valve: [m].
% nR_Lvet = length( R_Lvet );                                                % Length of the previous vector.
% 
% kvet = exp( linspace( 0 , log( 1e5 ) , 50 ) );                             % Vector of the possible stiffnes of the valve: [m].
% nkvet = length( kvet );                                                    % Length of the previous vector.
% 
% % Initiation of the variables containing the time and status vectors for 
% % each case under consideration from the cycle.
% X_3D = cell( nR_Lvet , nkvet );
% t_ode_3D = X_3D;
%
% for iR_L = 1 : nR_Lvet
%     for ik = 1 : nkvet
% %         Allocation of the new variables R_L, k for each case in a vector
%         x = [ R_Lvet( iR_L ) , kvet( ik ) ];
% 
%         Param.RF.R_L = x( 1 );                                           % New variable R_L: [m].
%         Param.RF.R_R = sqrt( 2 ) * Param.RF.R_L;                         % New variable R_R: [m]. 
%         Param.RF.Vp  = pi * Param.RF.Lp * ( Param.RF.R_L + Param.RF.R_R );    % New variable V_p: [m^3].
%         Param.RF.m   = Param.RF.Vp * Param.RF.rho_p;                     % New variable m: [kg].
%         Param.RF.k   = x( 2 );                                           % New variable k: [N/m].
%         Param.RF.cc  = 2 * sqrt( Param.RF.k * Param.RF.m );              % New variable cc: [(N/m-kg)^(1/2)].
%         zq_mat = interp2( log( k_mat ) , R_L_mat , z , log( Param.RF.k ) , Param.RF.R_L );    % New variable damping ration: [-].
%         Param.RF.z   = zq_mat;                                           % New variable damping ration: [-].
%         Param.RF.r   = Param.RF.z * Param.RF.cc;                         % New variable r: [-].
% 
% %         Evaluate Previus Expression.
%         [ Param ] = RVEval( Param );
%
% %         Integration of the complete system with active relief valve.
%         [ t_ode_opt , X_opt ] = ODE_RV( tspan , X0 , Param );
% 
% %         Allocation of the variables containing the time and status vectors 
% %         for each case under consideration from the cycle.
%         X_3D{ iR_L , ik } = X_opt;
%         t_ode_3D{ iR_L , ik } = t_ode_opt;
%     end
% 
% end
% 
% % Loading of data for interpolation of the damping ratio, function of the 
% % valve radius and of the stiffness.
% % load('matlab_tX_ode_3D.mat');
% 
% % Preallocation of the force matrices obtained for the previous cases of 
% % radius and stiffness.
% F_Max_b_max = zeros( nR_Lvet , nkvet );
% F_Max = F_Max_b_max;
% 
% for iR_L = 1 : nR_Lvet
%     for ik = 1 : nkvet
%         
%         % Matrix of state vectors, at each integration time for the valve 
%         % radius and stiffness value.
%         X = X_3D{ iR_L , ik };
%         
%         % Absolute value of the force on the piston at each moment of time 
%         % [N].
%         F = abs( Param.Dynam.F( X( : , 3 ) , X( : , 4 ) ) );
%         
%         % Absolute value of the speed on the piston at each moment of time 
%         % [m/s].
%         a_d = abs( Param.Kine.a_d( X( : , 1 ) , X( : , 2 ) ) );
%         
%         % Maximum speed value on the piston [m/s].
%         [ ~ , idx_a_d ] = max( a_d );
%         
%         % Value of the force on the piston at the maximum speed value [N].
%         F_Max_b_max( iR_L , ik ) = F( idx_a_d );
%         
%         % Maximum force value on the piston [N].
%         F_Max( iR_L , ik ) = max( F );
%     end
% end
% 
% % Local constrained minimization process to obtain R_L, k with minimal 
% % force.
% tic
% [ Param ] = RVOptim( tspan , X0 , Param );
% fminRunTime = toc;
% disp( [ 'The run time of the optimization process is: ' num2str( fminRunTime , '%10.3f' ) ' second' ] );
