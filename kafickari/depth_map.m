function [Z] = depth_map(im0, im1, info)
    %DEPTH_MAP Summary of this function goes here
    %   Detailed explanation goes here

    
    im0_gray = im2gray(im0);
    im1_gray = im2gray(im1);
    
    pom = mod((info{10,2}-info{9,2}),16);
    disparityRange = [info{9,2} (info{10,2}-pom)+16];
    
    disparityMap = disparityBM(im0_gray,im1_gray, 'DisparityRange',disparityRange,'UniquenessThreshold',1);
    %disparityMap(isnan(disparityMap)) = 0;%a nebo pak interpolovat
    f1 = str2num(info{1,2});
    f2 = str2num(info{2,2});
    f = (f1(1) + f2(1))/2;
    Z = (info{4,2}*f)./(disparityMap + info{3,2});
%     Z(isnan(Z)) = 0;
end

