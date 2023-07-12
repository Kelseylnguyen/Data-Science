

pollutantmean <- function(directory, pollutant, id=1:332){
  
  files <- list.files(path=directory, pattern=".csv", full.names = TRUE)
  val <- numeric()
                      
  for (i in id){
    data <- read.csv(files[[i]]) 
    val <- c(val, data[[pollutant]])
    }
    mean(val,na.rm=TRUE)
}









          
