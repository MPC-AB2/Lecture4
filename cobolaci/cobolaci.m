function [depthMaps] = cobolaci(path)
my_path = path;
recurse_subfolders;
depthMaps = {};
    for i = 2:numberOfFolders

        %load data for 1 folder
        pathTxt = [listOfFolderNames(i) '\calib.txt'];
        pathTxt = join(pathTxt);
        pathTxt = strrep(pathTxt," ","");
        importFromTxt;
        f = f0;

        my_text = [listOfFolderNames(i) '\im0.png'];
        my_text = join(my_text);
        my_text = strrep(my_text," ","");
        I0 = rgb2gray(imread(my_text));

        my_text = [listOfFolderNames(i) '\im1.png'];
        my_text = join(my_text);
        my_text = strrep(my_text," ","");
        I1 = rgb2gray(imread(my_text));

        %compute depthMap
        depth = DepthMapComputation(I0,I1,doffs,b,f,vmin,vmax);
        depth(isnan(depth)) = 0;
        depth = imhmin(depth,0.0001);
        depthMaps{i-1} = depth;

    end


end