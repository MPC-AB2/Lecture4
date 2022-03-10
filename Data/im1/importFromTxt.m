params = importdata(pathTxt);
% pat = digitsPattern
doffs = regexp(params(3),'\d+\.?\d*','match');
doffs = str2double(cell2mat(doffs{1}));

b = regexp(params(4),'\d+\.?\d*','match');
b = str2double(cell2mat(b{1}));

cam0 = regexp(params(1),'\d+\.?\d*','match');
cam0 = cell2table(cam0{1});
f01 = str2double(cell2mat(cam0.Var2));
f02 = str2double(cell2mat(cam0.Var6));
f0 = mean([f01, f02]);

cam1 = regexp(params(1),'\d+\.?\d*','match');
cam1 = cell2table(cam1{1});
f11 = str2double(cell2mat(cam1.Var2));
f12 = str2double(cell2mat(cam1.Var6));
f1 = mean([f11, f12]);

vmin= regexp(params(9),'\d+\.?\d*','match');
vmin = str2double(cell2mat(vmin{1}));
vmax= regexp(params(10),'\d+\.?\d*','match');
vmax = str2double(cell2mat(vmax{1}));