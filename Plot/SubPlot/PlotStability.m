%% Plot of Eigen-Value.
figure;
subplot( 1 , 2 , 1 );
hold on; grid on;
plot( real( eigvalP1HP2L ) , imag( eigvalP1HP2L ) , 'bo' , 'LineWidth' , 2 , 'MarkerFaceColor' , 'b' );

% Setting
xlabel( '$Re\{\lambda \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{\lambda \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$\lambda$' , 'Location' , 'NorthWest' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

% Zoom of the Eigen-Value plot.
subplot( 1 , 2 , 2 );
hold on; grid on;
plot( real( eigvalP1HP2L ) , imag( eigvalP1HP2L ) , 'bo' , 'LineWidth' , 2 , 'MarkerFaceColor' , 'b' );

% Setting
xlabel( '$Re\{\lambda \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{\lambda \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$\lambda$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
xlim( [ - 40 , 40 ] );

%% Trend of the Step-Size.
figure;
hold on; grid on;
plot( T( 2 : end ) , h , 'LineWidth' , 2 );

% Setting
xlabel( '$T$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Step-Size$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$h(t)$' , 'Location' , 'NorthWest' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

%% Numerical Stability BDF Reagion Plot.
figure;
hold on; grid on;

C = 'color'; c = {'b','r','g','m','c','y'};
x = [0 0]; y = [-8 8]; K = 'k'; LW = 'linewidth';
t = linspace(0 , 2*pi,10000);
z = exp(1i*t);
plot(8*y,x,K,LW,1), hold on, plot(x,8*y,K)
d = 1-1./z;
r = 0;
Pl = [  ];
for i = 1:5
  r = r+(d.^i)/i;
  pl = plot(r,C,c{i},LW,2);
  Pl = [ Pl , pl ];
end
axis square, grid on


% Setting
xlabel( '$Re\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( Pl , '$I$ $Order$' , '$II$ $Order$' , '$III Order$' , '$IV Order$' , '$V Order$' , 'Location' , 'EastOutSide' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
axis( [ -5 20 -15 15 ] );

%% Numerical Eigen-Value Plot with Stability Reagion of the BDF.
figure;
subplot( 1 , 2 , 1 );
hold on; grid on;
plot( real( eigvalP1HP2L )' .* h , imag( eigvalP1HP2L )' .* h , 'b*' , 'LineWidth' , 2 , 'MarkerFaceColor' , 'b' );

% Setting
xlabel( '$Re\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( '$h\lambda_i$' , 'Location' , 'NorthWest' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );

% Zoom of the Numerical Eigen-Value Plot with Stability Reagion of the BDF.
subplot( 1 , 2 , 2 );
hold on; grid on;
pl1 = plot( real( eigvalP1HP2L )' .* h , imag( eigvalP1HP2L )' .* h , 'b*' , 'LineWidth' , 2 , 'MarkerFaceColor' , 'b' );

C = 'color'; c = {'b','r','g','m','c','y'};
x = [0 0]; y = [-8 8]; K = 'k'; LW = 'linewidth';
t = linspace(0 , 2*pi,10000);
z = exp(1i*t);
plot(8*y,x,K,LW,1), hold on, plot(x,8*y,K)
d = 1-1./z;
r = 0;
Pl = [pl1(1)];
for i = 1:5
  r = r+(d.^i)/i;
  pl = plot(r,C,c{i},LW,2);
  Pl = [ Pl , pl ];
end
axis square, grid on

% Setting
xlabel( '$Re\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( Pl , '$h\lambda_i$' , '$I$ $Order$' , '$II$ $Order$' , '$III Order$' , '$IV Order$' , '$V Order$' , 'Location' , 'NorthWest' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
axis( [ -20 20 -20 20 ] );

%% Zoom of the Numerical Eigen-Value Plot with Stability Reagion of the BDF.
figure;
subplot( 1 , 2 , 1 );
hold on; grid on;
pl1 = plot( real( eigvalP1HP2L )' .* h , imag( eigvalP1HP2L )' .* h , 'b*' , 'LineWidth' , 2 , 'MarkerFaceColor' , 'b' );

C = 'color'; c = {'b','r','g','m','c','y'};
x = [0 0]; y = [-8 8]; K = 'k'; LW = 'linewidth';
t = linspace(0 , 2*pi,10000);
z = exp(1i*t);
d = 1-1./z;
r = 0;
Pl = [pl1(1)];
for i = 1:5
  r = r+(d.^i)/i;
  pl = plot(r,C,c{i},LW,2);
  Pl = [ Pl , pl ];
end
axis square, grid on

% Setting
xlabel( '$Re\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( Pl , '$h\lambda_i$' , '$I$ $Order$' , '$II$ $Order$' , '$III Order$' , '$IV Order$' , '$V Order$' , 'Location' , 'East' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
axis( [ -1 1 -1 1 ] );

% Zoom of the Numerical Eigen-Value Plot with Stability Reagion of the BDF.
subplot( 1 , 2 , 2 );
hold on; grid on;
pl1 = plot( real( eigvalP1HP2L )' .* h , imag( eigvalP1HP2L )' .* h , 'b*' , 'LineWidth' , 2 , 'MarkerFaceColor' , 'b' );

C = 'color'; c = {'b','r','g','m','c','y'};
x = [0 0]; y = [-8 8]; K = 'k'; LW = 'linewidth';
t = linspace(0 , 2*pi,10000);
z = exp(1i*t);
d = 1-1./z;
r = 0;
Pl = [pl1(1)];
for i = 1:5
  r = r+(d.^i)/i;
  pl = plot(r,C,c{i},LW,2);
  Pl = [ Pl , pl ];
end
axis square, grid on

% Setting
xlabel( '$Re\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
ylabel( '$Im\{h\lambda_i \}$ $[-]$' , 'Interpreter' , 'LaTex' , 'FontSize' , LabelFontSize );
Leg = legend( Pl , '$h\lambda_i$' , '$I$ $Order$' , '$II$ $Order$' , '$III Order$' , '$IV Order$' , '$V Order$' );
set( Leg , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize );
title( Leg , '$Legend$' , 'Interpreter' , 'LaTex' , 'FontSize' , LegFontSize * 16 / 14 );
axis( [ -4e-5 4e-5 -0.045 0.045 ] );