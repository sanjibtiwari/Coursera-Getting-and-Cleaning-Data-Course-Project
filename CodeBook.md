Getting and Cleaning Data
Course Project
*Please Download the CodeBook.html to view this in a properly formatted html file.

This is the code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.

The first part of the code downloads the data collected from the accelerometers from Samsung Galaxy S Smartphone. The files contains a test set and a training set. Below is the information of all the files

# - 'features_info.txt': Shows information about the variables used on the feature vector.
# 
# - 'features.txt': List of all features.
# 
# - 'activity_labels.txt': Links the class labels with their activity name.
# 
# - 'train/X_train.txt': Training set.
# 
# - 'train/y_train.txt': Training labels.
# 
# - 'test/X_test.txt': Test set.
# 
# - 'test/y_test.txt': Test labels.
The R code to achieve this is below:

labels<-read.table (".\\UCI HAR Dataset\\features.txt", header=FALSE)

train<-read.table (".\\UCI HAR Dataset\\train\\X_train.txt", header=FALSE,col.names=labels[,2]) #train data set
train_labels<-read.table (".\\UCI HAR Dataset\\train\\y_train.txt", header=FALSE, col.names="Activity") # train data activity labels
train_subjects<-read.table (".\\UCI HAR Dataset\\train\\subject_train.txt", header=FALSE, col.names="Subjects") # train data subject labels
train<-cbind(train_subjects,train_labels,train) # adding activity, subject labels to train dataset


test<-read.table (".\\UCI HAR Dataset\\test\\X_test.txt", header=FALSE, col.names=labels[,2]) #test data set
test_labels<-read.table (".\\UCI HAR Dataset\\test\\y_test.txt", header=FALSE, col.names="Activity") # test data activity labels
test_subjects<-read.table (".\\UCI HAR Dataset\\test\\subject_test.txt", header=FALSE, col.names="Subjects") # test data activity labels
test<-cbind(test_subjects,test_labels,test) # adding activity, subject labels to test dataset


activity_labels<- read.table (".\\UCI HAR Dataset\\activity_labels.txt", header=FALSE, col.names=c("Activity","Activity_Labels"))
In this code,

The labels variables are the list of all the features
The test and train are the datasets
The test_labels and train_labels are the observation type labels
The train_subjects and test_subjects are the subject labels for each
participants numbered from 1 to 30
Part 2: Merging the Test and Train Dataset

The following code merges the training and test data sets and extracts the measurements for the mean and the standard deviation. It also uses the activity_labels to label the merged dataset by the various activities. The resuting data frame is stored in activity_data

#******* 1. Merges the training and the test sets to create one data set*********

activity_data<-rbind(train,test)


# removing tables that won't be used in further analysis
rm(labels,train,test, train_labels, test_labels)

# ******* 2. Extracts only the measurements on the mean and standard deviation for each measurement*******

activity_data<-activity_data %>%
                select(Subjects,Activity,grep("mean",names(activity_data)),grep("std",names(activity_data))) %>%
        # ******* 3. Uses descriptive activity names to name the activities in the data set*******                
                left_join(.,activity_labels, by="Activity") %>% # adding description to activity labels
                select(Subjects,Activity_Labels,everything(),-Activity)
