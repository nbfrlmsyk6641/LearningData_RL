function alpha = calculate_activation(mu_e, mu_ec)

% 定义规则表
% （1：N，2：Z，3：P）
rule_list = [
    1 1 1 2; % 规则1
    1 2 1 2; % 规则2
    1 3 1 2; % 规则3
    2 1 1 3; % 规则4
    2 2 3 3; % 规则5
    2 3 3 3; % 规则6
    3 1 3 2; % 规则7
    3 2 3 2; % 规则8
    3 3 3 2; % 规则9
];

num_rules = size(rule_list, 1);
alpha = zeros(num_rules, 1);

for i = 1:num_rules
    % 获取规则所需的输入隶属度函数索引
    idx_e = rule_list(i, 1);
    idx_ec = rule_list(i, 2);
    
    % 获取对应的隶属度值
    mu_e_i = mu_e(idx_e);
    mu_ec_i = mu_ec(idx_ec);
    
    % 计算规则的激活度（Mamdani方法，取小运算）
    alpha(i) = min(mu_e_i, mu_ec_i);
end
end

