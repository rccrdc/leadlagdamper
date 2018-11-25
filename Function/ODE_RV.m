%{
%-Abstract
%
%   ODE_RV: This function performs the numerical iteration of the system of
%           differential equations that regulate the motion of the blade, 
%           the plunger of the lead-lag damper governed by the passage of 
%           fluid and the relief valve, and also obtains the time step 
%           values necessary for the stability analysis .
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
%      [ t , X , T , h ] = ODE_RV( tspan , x0 , Param );
%
%   Returns:
%
%     t:    Temporal moments of integration.
%     X:	Vector containing the state variables at each time point 
%           defined in the previous vector.
%     T:    Vector containing the numerical integration intervals.
%     h:    Vector containing the time -step referred to the previous 
%           vector.
%
%-Version
%
%  -Version 1.0.0, 20-JAN-2017.
%
%-&
%}

function [ t , X , T , h ] = ODE_RV( tspan , x0 , Param )
%% Date
T   = [  ]; % Preallocation of the vector containing the numerical integration intervals.
h   = [  ]; % Preallocation of the ector containing the time-step referred to the previous vector.

%% Integrator
% Set of the propeties for the ODE function.
OdeOpt = odeset( 'AbsTol'     , 1e-10 , ...         % Setting the absolute tolerance.
                 'RelTol'     , 1e-10 , ...         % Setting the Relative tolerance.
                 'OutputFcn'  , @myOutputFcn );     % Setting the use of a call back function.

% Integration the O.D.E. system.
[ t , X ] = ode15s( @odeFun , tspan , x0 , OdeOpt );

%% Support Function.
% O.D.E. function for numerical integration.
    function [ x_d ] = odeFun( t , x )
        
        % Extraxt the variables from the vector x.
        xi         = x( 1 );    % Lead-lag angle [rad].
        xi_d       = x( 2 );	% Lead-lag angular velocity [ras/s].
        P1         = x( 3 );	% Pressure in left chamber of the lead-lag damper [Pa].
        P2         = x( 4 );    % Pressure in right chamber of the lead-lag damper [Pa].
        x_RF_Up    = x( 5 );    % Poppet displacement of the left to right flow in the relief valve: [m].
        xd_RF_Up   = x( 6 );    % Poppet velocity of the left to right flow in the relief valve: [m/s].
        x_RF_Down  = x( 7 );    % Poppet displacement of the right to left flow in the relief valve: [m].
        xd_RF_Down = x( 8 );    % Poppet velocity of the right to left flow in the relief valve: [m/s].
        
        % Setting of the selected perturbation case.
        switch Param.FlagF
            case { 'Disp' }
                F = 0;
                
            case { 'Imp' }
                F = 0;
                if t <= Param.t_imp
                    F = Param.F_max;
                end
                
            case { 'Sin' }
                F = Param.F_max * sin ( 2 * pi * Param.freq * t );
                
            case { 'Simp' }
                F = 0;
                if t >= Param.t_imp && t <= Param.t_imp + Param.t_dur
                   F = Param.F_max * sin ( 2 * pi * Param.freq * t );
                end
                
            otherwise
                error( 'error: "FlagF" not valid.' );
        end
        
%% Impact force dynamics - Damper
        
%% Impact force dynamics - Relief Valve
        
        % Setting and computation of the contact force for relief valve (u).
        if x_RF_Up < 0 % Condition of contact between the relief valve and the seat.
           F_s_Up = Param.RF.k_s * ( x_RF_Up ) + Param.RF.r_s * ( xd_RF_Up );
           
        elseif x_RF_Up > Param.RF.l % maximum stroke of the poppet
           F_s_Up = Param.RF.k_s * ( x_RF_Up - Param.RF.l );
           
        else 
            F_s_Up = 0;
        end
        
        % Setting and computation of the contact force for relief valve (d).
        if x_RF_Down < 0 % Condition of contact between the relief valve and the seat.
           F_s_Down  = Param.RF.k_s * ( x_RF_Down ) + Param.RF.r_s * ( xd_RF_Down );
           
        elseif x_RF_Down > Param.RF.l % maximum stroke of the poppet
           F_s_Down  = Param.RF.k_s * ( x_RF_Down - Param.RF.l );
           
        else 
            F_s_Down = 0;
        end 
        
