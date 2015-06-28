# Demo with plyr 
library(plyrmr)
library(rhdfs)
hdfs.init()

# Set backend as local for learning purpose 
plyrmr.options(backend = "local")

#Reference: https://rstudio-pubs-static.s3.amazonaws.com/84839_2132bdfdf9414d049a0f6a25f2971e01.html

# Simulate to create a big data set in HDFS  
car_df <- to.dfs(mtcars, output = "/tmp/mtcars" )
# Calculate the rate between carb and cyl, save the result into file 
output(bind.cols(input("/tmp/mtcars"), carb.per.cyl = carb/cyl),"/tmp/carb.per.cyl")

# Calculate mean of hp grouped by cyl 
input(car_df) %|% group(cyl) %|% transmute(mean(hp)) %|% output("/tmp/hp.cyl")

# Try with data Titanic 
#file.remove('/tmp/titanic')
# Simulate a big data set in hdfs 
tidata = to.dfs(data.frame(Titanic), output ='/tmp/titanic')
# Calculate sum of death and survive by gender 
input(tidata) %|% group(Sex, Survived) %|% transmute(sum(Freq))

