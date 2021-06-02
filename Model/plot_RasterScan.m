%% Plot the modelled raster scan
function plot_RasterScan(OP,Scan,FocalPositions,colour,figTitle,transparency)
figure(gcf)
centre = round(size(FocalPositions,4)/2);

xyz = permute(FocalPositions, [1,3,4,2]);
xyz_start = permute(FocalPositions(:,:,:,1), [1,3,4,2]);
xyz_centre = permute(FocalPositions(:,:,:,centre), [1,3,4,2]);
xyz = reshape(xyz, [], 3);
xyz_start = reshape(xyz_start, [], 3);
xyz_centre = reshape(xyz_centre, [], 3);

if strcmp(Scan.ScanDirection,'x')
    
    scatter3(xyz(:,2),xyz(:,1),xyz(:,3),100,'.','MarkerEdgeColor',colour,'MarkerEdgeAlpha',transparency); hold on
    scatter3(xyz_start(:,2),xyz_start(:,1),xyz_start(:,3),100,'+','MarkerEdgeColor',rgb('DarkOrange'),'LineWidth',1.5); hold on
    scatter3(xyz_centre(:,2),xyz_centre(:,1),xyz_centre(:,3),100,'x','MarkerEdgeColor',rgb('Gray'),'LineWidth',1.5); hold on
    
elseif strcmp(Scan.ScanDirection,'y')
    
    scatter3(xyz(:,1),-xyz(:,2),xyz(:,3),100,'.','MarkerEdgeColor',colour,'MarkerEdgeAlpha',transparency); hold on
    scatter3(xyz_start(:,1),-xyz_start(:,2),xyz_start(:,3),100,'+','MarkerEdgeColor',rgb('DarkOrange'),'LineWidth',1.5); hold on
    scatter3(xyz_centre(:,1),-xyz_centre(:,2),xyz_centre(:,3),100,'x','MarkerEdgeColor',rgb('Gray'),'LineWidth',1.5); hold on
    
end

title(figTitle)
ylabel('Scan direction (\mum)')
xlabel('Non-scan direction (\mum)')
zlabel('Z (\mum)')
xlim ([-OP.FOV_um/2 OP.FOV_um/2])
ylim ([-OP.FOV_um/2 OP.FOV_um/2])
set(gca, 'FontName', 'times','FontSize',16)
view([0,90])
axis equal
set(gcf, 'Renderer', 'Painters');
end