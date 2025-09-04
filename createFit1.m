function [fitresult, gof] = createFit1(xc, vx_m)

%% Fit: 'Curve Fit for Velocity Gradient'.
[xData, yData] = prepareCurveData( xc, vx_m );

% Set up fittype and options.
ft = fittype('a*x^(-b)');
opts = fitoptions('Method', 'NonlinearLeastSquares');
opts.Display = 'Off';
opts.StartPoint = [90, -0.567]; % Set your initial values for 'a' and 'b'

% Fit model to data.
[fitresult, gof] = fit(xData, yData, ft, opts);

% Calculate R-squared (R2) value
 R2 = gof.rsquare;
 % Get the fit equation as a string
fitEquation = formula(fitresult);

 % Get the 'a' and 'b' coefficients from the fit result
a = fitresult.a;
b = fitresult.b;

% Display the coefficients 'a' and 'b'
disp(['a = ' num2str(a)]);
disp(['b = ' num2str(b)]);


% Plot fit with data.
%figure( 'Name', '10nm Velocity Gradient' );
h = plot( fitresult, xData, yData );
legend( h, 'Avg. Velocity', 'Fit', 'Location', 'NorthEast', 'Interpreter', 'latex' );
% Label axes
xlabel( 'Distance Traveled (\mum)', 'Interpreter', 'tex' );
ylabel( 'Average Velocity (\mum/s)', 'Interpreter', 'tex' );

% Display R2 value and Fit equation
text(0.1, 0.9, ['R^2 = ' num2str(R2)], 'Units', 'normalized');
text(0.1, 0.8, ['Fit Equation: ' fitEquation], 'Units', 'normalized', 'Interpreter', 'tex');
%grid on



% Display R2 value and Fit equation
text(0.1, 0.7, ['a = ' num2str(a)], 'Units', 'normalized');
text(0.1, 0.6, ['b = ' num2str(b)], 'Units', 'normalized');