%% Area dynamics - Relief Valves
        
        % Setting and computation of the opening area of the first relief valve (u) during
        % its motion.
        if x_RF_Up>= 0 % Opening condition.
            A_RF_Up = Param.RF.A( x_RF_Up );
            
            if x_RF_Up > Param.RF.Lp % Maximum opening condition
                A_RF_Up = Param.RF.A_max;
            end
        else
            A_RF_Up=0;
        end
        
        % Setting and computation of the opening area of relief valve (d) 
        % during its motion.
        if x_RF_Down >= 0 % Opening condition.
            A_RF_Down = Param.RF.A( x_RF_Down );
            
            if x_RF_Down > Param.RF.Lp % Maximum opening condition
                A_RF_Down = Param.RF.A_max;
            end
        else
             A_RF_Down=0;
        end    
       
%% Pressure dynamics
        
        % Setting and computation of the density of the fluid and
        % of the volumetric flow rates through
        % the relief valves.
        if P1 > P2
            % Density, [kg/m^3].
            rho = Param.Dynam.rho_1( P1 );
            
            % Volumetric flow rate entering chamber 1, [m^3/s].
            Q1_in     = 0;
            
            % Volumetric flow outgoing from chamber 1, [m^3/s].
            Q1_out    = Param.RF.Q( A_RF_Up , P1 , P2 , rho ) + Param.RF.Q( A_RF_Down , P2 , P1 , rho );
            
            % Volumetric flow rate entering chamber 2, [m^3/s].
            Q2_in     = Param.RF.Q( A_RF_Up , P1 , P2 , rho ) + Param.RF.Q( A_RF_Down , P2 , P1 , rho );
            
            % Volumetric flow outgoing from chamber 1, [m^3/s].
            Q2_out    = 0;
        else
            % Density, [kg/m^3].
            rho       = Param.Dynam.rho_2( P2 );
            
            % Volumetric flow rate entering chamber 1, [m^3/s].
            Q1_in     = Param.RF.Q( A_RF_Up , P1 , P2 , rho ) + Param.RF.Q( A_RF_Down , P2 , P1 , rho );                
            
            % Volumetric flow outgoing from chamber 1, [m^3/s].
            Q1_out    = 0;
            
            % Volumetric flow rate entering chamber 2, [m^3/s].
            Q2_in     = 0;
            
            % Volumetric flow outgoing from chamber 1, [m^3/s].
            Q2_out    = Param.RF.Q( A_RF_Up , P1 , P2 , rho ) + Param.RF.Q( A_RF_Down , P2 , P1 , rho );
        end
        
        % Allocation of the derived state vector.
        x_d( 1 , 1 ) = xi_d;                                                            % Angular speed of the blade: [rad/s].
        x_d( 2 , 1 ) = Param.Dynam.xi_dd( F , P1 , P2  , xi , xi_d );                   % Angular acceleration of the blade: [rad/s^2].
        x_d( 3 , 1 ) = Param.Dynam.P1_d( P1 , P2 , Q1_in , Q1_out , rho , xi , xi_d );  % Time derivation of the pressure in the chamber 1: [Pa/s].
        x_d( 4 , 1 ) = Param.Dynam.P2_d( P1 , P2 , Q2_in , Q2_out , rho , xi , xi_d );  % Time derivation of the pressure in the chamber 2: [Pa/s].
        x_d( 5 , 1 ) = xd_RF_Up;                                                        % Poppet velocity of relief valve u: [m/s].
        x_d( 6 , 1 ) = Param.RF.x_dd( F_s_Up , P1 , P2 , x_RF_Up , xd_RF_Up );          % Poppet acceleration of relief valveu: [m/s^2].
        x_d( 7 , 1 ) = xd_RF_Down;                                                      % Poppet velocity of relief valve d: [m/s].
        x_d( 8 , 1 ) = Param.RF.x_dd( F_s_Down , P2 , P1 , x_RF_Down , xd_RF_Down );    % Poppet acceleration of relief valve d: [m/s^2].
        
    end

% Function extracts the time step and numerical integration intervals.
    function Status = myOutputFcn ( t , x , flag )
        
        
        if isempty( flag )
            
            h = [ h ; t' - T( end ) ];  % Calculation of the time step.
            T = [ T ; t' ];             % Calculation of the numerical integration intervals.
            
        else
            
            switch ( flag )
                
                case 'init'
                    
                    T = [ T ; t( 1 ) ]; % Calculation of the numerical integration intervals.
                    
                case 'done'
                    
                    
                    
                otherwise

                    
                    
            end
            
        end
        
        Status = 0;
        
    end

end