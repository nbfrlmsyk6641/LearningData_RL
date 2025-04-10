% 待拟合数据
beta = [0.000,0.100,0.200,0.300,0.400,0.500,0.600,0.700,0.800,0.900,1.000,1.100,1.200]';

% J = [7.2059,6.3890,5.6689,5.0441,4.5066,4.0898,3.7960,3.6232,3.5785,3.6661,3.8910,4.2540,4.7577]';
J = [20.0294,17.7581,15.7554,14.0172,12.5451,11.4016,10.5764,10.0925,9.9668,10.2106,10.8324,11.8404,13.2396]';
% J = [39.2649,34.8123,30.8852,27.4765,24.6181,22.3669,20.7447,19.7959,19.5494,20.0290,21.2167,23.2225,25.9633]';

% 利用最小二乘法进行拟合，已知J和b呈现二次函数关系，则J(b) = a*beta^2 + c*beta + d

% 最小二乘法拟合原理，J = Xθ, θ = [a,c,d]^T, X = [beta^2,beta,1]

% 计算拟合后的系数
X = [beta.^2, beta, ones(size(beta))];

theta = X \ J;

a = theta(1);
c = theta(2);
d = theta(3);

% 拟合结果显示
fprintf('拟合结果: J(b) = %.4f b^2 + %.4f b + %.4f\n', a, c, d);

% 拟合效果画图
beta_fit = linspace(min(beta), max(beta), 100)'; 
J_fit = a * beta_fit.^2 + c * beta_fit + d;   
figure;  % 创建新图形窗口
plot(beta, J, 'o', 'MarkerSize', 8, 'LineWidth', 1.5);  
hold on;
plot(beta_fit, J_fit, '-', 'LineWidth', 2); 
hold off;
xlabel('beta');
ylabel('J(beta)');
legend('原始数据', '拟合曲线');
title('离线拟合: J(beta)');
grid on;

if a > 0
    beta_opt = -c / (2 * a);
    fprintf('离线初始最优反馈系数 beta_opt = %.4f\n', beta_opt);
else
    warning('a <= 0, 数据有误');
end

% 
% b = [0.000,0.050,0.100,0.150,0.200,0.250,0.300,0.350,0.400,0.450,0.500,0.550,0.600,0.650,0.700,0.750,0.800,0.850,0.900,0.950,1.000,1.050,1.100,1.150,1.200,1.250,1.300,1.350,1.400,1.450,1.500]';
% % J = [20.0294,18.8601,17.7581,16.7232,15.7554,14.8539,14.0172,13.2413,12.5365,11.9057,11.3392,10.8385,10.4052,10.0379,9.7374,9.5043,9.3373,9.2376,9.2046,9.2386,9.3389,9.5067,9.7408,10.0445,10.4097,10.8447,11.3465,11.9152,12.5499,13.2528,14.0215]';
% J = [20.0294,18.8601,17.7581,16.7232,15.7554,14.8539,14.0172,13.2413,12.5451,11.9362,11.4016,10.9468,10.5764,10.2906,10.0925,9.9845,9.9668,10.0420,10.2106,10.4242,10.8324,11.2882,11.8404,12.4950,13.2396,14.0881,15.0362,16.0844,17.2319,18.4823,19.8325]';
% 
% % 构建设计矩阵
% X = [b.^2, b, ones(size(b))];
% 
% % 最小二乘求解
% theta = X \ J;
% a = theta(1);
% c = theta(2);
% d = theta(3);
% 
% % 计算最优b
% b_opt = -c/(2*a);
% 
% % 生成拟合曲线
% b_fit = linspace(min(b), max(b), 100)';
% J_fit = a*b_fit.^2 + c*b_fit + d;
% 
% % 绘图
% figure;
% hold on;
% scatter(b, J, 50, 'filled', 'MarkerFaceColor', [0.2 0.4 0.8]);
% plot(b_fit, J_fit, 'LineWidth', 2, 'Color', [0.8 0.2 0.2]);
% xline(b_opt, '--', 'Optimal b', 'LabelVerticalAlignment','bottom');
% xlabel('反馈系数 b');
% ylabel('性能指标 J');
% title(sprintf('最优b=%.3f', b_opt));
% grid on;
% box on;
% 
% % 计算R²
% J_pred = X*theta;
% SS_tot = sum((J - mean(J)).^2);
% SS_res = sum((J - J_pred).^2);
% R2 = 1 - SS_res/SS_tot;
% 
% % 显示结果
% disp(['拟合方程: J = ', num2str(a),'b² + ', num2str(c),'b + ', num2str(d)]);
% disp(['最优反馈系数: b_opt = ', num2str(b_opt)]);
% disp(['决定系数 R² = ', num2str(R2)]);

% data = [0.3,0.0,7.2059;
%         0.3,0.1,6.3890;
%         0.3,0.2,5.6689;
%         0.3,0.3,5.0411;
%         0.3,0.4,4.5066;
%         0.3,0.5,4.0898;
%         0.3,0.6,3.7960;
%         0.3,0.7,3.6232;
%         0.3,0.8,3.5785;
%         0.3,0.9,3.6661;
%         0.3,1.0,3.8910;
%         0.3,1.1,4.2540;
%         0.3,1.2,4.7577;
%         0.5,0.0,20.0294;
%         0.5,0.1,17.7581;
%         0.5,0.2,15.7554;
%         0.5,0.3,14.0172;
%         0.5,0.4,12.5451;
%         0.5,0.5,11.4016;
%         0.5,0.6,10.5764;
%         0.5,0.7,10.0925;
%         0.5,0.8,9.9668;
%         0.5,0.9,10.2106;
%         0.5,1.0,10.8324;
%         0.5,1.1,11.8404;
%         0.5,1.2,13.2396;
%         0.7,0.0,39.2649;
%         0.7,0.1,34.8123;
%         0.7,0.2,30.8852;
%         0.7,0.3,27.4765;
%         0.7,0.4,24.6481;
%         0.7,0.5,22.3669;
%         0.7,0.6,20.7447;
%         0.7,0.7,19.7959;
%         0.7,0.8,19.5494;
%         0.7,0.9,20.0290;
%         0.7,1.0,21.2167;
%         0.7,1.1,23.2225;
%         0.7,1.2,25.9633];
% Tl = data(:,1);
% b = data(:,2);
% J = data(:,3);
% 
% X = [b.^2, b, Tl, Tl.^2, b.*Tl, ones(size(b))];
% 
% theta = X \ J;
% alpha1 = theta(1);
% alpha2 = theta(2);
% beta1  = theta(3);
% beta2  = theta(4);
% gamma  = theta(5);
% delta  = theta(6);
% 
% % 模型验证
% J_pred = X * theta;
% SS_tot = sum((J - mean(J)).^2);
% SS_res = sum((J - J_pred).^2);
% R2 = 1 - SS_res / SS_tot;
% disp(['R² = ', num2str(R2)]);
% 
% 
% % 三维曲面可视化
% b_range = 0:0.05:1.2;
% Tl_range = 0.3:0.05:0.7;
% [b_grid, Tl_grid] = meshgrid(b_range, Tl_range);
% J_grid = alpha1*b_grid.^2 + alpha2*b_grid + beta1*Tl_grid + beta2*Tl_grid.^2 + gamma*b_grid.*Tl_grid + delta;
% 
% figure;
% surf(b_grid, Tl_grid, J_grid);
% xlabel('b'); ylabel('T_l'); zlabel('J'); title('双变量二次响应面');
% colormap jet; colorbar;
% hold on;
% scatter3(b, Tl, J, 50, 'r', 'filled');
% 
