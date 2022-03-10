function [DepthMap] = DepthMapComputation(I0,I1,doffs,baseline,f,vmin,vmax)
% vmin = 8*(round(vmin/8));
% vmax = 8*(round(vmax/8));
rng(5)
disparityMap = disparitySGM(I0,I1,'DisparityRange',[24 128],'UniquenessThreshold',0);

DepthMap = (baseline*f)./(disparityMap + doffs);

end