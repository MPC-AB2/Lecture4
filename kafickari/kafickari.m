function [Depth_map] = kafickari(paths)
%KAFICKARI Summary of this function goes here
    Depth_map = cell(1,5);
    for i = 1:5
    
        im0 = imread([paths, '\im', num2str(i),'\im0.png']);
        im1 = imread([paths, '\im', num2str(i),'\im1.png']);
        info = readcell([paths,'\im', num2str(i),'\calib.txt']);
        
        Z = depth_map(im0, im1, info);

        Z = fillmissing(Z, "linear");
        Z(isnan(Z)) = 1;

        Z = medfilt2(Z, [50 50]);
        Z = imhmin(Z, 8);

        Depth_map{1,i} = Z;

    end


end

