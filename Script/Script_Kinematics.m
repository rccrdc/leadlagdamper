%% Kinematic
% Compute the angle between plunger and x-axis.
delta    = atan( ( d * sin( alpha ) + ( 1 - cos( alpha ) ) * c ) / ( d * cos( alpha ) + c * sin( alpha ) ) );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.delta = eval( subs( delta , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ,             d ,             c ] , ...
    [    xi ,              xi_d ,                         xi_dd , Param.Blade.d , Param.Blade.c ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Kine.delta = matlabFunction( Param.Syms.funeva.delta );

%% Compute the extension of the plunger of the lead-lag damper.
a    = ( d * cos( alpha ) + c * sin( alpha ) ) / cos( delta );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.a = eval ( subs( a , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ,             d ,             c ] , ...
    [    xi ,              xi_d ,                         xi_dd , Param.Blade.d , Param.Blade.c ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Kine.a = matlabFunction( Param.Syms.funeva.a );

%% Compute the displacement of the plunger w.r.t. the equilibrium position,
% at the cente of the damper.
b = a - a0;

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.b = eval( subs( b , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t )  ,             d ,             c ,             a0 ] , ...
    [    xi ,              xi_d ,                          xi_dd , Param.Blade.d , Param.Blade.c , Param.Blade.a0 ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Kine.b = matlabFunction( Param.Syms.funeva.b );

%% Compute the velocity of the plunger of the lead-lag damper.
d_a   = diff( a , t );
d_as  = simplify( d_a );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.a_d = eval( subs( d_a , ...
    [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ,             d ,             c ] , ...
    [    xi ,              xi_d ,                         xi_dd , Param.Blade.d , Param.Blade.c ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Kine.a_d = matlabFunction( Param.Syms.funeva.a_d );

%% Compute & Simplified the acceleration of the piston of the lead-lag damper.
% dd_a   = diff( d_a , t );
% dd_as  = simplify( dd_a );
% 
% Replacement of constant parameters within the previous symbolic function.
% Param.Syms.funeva._a_dd = eval( subs( dd_a , ...
%     [ alpha , diff( alpha , t ) , diff( diff( alpha , t ) , t ) ,              d ,             c ] , ...
%     [    xi ,              xi_d ,                         xi_dd , Param.Blade.a0 , Param.Blade.c ] ) );

%% Conversion of the previous symbolic function into an anonymous function.
% Param.Kine.a_dd = matlabFunction( Param.Syms.funeva.a_dd );

%% Compute the derivative of the displacement of the piston of the lead-lag damper with respect to lead-lag angle.
d_a_dxi   = diff( subs( a , alpha , xi ) , xi );
d_a_dxi_s = simplify( d_a_dxi );

% Replacement of constant parameters within the previous symbolic function.
Param.Syms.funeva.dadxi = eval( subs( d_a_dxi , ...
    [              d ,             c ] , ...
    [ Param.Blade.a0 , Param.Blade.c ] ) );

% Conversion of the previous symbolic function into an anonymous function.
Param.Kine.dadxi = matlabFunction( Param.Syms.funeva.dadxi );
