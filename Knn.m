
train1 = load('FeatureMatrix_train.txt');        %load the train data 
x_train1 = train1 (:,1:end-1);                   %choose the wanted data only (everything except the labels)
label1 = train1(:,end);                          %save the labels 

filesTest = dir('*_test.txt');                    %read the test files from directory 
fileT= filesTest';
class1=cell(22,5);                             %create a cell array to hold the results of (k=3,k=5,k=7) of all 22 files

 for v=1:22;
    
   x1 = load (fileT(v).name);                %load the ith data to deal with it
   x_test1 = x1(:,1:end-1);                  %choose the wanted data only (everything except the labels)
   class1{v,1} = knnclassify (x_test1 , x_train1 , label1 , 3);   
   class1{v,2} = knnclassify (x_test1 , x_train1 , label1 , 5);
   class1{v,3} = knnclassify (x_test1 , x_train1 , label1 , 7);
   class1{v,4} = knnclassify (x_test1 , x_train1 , label1 , 9);
   class1{v,5} = knnclassify (x_test1 , x_train1 , label1 , 11);
 end