A snip of the activity_data table is shown below:
activity_data
Subjects	Activity_Labels	tBodyAcc.mean…X	tBodyAcc.mean…Y	tBodyAcc.mean…Z	tGravityAcc.mean…X	tGravityAcc.mean…Y	tGravityAcc.mean…Z	tBodyAccJerk.mean…X	tBodyAccJerk.mean…Y	tBodyAccJerk.mean…Z	tBodyGyro.mean…X	tBodyGyro.mean…Y	tBodyGyro.mean…Z	tBodyGyroJerk.mean…X	tBodyGyroJerk.mean…Y	tBodyGyroJerk.mean…Z	tBodyAccMag.mean..	tGravityAccMag.mean..	tBodyAccJerkMag.mean..	tBodyGyroMag.mean..	tBodyGyroJerkMag.mean..	fBodyAcc.mean…X	fBodyAcc.mean…Y	fBodyAcc.mean…Z	fBodyAcc.meanFreq…X	fBodyAcc.meanFreq…Y	fBodyAcc.meanFreq…Z	fBodyAccJerk.mean…X	fBodyAccJerk.mean…Y	fBodyAccJerk.mean…Z	fBodyAccJerk.meanFreq…X	fBodyAccJerk.meanFreq…Y	fBodyAccJerk.meanFreq…Z	fBodyGyro.mean…X	fBodyGyro.mean…Y	fBodyGyro.mean…Z	fBodyGyro.meanFreq…X	fBodyGyro.meanFreq…Y	fBodyGyro.meanFreq…Z	fBodyAccMag.mean..	fBodyAccMag.meanFreq..	fBodyBodyAccJerkMag.mean..	fBodyBodyAccJerkMag.meanFreq..	fBodyBodyGyroMag.mean..	fBodyBodyGyroMag.meanFreq..	fBodyBodyGyroJerkMag.mean..	fBodyBodyGyroJerkMag.meanFreq..	tBodyAcc.std…X	tBodyAcc.std…Y	tBodyAcc.std…Z	tGravityAcc.std…X	tGravityAcc.std…Y	tGravityAcc.std…Z	tBodyAccJerk.std…X	tBodyAccJerk.std…Y	tBodyAccJerk.std…Z	tBodyGyro.std…X	tBodyGyro.std…Y	tBodyGyro.std…Z	tBodyGyroJerk.std…X	tBodyGyroJerk.std…Y	tBodyGyroJerk.std…Z	tBodyAccMag.std..	tGravityAccMag.std..	tBodyAccJerkMag.std..	tBodyGyroMag.std..	tBodyGyroJerkMag.std..	fBodyAcc.std…X	fBodyAcc.std…Y	fBodyAcc.std…Z	fBodyAccJerk.std…X	fBodyAccJerk.std…Y	fBodyAccJerk.std…Z	fBodyGyro.std…X	fBodyGyro.std…Y	fBodyGyro.std…Z	fBodyAccMag.std..	fBodyBodyAccJerkMag.std..	fBodyBodyGyroMag.std..	fBodyBodyGyroJerkMag.std..
1	STANDING	0.2885845	-0.0202942	-0.1329051	0.9633961	-0.1408397	0.1153749	0.0779963	0.0050008	-0.0678308	-0.0061008	-0.0313648	0.1077254	-0.0991674	-0.0555174	-0.0619858	-0.9594339	-0.9594339	-0.9933059	-0.9689591	-0.9942478	-0.9947832	-0.9829841	-0.9392686	0.2524829	0.1318358	-0.0520503	-0.9923324	-0.9871699	-0.9896961	0.8703845	0.2106970	0.2637079	-0.9865744	-0.9817615	-0.9895148	-0.2575489	0.0979471	0.5471510	-0.9521547	-0.0884361	-0.9937256	0.3469885	-0.9801348	-0.1289889	-0.9919904	-0.0743230	-0.9952786	-0.9831106	-0.9135264	-0.9852497	-0.9817084	-0.8776250	-0.9935191	-0.9883600	-0.9935750	-0.9853103	-0.9766234	-0.9922053	-0.9921107	-0.9925193	-0.9920553	-0.9505515	-0.9505515	-0.9943364	-0.9643352	-0.9913676	-0.9954218	-0.9831330	-0.9061650	-0.9958207	-0.9909363	-0.9970517	-0.9850326	-0.9738861	-0.9940349	-0.9561340	-0.9937550	-0.9613094	-0.9906975
1	STANDING	0.2784188	-0.0164106	-0.1235202	0.9665611	-0.1415513	0.1093788	0.0740067	0.0057711	0.0293766	-0.0161116	-0.0838938	0.1005843	-0.1105028	-0.0448187	-0.0592428	-0.9792892	-0.9792892	-0.9912535	-0.9806831	-0.9951232	-0.9974507	-0.9768517	-0.9735227	0.2713086	0.0428636	-0.0143098	-0.9950322	-0.9813115	-0.9897398	0.6085135	-0.0536756	0.0631483	-0.9773867	-0.9925300	-0.9896058	-0.0481674	-0.4016079	-0.0681783	-0.9808566	-0.0441499	-0.9903355	0.5320605	-0.9882956	-0.2719585	-0.9958539	0.1580745	-0.9982453	-0.9753002	-0.9603220	-0.9974113	-0.9894474	-0.9316387	-0.9955481	-0.9810636	-0.9918457	-0.9831200	-0.9890458	-0.9891212	-0.9898726	-0.9972926	-0.9938510	-0.9760571	-0.9760571	-0.9916944	-0.9837542	-0.9961016	-0.9986803	-0.9749298	-0.9554381	-0.9966524	-0.9820839	-0.9926268	-0.9849043	-0.9871681	-0.9897847	-0.9758658	-0.9919603	-0.9833219	-0.9963995
1	STANDING	0.2796531	-0.0194672	-0.1134617	0.9668781	-0.1420098	0.1018839	0.0736360	0.0031040	-0.0090456	-0.0316983	-0.1023354	0.0961269	-0.1084857	-0.0424103	-0.0558288	-0.9837031	-0.9837031	-0.9885313	-0.9763171	-0.9934032	-0.9935941	-0.9725115	-0.9833040	0.1245312	-0.0646106	0.0826769	-0.9909937	-0.9816422	-0.9875663	0.1154340	-0.1934363	0.0382543	-0.9754332	-0.9937147	-0.9867557	-0.2166851	-0.0172642	-0.1107203	-0.9877948	0.2578991	-0.9892801	0.6607950	-0.9892548	-0.2127279	-0.9950305	0.4145028	-0.9953796	-0.9671870	-0.9789440	-0.9995740	-0.9928658	-0.9929172	-0.9907428	-0.9809556	-0.9896866	-0.9762921	-0.9935518	-0.9863787	-0.9884618	-0.9956321	-0.9915318	-0.9880196	-0.9880196	-0.9903969	-0.9860515	-0.9950910	-0.9963128	-0.9655059	-0.9770493	-0.9912488	-0.9814148	-0.9904159	-0.9766422	-0.9933990	-0.9873282	-0.9890155	-0.9908667	-0.9860277	-0.9951274
1	STANDING	0.2791739	-0.0262006	-0.1232826	0.9676152	-0.1439764	0.0998501	0.0773206	0.0200576	-0.0098648	-0.0434100	-0.0913862	0.0855377	-0.0911699	-0.0363326	-0.0604647	-0.9865418	-0.9865418	-0.9930780	-0.9820599	-0.9955022	-0.9954906	-0.9835697	-0.9910798	0.0290444	0.0803023	0.1856947	-0.9944466	-0.9887272	-0.9913542	0.0357981	-0.0930358	0.1680952	-0.9871096	-0.9936015	-0.9871913	0.2168625	-0.1352454	-0.0497280	-0.9875187	0.0735815	-0.9927689	0.6789213	-0.9894128	-0.0356842	-0.9952207	0.4045725	-0.9960915	-0.9834027	-0.9906751	-0.9966456	-0.9813928	-0.9784764	-0.9926974	-0.9875528	-0.9934976	-0.9913848	-0.9924073	-0.9875542	-0.9911194	-0.9966410	-0.9933289	-0.9864214	-0.9864214	-0.9933808	-0.9873511	-0.9952666	-0.9963121	-0.9832444	-0.9902291	-0.9913783	-0.9869268	-0.9943908	-0.9928104	-0.9916460	-0.9886776	-0.9867420	-0.9916998	-0.9878358	-0.9952369
1	STANDING	0.2766288	-0.0165697	-0.1153618	0.9682244	-0.1487502	0.0944859	0.0734444	0.0191216	0.0167800	-0.0339604	-0.0747080	0.0773920	-0.0907701	-0.0376325	-0.0582893	-0.9928272	-0.9928272	-0.9934800	-0.9852037	-0.9958076	-0.9972859	-0.9823010	-0.9883694	0.1810898	0.0579879	0.5597863	-0.9962920	-0.9887900	-0.9906244	0.2733502	0.0791354	0.2923842	-0.9824465	-0.9929838	-0.9886664	-0.1533426	-0.0884027	-0.1622304	-0.9935908	0.3943103	-0.9955228	0.5590577	-0.9914330	-0.2735820	-0.9950928	0.0877530	-0.9981386	-0.9808173	-0.9904816	-0.9984293	-0.9880982	-0.9787449	-0.9964202	-0.9883587	-0.9924549	-0.9851836	-0.9923781	-0.9874018	-0.9913545	-0.9964730	-0.9945110	-0.9912754	-0.9912754	-0.9958537	-0.9890626	-0.9952580	-0.9986065	-0.9801295	-0.9919150	-0.9969025	-0.9886067	-0.9929065	-0.9859818	-0.9919558	-0.9879443	-0.9900635	-0.9943890	-0.9890594	-0.9954648
The following r code appropriately labels the data set with descriptive variable names

