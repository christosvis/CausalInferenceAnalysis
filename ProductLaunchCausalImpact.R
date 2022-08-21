#load library
library(CausalImpact)
library(pivottabler)

# import data and choose file
df <- read.csv(file.choose())

# pivot table
# arguments:  qpvt(dataFrame, rows, columns, calculations, ...)
pivot1 <- qpvt(df, "AppInstalls", "COUNTRY", "sum(SUM.PLATFORM_NPU.)") 
pivot1

# convert to data frame 
out <- pivot1$asDataFrame()
out
str(out)


# Delete last row (totals)
df1 <- head(out, - 1)          
df1


# check data
# dim(df)
# head(df)


# declare time series variables
us <- ts(df1$US)
gb <- ts(df1$GB)
au <- ts(df1$AU)

# bind data
# data <- cbind(us, gb) 

# check data
# head(data)

# visualize
# matplot(data, type = "l")

# dates
# nrow() numberof rows
time.points <- seq.Date(as.Date("2022-07-01"), by = 1, length.out = nrow(df1))

#time.points

# bind data
data <- zoo(cbind(us, gb), time.points)

# check data
# head(data)

#############
# create data for correlation until date you want. Change the number of last rows
data.cor <- head(data, - 6)          
data.cor

# correlations
matplot(data.cor, type = "l")
cor(data.cor)
##############


# visualize
matplot(data, type = "l")

# set pre and post periods. Change dates accordingly
pre.period <- as.Date(c("2022-01-01", "2022-02-02"))
post.period <- as.Date(c("2022-02-03", "2022-02-07"))

# run causal inference analysis
impact <- CausalImpact(data, pre.period, post.period)

# Plotting results
plot(impact)

#Summary
summary(impact)

# Detailed summary
summary(impact, "report")

# Access all numbers in the report
impact$summary
