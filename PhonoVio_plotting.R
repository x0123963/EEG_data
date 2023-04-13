# Concatenate individual .txt files into 1 .csv file
# Lisa Chang 03.31.2023

# import dataset
setwd("F:/PhonoVio_JesseLab/suffix")

subjects<- c("S050", "S052", "S053", "S055", "S058", 
             "S059", "S060", "S061", "S062", "S063")
all<-NULL

for (s in 1:(length(subjects))){
  files<- list.files(file.path(subjects[s], "ERP_txt"))
  all_s<- NULL
  
  for(i in 1:(length(files))){
    temp<- read.table(file.path(subjects[s], "ERP_txt", files[1]), header = TRUE)
    condition<- rep(substr(files[i],11, nchar(files[i])-4), nrow(temp))
    temp<- data.frame(condition, temp)
    all_s<- rbind(all_s,temp)
  }
  
  all_s<- data.frame(subject = rep(subjects[s], nrow(all_s)), all_s)
  all<- rbind(all, all_s)
}

write.csv(all, row.names = FALSE, file = "LIPS_10subj.csv")
