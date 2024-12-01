%RBFN简单实现

% 清除工作空间并关闭所有图形
clear; clc; close all;

% Step 1: 生成训练数据
f = @(x) sin(x); %待逼近的函数

% 生成 N 个均匀分布在 [0, 2π] 上的训练样本
N = 100;                          % 训练样本数
x_train = linspace(0, 2*pi, N)';  % 列向量
y_train = f(x_train);             % 计算对应的输出

% 设置隐藏层节点（RBF 神经元）数目
M = 10;
% 选择 RBF 的中心（μ_i），均匀分布在输入空间 [0, 2π] 上
centers = linspace(0, 2*pi, M)';  % 列向量

% 设置高斯函数的宽度（σ）
% 为简单起见，这里所有的 RBF 使用相同的 σ
% σ 通常可以设置为中心间距的倍数
d_max = max(centers(2:end) - centers(1:end-1));  
sigma = d_max;

% 初始化隐藏层输出矩阵 H，尺寸为 [M x N]
H = zeros(M, N);

% 计算每个 RBF 神经元对每个训练样本的响应
for i = 1:M
    % 计算第 i 个 RBF 神经元对所有训练样本的响应
    H(i, :) = exp(-((x_train' - centers(i)).^2) / (2 * sigma^2));
    % x_train' 将列向量转置为行向量，便于与标量 centers(i) 相减
end

% 使用线性最小二乘法求解输出层权重向量 w
% 目标是最小化 E = || H^T * w - y_train ||^2
% 求解正规方程：w = (H * H^T)^{-1} * H * y_train
w = (H * H') \ (H * y_train);

% 生成测试数据（用于绘制逼近曲线）
x_test = linspace(0, 2*pi, 1000)';  % 测试样本数可以设为较大值
y_test = f(x_test);  % 计算真实函数值

% 计算隐藏层在测试数据上的输出
H_test = zeros(M, length(x_test));  % 初始化
for i = 1:M
    H_test(i, :) = exp(-((x_test' - centers(i)).^2) / (2 * sigma^2));
end

% 计算 RBFN 在测试数据上的输出
y_pred = (w' * H_test)';  % w' * H_test 的结果是行向量，转置为列向量

figure;
% 绘制训练数据点
plot(x_train, y_train, 'bo', 'MarkerSize', 5, 'DisplayName', '训练数据');
hold on;

% 绘制真实函数曲线
plot(x_test, y_test, 'r-', 'LineWidth', 2, 'DisplayName', '真实函数');

% 绘制 RBFN 的逼近曲线
plot(x_test, y_pred, 'g--', 'LineWidth', 2, 'DisplayName', 'RBFN 逼近');

% 图形美化
legend('show');
xlabel('x');
ylabel('y');
title('RBF 网络对 sin(x) 的逼近');
grid on;
hold off;

% 计算训练数据上的预测输出
y_train_pred = (w' * H)';  % H 为 [M x N]，w' 为 [1 x M]

% 计算训练误差 MSE
mse_train = mean((y_train - y_train_pred).^2);
fprintf('训练集上的均方误差（MSE）：%.6f\n', mse_train);

% 计算测试误差 MSE
mse_test = mean((y_test - y_pred).^2);
fprintf('测试集上的均方误差（MSE）：%.6f\n', mse_test);
