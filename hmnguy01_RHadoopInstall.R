# Install RHadoop packages 
# Install pre-requiste packages 
install.packages(c("Rcpp", "RJSONIO", "bitops", "digest", 
                   "functional", "stringr", "plyr", "reshape2", "dplyr", 
                   "R.methodsS3", "caTools", "Hmisc"))
install.packages("data.table")
installed.packages("rjson")
installed.packages("memoise")
installed.packages("rJava")

# Install RHadoop *remember to download them first* 
# rhdfs
install.packages("RHadoop/rhdfs_1.0.8.tar.gz?raw=true", repos = NULL, type ="source")
# rmr2 
install.packages("RHadoop/rmr2_3.3.1.tar.gz", repos = NULL, type ="source")
# plyrmr 
install.packages("RHadoop/plyrmr_0.6.0.tar.gz", repos = NULL, type ="source")

