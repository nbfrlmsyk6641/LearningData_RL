function [y_pred, E, centers_out, sigma_out, W_out]  = RBFN_OnLine(uk, uk_1, yk_1, yk_2, yk_3, yk_4, yk)

% 将单独的输入组合成一个列向量 u,RBFN有6个输入
u = [uk; uk_1; yk_1; yk_2; yk_3; yk_4]; % [6 x 1]

%RBFN参数定义与初始化
persistent centers sigma W learning

if isempty(centers)

    %从文件中加载预训练的参数，注意文件名
    data = load('RBFN_parameters2.mat');
    centers = data.centers;
    sigma = data.sigma;
    W = data.W_init;

    learning = true;

end

K = 36; % 神经元数量
H = zeros(K, 1);

for j = 1:K
    % 计算第 j 个 RBF 神经元的输出
    distance = norm(u - centers(j, :)'); % 确保维度匹配
    H(j) = exp(- (distance^2) / (2 * sigma^2));
end

% 计算网络的预测输出
y_pred = W' * H;

% 计算预测误差
e = yk - y_pred;
E = e;

% 学习率设置
eta_W = 0.12;     % 权值学习率
eta_c = 0.015;    % 中心值学习率
eta_sigma = 0.015; % 宽度学习率

epsilon = 0.01; % 误差阈值

% 判断是否需要更新参数，误差没有达到要求就更新
if learning
    % 更新权值
    W = W + eta_W * e * H;

    % 更新中心值
    for j = 1:K
        centers(j, :) = centers(j, :) + ...
            eta_c * e * W(j) * H(j) * (u' - centers(j, :)) / sigma^2;
    end

    % 为了简化，所有的神经元都用一个宽度参数
    delta_sigma = 0;
    for j = 1:K
        delta_sigma = delta_sigma + ...
            e * W(j) * H(j) * (norm(u - centers(j, :)')^2) / sigma^3;
    end
    % 更新宽度
    sigma = sigma + eta_sigma * delta_sigma / K;
end

% 收敛条件判断
if abs(e) < epsilon
    % 误差小于阈值，停止参数更新
    learning = false;
else
    % 误差大于阈值，继续参数更新
    learning = true;
end

centers_out = centers;
sigma_out = sigma;
W_out = W;

end




