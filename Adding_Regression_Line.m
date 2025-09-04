figure()
plot(x, y, '*','displayname','Scatterplot')
title('scatterplot')
xlabel('estimated')
ylabel('measured')
% Fit linear regression line with OLS.
b = [ones(size(x,1),1) x]\y;
% Use estimated slope and intercept to create regression line.
RegressionLine = [ones(size(x,1),1) x]*b;
% Plot it in the scatter plot and show equation.
hold on,
plot(x,RegressionLine,'displayname',sprintf('Regression line (y = %0.2f*x + %0.2f)',b(2),b(1)))
legend('location','nw')
% RMSE between regression line and y
RMSE = sqrt(mean((y-RegressionLine).^2));
% R2 between regression line and y
SS_X = sum((RegressionLine-mean(RegressionLine)).^2);
SS_Y = sum((y-mean(y)).^2);
SS_XY = sum((RegressionLine-mean(RegressionLine)).*(y-mean(y)));
R_squared = SS_XY/sqrt(SS_X*SS_Y);
fprintf('RMSE: %0.2f | R2: %0.2f\n',RMSE,R_squared)