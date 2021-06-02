function plot_OpticalPath(OP,Z,RaysX,RaysY)

%% Ray plot through AODs, relay lenses and objective
figure(); hold on;
xlabel('Z (m)')
ylabel('Y (m)')
zlabel('X (m)')
set(gca, 'FontName', 'times','FontSize',16)
pbaspect([2 1 1])
plot3(Z.Zplanes,RaysX,RaysY,'Color',[0 0.4 0.7],'LineWidth',0.8);

% AOD centre point and optical axis:
plot3([Z.Zaod(4)-OP.zError Z.Zaod(4)-OP.zError],[0 0],[0 0],'o','Color','r','MarkerFaceColor','r','MarkerSize',2.5);
% Relay lens 1:
plot3([Z.Zplanes(6),Z.Zplanes(6)],[0,0],[-0.009,0.009],'Color',rgb('DeepSkyBlue'),'LineWidth',1.5)
% Relay focus:
plot3([Z.Zplanes(6)-OP.f_R1, Z.Zplanes(6)-OP.f_R1],[0,0],[-0.009,0.009],'--','Color',rgb('Crimson'),'LineWidth',1.5)
% Relay lens 2:
plot3([Z.Zplanes(7),Z.Zplanes(7)],[0,0],[-0.009,0.009],'Color',rgb('DeepSkyBlue'),'LineWidth',1.5)
% Objective lens:
plot3([Z.Zplanes(9),Z.Zplanes(9)],[0,0],[-0.009,0.009],'Color',rgb('DimGray'),'LineWidth',1.5)

xlim([-1.1,-0.4])
ylim([-0.01,0.01])
zlim([-0.01,0.01])
view([180,0])
set(gcf, 'Renderer', 'Painters');

end
