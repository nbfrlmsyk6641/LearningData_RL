u = system_u; % 输入信号，大小 [N x 1]
y = system_y; % 输出信号，大小 [N x 1]

% 检查输入数据
if length(u) ~= length(y)
    error('输入 u 和输出 y 的长度不一致！');
end

% 确定滞后阶数
p = 2; % 过去的输入数量
q = 4; % 过去的输出数量

% 确定构建特征向量的起始点
start_idx = max(p, q) + 1;

% 样本数量
N = length(u);
num_samples = N - start_idx + 1;

% 初始化输入矩阵 X 和目标向量 Y
X = zeros(num_samples, p + q); % 每个输入向量的维度为 p + q = 6
Y = zeros(num_samples, 1);

% 构建输入矩阵 X 和目标向量 Y
for i = start_idx:N
    % 构建输入向量 x_t
    x_t = [
        u(i - 0);   % u_t
        u(i - 1);   % u_{t-1}
        y(i - 1);   % y_{t-1}
        y(i - 2);   % y_{t-2}
        y(i - 3);   % y_{t-3}
        y(i - 4)    % y_{t-4}
    ];
    X(i - start_idx + 1, :) = x_t';
    
    % 目标输出 y_t
    Y(i - start_idx + 1) = y(i);
end

% 使用 K-均值聚类
K = 36; % RBF 神经元的数量
rng(42); % 设置随机数种子，对随机性进行固定
[cluster_idx, centers] = kmeans(X, K);

% 计算 RBF 的宽度（Widths）
distance_matrix = pdist2(centers, centers);

% 将对角线元素设为 Inf
for i = 1:K
    distance_matrix(i, i) = Inf;
end

% 找到每个中心的最近邻距离
min_distances = min(distance_matrix, [], 2);

% 设置宽度，可以选择使用平均最近邻距离
widths = mean(min_distances);

% 如果希望每个 RBF 神经元有相同的宽度
sigma = widths;

% 初始化隐藏层输出矩阵 H
H = zeros(num_samples, K);

% 计算隐藏层输出
for i = 1:num_samples
    for j = 1:K
        % 计算第 i 个样本与第 j 个中心的距离
        distance = norm(X(i, :) - centers(j, :));
        
        % 计算 RBF 神经元的输出
        H(i, j) = exp(- (distance^2) / (2 * sigma^2));
    end
end

% 使用梯度下降训练输出层权值 W

% 初始化权值
W = randn(K, 1) * 0.01;

% 设置超参数
learning_rate = 0.25;
num_epochs = 5000;
lambda = 0.002; % 正则化参数（可根据需要调整）

% 记录损失
loss_history = zeros(num_epochs, 1);

for epoch = 1:num_epochs
    % 前向传播：计算预测输出
    Y_pred = H * W;
    
    % 计算损失函数（包括正则化项）
    loss = mean((Y_pred - Y).^2) + lambda * (W' * W);
    
    % 记录损失
    loss_history(epoch) = loss;
    
    % 计算梯度
    dW = (2 / num_samples) * (H' * (Y_pred - Y)) + 2 * lambda * W;
    
    % 更新权值
    W = W - learning_rate * dW;
    
    % 50轮输出一次损失情况
    if mod(epoch, 50) == 0
        fprintf('Epoch %d/%d, Loss: %.6f\n', epoch, num_epochs, loss);
    end
end

% 绘制损失函数的下降曲线
figure;
plot(1:num_epochs, loss_history, 'LineWidth', 1.5);
xlabel('Epoch');
ylabel('Loss');
title('Loss Function over Epochs');

% 计算最终的预测输出
Y_pred = H * W;

% 计算均方误差
MSE = mean((Y - Y_pred).^2);

% 显示最终的 MSE
fprintf('训练完成！最终的均方误差（MSE）：%.6f\n', MSE);

% 绘制真实输出与预测输出的对比图
figure;
plot(Y, 'b', 'LineWidth', 1.5); hold on;
plot(Y_pred, 'r--', 'LineWidth', 1.5);
legend('真实输出', '预测输出');
xlabel('样本编号');
ylabel('输出');
title('真实输出与预测输出对比');

