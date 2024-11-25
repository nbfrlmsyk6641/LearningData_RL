% 粒子群算法优化 f(x) = x^2 的最小值
clc; clear; close all;

% 参数设置
num_particles = 30; % 粒子数量
max_iter = 100; % 最大迭代次数
w = 0.5; % 惯性权重
c1 = 1.5; % 个体加速因子
c2 = 1.5; % 群体加速因子
x_min = -10; % 搜索空间下界
x_max = 10; % 搜索空间上界
v_max = (x_max - x_min) / 2; % 最大速度

% 初始化粒子的位置和速度
x = x_min + (x_max - x_min) * rand(num_particles, 1);
v = zeros(num_particles, 1);

% 初始化个体最优位置和全局最优位置
pBest = x;
gBest = x(1);

% 计算初始的适应度值
pBest_val = x.^2;
gBest_val = pBest_val(1);

% 找到初始的全局最优位置
for i = 2:num_particles
    if pBest_val(i) < gBest_val
        gBest = pBest(i);
        gBest_val = pBest_val(i);
    end
end

% 迭代更新
for iter = 1:max_iter
    for i = 1:num_particles
        % 更新速度和位置
        r1 = rand;
        r2 = rand;
        v(i) = w * v(i) + c1 * r1 * (pBest(i) - x(i)) + c2 * r2 * (gBest - x(i));
        v(i) = max(min(v(i), v_max), -v_max); % 限制速度
        x(i) = x(i) + v(i);
        x(i) = max(min(x(i), x_max), x_min); % 限制位置

        % 计算新的适应度值
        fit = x(i)^2;

        % 更新个体最优位置
        if fit < pBest_val(i)
            pBest(i) = x(i);
            pBest_val(i) = fit;
        end

        % 更新全局最优位置
        if fit < gBest_val
            gBest = x(i);
            gBest_val = fit;
        end
    end

    % 输出当前迭代的最优值
    fprintf('Iteration %d: Best Value = %.6f\n', iter, gBest_val);
end

% 输出最终结果
fprintf('Optimal Solution: x = %.6f, f(x) = %.6f\n', gBest, gBest_val);
