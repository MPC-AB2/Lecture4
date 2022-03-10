function [depthMaps] = prvni(path)
    folders = dir([path, '\im*']);
    depthMaps = cell(1, length(folders));
    for i = 1:length(folders)
        im0 = imread([folders(i).folder, '\', folders(i).name,  '\im0.png']);
        im1 = imread([folders(i).folder, '\', folders(i).name,  '\im1.png']);
        dispar = disparitySGM(rgb2gray(im0), rgb2gray(im1));
        dispar(isnan(dispar)) = 0;
        depthMaps{i} = dispar;
    end
end