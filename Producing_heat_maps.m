close all
clc
load('DConnectivity_Sham_HC_Theta.mat','Directional_HC_Theta')
for i=1:size(Directional_HC_Theta,3)
    i
    clear('PD')
    clear('file')
PD=Directional_HC_Theta(:,:,i);
%PD1=(imagesc(PD1))*100;
PD=PD./max(max(abs(PD)));
%PD=PD.*255;
set(gcf,'color','none')
image=heatmap(PD);
colormap hot
image.GridVisible='off';
image.ColorbarVisible='off';
image.FontColor='none';
image.CellLabelColor='none';
%image=imagesc(image);
file=sprintf('HCteta_%d.jpg', i);
export_fig (file);
%image=RemoveWhiteSpace(image);

%RemoveWhiteSpace([], 'file', sprintf('%d.tif', i) , 'output', sprintf('%d.png', i));


%imwrite(image,file);
end