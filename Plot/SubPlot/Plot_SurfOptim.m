%%
n = 70;
R_Lq = linspace( Param.Opt.R_L( 1 ) , Param.Opt.R_L( end ) , n );
kq = linspace( log( Param.Opt.k( 1 ) ) , log( Param.Opt.k( end ) ) , n );

k_mat = Param.Opt.k .* ones( length( Param.Opt.R_L ) , length( Param.Opt.k ) );
kq_mat = kq .* ones( n , n );

R_L_mat = ( Param.Opt.R_L .* ones( length( Param.Opt.k ) , length( Param.Opt.R_L ) ) )';
R_Lq_mat = ( R_Lq .* ones( n , n ) )';

zq_mat = interp2( log( k_mat ) , R_L_mat , Param.Opt.z , kq_mat , R_Lq_mat );

%%
figure
subplot( 1 , 2 , 1 );
hold on; grid on;
surf( kq_mat , R_Lq_mat , zq_mat );
plot1hand = scatter3( log( Param.RF.k ) , Param.RF.R_L , Param.RF.z , 'r' , 'MarkerFaceColor' , 'r' );

% Setting
xlabel( '$ln(k)$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$R_L$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
zlabel( '$\zeta$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( plot1hand , '$\zeta(R_{L \; optim},k_{optim})$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

subplot( 1 , 2 , 2 );
hold on; grid on;
contour( kq_mat , R_Lq_mat , zq_mat , 300 );
scatter( log( Param.RF.k ) , Param.RF.R_L , 'r' , 'MarkerFaceColor' , 'r' );

% Setting
xlabel( '$ln(k)$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$R_L$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
c = colorbar;
c.Label.FontSize = 15;
c.Label.Interpreter = 'LaTex';
c.Label.String = '$\zeta$ $[-]$';

%% Plot of the surface of the force at the mazimum velocity of the piston.
figure
subplot( 1 , 2 , 1 );
hold on; grid on;
surface( R_Lvet , log( kvet ) , F_Max_b_max' );
plot1hand = scatter3( Param.RF.R_L , log( Param.RF.k ) , F_Max_b_max_optim , 'r' , 'MarkerFaceColor' , 'r' );

% Setting
xlabel( '$R_L$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$ln(k)$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
zlabel( '$F(\dot{b}_{max})$ $[N]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( plot1hand , '$F(\dot{b}_{max})_{optim}$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

subplot( 1 , 2 , 2 );
hold on; grid on;
contour( R_Lvet , log( kvet ) , F_Max_b_max' , 1000 );
scatter( Param.RF.R_L , log( Param.RF.k ) , 'r' , 'MarkerFaceColor' , 'r' );

% Setting
xlabel( '$R_L$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$ln(k)$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
c = colorbar;
c.Label.FontSize = 15;
c.Label.Interpreter = 'LaTex';
c.Label.String = '$F(\dot{b}_{max})$ $[N]$';

%% Plot of the surface of the Maximum force.
figure
subplot( 1 , 2 , 1 );
hold on; grid on;
surface(R_Lvet,log(kvet),F_Max');
plot1hand = scatter3( Param.RF.R_L , log( Param.RF.k ) , F_Max_optim , 'r' , 'MarkerFaceColor' , 'r' );

% Setting
xlabel( '$R_L$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$ln(k)$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
zlabel( '$F_{max}$ $[N]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( plot1hand , '$F(\dot{b}_{max})_{optim}$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

subplot( 1 , 2 , 2 );
hold on; grid on;
contour(R_Lvet,log(kvet),F_Max',300);
scatter( Param.RF.R_L , log( Param.RF.k ) , 'r' , 'MarkerFaceColor' , 'r' );

% Setting
xlabel( '$R_L$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$ln(k)$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
c = colorbar;
c.Label.FontSize = 15;
c.Label.Interpreter = 'LaTex';
c.Label.String = '$F_{max}$ $[N]$';