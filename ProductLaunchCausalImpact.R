# https://google.github.io/CausalImpact/CausalImpact.html

#load library
library(CausalImpact)
library(pivottabler)

# Example dataset
# set.seed(1)
# x1 <- 100 + arima.sim(model = list(ar = 0.999), n = 100)
# y <- 1.2 * x1 + rnorm(100)
# y[71:100] <- y[71:100] + 10
# data <- cbind(y, x1)

# import data
# data <-  read.csv('/Users/christos/Downloads/oura-launch.csv')

# import data and choose file
df <- read.csv(file.choose())

# pivot table
# arguments:  qpvt(dataFrame, rows, columns, calculations, ...)
pivot1 <- qpvt(df, "NPU_DATE", "COUNTRY", "sum(SUM.PLATFORM_NPU.)") 
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
se <- ts(df1$SE)
row <- ts(df1$ROW)

# bind data
# data <- cbind(us, gb) 

# check data
# head(data)

# visualize
# matplot(data, type = "l")

# Set pre and post periods (no dates)
# pre.period <- c(1, 32)
# post.period <- c(33, 35)

# dates
# nrow() numberof rows
time.points <- seq.Date(as.Date("2022-07-01"), by = 1, length.out = nrow(df1))

#time.points

# bind data
data <- zoo(cbind(us, gb), time.points)

# check data
# head(data)

#############
# create data for correlation until August 1
data.cor <- head(data, - 6)          
data.cor

# correlations
matplot(data.cor, type = "l")
cor(data.cor)
##############


# visualize
matplot(data, type = "l")

pre.period <- as.Date(c("2022-07-01", "2022-08-02"))
post.period <- as.Date(c("2022-08-03", "2022-08-07"))

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
