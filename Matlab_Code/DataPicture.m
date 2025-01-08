% 实验数据点数
numPoints = 3000001; 

% 横轴
t = linspace(0, 30, numPoints);

% 真实值
trueValue = 5.25e-3; % 根据不同的变量调整

figure;

% 绘制实验数据曲线
plot(t, experimentalData, 'b-', 'LineWidth', 1.2);

% 保持当前图形
hold on;

% 绘制真实值曲线
yline(trueValue, 'r--', 'LineWidth', 1.2);

% 释放保持状态
hold off;

% 添加轴标签
xlabel('时间 (秒)');
ylabel('电感 (H)');

% 添加图形标题
title('电感辨识结果');

% 添加图例
legend('辨识值', '真实值');

% 显示网格线
grid on;

