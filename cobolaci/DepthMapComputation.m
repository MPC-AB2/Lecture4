function [DepthMap] = DepthMapComputation(I0,I1,doffs,baseline,f,vmin,vmax)
% vmin = 8*(round(vmin/8));
% vmax = 8*(round(vmax/8));

disparityMap = disparitySGM(I0,I1,'DisparityRange',[48 176],'UniquenessThreshold',0);
disparityMap(isnan(disparityMap)) = 0;
disparityMap = imhmin(disparityMap,0.0001);
disparityMap = medfilt2(disparityMap,[45 45]);
%         for ind1 = 2:size(disparityMap,1)-1
%             for ind2 = 2:size(disparityMap,2)-1
%                 if isnan(disparityMap(ind1,ind2))
%                     disparityMap(ind1,ind2) = median(median(disparityMap(ind1-1:ind1+1,ind2-1:ind2+1)));
%                 end
%             end
%         end

DepthMap = (baseline*f)./(disparityMap + doffs);

end