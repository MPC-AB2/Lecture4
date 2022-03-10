load('depthMaps.mat');
img = imread('C:\Users\xdufko01\Desktop\lecture4\Data_public\Data\im1\im1.png');
R = img(:,:,1);
R = R(:);
G = img(:,:,2);
G=G(:);
B = img(:,:,3);
B=B(:);
mapa = depthMaps{1,1};
xyz = zeros(size(mapa,1)*size(mapa,2),3);
x=0;
y=0;
z=0;
pozice = 1;
for i = 1:size(mapa,1)
    for j = 1:size(mapa,2)
        xyz(pozice,1) = i;
        xyz(pozice,2) = j;
        xyz(pozice,3) = mapa(i,j);
        pozice = pozice+1;
    end
end

pC = pointCloud(xyz,'Color',[R G B]);
figure
pcshow(pC)