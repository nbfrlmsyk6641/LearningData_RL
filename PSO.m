% PSO parameters
num_particles = 30; % 粒子数量
num_dimensions = 2; % 问题的维度
max_iterations = 500; % 最大迭代次数

%惯性权重、认知权重和社会权重，PSO的参数
w = 0.5; 
c1 = 1.5; 
c2 = 1.5; 

% 对粒子随机初始化，其实也就是对可能存在的解进行随机初始化
particles = rand(num_particles, num_dimensions) * 10 - 5;
velocities = rand(num_particles, num_dimensions) * 2 - 1;

% 初始化局部最佳与全局最佳位置
%将当前位置作为局部最优位置，带入到适应度函数中，获取每一个粒子的适应度值
%在适应度值中找到全局最优位置，作为起点开始迭代
pBest = particles;
pBest_values = arrayfun(@(i) fitness_function(particles(i, :)), 1:num_particles);
[~, gBest_index] = min(pBest_values);
gBest = particles(gBest_index, :);

% 开始进行ESO
for t = 1:max_iterations
    for i = 1:num_particles
        % Evaluate fitness
        fitness = fitness_function(particles(i, :));
        
        % Update personal best
        if fitness < pBest_values(i)
            pBest(i, :) = particles(i, :);
            pBest_values(i) = fitness;
        end
        
        % Update global best
        if fitness < fitness_function(gBest)
            gBest = particles(i, :);
        end
        
        % Update velocity and position
        r1 = rand;
        r2 = rand;
        velocities(i, :) = w * velocities(i, :) + c1 * r1 * (pBest(i, :) - particles(i, :)) + c2 * r2 * (gBest - particles(i, :));
        particles(i, :) = particles(i, :) + velocities(i, :);
    end
    
    % Print progress
    fprintf('Iteration %d: Best fitness value = %.4f\n', t, fitness_function(gBest));
end

% Display results
disp('Optimal solution found:');
disp(gBest);
disp('Fitness value at optimal solution:');
disp(fitness_function(gBest));

% Fitness function
function f = fitness_function(x)
    f = x(1)^2 + x(2)^2;
end
