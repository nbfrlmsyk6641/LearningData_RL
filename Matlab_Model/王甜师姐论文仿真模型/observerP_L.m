clear all
close all
jm=1.59e-4;
jl=2.29e-3;
ks=570;
A=[0 0 -1/jm 0;0 0 1/jl -1/jl;ks -ks 0 0;0 0 0 0];
B=[1/jm ;0; 0; 0];
[G,H]=c2d(A,B,0.001);%�Ծ���A��B�ֱ������ɢ�������в���ʱ��Ϊ1ms

syms s l1 l2 l3 l4 L;
L=[l1;l2;l3;l4];%״̬��������
C=[1 0 0 0];
X1=vpa(expand((s-0.8)^4));
X2=vpa(det(s*eye(4)-(A-L.*C)));%��Ϊ����ɢ��ϵͳ������ֵ
X=X1-X2;
res1=fliplr(coeffs(X,s));
x=solve([res1(1)==0,res1(2)==0,res1(3)==0,res1(4)==0])
%disp("��������")
L = [x.l1;x.l2;x.l3;x.l4 ]
disp("�������õ��ˣ�")
vpa((G-L.*C));
H;