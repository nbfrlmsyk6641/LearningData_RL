function [IAE, ZeroCount] = IAE_ZD(Err)

%本函数实现了半个振动周期内IAE的运算，并统计一个滑动窗口内的过零点，如果过零点超出阈值可以判定谐振发生

persistent T IAE_Now IAE_Last Err_Last time zeroCrossCount counttime countstarttime IAE_Sum IAE_Count

%变量定义与初始化
if isempty(T)
    T = 0.0001;
    IAE_Now = 0;
    IAE_Last = 0;
    Err_Last = 0;
    time = 0;
    zeroCrossCount = 0;
    counttime = 100 * T;
    countstarttime = 0.3;
    IAE_Sum = 0; 
    IAE_Count = 0;
end

%算法在0.3s后开始计算IAE，以避免初始时的突变，误差过小也没有必要计算IAE
if (time >= 0.3)
    if sign(Err) == sign(Err_Last)
        IAE_Now = IAE_Now + abs(Err) * T;
    else
        IAE_Sum = IAE_Sum + IAE_Now;
        IAE_Now = 0;
        zeroCrossCount = zeroCrossCount + 1;
        IAE_Count = IAE_Count + 1;

        % 如果累计了10个误差积分值，计算平均值并输出
        if IAE_Count == 10
            IAE_Last = IAE_Sum / 10;
            IAE_Sum = 0; 
            IAE_Count = 0; 
        end
    end
end

% 检查是否超过时间窗口
if time - countstarttime >= counttime
    countstarttime = time; % 更新窗口开始时间
    zeroCrossCount = 0; % 重置过零点计数
end

time = time + T;
Err_Last = Err;

%抑制后一般难以维持到很完美的误差为0，认为IAE抑制到小于1e-4就算完成
if (IAE_Last < 1e-4)
    IAE_Last = 0;
    zeroCrossCount = 0;
end

IAE = IAE_Last;
ZeroCount = zeroCrossCount;

end

