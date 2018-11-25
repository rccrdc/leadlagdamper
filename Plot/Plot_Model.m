%% Inizialization
close all;
LabelFontSize = 18;
LegFontSize = 14;

%% Plot Angles.
PlotAngle;

%% Plot Pressure
PlotPressure;

%% Displacement of piston of the lead-lag damper.
figure;
hold on; grid on;
plot( t_ode , b , 'LineWidth' , 2 );

% Setting
xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$b$ $[m]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$b(t)$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

if exist('t_ode_NoOptm','var') == 0
    %% Plot Plunger Force of the lead-lag damper.
    figure;
    hold on; grid on;
    plot( t_NoRV , F_NoRV , 'r' , 'LineWidth' , 2 );
    plot( t_ode , F , 'LineWidth' , 2 );

    % Setting
    xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    ylabel( '$F$ $[N]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    Leg = legend( '$F_{No \; R.V.}(t)$' , '$F(t)$' );
    set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
    title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

    %% Force vs. velocity of the piston.
    figure;
    hold on; grid on;
    plot( abs( a_d ) , abs( F ) , 'LineWidth' , 2 );

    % Setting
    xlabel( '$\dot{b}$ $[m/s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    ylabel( '$F$ $[N]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    Leg = legend( '$F(\dot{b})$' , 'Location' , 'SouthEast' );
    set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
    title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

else
    %% Plot Plunger Force of the lead-lag damper.
    figure;
    hold on; grid on;
    plot( t_ode , F , 'LineWidth' , 2 );
    plot( t_NoRV , F_NoRV , '--' , 'LineWidth' , 2 );
    plot( t_ode_NoOptm , F_NoOptm , 'LineWidth' , 2 );
    
    % Setting
    xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    ylabel( '$F$ $[N]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    Leg = legend( '$F(t)$' , '$F_{No \; R.V.}(t)$' , '$F_{no \; optim}(t)$' );
    set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
    title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

    %% Force vs. velocity of the piston.
    figure;
    hold on; grid on;
    plot( abs( a_d ) , abs( F ) , 'LineWidth' , 2 );
    plot( abs( a_d_NoOptm ) , abs( F_NoOptm ) , 'LineWidth' , 2 );

    % Setting
    xlabel( '$\dot{b}$ $[m/s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    ylabel( '$F$ $[N]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    Leg = legend( '$F(\dot{b})$' , '$F_{no \; optim}(\dot{b})$' , 'Location' , 'SouthEast' );
    set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
    title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

end
%% Plot Relief valve parameter.
PlotReliefValve;

%%
%Plot_SurfOptim;

%% Plot Stability Reagion.
PlotStability
