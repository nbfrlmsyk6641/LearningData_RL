%仿真数据存成数组，数组转存为csv格式文件，Origin处理csv比较方便

% 创建时间列,运行步长是第2个参数，运行时长是第3个参数，根据需要改
time = (0:0.0001:2.0)';

% 组合时间和数据,数据存在数组里面，改名称就行（第二个参数）
combined_data1 = [time, Wm0];
combined_data2 = [time, Wm];
combined_data3 = [time, Te0];
combined_data4 = [time, Te];
combined_data5 = [time, beta];

% 保存为 CSV 文件,此时保存的没有数据标题
writematrix(combined_data1, 'Wm0_0.5_data.csv');
writematrix(combined_data2, 'Wm_0.5_data.csv');
writematrix(combined_data3, 'Te0_0.5_data.csv');
writematrix(combined_data4, 'Te_0.5_data.csv');
writematrix(combined_data5, 'beta_0.5_data.csv');


%数据标题
header1 = {'Time', 'Wm0'};
writecell(header1, 'Wm0_0.5_Simulation_Data.csv');
writematrix(combined_data1, 'Wm0_0.5_Simulation_Data.csv', 'WriteMode', 'append');

% 
%数据标题
header2 = {'Time', 'Wm'};
writecell(header2, 'Wm_0.5_Simulation_Data.csv');
writematrix(combined_data2, 'Wm_0.5_Simulation_Data.csv', 'WriteMode', 'append');


%数据标题
header3 = {'Time', 'Te0'};
writecell(header3, 'Te0_0.5_Simulation_Data.csv');
writematrix(combined_data3, 'Te0_0.5_Simulation_Data.csv', 'WriteMode', 'append');

 
%数据标题
header4 = {'Time', 'Te'};
writecell(header4, 'Te_0.5_Simulation_Data.csv');
writematrix(combined_data4, 'Te_0.5_Simulation_Data.csv', 'WriteMode', 'append');


%数据标题
header5 = {'Time', 'beta'};
writecell(header5, 'beta_0.5_Simulation_Data.csv');
writematrix(combined_data5, 'beta_0.5_Simulation_Data.csv', 'WriteMode', 'append');


