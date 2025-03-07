%仿真数据存成数组，数组转存为csv格式文件，Origin处理csv比较方便

% 创建时间列,运行步长是第2个参数，运行时长是第3个参数，根据需要改
time = (0:0.0001:4.0)';

% 组合时间和数据,数据存在数组里面，改名称就行（第二个参数）
combined_data1 = [time, Wm];
combined_data2 = [time, Te];
% combined_data3 = [time, a];
% combined_data4 = [time, Tso];

% 保存为 CSV 文件,此时保存的没有数据标题
writematrix(combined_data1, 'Wm_3.00_data.csv');
writematrix(combined_data2, 'Te_3.00_data.csv');
% writematrix(combined_data3, 'a_4.35_data.csv');
% writematrix(combined_data4, 'Tso_data.csv');

%数据标题
header1 = {'Time', 'Wm'};
writecell(header1, 'Wm_3.00_Simulation_Data.csv');
writematrix(combined_data1, 'Wm_3.00_Simulation_Data.csv', 'WriteMode', 'append');
% 
% %数据标题
header2 = {'Time', 'Te'};
writecell(header2, 'Te_3.00_Simulation_Data.csv');
writematrix(combined_data2, 'Te_3.00_Simulation_Data.csv', 'WriteMode', 'append');
% 
% %数据标题
% header3 = {'Time', 'a'};
% writecell(header3, 'a_4.35_Simulation_Data.csv');
% writematrix(combined_data3, 'a_4.35_Simulation_Data.csv', 'WriteMode', 'append');
% 
% %数据标题
% header4 = {'Time', 'Tso'};
% writecell(header4, 'Tso_Simulation_Data.csv');
% writematrix(combined_data4, 'Tso_Simulation_Data.csv', 'WriteMode', 'append');