names(activity_data)<- gsub("^t","Time", names(activity_data)) # Replacing starting t with Time
names(activity_data)<- gsub("^f","Frequency", names(activity_data)) # Replacing starting f with frequency
names(activity_data)<-gsub("mean","Mean", names(activity_data)) # Capitalizing M in mean
names(activity_data)<-gsub("std.","Std", names(activity_data)) # Capitalizing S in std
names(activity_data)<-gsub("\\.","", names(activity_data)) # Replacing the dots with blanks

A snip of the appropriately labeled data set is shown below:

activity_data with Appropriate Labels
Subjects	Activity_Labels	TimeBodyAccMeanX	TimeBodyAccMeanY	TimeBodyAccMeanZ	TimeGravityAccMeanX	TimeGravityAccMeanY	TimeGravityAccMeanZ	TimeBodyAccJerkMeanX	TimeBodyAccJerkMeanY	TimeBodyAccJerkMeanZ	TimeBodyGyroMeanX	TimeBodyGyroMeanY	TimeBodyGyroMeanZ	TimeBodyGyroJerkMeanX	TimeBodyGyroJerkMeanY	TimeBodyGyroJerkMeanZ	TimeBodyAccMagMean	TimeGravityAccMagMean	TimeBodyAccJerkMagMean	TimeBodyGyroMagMean	TimeBodyGyroJerkMagMean	FrequencyBodyAccMeanX	FrequencyBodyAccMeanY	FrequencyBodyAccMeanZ	FrequencyBodyAccMeanFreqX	FrequencyBodyAccMeanFreqY	FrequencyBodyAccMeanFreqZ	FrequencyBodyAccJerkMeanX	FrequencyBodyAccJerkMeanY	FrequencyBodyAccJerkMeanZ	FrequencyBodyAccJerkMeanFreqX	FrequencyBodyAccJerkMeanFreqY	FrequencyBodyAccJerkMeanFreqZ	FrequencyBodyGyroMeanX	FrequencyBodyGyroMeanY	FrequencyBodyGyroMeanZ	FrequencyBodyGyroMeanFreqX	FrequencyBodyGyroMeanFreqY	FrequencyBodyGyroMeanFreqZ	FrequencyBodyAccMagMean	FrequencyBodyAccMagMeanFreq	FrequencyBodyBodyAccJerkMagMean	FrequencyBodyBodyAccJerkMagMeanFreq	FrequencyBodyBodyGyroMagMean	FrequencyBodyBodyGyroMagMeanFreq	FrequencyBodyBodyGyroJerkMagMean	FrequencyBodyBodyGyroJerkMagMeanFreq	TimeBodyAccStdX	TimeBodyAccStdY	TimeBodyAccStdZ	TimeGravityAccStdX	TimeGravityAccStdY	TimeGravityAccStdZ	TimeBodyAccJerkStdX	TimeBodyAccJerkStdY	TimeBodyAccJerkStdZ	TimeBodyGyroStdX	TimeBodyGyroStdY	TimeBodyGyroStdZ	TimeBodyGyroJerkStdX	TimeBodyGyroJerkStdY	TimeBodyGyroJerkStdZ	TimeBodyAccMagStd	TimeGravityAccMagStd	TimeBodyAccJerkMagStd	TimeBodyGyroMagStd	TimeBodyGyroJerkMagStd	FrequencyBodyAccStdX	FrequencyBodyAccStdY	FrequencyBodyAccStdZ	FrequencyBodyAccJerkStdX	FrequencyBodyAccJerkStdY	FrequencyBodyAccJerkStdZ	FrequencyBodyGyroStdX	FrequencyBodyGyroStdY	FrequencyBodyGyroStdZ	FrequencyBodyAccMagStd	FrequencyBodyBodyAccJerkMagStd	FrequencyBodyBodyGyroMagStd	FrequencyBodyBodyGyroJerkMagStd
1	STANDING	0.2885845	-0.0202942	-0.1329051	0.9633961	-0.1408397	0.1153749	0.0779963	0.0050008	-0.0678308	-0.0061008	-0.0313648	0.1077254	-0.0991674	-0.0555174	-0.0619858	-0.9594339	-0.9594339	-0.9933059	-0.9689591	-0.9942478	-0.9947832	-0.9829841	-0.9392686	0.2524829	0.1318358	-0.0520503	-0.9923324	-0.9871699	-0.9896961	0.8703845	0.2106970	0.2637079	-0.9865744	-0.9817615	-0.9895148	-0.2575489	0.0979471	0.5471510	-0.9521547	-0.0884361	-0.9937256	0.3469885	-0.9801348	-0.1289889	-0.9919904	-0.0743230	-0.9952786	-0.9831106	-0.9135264	-0.9852497	-0.9817084	-0.8776250	-0.9935191	-0.9883600	-0.9935750	-0.9853103	-0.9766234	-0.9922053	-0.9921107	-0.9925193	-0.9920553	-0.9505515	-0.9505515	-0.9943364	-0.9643352	-0.9913676	-0.9954218	-0.9831330	-0.9061650	-0.9958207	-0.9909363	-0.9970517	-0.9850326	-0.9738861	-0.9940349	-0.9561340	-0.9937550	-0.9613094	-0.9906975
1	STANDING	0.2784188	-0.0164106	-0.1235202	0.9665611	-0.1415513	0.1093788	0.0740067	0.0057711	0.0293766	-0.0161116	-0.0838938	0.1005843	-0.1105028	-0.0448187	-0.0592428	-0.9792892	-0.9792892	-0.9912535	-0.9806831	-0.9951232	-0.9974507	-0.9768517	-0.9735227	0.2713086	0.0428636	-0.0143098	-0.9950322	-0.9813115	-0.9897398	0.6085135	-0.0536756	0.0631483	-0.9773867	-0.9925300	-0.9896058	-0.0481674	-0.4016079	-0.0681783	-0.9808566	-0.0441499	-0.9903355	0.5320605	-0.9882956	-0.2719585	-0.9958539	0.1580745	-0.9982453	-0.9753002	-0.9603220	-0.9974113	-0.9894474	-0.9316387	-0.9955481	-0.9810636	-0.9918457	-0.9831200	-0.9890458	-0.9891212	-0.9898726	-0.9972926	-0.9938510	-0.9760571	-0.9760571	-0.9916944	-0.9837542	-0.9961016	-0.9986803	-0.9749298	-0.9554381	-0.9966524	-0.9820839	-0.9926268	-0.9849043	-0.9871681	-0.9897847	-0.9758658	-0.9919603	-0.9833219	-0.9963995
1	STANDING	0.2796531	-0.0194672	-0.1134617	0.9668781	-0.1420098	0.1018839	0.0736360	0.0031040	-0.0090456	-0.0316983	-0.1023354	0.0961269	-0.1084857	-0.0424103	-0.0558288	-0.9837031	-0.9837031	-0.9885313	-0.9763171	-0.9934032	-0.9935941	-0.9725115	-0.9833040	0.1245312	-0.0646106	0.0826769	-0.9909937	-0.9816422	-0.9875663	0.1154340	-0.1934363	0.0382543	-0.9754332	-0.9937147	-0.9867557	-0.2166851	-0.0172642	-0.1107203	-0.9877948	0.2578991	-0.9892801	0.6607950	-0.9892548	-0.2127279	-0.9950305	0.4145028	-0.9953796	-0.9671870	-0.9789440	-0.9995740	-0.9928658	-0.9929172	-0.9907428	-0.9809556	-0.9896866	-0.9762921	-0.9935518	-0.9863787	-0.9884618	-0.9956321	-0.9915318	-0.9880196	-0.9880196	-0.9903969	-0.9860515	-0.9950910	-0.9963128	-0.9655059	-0.9770493	-0.9912488	-0.9814148	-0.9904159	-0.9766422	-0.9933990	-0.9873282	-0.9890155	-0.9908667	-0.9860277	-0.9951274
1	STANDING	0.2791739	-0.0262006	-0.1232826	0.9676152	-0.1439764	0.0998501	0.0773206	0.0200576	-0.0098648	-0.0434100	-0.0913862	0.0855377	-0.0911699	-0.0363326	-0.0604647	-0.9865418	-0.9865418	-0.9930780	-0.9820599	-0.9955022	-0.9954906	-0.9835697	-0.9910798	0.0290444	0.0803023	0.1856947	-0.9944466	-0.9887272	-0.9913542	0.0357981	-0.0930358	0.1680952	-0.9871096	-0.9936015	-0.9871913	0.2168625	-0.1352454	-0.0497280	-0.9875187	0.0735815	-0.9927689	0.6789213	-0.9894128	-0.0356842	-0.9952207	0.4045725	-0.9960915	-0.9834027	-0.9906751	-0.9966456	-0.9813928	-0.9784764	-0.9926974	-0.9875528	-0.9934976	-0.9913848	-0.9924073	-0.9875542	-0.9911194	-0.9966410	-0.9933289	-0.9864214	-0.9864214	-0.9933808	-0.9873511	-0.9952666	-0.9963121	-0.9832444	-0.9902291	-0.9913783	-0.9869268	-0.9943908	-0.9928104	-0.9916460	-0.9886776	-0.9867420	-0.9916998	-0.9878358	-0.9952369
1	STANDING	0.2766288	-0.0165697	-0.1153618	0.9682244	-0.1487502	0.0944859	0.0734444	0.0191216	0.0167800	-0.0339604	-0.0747080	0.0773920	-0.0907701	-0.0376325	-0.0582893	-0.9928272	-0.9928272	-0.9934800	-0.9852037	-0.9958076	-0.9972859	-0.9823010	-0.9883694	0.1810898	0.0579879	0.5597863	-0.9962920	-0.9887900	-0.9906244	0.2733502	0.0791354	0.2923842	-0.9824465	-0.9929838	-0.9886664	-0.1533426	-0.0884027	-0.1622304	-0.9935908	0.3943103	-0.9955228	0.5590577	-0.9914330	-0.2735820	-0.9950928	0.0877530	-0.9981386	-0.9808173	-0.9904816	-0.9984293	-0.9880982	-0.9787449	-0.9964202	-0.9883587	-0.9924549	-0.9851836	-0.9923781	-0.9874018	-0.9913545	-0.9964730	-0.9945110	-0.9912754	-0.9912754	-0.9958537	-0.9890626	-0.9952580	-0.9986065	-0.9801295	-0.9919150	-0.9969025	-0.9886067	-0.9929065	-0.9859818	-0.9919558	-0.9879443	-0.9900635	-0.9943890	-0.9890594	-0.9954648
The following code creates a tidy data frame called tidy_activity. All the values from activity_data are summarized as mean.

 tidy_activity<- activity_data %>%
                 gather(.,Features, Values,-(1:2)) %>%       
                 group_by(Subjects, Activity_Labels, Features) %>%
                 summarise(Value=mean(Values)) %>%
                 ungroup(.) # its always a good practice to ungroup after performing the wated calculations
The final output is a tidy data set. A snip of the final data set is snown below

Final Tidy Data Set
Subjects	Activity_Labels	Features	Value
1	LAYING	FrequencyBodyAccJerkMeanFreqX	0.1324191
1	LAYING	FrequencyBodyAccJerkMeanFreqY	0.0245136
1	LAYING	FrequencyBodyAccJerkMeanFreqZ	0.0243879
1	LAYING	FrequencyBodyAccJerkMeanX	-0.9570739
1	LAYING	FrequencyBodyAccJerkMeanY	-0.9224626

References: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013

THE END
