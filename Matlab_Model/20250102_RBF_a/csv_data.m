%仿真数据存成数组，数组转存为csv格式文件，Origin处理csv比较方便

% 创建时间列,运行步长是第2个参数，运行时长是第3个参数
time = (0:0.0001:4.0)';

% 组合时间和数据,数据存在数组里面，改名称就行
combined_data = [time, Te];

% 保存为 CSV 文件,此时保存的没有数据标题
writematrix(combined_data, 'Te_4.35_data.csv');

%数据标题
header = {'Time', 'Te'};
writecell(header, 'Te_Simulation_4.35_Data.csv');
writematrix(combined_data, 'Te_Simulation_4.35_Data.csv', 'WriteMode', 'append');
