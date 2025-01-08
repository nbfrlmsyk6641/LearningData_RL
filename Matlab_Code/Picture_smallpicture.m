% 假设预测误差数据存储在数组 'errors' 中
errors = Valuea;

% 1. 绘制整个误差曲线
figure; % 创建新图
plot(errors, 'LineWidth', 1.5);
xlabel('时间 (s)'); % 更新 x 轴标签
ylabel('a');
title('谐振抑制系数a更新曲线');
grid on; % 添加网格

% 2. 定义第一个放大区域
x_zoom1 = 29000:30000;
y_zoom1 = errors(x_zoom1);

% 3. 定义第二个放大区域
x_zoom2 = 31000:31200;
y_zoom2 = errors(x_zoom2);

% 4. 插入第一个局部放大图
axes('Position', [0.55, 0.20, 0.2, 0.2]); % 子图1位置和大小
plot(x_zoom1, y_zoom1, 'LineWidth', 2, 'Color', 'r');
xlabel('时间 (s)'); % 更新 x 轴标签
ylabel('a');
title('局部放大图');
grid on;

% 5. 插入第二个局部放大图
axes('Position', [0.55, 0.65, 0.2, 0.2]); % 子图2位置和大小
plot(x_zoom2, y_zoom2, 'LineWidth', 2, 'Color', 'g');
xlabel('时间 (s)'); % 更新 x 轴标签
ylabel('a');
title('局部放大图');
grid on;
