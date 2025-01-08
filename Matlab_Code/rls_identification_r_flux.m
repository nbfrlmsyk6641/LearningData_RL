function[sys,x0,str,ts]=rls_ident_R_FAI(t,x,u,flag)
theta0=[0.5,0.1]; %����ʶ�����ĳ�ֵ��R��Flux
Pn0=0.0008*eye(2); % Э�������
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
function[sys,x0,str,ts]=mdlInitializeSizes(theta0,Pn0)%��ʼ������
sizes=simsizes;
sizes.NumContStates=0;
sizes.NumDiscStates=6;
sizes.NumOutputs=2;
sizes.NumInputs=3;
sizes.DirFeedthrough=0;
sizes.NumSampleTimes=1;
sys=simsizes(sizes);
x0=[theta0';Pn0(:)];% ��Ҫ���µ�״̬�����ĳ�ֵ
str=[];
ts=[-1,0]; % �̳������źŵĲ���ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlUpdate(t,x,u)%���ݵ�ǰ���ݸ��¾��󲢼����ʶֵ
h=[u(1),u(2)]';             %�ɼ�����
Pn0=reshape(x(3:end),2,2);     %��״̬�����з����p0
K=Pn0*h/(1+h'*Pn0*h);           %�����������
Pn1=(Pn0-K*h'*Pn0);             %������һ��Э������
theta0=x(1:2);               %��״̬�����з����theta0
theta1=theta0+K*(u(3)-h'*0.96*theta0);  %������һ��theta
sys=[theta1;Pn1(:)];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sys=mdlOutputs(t,x,u)%�����ʶֵ
theta1=x(1:2);
sys=theta1;
