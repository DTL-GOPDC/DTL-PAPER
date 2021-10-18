% clc
close all
clear all
PD_features=xlsread('secondlast_scores_of_PD.csv');
HC_features=xlsread('secondlast_scores_of_HC.csv');
load('index.mat');
Name_UPDRS={'Tremor','Bradykinesia','Rigidity'};
Name_band={'Theta','Alpha','Beta','Gamma'};
%% beta
PD=zeros(4,15,64); %teta,alpha,beta,gamma
HC=zeros(4,18,64);
Mix=zeros(size(HC,1),size(HC,2)+size(PD,2),size(PD,3));

for counter_band=1:size(index_matrix_HC,1)
for i=1:size(PD,2)
     PD(counter_band,i,:)=PD_features(index_matrix_PD(counter_band,i),:);
    
end


for j=1:size(HC,2)
    HC(counter_band,j,:)=HC_features(index_matrix_HC(counter_band,j),:);
    
end


Mix(counter_band,:,:)=[PD(counter_band,:,:) HC(counter_band,:,:)];
end


%% UPDRS load
pd_fault=[2,3,7,8,12];

UPDRS=xlsread('UPDRS.xlsx');
idx_Bradkynesia=find(UPDRS(1,:)==3.1400)
idx_tremor=max(find(UPDRS(1,:)==2.1000))
idx_rigidity=find(UPDRS(1,:)==3.2000)+1

UPDRS(1,:)=[];
UPDRS(pd_fault,:)=[];
UPDRS_tot=UPDRS(:,1);
UPDRS_pd(1,:)=UPDRS(:,idx_tremor); %tremor
UPDRS_pd(2,:)=UPDRS(:,idx_Bradkynesia); %Bradkynesia(Body)
UPDRS_pd(3,:)=sum(UPDRS(:,idx_rigidity:idx_rigidity+4),2); %rigidity sum for 5 body part

% UPDRS_pd(3,:)=UPDRS(:,68);
% UPDRS_pd(4,:)=UPDRS(:,1);

UPDRS_hc=zeros(size(UPDRS_pd,1),18);

UPDRS_mix=[UPDRS_pd UPDRS_hc];
    
  


%% 
col=['g' 'b' 'r' 'k'];
for counter_band=1:size(index_matrix_HC,1)
    counter_band
for i=1:size(UPDRS_mix,1)
    for j=1:size(Mix,3)
     
[R1n,P1n]=corrcoef(Mix(counter_band,:,j),UPDRS_mix(i,:));
R(counter_band,i,j)=R1n(1,2);
P(counter_band,i,j)=P1n(1,2);
    end

P(counter_band,i,isnan(P(counter_band,i,:))==1)=1;
R(counter_band,i,isnan(R(counter_band,i,:))==1)=0;
end




for e=1:size(P,2)
    e
   
chracteristic_idx{counter_band,e}=find(P(counter_band,e,:)<5e-2);


Pvalue{counter_band,e}=P(counter_band,e,chracteristic_idx{counter_band,e}(:));
Rvalue{counter_band,e}=R(counter_band,e,chracteristic_idx{counter_band,e}(:));
[max_Rvalue(counter_band,e),idx_Rvalue(counter_band,e)]=max(abs(Rvalue{counter_band,e}))


end

color=['k','b','g','r'];
figure;
for i=1:size(Pvalue,2)

    
subplot(2,1,2)
stem(Pvalue{counter_band,i}(:),'color',col(i))
ylabel('P-value')
xlabel(sprintf('No. of Significant Common Feature in %s',Name_band{counter_band}));
hold on;
subplot(2,1,1)
stem(Rvalue{counter_band,i}(:),'color',col(i))
xlabel(sprintf('No. of Significant Common Feature in %s',Name_band{counter_band}));
%legend(Name_UPDRS{counter_band},color{counter_band})
ylabel('R (%)')
%xlabel('No. of Significant Common Feature in %s Band ',Name_band{counter_band});
hold on;
 Legend{i}=sprintf('%s',Name_UPDRS{i});
end
legend(Legend)
title('Correlation of Features Value with UPDRS')
%lName_UPDRS{counter_band})
fig=gcf;

set(findall(gcf,'-property','FontSize'),'FontSize',14, 'fontweight', 'bold', 'LineWidth', 2)
end
save('output_three_characteristic.mat','Pvalue','Rvalue','chracteristic_idx')
%%
%idx_delete=find(P1>.05);
%P1(idx_delete)=[];
%R1(idx_delete)=[];
%[P1_sort,idx]=sort(P1,'ascend')
% R1_sort=R1(idx);






