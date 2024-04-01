%%friction factor Moody
clc

%%initial Test
ReD = 10^3
eD = 0.002
f =friction_factor(ReD,eD)

%% Let's recreat the famous Moody diagram
eD = [0.05,0.04,0.03,0.02,0.015,0,01,0.008,0,006,0.004,0.002,0.001];
ReD = logspace(3,8,100);
for i = 1:length(eD)
    for j = 1:length(ReD)
        f(i,j) =friction_factor(ReD(j),eD(i));
    end
end
loglog(ReD,f,'LineWidth',1.5)
grid on
legend(num2str(eD'))
xlabel('ReD')
ylabel('f')
