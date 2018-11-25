%% Trend of the Pressure in both chambers in time.
figure;
% subplot( 1 , 2 , 1 );
hold on; grid on;
plot( t_NoRV , X_NoRV( : , 3 ) , '--' , 'LineWidth' , 2 );
plot( t_NoRV , X_NoRV( : , 4 ) , '--' , 'LineWidth' , 2 );
plot( t_ode , X( : , 3 ) , 'LineWidth' , 2 );
plot( t_ode , X( : , 4 ) , 'LineWidth' , 2 );

% Setting
xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$P$ $[Pa]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$P_{1 \; No \; R.V.}(t)$' , '$P_{2 \; No \; R.V.}(t)$' , '$P_{1}(t)$' , '$P_{2}(t)$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

%% %% Trend of the Pressure time derivative in both chambers in time.
% figure
% % subplot( 1 , 2 , 2 );
% hold on; grid on;
% plot( t_ode , X_d( : , 3 ) , 'LineWidth' , 2 );
% plot( t_ode , X_d( : , 4 ) , 'LineWidth' , 2 );
% 
% % Setting
% xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
% ylabel( '$\dot{P}$ $[Pa/s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
% Leg = legend( '$\dot{P}_{1}(t)$' , '$\dot{P}_{2}(t)$' );
% set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
% title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
