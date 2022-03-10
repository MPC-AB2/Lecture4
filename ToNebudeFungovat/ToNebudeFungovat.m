function [depthMaps] = ToNebudeFungovat( path )

%     cesta = "C:\Users\xnemec77\Documents\MPC-AB2\Lecture4\Data_public\Data";
    file = dir(path);
    file(ismember({file.name}, {'.', '..'})) = [];
    img = {};
    infoValue = zeros(numel(file),3);
    
    for i = 1:numel(file)
    %   Obrázky
        img{i,1} = imread(path + "\" + file(i).name + "\im0.png");
        img{i,2} = imread(path + "\" + file(i).name + "\im1.png");
    %   Info file
        soubor = importdata(path + "\" + file(i).name + "\calib.txt");
        tmp = split(soubor,"="); tmp = tmp(:,2);
        f = str2num(tmp{1});
        infoValue(i,1:3) = [str2double(tmp{4}), f(1,1), str2double(tmp{3})]; %baseline, f, offset
    end
    
    depthMaps = cell(1,numel(file));
    
    for i = 1:numel(file)
        im0 = rgb2gray(img{i,1});
        im1 = rgb2gray(img{i,2});
        baseline = infoValue(i,1); f = infoValue(i,2); offs = infoValue(i,3);
    
        range = [50 178];
        dispMap = disparitySGM(im0,im1,"DisparityRange",range);
        dispMap_pom = disparityBM(im0, im1, 'DisparityRange', range);

                
        kolik_min = 4;
        zmena = 1;
        velikost_okna = 5;
        pom = floor(velikost_okna/2);
        for ii = 1:50
%            if mod(ii,10)==0
%                 disp(ii)
%            end
            zmena = 0;
            for s = pom+1:(size(dispMap,2)-pom)
                for r = pom+1:(size(dispMap,1)-pom)
                    
                    if isnan(dispMap(r,s)) && (sum(sum(~isnan(dispMap(r-pom:r+pom,s-pom:s+pom))))>=kolik_min)
                        
                        cast = dispMap(r-1:r+1,s-1:s+1);
                        dispMap(r,s) = mean(cast(~isnan(cast))); 
                        zmena = zmena+1;
                    end
            
                end
            end
        end
    
        dispMap(isnan(dispMap)) = dispMap_pom(isnan(dispMap));
    %% Interpolace
    %     dispMap(isnan(dispMap)) = 0;
    %     imshow(dispMap,range)
    %     colormap jet
        
        Z = (baseline * f) ./ (dispMap + offs);
        depthMaps{1,i} = Z;
    end
    
%      addpath("C:\Users\xnemec77\Documents\MPC-AB2\Lecture4\Data_public")
%     [MAE,percantageMissing,~] = evaluateReconstruction(depthMaps)
    
end

   



