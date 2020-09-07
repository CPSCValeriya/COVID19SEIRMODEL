function s = seir(t,y, days,rtzero)

alpha = 1/5.2;
gamma = (1/10);
%r0 = 1.25;
N = 5.0e6;
r0 = interp1(days, rtzero, t);
%r0 = 3.5;
beta = r0*gamma;


% S = Y(1), E = Y(2), I = Y(3) , R = Y(4)
% ds/dt  = -beta * s * I / N
s(1) = -beta * y(1) * (y(3)/N);
% dE/dt = beta * S * I / N - alpha * E
s(2) = beta*y(1)*(y(3)/N) - alpha*y(2);
% dI/dt = alpha*E - gamma*I
s(3) = alpha*y(2) - gamma*y(3);
%dR/dt = gamma*I
s(4) = gamma*y(3);

s = s(:);

end