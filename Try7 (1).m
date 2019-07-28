
%%reading the files of dataset
%
%%PRE-PROCESSING%%
%

filesC = dir('*00.txt');                        %reading control data files that ends with 00 in the directory
fileC = filesC';
filesP = dir('*11.txt');                        %reading patient data files that ends with 11 in the directory     
fileP = filesP';

N= cell(:,:);                                   %cell array to hold the processed data of each CO. file(38 mat.) 
P= cell(:,:);                                   %cell array to hold the processed data of each PT. file(38 mat.)


%%creating matrices to hold the values of extracted feature of each data file (CO. ones & Pt. ones)  
meanN =zeros(length(fileC),1);                 meanP =zeros(length(fileP),1);
medianN =zeros(length(fileC),1);               medianP =zeros(length(fileP),1);
sdN =zeros(length(fileC),1);                   sdP =zeros(length(fileP),1);
skewN =zeros(length(fileC),1);                 skewP =zeros(length(fileP),1);
percentileN=zeros(length(fileC),1);            percentileP=zeros(length(fileP),1);
varN=zeros(length(fileC),1);                   varP=zeros(length(fileP),1);
maxN=zeros(length(fileC),1);                   maxP=zeros(length(fileP),1);
minN=zeros(length(fileC),1);                   minP=zeros(length(fileP),1);


%%%%%%%%%%%%%%NORMAL SUBJECT%%%%%%%%%%%%%%%%%
  for i = 1: length(fileC)

         x_file = load(fileC(i).name);      %dealing with the ith file of directory
         a = x_file(:,[1 18 19]);           %choosing the wanted data only(Time , VGRF of RF and LF)
         
         toDeleteF30_CO = 30 > a(:,1);      %values of time to delete at first period
         a(toDeleteF30_CO, : )=[];          %remove rows of unwanted data 
         
         
          b=a;                              %Saving the new matrix (Different dimentions)  
          toDeleteL30_Co = b(:,1)> 91 ;     %values of time to delete at last period
          b (toDeleteL30_Co, : )= [];       %remove rows of unwanted data

          b ( b (:,2)<200 ,2 )= 0;          %zeroing the noise of right foot force values
          b ( b (:,3)<200 ,3)= 0;           %zeroing the noise of left foot force values
          
          N{i}= b;                                %add each processed data file to the normal cell array N
          savfile =sprintf('CoP%d55.txt',i);      %create names for the new processed files and save them 
          save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' savfile],'b', '-ascii');
          
   %%PLOTTING          
          subplot (2,1,1)                                      %divide the figure to 2 parts of one column
          plot ( N{i}(:,1), N{i}(:,2) , 'green' )              %plot TIME VS RIGHT FOOT O/P
          hold on 
          plot ( N{i}(:,1), N{i}(:,3) ,'yellow')               %plot TIME VS LEFT FOOT O/P
          hold off

          title ('VGRF of Normal Patient')                     %title of graph
          legend ('Right Foot o/p', 'Left Foor o/p')           %indication of curves colors
          xlabel ('Time in seconds')                           %x-axis label
          ylabel (' VGRF')                                     %y-axis label
          axis ([30 35.5 0 1200])                              %values of axises to show
          
   %%FEATURE EXTRACTION
          meanN(i,1)= mean (nanmean(b(:,2:3)));                  %calculate the feature of each file and save in
          medianN(i,1)= mean(nanmedian(b(:,2:3)));               %its corresponding matrix name
          sdN (i,1)= mean(nanstd(b(:,2:3)));
          skewN (i,1) = mean(skewness (b(:,2:3)));
          percentileN(i,1)= mean(prctile(b(:,2:3),95));
          varN (i,1) = mean(var (b(:,2:3)));
          maxN (i,1) = mean(max (b(:,2:3)));
          minN (i,1) = mean (min (b(:,2:3)));

  end
  
  FM_N =[meanN medianN sdN skewN percentileN varN maxN minN];            %collect the normal data features in one matrix       
  FM_N (:,end+1)= 0;                                       %add a col. to label the normal data as 0
  
  FM_N_train= FM_N(1:27,:);                                %subset the feature matrix to train set
  FM_N_test = FM_N(28:end,:);                              %subset the feature matrix to test set
  
  
