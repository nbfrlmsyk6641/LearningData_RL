function optimalControlParam = PSO_Optimization(currentError)
    % 粒子群优化参数
    persistent numParticles numIterations controlParamRange positions velocities personalBestPositions personalBestErrors globalBestPosition globalBestError iter fitnessThreshold v_max w_max w_min

    if isempty(iter)
        % 初始化参数
        numParticles = 30; % 粒子数量
        numIterations = 100; % 迭代次数
        controlParamRange = [0, 1]; % 控制参数范围
        fitnessThreshold = 1e-4; % 误差调整阈值，期望误差调整为0.0001

        % 初始化粒子位置和速度
        positions = controlParamRange(1) + (controlParamRange(2) - controlParamRange(1)) * rand(numParticles, 1);
        v_max = (controlParamRange(2) - controlParamRange(1)) * 0.1; % 速度最大值
        velocities = rand(numParticles, 1) * 2 * v_max - v_max; % 初始化速度为随机值

        personalBestPositions = positions;
        personalBestErrors = inf(numParticles, 1);

        % 全局最佳
        globalBestError = inf;
        globalBestPosition = positions(1);

        % 初始化迭代计数器
        iter = 1;
    end

    % PSO 参数
    w_max = 0.9;
    w_min = 0.4;
    c1 = 2; % 个人学习因子
    c2 = 2; % 社会学习因子

    % 在每次调用时更新PSO
    if iter <= numIterations
        w = w_max - (w_max - w_min) * (iter / numIterations);
        for i = 1:numParticles
            % 更新速度
            velocities(i) = w * velocities(i) + ...
                            c1 * rand * (personalBestPositions(i) - positions(i)) + ...
                            c2 * rand * (globalBestPosition - positions(i));

            velocities(i) = max(min(velocities(i), v_max), -v_max);%限制速度

            % 更新位置
            positions(i) = positions(i) + velocities(i);

            % 位置约束
            positions(i) = max(min(positions(i), controlParamRange(2)), controlParamRange(1));

            % 计算适应度
            currentError = fitnessFunction(currentError);

            % 更新个人最佳
            if currentError < personalBestErrors(i)
                personalBestErrors(i) = currentError;
                personalBestPositions(i) = positions(i);
            end

            % 更新全局最佳
            if currentError < globalBestError
                globalBestError = currentError;
                globalBestPosition = positions(i);
            end
        end

        % 增加迭代计数
        iter = iter + 1;

        if globalBestError <= fitnessThreshold
            iter = numIterations + 1;         %达到控制要求，提前终止循环
        end

    end

    % 输出最佳控制参数
    optimalControlParam = globalBestPosition;
end

function error = fitnessFunction(currentError)
    % 适应度函数直接返回当前误差
    error = currentError;
end
