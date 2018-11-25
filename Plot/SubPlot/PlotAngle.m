%% Plot of the lead-lag angle in time.
% In the case of sinosoidal perturbation, the force that would be obtained 
% without the lead-lag damper is also plotted.

if strcmp( Param.FlagF , 'Sin' ) == 1 || strcmp( Param.FlagF , 'Simp' ) == 1
    figure;
    hold on; grid on;
    plot( t_NoDam , rad2deg( X_NoDam( : , 1 ) ) , 'r' , 'LineWidth' , 2);
    plot( t_ode , rad2deg( X( : , 1 ) ) , 'LineWidth' , 2 );
    

    % Setting
    xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    ylabel( '$\xi$ $[^\circ]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    Leg = legend( '$\xi_{No \; Damp}(t)$' , '$\xi(t)$' );
    set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
    title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
else
    figure;
    hold on; grid on;
    plot( t_ode , rad2deg( X( : , 1 ) ) , 'LineWidth' , 2 );

    % Setting
    xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    ylabel( '$\xi$ $[^\circ]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
    Leg = legend( '$\xi(t)$' );
    set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
    title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );   
end

%% Lead-lag Angular Velocity.
figure;
hold on; grid on;
plot( t_ode , rad2deg( X( : , 2 ) ) , 'LineWidth' , 2 );

% Setting
xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$\dot{\xi}$ $[^\circ/s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$\dot{\xi}(t)$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

% %% Lead-lag Angular Acceleration.
% figure;
% hold on; grid on;
% plot( t_ode , rad2deg( X_d( : , 2 ) ) , 'LineWidth' , 2 );
% 
% % Setting
% xlabel( '$t$ $[s]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
% ylabel( '$\ddot{\xi}$ $[^\circ/s^2]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
% Leg = legend( '$\ddot{\xi}(t)$' );
% set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
% title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