%%%%%%%%%%%%%%%%PATIENT SUBJECT%%%%%%%%%%%%%%%%%%%%
  for k = 1:length (fileP); 
     
         y_file = load(fileP(k).name );
         c = y_file(:,[1 18 19]);
    
         toDeleteF30_Pt  = 30 > c(:,1);
         c (toDeleteF30_Pt, : )= [];

         d= c ;
         toDeleteL30_Pt = d(:,1)> 91 ;
         d (toDeleteL30_Pt, : )= [];

         d ( d (:,2)<200 ,2 )= 0;
         d ( d (:,3)<200 ,3)= 0;
         
         P{k}= d;
         savfile = sprintf('PtP%d99.txt',k);
         save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' savfile],'d', '-ascii');
         
   %%PLOTTING  

         subplot (2,1,2)
         plot ( P{k}(:,1), P{k}(:,2) , 'magenta' )
         hold on 
         plot ( P{k}(:,1 ), P{k}(:,3) , 'cyan' )
         hold off

         title ('VGRF of Diseased Patient')
         legend ('Right Foot o/p', 'Left Foot o/p')
         xlabel ('Time in seconds')
         ylabel ('VGRF ')
         axis ([30 35.5 0 1200])
         
%%FEATURE EXTRACTION
          meanP(k,1)= mean(nanmean (d(:,2:3))); 
          medianP(k,1)= mean(nanmedian(d(:,2:3)));
          sdP (k,1)= mean(nanstd(d(:,2:3)));
          skewP (k,1) =mean( skewness (d(:,2:3)));
          percentileP(k,1)= mean(prctile(d(:,2:3),95));        
          varP (k,1) = mean(var(d(:,2:3)));
          maxP (k,1) = mean(max (d(:,2:3)));
          minP (k,1) = mean (min (d(:,2:3)));

  end
  
 FM_P = [meanP medianP sdP skewP percentileP varP maxP minP];    %collect the patient data features in one matrix
 FM_P(:,end+1)= 1;                                 %add a col. to label the patient data as 1

 FM_P_train= FM_P(1:27,:);                         %subset the feature matrix to train set
 FM_P_test = FM_P(28:end,:);                       %subset the feature matrix to test set
 
 %%%saving train dataset
 FM_train = [ FM_N_train ; FM_P_train];             %collecting all train dataset (normal+patient)
 savtraindata = 'FeatureMatrix_train.txt';            %save the train dataset as on text file
 save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' savtraindata],'FM_train', '-ascii');
 
 %%%saving test dataset

 %save normal test dataset as seperated text files for each subject either
 %normal or patient subject
 
 Nt1 = FM_N_test (1,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N1_test.txt'],'Nt1', '-ascii');
 Nt2 = FM_N_test (2,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N2_test.txt'],'Nt2', '-ascii');
 Nt3 = FM_N_test (3,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N3_test.txt'],'Nt3', '-ascii');
 Nt4 = FM_N_test (4,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N4_test.txt'],'Nt4', '-ascii');
 Nt5 = FM_N_test (5,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N5_test.txt'],'Nt5', '-ascii');
 Nt6 = FM_N_test (6,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N6_test.txt'],'Nt6', '-ascii');
 Nt7 = FM_N_test (7,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N7_test.txt'],'Nt7', '-ascii');
 Nt8 = FM_N_test (8,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N8_test.txt'],'Nt8', '-ascii');
 Nt9 = FM_N_test (9,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N9_test.txt'],'Nt9', '-ascii');
 Nt10 = FM_N_test (10,:);  save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N10_test.txt'],'Nt10', '-ascii');
 Nt11 = FM_N_test (11,:);  save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'N11_test.txt'],'Nt11', '-ascii');


 Pt1 = FM_P_test (1,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P12_test.txt'],'Pt1', '-ascii');
 Pt2 = FM_P_test (2,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P13_test.txt'],'Pt2', '-ascii');
 Pt3 = FM_P_test (3,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P14_test.txt'],'Pt3', '-ascii');
 Pt4 = FM_P_test (4,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P15_test.txt'],'Pt4', '-ascii');
 Pt5 = FM_P_test (5,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P16_test.txt'],'Pt5', '-ascii');
 Pt6 = FM_P_test (6,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P17_test.txt'],'Pt6', '-ascii');
 Pt7 = FM_P_test (7,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P18_test.txt'],'Pt7', '-ascii');
 Pt8 = FM_P_test (8,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P19_test.txt'],'Pt8', '-ascii');
 Pt9 = FM_P_test (9,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P20_test.txt'],'Pt9', '-ascii');
 Pt10 = FM_P_test (10,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P21_test.txt'],'Pt10', '-ascii');
 Pt11 = FM_P_test (11,:);    save(['C:\Users\ALYA-IBRAHIM\Desktop\normal data\' 'P22_test.txt'],'Pt11', '-ascii');
