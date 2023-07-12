

complete <- function(directory, id=1:332){
  files <- list.files(path=directory, pattern=".csv", full.names = TRUE)
  df <- data.frame()
  
  for (i in id){
    data <- read.csv(files[i])
    nobs <- sum(complete.cases(data))
    df <- rbind(df,data.frame(id=i, nobs=nobs))
  }
  print(df)
  
}
