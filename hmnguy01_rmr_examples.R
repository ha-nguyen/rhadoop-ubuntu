### Testing RHadoop with rmr2

# Set up variable environment 
Sys.setenv("HADOOP_CMD"="/usr/local/hadoop/bin/hadoop")
Sys.setenv("LD_LIBRARY_PATH"="/usr/local/hadoop/lib/native/")
# Load packages 
library(rhdfs)
hdfs.init()
library(rmr2)

# Set backup as local to test rmr2 features using local file system *used for learning*  
rmr.options(backend="local")

# First example: Calculate the first hundreds squares 
small.ints = to.dfs(1:100)
cal <- mapreduce( input = small.ints, map = function(., v) cbind(v, v^2))
from.dfs(cal)

# Second examples: Count how many times each outcome occurred from a binominal sample 
groups = rbinom(32, n = 50, prob = 0.5)

# Load object to HDFS
bigroup <- to.dfs(groups)
# Run mapreduce job 
count.bigroup <- mapreduce(input  = bigroup, output = "/tmp/bigroup",
                           map = function (k,v) keyval(v,1), reduce = function(k,v) keyval(k, sum(v)))
# Output result is saved to hdfs "/tmp"
# Get the result 
from.dfs("/tmp/bigroup")

# Car example:calculate mean of horse power by cylinder 
# Get data 
mtcars <- data.frame(mtcars)
mtcard.fs <- to.dfs(mtcars)

# Map & Reduce  function: 
cyl.map = function (k, v){
        cyl <- v$cyl
        hp <- v$hp
        keyval(cyl, hp)
}

cyl.reduce = function (cyl, hp) {
        keyval(cyl, mean(hp)) }

# Run MapReduce job and get result 
cyl.count <- mapreduce(input = mtcard.fs, map= cyl.map, reduce = cyl.reduce)
data.frame(from.dfs(cyl.count))

# Word Count Example : Count the number of words in the text file 
# Write a map function to split words in a file  
wc.map = function(key, lines) { 
        # Split words by white space 
        word.lists <- strsplit(lines, split = "\\s")
        words <- unlist(word.lists)
        # Return key-value pair 
        keyval(words, 1)
}

# Write a reduce function to calculate word frequency 
wc.reduce = function (words, count) {
        keyval(words, sum(count))
}
# Load the sample text line  
line <- "“The crew of the space shuttle Challenger honored us by the manner in which they lived their lives. We will never forget them, nor the last time we saw them, this morning, as they prepared for their journey and waved good-bye and 'slipped the surly bonds of earth' to 'touch the face of God. ”"
test.textfile <- to.dfs(line)

# Run the mapreduce job 
word.count <- mapreduce(input = test.textfile, map = wc.map, reduce = wc.reduce)
# Get the result in a data frame 
as.data.frame(from.dfs(word.count)) 

