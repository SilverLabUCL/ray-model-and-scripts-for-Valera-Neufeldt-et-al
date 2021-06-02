%% Script to generate Figure S10d. F.N. 25.05.2021
mainFolder = initialise_script('S10d');

[OP,Scan,DC,Z,Exp] = setup_FigS10d(mainFolder);

%% Plot the experimental (red) trajectories
figure(); hold on
colour = rgb('Red');
to_plot = true;
[~,~,~] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);    % Data set 1
Exp.fileName = 'yScan_aa0_005_dt2e-07_2_Tracks.xml';
[~,~,~] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);    % Data set 2
title('Figure S10(d)')
set (gca,'Xdir','reverse')
set (gca,'Ydir','reverse')
xlim([-130,130])
ylim([-130,130])
ylabel('Scan direction (\mum)')
xlabel('Non-scan direction (\mum)')
set(gca, 'FontName', 'times','FontSize',16)
set(gcf, 'Renderer', 'Painters');
%%
cd(mainFolder)