function [N, Z, P] = fuzzy_membership(e)
% 输入: e - 输入变量
% 输出: N, Z, P - 隶属度函数的值

% 定义隶属度函数
N = zmf(e, -1, -1/3);
Z = trimf(e, [-2/3, 0, 2/3]);
P = smf(e, 1/3, 1);

end

function y = zmf(x, a, b)
% Z-型隶属度函数

y = 0;

if x <= a
    y = 1;
elseif x > a && x < (a+b)/2
    y = 1 - 2 * ((x - a) / (b - a))^2;
elseif x >= (a+b)/2 && x < b
    y = 2 * ((b - x)/(b - a))^2;
elseif x >= b
    y = 0;
end
end

function y = trimf(x, params)
% 三角隶属度函数

y = 0;

a = params(1);
b = params(2);
c = params(3);
if x <= a || x >= c
    y = 0;
elseif x == b
    y = 1;
elseif x > a && x < b
    y = (x - a) / (b - a);
else
    y = (c - x) / (c - b);
end
end

function y = smf(x, a, b)
% S-型隶属度函数

y = 0;

if x <= a
    y = 0;
elseif x > a && x < (a+b)/2
    y = 2 * ((x - a)/(b - a))^2;
elseif x >= (a+b)/2 && x < b
    y = 1 - 2*((b - x)/(b - a))^2;
elseif x >= b
    y = 1;
end
end
