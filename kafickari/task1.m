%% nacteni obrazku
Depth_map = cell(1,5);
paths = 'C:\Users\xschne08\Documents\mpc_ab2\Lecture4\Data\im';
for i = 1:5

im0 = imread([paths, num2str(i),'\im0.png']);
im1 = imread([paths, num2str(i),'\im1.png']);
info = readcell([paths, num2str(i),'\calib.txt']);

Z = depth_map(im0, im1, info);
Depth_map{1,i} = Z;
end

