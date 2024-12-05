warning off;

%加载设计好的模糊PID控制器
a = readfis('fuzzpid');

%积分时间
ts = 0.001;

%控制对象定义，连续域定义后利用零阶保持法进行离散化
sys = tf(133,[1,25,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0;u_2 = 0;
y_1 = 0;y_2 = 0;

%误差、误差变化率、误差积分
e_1 = 0;ec_1 = 0;ei = 0;

%控制参数初始化
kp0 = 0;ki0 = 0;

%开始控制过程
for k = 1:1:1000
    %生成时间
    time(k) = k * ts;
    %期望值为1
    r(k) = 1;
    
    %控制器输出
    k_pid = evalfis([e_1,ec_1],a);
    kp(k) = kp0 + k_pid(1);
    ki(k) = ki0 + k_pid(2);
    %计算当前模糊PID控制器的控制量
    u(k) = kp(k) * e_1 + ki(k) * ei;

    %控制量输入至系统，计算系统响应
    %这里很特殊，系统的输出是用差分方程的形式计算
    y(k) = -den(2)*y_1 - den(3)*y_2 + num(2)*u_1 +num(3)*u_2;

    %计算误差
    e(k) = r(k) - y(k);

    u_2 = u_1;u_1 = u(k);
    y_2 = y_1;y_1 = y(k);

    %计算误差积分量、上一次误差
    ei = ei + e(k) * ts;
    ec(k) = e(k) - e_1;
    e_1 = e(k);
    ec_1 = ec(k);
end

%控制结束，控制过程可视化
figure(1);
plot(time,r,'r',time,y,'b:','LineWidth',2);
xlabel('time(s)');ylabel('r,y');
legend('Ideal position','Practical position');
figure(2);
subplot(211);
plot(time,kp,'r','LineWidth',2);
xlabel('time(s)');ylabel('kp');
subplot(212);
plot(time,ki,'r','LineWidth',2);
xlabel('time(s)');ylabel('ki');
figure(3);
plot(time,u,'r','LineWidth',2);
xlabel('time(s)');ylabei('Control input');

