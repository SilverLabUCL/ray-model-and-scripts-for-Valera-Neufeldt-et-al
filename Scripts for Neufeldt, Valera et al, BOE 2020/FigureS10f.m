
%% Script to generate Figure 3d. F.N. 25.05.2021
mainFolder = initialise_script('S10f');

[OP,Scan,DC,Z,Exp] = setup_FigS10f;

Set = {'Before','After_100um','After_200um'};
BA = {'Before','After','After'};
dwellTimes = {'5e-08','1e-07','2e-07'};
dwellTimes_ns = [50,100,200];
Colours = {'DeepPink','Black','ForestGreen'};
figure(); hold on;

for i_set = 1:3
    
    for dwellTime = 1:3
        
        Exp.dataLocation = [mainFolder,path_for_figures, 'FigureS10f/',char(Set(i_set)),'/'];
        Exp.fileName = ['yScan_',char(BA(i_set)),'_aa0_005_dt',char(dwellTimes(dwellTime)),'.xml'];
        
        if i_set == 2
        Exp.numberPlanes = 41;
        else
        Exp.numberPlanes = 81;
        end
        
        colour = rgb('Red');
        to_plot = false;
        [Error,STD,STE] = plot_BeadTrajectories(OP,Scan,Exp,colour,to_plot);
        
        figure(gcf)
        scatter(dwellTimes_ns(dwellTime),Error,90,'o','MarkerFaceColor',rgb(Colours(i_set)),'MarkerEdgeColor',rgb(Colours(i_set)));
        errorbar(dwellTimes_ns(dwellTime),Error,STE,'LineStyle','none','Color',rgb(Colours(i_set)),'LineWidth',1.5,'CapSize',15);
        xlim([25,225])
        xticks([50,100,200])
        yticks(0:0.2:2)
        xlabel('Dwell Time (ns)')
        ylabel('Mean Error (\mum)')
        title('Figure S10(f)')
        set(gca, 'FontName', 'times','FontSize',16)
        set(gcf, 'Renderer', 'Painters')
    end
end

%%
cd(mainFolder)
