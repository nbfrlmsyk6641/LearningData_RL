num_samples = length(out.u);

% 滞后阶数
n_u = 2;%使用上次和上上次的控制量u
n_y = 4;%使用过去4个时刻的输出量y

% 总的输入维度，7
input_dim = n_u + 1 + n_y;

% 初始化特征向量矩阵
X = zeros(num_samples - max(n_u, n_y), input_dim);

for k = max(n_u, n_y) + 1:num_samples
    % 提取当前和过去的控制输入
    u_features = out.u(k:-1:k-n_u);

    % 提取过去的系统输出
    y_features = out.y(k-1:-1:k-n_y);

    % 构建特征向量
    X(k - max(n_u, n_y), :) = [u_features; y_features]';
end

Y = out.y(max(n_u, n_y) + 1:end);

% 计算均值和标准差
input_mean = mean(X);
input_std = std(X);

% 防止除以零
input_std(input_std == 0) = 1e-8;

% 归一化特征向量
X_norm = (X - input_mean) ./ input_std;

% 选择聚类数量（RBF 神经元数量）
K = 14;

% 执行 K-均值聚类
[idx, centers] = kmeans(X_norm, K);

widths = zeros(K, 1);

for i = 1:K
    % 提取属于第 i 个聚类的样本
    cluster_points = X_norm(idx == i, :);

    % 计算每个样本与聚类中心的距离
    distances = sqrt(sum((cluster_points - centers(i, :)).^2, 2));

    % 计算平均距离作为宽度
    widths(i) = mean(distances);

    % 防止宽度为零
    if widths(i) == 0
        widths(i) = 1e-8;
    end
end

% 保存中心和宽度
RBF_centers = centers;
RBF_widths = widths;

