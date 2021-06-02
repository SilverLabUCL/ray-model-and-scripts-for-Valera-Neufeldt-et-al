
%% It is recommended to clear the workspace before starting
% clear all

%% Add path
cd(strrep([fileparts(fileparts(which('generate_all_figures'))),'\'],'\','/'))
main_path = initialise_script(); %also called in every function

%% Generate all figures
Figure2();
Figure3d();
Figure4e();
Figure4f();
Figure4gh();
Figure5c();
Figure5d();
FigureS4();
FigureS5();
FigureS6();
FigureS7a();
FigureS7b();
FigureS8();
FigureS10a();
FigureS10d();
FigureS10f();

% clear all