function [depthMaps] = prvni(path)
    folders = dir([path, '\im*']);
    depthMaps = cell(1, length(folders));
    for i = 1:length(folders)
        im0 = rgb2gray(imread([folders(i).folder, '\', folders(i).name,  '\im0.png']));
        im1 = rgb2gray(imread([folders(i).folder, '\', folders(i).name,  '\im1.png']));
        
        [vars , vals] = readvars([folders(i).folder, '\', folders(i).name,  '\calib.txt']);
        doffs = vals(vars=="doffs");
        baseline = vals(vars=="baseline");

        %%
        vmin = vals(vars=="vmin");
        vmax = vals(vars=="vmax");
        tmp = mod(vmax-vmin,16);
        range = [vmin+16 vmax-tmp];
        disp(range)

        splited = split(fgetl(fopen([folders(i).folder, '\', folders(i).name,  '\calib.txt'])), '=');
        A = str2num(splited{2});
        f = A(1,1);

        dispar = disparityBM(im0, im1, 'UniquenessThreshold', 1, 'DisparityRange', range);
%         dispar(isnan(dispar)) = 0;
        depthMap = (baseline*f)./(dispar+doffs);
        depthMap(isnan(depthMap)) = 0;

        se = strel('ball',3,3);

        depthMap_fi = medfilt2(depthMap);
        depthMap_fi = medfilt2(depthMap_fi);

        depthMap_er = imerode(depthMap_fi,se);
        depthMap_er = imfill(depthMap_er, 'holes');
        depthMap_me = medfilt2(depthMap_er);
        depthMap_di = imdilate(depthMap_me,se);
%         H = fspecial('average',[100 100]);
%         depthMap_av = imfilter(depthMap_er,H,'replicate');
        

        figure
        subplot 141
        imshow(depthMap, [])
        subplot 142
        imshow(depthMap_fi, [])
        subplot 143
        imshow(depthMap_er, [])
        subplot 144
        imshow(depthMap_di, [])
        
        depthMaps{i} = depthMap_di;
    end
end