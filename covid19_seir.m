clear all ;
clc ; 
clear; 

time = [0 180];
N = 5.0e6;
init = [N  - 40 - 800; 800; 40;  0];
rtol = 1.e-6; 
atol = 1.e-5;
options = odeset('AbsTol',atol,'RelTol',rtol,'MaxOrder',5);
days = 0:180;
maxd = 181;

rtzero1 = 3.5;
rtzero2 = zeros(1,maxd);
rtzero3 = zeros(1,maxd);
rtzero4 = zeros(1,maxd);

rtable2 = [1  3.5 ; 21 2.6; 71 1.9; 85 1.0; 91 0.55; 111 0.55; 1001 0.5];
rtable3 = [1 3; 21 2.2 ; 71 0.7 ; 85 0.8 ; 91  1.00; 111 0.9; 1001 0.5];
rtable4 = [1 3; 21 2.2 ; 71 0.9 ; 85 2.5 ; 91  3.20; 111 0.85; 1001 0.5];

for j = 1:6
    constdays = min(rtable2(j+1,1) , maxd+1) - rtable2(j,1);
    rtzero2(rtable2(j,1):rtable2(j,1)+constdays-1) = rtable2(j,2)*ones(1,constdays);
    
    constdays = min(rtable3(j+1,1) , maxd+1) - rtable3(j,1);
    rtzero3(rtable3(j,1):rtable3(j,1)+constdays-1) = rtable3(j,2)*ones(1,constdays);
    
    constdays = min(rtable4(j+1,1) , maxd+1) - rtable4(j,1);
    rtzero4(rtable4(j,1):rtable4(j,1)+constdays-1) = rtable4(j,2)*ones(1,constdays);
end

%rtzero = 3.5;
[t1,y1] = ode45( @(t1,y1) seir_const(t1,y1, days, 3.5), time, init, options) ;
[t2,y2] = ode45( @(t2,y2) seir(t2,y2, days, rtzero2), time, init, options) ;
[t3,y3] = ode45( @(t3,y3) seir(t3,y3, days, rtzero3), time, init, options) ;
[t4,y4] = ode45( @(t4,y4) seir(t4,y4, days, rtzero4), time, init, options) ;

figure 
subplot(2,1,1);
hold on
plot(t1, y1(:,2) + y1(:,3));
plot(t2, y2(:,2) + y2(:,3));
plot(t3, y3(:,2) + y3(:,3));
plot(t4, y4(:,2) + y4(:,3));
legend('Scenario 1','Scenario 2','Scenario 3','Scenario 4');
hold off;
title('Active cases: E + I');
xlabel("Time(Days)");
ylabel("Cases");

subplot(2,1,2);
hold on;
plot(t1, y1(:,2) + y1(:,3) + y1(:,4));
plot(t2, y2(:,2) + y2(:,3) + y2(:,4));
plot(t3, y3(:,2) + y3(:,3) + y3(:,4));
plot(t4, y4(:,2) + y4(:,3) + y4(:,4));
legend('Location','west');
set(gca,'yscale','log')
legend('Scenario 1','Scenario 2','Scenario 3','Scenario 4');
hold off;
title('Total cases: E + I + R ');
xlabel("Time(Days)");
ylabel("Cases");


hosp_num1= [];
icu_num1 = [];
hosp_num2= [];
icu_num2 = [];
hosp_num3= [];
icu_num3 = [];
hosp_num4= [];
icu_num4 = [];

for i = 1:465
    hosp = 0.08 * y1(i,3);
    hosp_num1 = [hosp_num1, hosp];
    icu = 0.01 * y1(i,3);
    icu_num1 = [icu_num1, icu];
end
hosp_num1 = hosp_num1(:);
icu_num1 = icu_num1(:);

for i = 1:513
    hosp = 0.08 * y2(i,3);
    hosp_num2 = [hosp_num2, hosp];
    icu = 0.01 * y2(i,3);
    icu_num2 = [icu_num2, icu];
end
hosp_num2 = hosp_num2(:);
icu_num2 = icu_num2(:);

