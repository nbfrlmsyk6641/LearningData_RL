function [IAE, ZeroCount] = IAE_ZD(Err)

persistent T IAE_Now IAE_Last Err_Last time zeroCrossCount counttime countstarttime

if isempty(T)
    T = 0.0001;
    IAE_Now = 0;
    IAE_Last = 0;
    Err_Last = 0;
    time = 0;
    zeroCrossCount = 0;
    counttime = 100 * T;
    countstarttime = 0.5;
end

if time >= 0.5
    if sign(Err) == sign(Err_Last)
        IAE_Now = IAE_Now + abs(Err) * T;
    else
    %检测出过零点,输出上一次的IAE，清零IAE
        IAE_Last = IAE_Now;
        IAE_Now = 0;
        zeroCrossCount = zeroCrossCount + 1;
    end
end

% 检查是否超过时间窗口
if time - countstarttime >= counttime
    countstarttime = time; % 更新窗口开始时间
    zeroCrossCount = 0; % 重置过零点计数
end

time = time + T;
Err_Last = Err;

IAE = IAE_Last;
ZeroCount = zeroCrossCount;

end



