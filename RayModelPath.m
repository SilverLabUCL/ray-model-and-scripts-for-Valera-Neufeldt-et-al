function model_path = RayModelPath()
    model_path = strrep([fileparts(which('RayModelPath')),'\'],'\','/');
    addpath([model_path,'Model/']);
end

