function [IAE_Output,Time,Count,Count_T] = IAE_Calculation(err)

persistent err_last T t IAE_Now Zero_Count Zero_T

%变量初始化
if isempty(T)
    T = 0.0001;
end

if isempty(t)
    t = 0;
end

if isempty(err_last)
    err_last = 0;
end

if isempty(IAE_Now)
    IAE_Now = 0;
end

if isempty(Zero_Count)
    Zero_Count = 0;
end

if isempty(Zero_T)
    Zero_T = 0;
end

if (t >= 0.5)
    if sign(err) == sign(err_last)
        IAE_Now = IAE_Now + abs(err) * T;
    else
        IAE_Now = 0;
        Zero_T = t;
        Zero_Count = Zero_Count + 1;
    end
    t = t + T;
else
    t = t + T;
end

err_last = err;

%数值输出
IAE_Output = IAE_Now;
Time = t;
Count = Zero_Count;
Count_T = Zero_T;

