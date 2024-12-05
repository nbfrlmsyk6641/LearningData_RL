function [Kp, Ki] = defuzzification(kp_range, kp_aggregated, ki_range, ki_aggregated)
% 解模糊函数，计算精确的 Kp 和 Ki，用重心法解模糊

% 计算 Kp 的重心
numerator_kp = sum(kp_range .* kp_aggregated);
denominator_kp = sum(kp_aggregated);
if denominator_kp ~= 0
    Kp = numerator_kp / denominator_kp;
else
    Kp = 0; % 避免除以零的情况
end

% 计算 Ki 的重心
numerator_ki = sum(ki_range .* ki_aggregated);
denominator_ki = sum(ki_aggregated);
if denominator_ki ~= 0
    Ki = numerator_ki / denominator_ki;
else
    Ki = 0; % 避免除以零的情况
end

end

