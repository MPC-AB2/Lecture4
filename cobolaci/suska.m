rng(5)

params = importdata('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture4\Data\im1\calib.txt');
im0 = imread('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture4\Data\im1\im0.png');
im1 = imread('C:\Users\xziakm00\Documents\AB2_cobolaci\Lecture4\Data\im1\im1.png');

I0 = rgb2gray(im0);

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

f = mean([f1, f0]);

vmin = regexp(params(9),'\d+\.?\d*','match');
vmin = str2double(cell2mat(vmin{1}));

vmax = regexp(params(10),'\d+\.?\d*','match');
vmax = str2double(cell2mat(vmax{1}));

% range = [vmin + (8 - rem(vmin,8)), vmax + (8 - rem(vmax,8))];

% d = disparitySGM(rgb2gray(im0), rgb2gray(im1), 'DisparityRange', [24, 224]);

d = disparitySGM(rgb2gray(im0), rgb2gray(im1), 'DisparityRange', [24,128], 'UniquenessThreshold', 0);


Z = (b*f)./(d + doffs);
Z(isnan(Z)) = 0;

figure
imshow(Z, [])

% d =



% na vystupe bz mala bzt cell array
disparityMap = disparitySGM(I0,I1,'DisparityRange',[24 128],'UniquenessThreshold',0);
figure