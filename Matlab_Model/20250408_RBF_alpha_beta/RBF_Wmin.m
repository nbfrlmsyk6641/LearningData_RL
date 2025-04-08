% 利用RBF训练转速下降最小值预测器，借助工具箱的方法

% 1. 读取Excel数据
filename = 'TL_Beta_Wmin.xlsx'; 
data_table = readtable(filename);

% 2. 提取数据
Tl_data = data_table.TL; % 负载转矩
beta_data = data_table.beta; % 补偿系数
Wmin_data = data_table.Wmin; % 转速下降最小值

% 3. 打包数据
P = [Tl_data'; beta_data']; 
T = Wmin_data'; 

% 4. 训练RBF神经网络
goal = 0.00001; % e^-5
spread = 1.0; 
MN = 50; 
DF = 1; 
net = newrb(P, T, goal, spread, MN, DF);  % 工具箱训网络

% 5. 模型评估
Y_pred = net(P);
RMSE = sqrt(mean((Y_pred - T).^2)); 
disp(['训练集 RMSE: ', num2str(RMSE)]);

% 6. 给一个数据测试效果
P_new = [0.3; 0.15]; 
Y_new = net(P_new);
disp(['预测的 Wmin: ', num2str(Y_new)]);

% 7. 提取网络信息
% 提取隐藏层神经元数量
num_neurons = net.layers{1}.size;

% 提取中心（centers），形状为 [num_neurons, input_dim]
centers = net.IW{1,1};

% 提取宽度（spreads），在 newrb 中为标量，直接使用训练时的 spread
spreads = spread; 

% 提取输出层权重，形状为 [output_dim, num_neurons]
weights = net.LW{2,1};

% 提取输出层偏置，形状为 [output_dim, 1]
bias = net.b{2};

% 显示提取的参数（可选）
disp(['隐藏层神经元数量: ', num2str(num_neurons)]);
disp('中心 (centers):');
disp(centers);
disp(['扩展常数 (spreads): ', num2str(spreads)]);
disp('输出层权重 (weights):');
disp(weights);
disp('输出层偏置 (bias):');
disp(bias);
% 
% % 1. 输入到隐藏层的参数
% centers = net.IW{1};      % 所有基函数的中心点 (N×2 矩阵，N为隐藏层神经元数)
% spread_actual = sqrt(-log(0.5)) / sqrt(net.b{1}(1));  % 计算实际 spread (σ)
% 
% % 2. 隐藏层到输出层的参数
% output_weights = net.LW{2,1};  % 输出权重 (1×N 向量)
% output_bias = net.b{2};        % 输出层偏置 (标量)
% 
% % 3. 其他信息
% num_neurons = net.layers{1}.size; % 实际神经元数量

