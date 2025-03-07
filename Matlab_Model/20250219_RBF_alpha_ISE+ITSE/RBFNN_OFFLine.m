% 加载数据
U = Te; % 控制输入数组，大小为 N x 1
Y = Wm; % 系统输出数组，大小为 N x 1

% 构建训练样本
start_idx = 5;
N_samples = length(U) - start_idx + 1;
X = zeros(N_samples, 6);
T = zeros(N_samples, 1);

for i = start_idx:length(U)
    X(i - start_idx + 1, :) = [...
        U(i);
        U(i - 1);
        Y(i - 1);
        Y(i - 2);
        Y(i - 3);
        Y(i - 4)];
    T(i - start_idx + 1) = Y(i);
end

% 设置隐藏层神经元数量
num_neurons = 36;

% 使用kmeans聚类确定中心
[cluster_idx, centers] = kmeans(X, num_neurons);

% 计算sigma
sigma = zeros(num_neurons, 1);
for i = 1:num_neurons
    cluster_points = X(cluster_idx == i, :);
    sigma(i) = mean(std(cluster_points));
    if sigma(i) == 0
        sigma(i) = 1e-6;
    end
end

% 初始化权值
W = randn(num_neurons, 1);

% 定义学习率和训练轮数
learning_rate = 0.08;
num_epochs = 1000000;
loss_history = zeros(num_epochs, 1);

% 训练循环
for epoch = 1:num_epochs
    % 前向传播
    G = calcGauss(X, centers, sigma);
    Y_hat = G * W;
    
    % 计算损失
    error = T - Y_hat;
    loss = mean(error.^2);
    loss_history(epoch) = loss;
    
    % 反向传播
    grad_W = -2 * (G' * error) / length(T);
    W = W - learning_rate * grad_W;
    
    if mod(epoch, 100) == 0
        fprintf('Epoch %d/%d, Loss: %.6f\n', epoch, num_epochs, loss);
    end
end

% 预测
Y_pred = G * W;

% 绘制结果
figure;
subplot(2,1,1);
plot(1:num_epochs, loss_history);
xlabel('Epoch');
ylabel('Loss');
title('Training Loss');

subplot(2,1,2);
plot(T, 'b', 'DisplayName', 'Actual Output');
hold on;
plot(Y_pred, 'r--', 'DisplayName', 'Predicted Output');
legend;
xlabel('Sample');
ylabel('Output');
title('Actual vs Predicted Output');

% 计算均方误差
mse = mean((T - Y_pred).^2);
fprintf('Mean Squared Error on Training Data: %.6f\n', mse);

% 高斯核计算函数
function G = calcGauss(X, centers, sigma)
    N = size(X, 1);
    num_neurons = size(centers, 1);
    G = zeros(N, num_neurons);
    for i = 1:num_neurons
        diff = X - centers(i, :);
        G(:, i) = exp(-sum(diff.^2, 2) / (2 * sigma(i)^2));
    end
end