for i = 1:497
    hosp = 0.08 * y3(i,3);
    hosp_num3 = [hosp_num3, hosp];
    icu = 0.01 * y3(i,3);
    icu_num3 = [icu_num3, icu];
end
hosp_num3 = hosp_num3(:);
icu_num3 = icu_num3(:);

for i = 1:593
    hosp = 0.08 * y4(i,3);
    hosp_num4 = [hosp_num4, hosp];
    icu = 0.01 * y4(i,3);
    icu_num4 = [icu_num4, icu];
end
hosp_num4 = hosp_num4(:);
icu_num4 = icu_num4(:);


figure 
subplot(2,1,1);
hold on
plot(t1, hosp_num1(:,1));
plot(t2, hosp_num2(:,1));
plot(t3, hosp_num3(:,1));
plot(t4, hosp_num4(:,1));
set(gca,'yscale','log')
yline(3500,'-','Capacity','LineWidth',1);
legend('Location','south');
legend('Scenario 1','Scenario 2','Scenario 3','Scenario 4');
title("Acute Care Bed Demand");
xlabel("Time(Days)");
ylabel("Cases");
hold off

subplot(2,1,2);
hold on
semilogy(t1, icu_num1(:,1));
semilogy(t2, icu_num2(:,1));
semilogy(t3, icu_num3(:,1));
semilogy(t4, icu_num4(:,1));
set(gca,'yscale','log')
legend('Location','south');
yline(160,'-','Capacity','LineWidth',1);
legend('Scenario 1','Scenario 2','Scenario 3','Scenario 4');
title("ICU Bed Demand");
xlabel("Time(Days)");
ylabel("Cases");
hold off

%total deaths
deaths = [];
for i = 1:189
  den = (y1(end,4) * 0.04 ) / 5  ;
  deaths = [deaths, den];
end
deaths = deaths(:);


%{
CODE FOR ALTERNATIVE FIGURES
figure 
subplot(2,1,1);
plot(t, y(:,2) + y(:,3));
title({'Scenario 1';'Active cases: E + I'});
xlabel("Time(Days)");
ylabel("Cases");
subplot(2,1,2);
plot(t, y(:,2) + y(:,3) + y(:,4));
title('Total cases: E + I + R ');
xlabel("Time(Days)");
ylabel("Cases");
% 3500/5600 hospital bed, 160/200 icu beds
% 8% infected go into hospital beds
% 1% infected go into icu beds 
% plot number of covid pateitns in hispital and in icus and compare to
% capacity 
hosp_num= [ ];
icu_num = [];
for i = 1:513
    disp(y(i,3));
    hosp = 0.08 * y(i,3);
    if hosp >= 3500
    hosp = 3500;
    end
    hosp_num = [hosp_num, hosp];
    icu = 0.01 * y(i,3);
    if icu >= 160 
        icu = 160;
    end
    icu_num = [icu_num, icu];
end
hosp_num = hosp_num(:);
icu_num = icu_num(:);
figure 
subplot(2,1,1);
plot(t, hosp_num(:,1));
title({"Scenario 1";"Hospital beds in use"});
xlabel("Time(Days)");
ylabel("Cases");
subplot(2,1,2);
plot(t, icu_num(:,1));
title("ICU beds in use");
xlabel("Time(Days)");
ylabel("Cases");

figure 
subplot(4,1,1);
plot(t, y(:,1));
title({"Scenario 1";"S with R0 = 3.5"});
%title({"Scenario 4";"S with time dependent R0"});
%title("Susceptible");
xlabel("Time(Days)");
ylabel("Cases");
subplot(4,1,2);
plot(t, y(:,2));
xlabel("Time(Days)");
ylabel("Cases");
title("E with R0 = 3.5");
%title("E with time dependent R0");
%title("Exposed");
subplot(4,1,3);
plot(t, y(:,3));
xlabel("Time(Days)");
ylabel("Cases");
title("I with R0 = 3.5");
%title("I with time dependent R0");
%title("Infected");
subplot(4,1,4);
plot(t, y(:,4));
xlabel("Time(Days)");
ylabel("Cases");
title("R with R0 = 3.5");
%title("R with time dependent R0");
%title("Recovered/Removed");
%}