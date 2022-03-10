function [depthMaps] = prvni(path)
    folders = dir([path, '\im*']);
    depthMaps = cell(1, length(folders));
    for i = 1:length(folders)
        im0 = imread([folders(i).folder, '\', folders(i).name,  '\im0.png']);
        im1 = imread([folders(i).folder, '\', folders(i).name,  '\im1.png']);
        
        [vars , vals] = readvars([folders(i).folder, '\', folders(i).name,  '\calib.txt']);
        doffs = vals(vars=="doffs");
        baseline = vals(vars=="baseline");

        splited = split(fgetl(fopen([folders(i).folder, '\', folders(i).name,  '\calib.txt'])), '=');
        A = str2num(splited{2});
        f = A(1,1);

        dispar = disparitySGM(rgb2gray(im0), rgb2gray(im1));
        dispar(isnan(dispar)) = 0;
        depthMap = (baseline*f)./(dispar+doffs) ;
        depthMaps{i} = depthMap;
    end
end