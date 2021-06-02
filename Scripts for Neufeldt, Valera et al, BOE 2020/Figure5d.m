%% Script to generate Figure 5d. F.N. 25.05.2021

% Set up
mainFolder = initialise_script('5d');
[OP,Scan,DC,Z,Exp] = setup_Fig5d(mainFolder);

%% Plot experimental bead trajectories after distortion precompensation
figure()
colour = rgb('Black');
to_plot = true;
[Error,STD,STE] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);
title('Figure 5(d)')
ylabel('Scan direction (\mum)')
xlabel('Non-scan direction (\mum)')
xlim([-205,205])
ylim([-205,205])
set(gca, 'FontName', 'times','FontSize',16)
set(gcf, 'Renderer', 'Painters');
%%
cd(mainFolder)