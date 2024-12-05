function [kp_range, kp_aggregated, ki_range, ki_aggregated] = compute_output_mf(alpha)

%#codegen
% 指定输入输出端口的维度
%#input alpha : size(9,1)
%#output kp_range : size(1,N)
%#output kp_aggregated : size(1,N)
%#output ki_range : size(1,N)
%#output ki_aggregated : size(1,N)
% 其中 N = num_points，需要在代码中定义为常数或参数


% 定义自变量范围
num_points = 1000; % 分辨率，可以根据需要调整

% 定义 Kp 的自变量范围
kp_range = linspace(-10, 10, num_points); % [-3.3333, 3.3333]

% 定义 Ki 的自变量范围
ki_range = linspace(-100, 100, num_points);

% 定义 Kp 的隶属度函数
% N2（负）：zmf，参数 [-3.3333, -1.3333]
kp_N2 = zmf(kp_range, -10, -4);

% Z2（零）：trimf，参数 [-1.6667, 0, 1.6667]
kp_Z2 = trimf(kp_range, -5, 0, 5);

% P2（正）：smf，参数 [1.3333, 3.3333]
kp_P2 = smf(kp_range, 4, 10);

% 定义 Ki 的隶属度函数
% N3（负）：zmf，参数 [-0.1, -0.0333]
ki_N3 = zmf(ki_range, -100, -30);

% Z3（零）：trimf，参数 [-0.0667, 0, 0.0667]
ki_Z3 = trimf(ki_range, -40, 0, 40);

% P3（正）：smf，参数 [0.0333, 0.1]
ki_P3 = smf(ki_range, 30, 100);

% 初始化聚合后的隶属度函数
kp_aggregated = zeros(1, num_points);
ki_aggregated = zeros(1, num_points);

% 定义规则列表
rule_list = [
    1 1 1 2; % 规则 1
    1 2 1 2; % 规则 2
    1 3 1 2; % 规则 3
    2 1 1 3; % 规则 4
    2 2 3 3; % 规则 5
    2 3 3 3; % 规则 6
    3 1 3 2; % 规则 7
    3 2 3 2; % 规则 8
    3 3 3 2; % 规则 9
];

% 对每条规则进行处理
for i = 1:length(alpha)
    activation = alpha(i);
    if activation > 0
        % 获取规则的输出隶属度函数索引
        kp_index = rule_list(i, 3);
        ki_index = rule_list(i, 4);
        
        % 获取对应的 Kp 隶属度函数
        switch kp_index
            case 1 % N2
                kp_mf = kp_N2;
            case 2 % Z2
                kp_mf = kp_Z2;
            case 3 % P2
                kp_mf = kp_P2;
            otherwise
                kp_mf = zeros(1, num_points); % 确保 kp_mf 被赋值
        end
        
        % 按照激活度进行截断
        kp_rule = min(kp_mf, activation);
        
        % 聚合（取最大值）
        kp_aggregated = max(kp_aggregated, kp_rule);
        
        % 同样处理 Ki
        switch ki_index
            case 1 % N3
                ki_mf = ki_N3;
            case 2 % Z3
                ki_mf = ki_Z3;
            case 3 % P3
                ki_mf = ki_P3;
            otherwise
                ki_mf = zeros(1, num_points); % 确保 kp_mf 被赋值
        end
        
        ki_rule = min(ki_mf, activation);
        ki_aggregated = max(ki_aggregated, ki_rule);
    end
end

end

% 隶属度函数定义
function y = zmf(x, a, b)
% Z 形隶属度函数
y = zeros(size(x));
idx1 = x <= a;
idx2 = x >= b;
idx3 = (~idx1) & (~idx2);
y(idx1) = 1;
y(idx2) = 0;
y(idx3) = 1 - 2*((x(idx3)-a)/(b-a)).^2;
end

function y = smf(x, a, b)
% S 形隶属度函数
y = zeros(size(x));
idx1 = x <= a;
idx2 = x >= b;
idx3 = (~idx1) & (~idx2);
y(idx1) = 0;
y(idx2) = 1;
y(idx3) = 2*((x(idx3)-a)/(b-a)).^2;
end

function y = trimf(x, a, b, c)
% 三角形隶属度函数
y = zeros(size(x));
idx1 = x <= a;
idx2 = x >= c;
idx3 = (x > a) & (x < b);
idx4 = (x >= b) & (x < c);
y(idx1) = 0;
y(idx2) = 0;
y(idx3) = (x(idx3) - a)/(b - a);
y(idx4) = (c - x(idx4))/(c - b);
end
