clc;
close all;
clear

load('output_three_characteristic.mat') % band, UPDRS(1,2,3,tot)
Name_UPDRS={'Tremor','Bradykinesia','Rigidity'};
Name_band={'Theta','Alpha','Beta','Gamma'};
for i=1:size(chracteristic_idx,2)   %band
    i
    % aya behtar nabud be ezaye har band biyaym UPDRS haye mokhtalef ro
    % negah konim???
    common1_2=intersect(chracteristic_idx{1,i}(:),chracteristic_idx{2,i}(:)); % teta and alpha common
    common3_4=intersect(chracteristic_idx{3,i}(:),chracteristic_idx{4,i}(:));  %beta and gamma common
    common_value=intersect(common1_2,common3_4); % for each UPDRS total common between bands
    common_total{i}=common_value;
    
end


    common1_2=intersect(common_total{1}(:),common_total{2}(:)); % teta and alpha common
   % common3_4=intersect(common_total{3}(:),common_total{4}(:));  %beta and gamma common
    common_value=intersect(common1_2,common_total{3}(:)); % for each UPDRS total common between bands
    common_final=common_value;
    R_final=zeros(size(Rvalue,1),size(Rvalue,2),numel(common_final)); %band,UPDRS,feature
    for i=1:size(R_final,3)  % feature
        clear('str')
        figure;
          cc=0;
        for index_band=1:size(R_final,1)%band
             cc=cc+1;
            for index_UPDRS=1:size(R_final,2)%UPDRS
             
                clear('idx')
                idx=find(chracteristic_idx{index_band,index_UPDRS}(:)==common_final(i));
                R_final(index_band,index_UPDRS,i)=Rvalue{index_band,index_UPDRS}(idx);
         

                     Legend{index_UPDRS}=sprintf('%s',Name_UPDRS{index_UPDRS});
                
            end
        
                  str{cc}=sprintf('%s ',Name_band{index_band})
             
        end
        
                    
                bar(R_final(:,:,i))
            
                set(gca, 'XTickLabel',str,'XTick',1:numel(str))
              legend(Legend)
              title(sprintf('Significant Correlation of Common Feature #%d Among the Four Bands',i))
              ylabel('Correlation (%)')
  
    
    fig=gcf;

set(findall(gcf,'-property','FontSize'),'FontSize',14, 'fontweight', 'bold', 'LineWidth', 2)
    end
    

% fh = findall(0,'Type','Figure');
% set( findall(fh, '-property', 'fontsize','fontweight'), 'fontsize', 14,'fontweight','bold')



