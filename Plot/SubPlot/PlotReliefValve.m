%%
A_max_vet = Param.RF.A_max * ones( size( t_ode ) );

%% Displacement of the Relief Valve
figure;
hold on; grid on;
plot( t_ode , X( : , 5 ) , 'LineWidth' , 2 );
plot( t_ode , X( : , 7 ) , 'LineWidth' , 2 );

% Setting
xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$x_{RV}$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$x_{RV_{Up}}(t)$' , '$x_{RV_{Down}}(t)$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

%% Velocity of the Relief Valve
figure;
hold on; grid on;
plot( t_ode , X( : , 6 ) , 'LineWidth' , 2 );
plot( t_ode , X( : , 8 ) , 'LineWidth' , 2 );

% Setting
xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$v_{RV}$ $[m/s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$v_{RV_{Up}}(t)$' , '$v_{RV_{Down}}(t)$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

%% Area of the Relief Valve
figure;
hold on; grid on;
plot( t_ode , Param.RF.A( X( : , 5 ) ) , 'LineWidth' , 2 );
plot( t_ode , Param.RF.A( X( : , 7 ) ) , 'LineWidth' , 2 );
plot( t_ode , A_max_vet , '--' , 'LineWidth' , 2 );

% Setting
xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$A_{RV}$ $[m^2]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$A_{RV_{Up}}(t)$' , '$A_{RV_{Down}}(t)$' , '$A_{Max}$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
