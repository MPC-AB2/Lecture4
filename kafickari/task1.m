%% nacteni obrazku
% Depth_map = cell(1,5);
paths = 'C:\Users\xschne08\Documents\mpc_ab2\Lecture4\Data';
% for i = 1:5
% 
% im0 = imread([paths, num2str(i),'\im0.png']);
% im1 = imread([paths, num2str(i),'\im1.png']);
% info = readcell([paths, num2str(i),'\calib.txt']);
% 
% Z = depth_map(im0, im1, info);
% Depth_map{1,i} = Z;
% end
% 
info = readcell([paths,'\im', num2str(i),'\calib.txt']);
    f1 = str2num(info{1,2});
    f2 = str2num(info{2,2});
K = [f1; f2];

% depth = kafickari(paths);
depth = Depth_map{1,2};
Sd = size(depth);
[X,Y] = meshgrid(1:Sd(2),1:Sd(1));
%K is calibration matrix
X = X - K(1,3) + 0.5;
Y = Y - K(2,3) + 0.5;
XDf = depth/K(1,1);
YDf = depth/K(2,2);
X = X .* XDf;
Y = Y .* YDf;
XY = cat(3,X,Y);
cloud = cat(3,XY,depth);
cloud = reshape(cloud,[],3) / 1000.0;
% if you can use matlab point cloud library
cloud = pointCloud(cloud);
pcshow(cloud);