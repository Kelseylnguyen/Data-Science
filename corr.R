

corr <- function(directory, threshold=0){
  files <- list.files(path=directory, pattern=".csv", full.names = TRUE)
  valu <- numeric()
  
  for (i in 1:length(files)){
    data <- read.csv(files[i])
    nobs <- sum(complete.cases(data))
    if (nobs > threshold){
      col <- data[complete.cases(data[c('sulfate','nitrate')]),]
      valu <- c(valu,cor(col$sulfate, col$nitrate))
    }
  }
  print(valu)
}  

