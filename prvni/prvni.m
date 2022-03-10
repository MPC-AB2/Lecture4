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

        dispar = disparitySGM(rgb2gray(im0), rgb2gray(im1), 'UniquenessThreshold',1);
%         dispar(isnan(dispar)) = 0;
        depthMap = (baseline*f)./(dispar+doffs) ;
        depthMap(isnan(depthMap)) = 0;

        se = strel('ball',2,2);

        depthMap_fi = medfilt2(depthMap);
        depthMap_er = imerode(depthMap_fi,se);

%         figure
%         subplot 131
%         imshow(depthMap, [])
%         subplot 132
%         imshow(depthMap_er, [])
%         subplot 133
%         imshow(depthMap_fi, [])

        depthMaps{i} = depthMap_er;
    end
end