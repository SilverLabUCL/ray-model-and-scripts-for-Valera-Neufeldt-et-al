function plot_Planes(OP,xFOV,yFOV,zFOV)
%% Plots the six sides of the FOV volume and the z = 0 plane

%% Plane at z = 0:
Pt1 = [OP.FOV_um./0.8.*1e-3,OP.FOV_um./0.8.*1e-3,0];
Pt2 = [-OP.FOV_um./0.8.*1e-3,OP.FOV_um./0.8.*1e-3,0];
Pt3 = [OP.FOV_um./0.8.*1e-3,-OP.FOV_um./0.8.*1e-3,0];
Pt4 = [-OP.FOV_um./0.8.*1e-3,-OP.FOV_um./0.8.*1e-3,0];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'k', 'FaceAlpha', 0.2)
hold on

%% Six sides of the FOV:
Pt1 = [xFOV(1,2),yFOV(1,1),zFOV(1)];
Pt2 = [xFOV(1,2),yFOV(1,2),zFOV(1)];
Pt3 = [xFOV(end,2),yFOV(end,1),zFOV(end)];
Pt4 = [xFOV(end,2),yFOV(end,2),zFOV(end)];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'r', 'FaceAlpha', 0.01)
hold on

Pt1 = [xFOV(1,1),yFOV(1,1),zFOV(1)];
Pt2 = [xFOV(1,1),yFOV(1,2),zFOV(1)];
Pt3 = [xFOV(end,1),yFOV(end,1),zFOV(end)];
Pt4 = [xFOV(end,1),yFOV(end,2),zFOV(end)];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'r', 'FaceAlpha', 0.1)
hold on

Pt1 = [xFOV(1,1),yFOV(1,2),zFOV(1)];
Pt2 = [xFOV(1,2),yFOV(1,2),zFOV(1)];
Pt3 = [xFOV(end,1),yFOV(end,2),zFOV(end)];
Pt4 = [xFOV(end,2),yFOV(end,2),zFOV(end)];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'r', 'FaceAlpha', 0.1)
hold on

Pt1 = [xFOV(1,1),yFOV(1,1),zFOV(1)];
Pt2 = [xFOV(1,2),yFOV(1,1),zFOV(1)];
Pt3 = [xFOV(end,1),yFOV(end,1),zFOV(end)];
Pt4 = [xFOV(end,2),yFOV(end,1),zFOV(end)];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'r', 'FaceAlpha', 0.1)
hold on

Pt1 = [xFOV(1,1),yFOV(1,1),zFOV(1)];
Pt2 = [xFOV(1,1),yFOV(1,2),zFOV(1)];
Pt3 = [xFOV(1,2),yFOV(1,1),zFOV(1)];
Pt4 = [xFOV(1,2),yFOV(1,2),zFOV(1)];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'r', 'FaceAlpha', 0.1)
hold on

Pt1 = [xFOV(end,1),yFOV(end,1),zFOV(end)];
Pt2 = [xFOV(end,1),yFOV(end,2),zFOV(end)];
Pt3 = [xFOV(end,2),yFOV(end,1),zFOV(end)];
Pt4 = [xFOV(end,2),yFOV(end,2),zFOV(end)];
PlanePts = [Pt2; Pt1; Pt3; Pt4];

fill3(PlanePts(:,1),PlanePts(:,2),PlanePts(:,3),'r', 'FaceAlpha', 0.1)
hold on
end
