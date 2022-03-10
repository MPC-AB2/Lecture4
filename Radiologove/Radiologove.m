function [depthMaps] = Radiologove( path )
    addpath path
    numFolder = size(dir([path '\im*']),1);
    folders = cell(1,numFolder);
    directory = dir([path '\im*']);
    for j = 1:numFolder
       folders{1,j} = directory(j).name;
    end
    
    depthMaps = cell(1,numFolder);
    
    for i = 1:numFolder
        files = dir([path '\' folders{1,i}]);
        images = dir([path '\' folders{1,i} '\*.png']);
        im0 = im2gray(imread([path '\' folders{1,i} '\' images(1).name]));
        im1 = im2gray(imread([path '\' folders{1,i} '\' images(2).name]));
        txt = dir([path '\' folders{1,i} '\*.txt']);
        txt=importdata([path '\' folders{1,i} '\' txt.name]);

        %% disparity map
        ndisp = strsplit(txt{7},'=');
        ndisp = str2double(ndisp{2});
        nd = round(ndisp/16)*16;
        disparityRange = [0 nd];
        
        disparityMap = disparityBM(im0,im1,'DisparityRange',disparityRange,'UniquenessThreshold',20,'ContrastThreshold',0.5,'DistanceThreshold',5);

        %% import txt
        
        C = strsplit(txt{1},' ');
        f = str2double(C{5});
        baseline = strsplit(txt{4},'=');
        baseline = str2double(baseline{2});
        doffs = strsplit(txt{3},'=');
        doffs = str2double(doffs{2});
        
        %% depth map
        
        f = repmat(f,size(disparityMap));
        baseline = repmat(baseline,size(disparityMap));
        doffs = repmat(doffs,size(disparityMap));
        Z = (baseline.*f)./(disparityMap+doffs);
        Z(isnan(Z)) = nanmean(nanmean(Z));%-30;
        nanMap = isnan(Z);
        counts = conv2(~nanMap, ones(3), 'same');
        % Get the sums of the non-nan values in the 3-by-3 window
        Z_sums = Z;
        Z_sums(isnan(Z)) = 0;
        % Make a "linear distance"-weighted kernel
        kernel = ones(3) / sqrt(2);
        kernel(2,:) = 1;
        kernel(:, 2) = 1;
        % Use that kernel to get distance weighted sums at each point.
        sums = conv2(Z_sums, kernel, 'same');
        % Divide them to get the average of non-nans in a 3-by-3 window.
        Z_means = sums ./ counts;
        % Replace nan values with the average values, leaving non-nan values alone.
        Z_repaired = Z; % Initialize as Z so we can leave the non-nan values alone.
        Z_repaired(nanMap) = Z_means(nanMap);
        Z = Z_repaired;
        
%         figure
%         imshow(Z,[])
%         colormap jet
%         colorbar
        depthMaps{1,i} = Z;
    end
end