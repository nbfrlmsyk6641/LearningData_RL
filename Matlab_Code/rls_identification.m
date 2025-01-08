function[sys,x0,str,ts]=rls_ident(t,x,u,flag)
theta0=[0.001]; %����ʶ�����ĳ�ֵ��L
Pn0=1000000*eye(1);% ȡ��ִ��ʵ��
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
sizes.NumContStates=0;    %����״̬������Ԫ����Ŀ
sizes.NumDiscStates=2;    %��ɢ״̬������Ԫ����Ŀ  �����ĸ�����theta��Pn��Ԫ���ܺ�
sizes.NumOutputs=1;       %���������Ԫ����Ŀ
sizes.NumInputs=2;        %����������Ԫ����Ŀ
sizes.DirFeedthrough=0;   %�����Ƿ�ֱ�ӷ��������
sizes.NumSampleTimes=1;   % ����ʱ������������������ڵ���1�������̶�Ϊ2
sys=simsizes(sizes);      % �����ϸ�ֵ�õĽṹ��������ֵ
x0=[theta0';Pn0(:)];%   ������Ҫ���µ�״̬�����ĳ�ֵ
str=[];
ts=[-1,0]; % �̳������źŵĲ���ʱ�䣬-1Ϊ�̳У�����ʱ��Ϊ1e-5
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)
h=[u(1)]';             %�ɼ�����
Pn0=reshape(x(2:end),1,1);     %��״̬�����з����p0
K=Pn0*h*inv(eye(1)*0.95+h'*Pn0*h);           %�����������
Pn1=(Pn0-K*h'*Pn0)*1/0.95;             %������һ��Э������
theta0=x(1:1); %��״̬�����з����theta0
y=[u(2)]
theta1=theta0+K*(y-h'*1*theta0);  %������һ��theta
sys=[theta1;Pn1(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlOutputs(t,x,u)
theta1=x(1:1);
sys=theta1;
