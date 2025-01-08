function[sys,x0,str,ts]=rls_ident(t,x,u,flag)
theta0=[0.001]; %被辨识参数的初值，L
Pn0=1000000*eye(1);% 取充分大的实数
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes(theta0,Pn0);
    case 2,
        sys=mdlUpdate(t,x,u);
    case 3,
        sys=mdlOutputs(t,x,u);
    case {1,4,9}
        sys=[];
    otherwise
        error(['Unhanded flag=',num2str(flag)]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[sys,x0,str,ts]=mdlInitializeSizes(theta0,Pn0)
sizes=simsizes;
sizes.NumContStates=0;    %连续状态向量的元素数目
sizes.NumDiscStates=2;    %离散状态向量的元素数目  向量的个数是theta和Pn的元素总和
sizes.NumOutputs=1;       %输出向量的元素数目
sizes.NumInputs=2;        %输入向量的元素数目
sizes.DirFeedthrough=0;   %输入是否直接反馈到输出
sizes.NumSampleTimes=1;   % 采样时间矩阵的行数，必须大于等于1，列数固定为2
sys=simsizes(sizes);      % 把以上赋值好的结构赋给返回值
x0=[theta0';Pn0(:)];%   设置需要更新的状态向量的初值
str=[];
ts=[-1,0]; % 继承输入信号的采样时间，-1为继承，采样时间为1e-5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)
h=[u(1)]';             %采集数据
Pn0=reshape(x(2:end),1,1);     %从状态变量中分离出p0
K=Pn0*h*inv(eye(1)*0.95+h'*Pn0*h);           %计算增益矩阵
Pn1=(Pn0-K*h'*Pn0)*1/0.95;             %计算下一个协方差阵
theta0=x(1:1); %从状态变量中分离出theta0
y=[u(2)]
theta1=theta0+K*(y-h'*1*theta0);  %计算下一个theta
sys=[theta1;Pn1(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlOutputs(t,x,u)
theta1=x(1:1);
sys=theta1;
