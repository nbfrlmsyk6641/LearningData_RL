clear all;
close all;
a = newfis('fuzzpid');

%参数e的隶属度函数
a = addvar(a,'input','e',[-1,1]);
a = addmf(a,'input',1,'N','zmf',[-1,-1/3]);
a = addmf(a,'input',1,'Z','trimf',[-2/3,0,2/3]);
a = addmf(a,'input',1,'P','smf',[1/3,1]);

%参数ec的隶属度函数
a = addvar(a,'input','ec',[-1,1]);
a = addmf(a,'input',2,'N1','zmf',[-1,-1/3]);
a = addmf(a,'input',2,'Z1','trimf',[-2/3,0,2/3]);
a = addmf(a,'input',2,'P1','smf',[1/3,1]);

%参数kp的隶属度函数
a = addvar(a,'output','kp',1/3 * [-10,10]);
a = addmf(a,'output',1,'N2','zmf',1/3 * [-10,-4]);
a = addmf(a,'output',1,'Z2','trimf',1/3 * [-5,0,5]);
a = addmf(a,'output',1,'P2','smf',1/3 * [4,10]);

%参数ki的隶属度函数
a = addvar(a,'output','ki',1/30 * [-3,3]);
a = addmf(a,'output',2,'N3','zmf',1/30 * [-3,-1]);
a = addmf(a,'output',2,'Z3','trimf',1/30 * [-2,0,2]);
a = addmf(a,'output',2,'P3','smf',1/30 * [1,3]);

%定义模糊规则表
rulelist = [1 1 1 2 1 1;
            1 2 1 2 1 1;
            1 3 1 2 1 1;
            2 1 1 3 1 1;
            2 2 3 3 1 1;
            2 3 3 3 1 1;
            3 1 3 2 1 1;
            3 2 3 2 1 1;
            3 3 3 2 1 1;];

%添加模糊规则,保存模糊控制器
a = addrule(a,rulelist);
a = setfis(a,'DefuzzMethod','centroid');
writeFIS(a,'fuzzpid');

%模糊控制器可视化
a = readfis('fuzzpid');
figure(1);
plotmf(a,'input',1);
figure(2);
plotmf(a,'input',2);
figure(3);
plotmf(a,'output',1);
figure(4);
plotmf(a,'output',2);
figure(5);
plotfis(a);

% 查看模糊规则
showrule(a);
ruleview('fuzzpid');

