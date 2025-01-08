function[sys,x0,str,ts]=rls_ident_R_FAI(t,x,u,flag)
theta0=[0.5,0.1]; %被辨识参数的初值，R、Flux
Pn0=0.0008*eye(2); % 协方差矩阵
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
function[sys,x0,str,ts]=mdlInitializeSizes(theta0,Pn0)%初始化参数
sizes=simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates=6;
sizes.NumOutputs=2;
sizes.NumInputs=3;
sizes.DirFeedthrough=0;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[theta0';Pn0(:)];% 需要更新的状态向量的初值
str=[];
ts=[-1,0]; % 继承输入信号的采样时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)%根据当前数据更新矩阵并计算辨识值
h=[u(1),u(2)]';             %采集数据
Pn0=reshape(x(3:end),2,2);     %从状态变量中分离出p0
K=Pn0*h/(1+h'*Pn0*h);           %计算增益矩阵
Pn1=(Pn0-K*h'*Pn0);             %计算下一个协方差阵
theta0=x(1:2);               %从状态变量中分离出theta0
theta1=theta0+K*(u(3)-h'*0.96*theta0);  %计算下一个theta
sys=[theta1;Pn1(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlOutputs(t,x,u)%输出辨识值
theta1=x(1:2);
sys=theta1;
