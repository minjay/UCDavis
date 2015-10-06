## STA141 Assignment 1 Code
## NAME: ZHEN ZHANG
## ID: 913435403
## 1
dim(vposts)
## 2
names(vposts)
unlist(sapply(vposts, class))
## 3
summary(vposts$price)
quantile(vposts$price, probs = seq(0.1, 1, 0.1), na.rm = T)
ggplot(vposts, aes(x = price)) + geom_density() + geom_rug()
ggplot(vposts, aes(x = price)) + geom_density() + scale_x_continuous(limit = c(0,60000))
## 4
summary(vposts$type)
prop.table(table(vposts$type))
## 5
table(vposts$fuel, vposts$type)
ggplot(vposts, aes(x = type, y = ..count..)) + geom_bar(aes(fill = fuel), position = 'stack')
tableHere <- function(x) {table(x$fuel,x$type)}
by(vposts, vposts$transmission, tableHere)
ggplot(vposts, aes(x = type, y = ..count..)) + geom_bar(aes(fill = fuel), position = 'stack') + facet_wrap(~transmission) +  scale_y_continuous(limit = c(0,1100))
## 6
levels(vposts$city)
length(levels(vposts$city))
## 7
table(vposts$byOwner, vposts$city)
prop.table(table(vposts$byOwner, vposts$city))
prop.table(table(vposts$byOwner, vposts$city), 1) # proportion on row
prop.table(table(vposts$byOwner, vposts$city), 2) # proportion on column
ggplot(vposts, aes(x = city, y = ..count..)) + geom_bar(aes(fill = byOwner), position = 'stack')
## 8
max(vposts$price, na.rm = T)
price_badIndex <- which(vposts$price == max(vposts$price, na.rm = T))
vposts$price[price_badIndex] = 18000
max(vposts$price, na.rm = T)
## 9
s <- split (vposts, vposts$byOwner)
counts_Owner <- table(s$"TRUE"$city,  s$"TRUE"$maker)
counts_Dealer <- table(s$"FALSE"$city,  s$"FALSE"$maker)
returnName = function(counts){names(counts)[order(counts, decreasing = TRUE)[1:3]]}
apply(counts_Owner, 1, returnName)
apply(counts_Dealer, 1, returnName)
## 10
age <- 2015 - vposts$year
vposts$age <- age
ggplot(vposts,aes(x = city, y = age)) + geom_boxplot(outlier.shape = NA) + facet_wrap(~byOwner) + scale_y_continuous(limit = c(0,30))
ggplot(vposts, aes(x = age)) + geom_density() + facet_wrap(~city, scales = "free") + scale_x_continuous(limit = c(0,50))
ggplot(vposts, aes(x = age)) + geom_density() + facet_wrap(~city, scales = "free") + scale_x_continuous(limit = c(0,30))
ggplot(vposts, aes(x = age)) + geom_density() + facet_wrap(~byOwner, scales = "free") + scale_x_continuous(limit = c(0,30))
## 11
ggmap(get_map("america", zoom = 4)) + geom_point(data = vposts, aes(x = long, y = lat))
## 12
vpostsFourVars <- as.data.frame(with(vposts, table(fuel,transmission,drive,type)))
ggplot(vpostsFourVars, aes(x = fuel, y = Freq, fill = type)) + geom_bar(stat = 'identity', position='stack') + facet_grid(transmission~drive)
## 13
ggplot(vposts, aes(y = odometer, x = age)) + geom_point() + scale_y_continuous(limits=c(0, 2.5*10^5)) + scale_x_continuous(limits=c(0, 70)) + stat_smooth()
ggplot(vposts, aes(y = odometer, x = price)) + geom_point() + scale_y_continuous(limits=c(0, 2.5*10^5)) + scale_x_continuous(limits=c(0, 7*10^4)) + stat_smooth()
## 14
ggplot(vposts, aes(x = age)) + geom_histogram() + scale_x_continuous(limit = c(0, 60))
old <- (vposts$age > 10)
vposts$old <- old
vpostsOld <- split(vposts,old)$'TRUE'
with(vpostsOld, table(maker))
ggplot(vpostsOld, aes(price)) + geom_density() + scale_x_continuous(limit = c(0,60000))
## 15
engine <- gsub('.*([0-9][.][0-9])L.*','\\1', vposts$body)
engine[engine == vposts$body] <- NA
head(engine, n = 20)
## 16
condTable <- table(vposts$condition)[order(table(vposts$condition),decreasing = T)[1:8]]
vpostsCond <- vposts[vposts$condition %in% rownames(condTable),]
ggplot(vpostsCond,aes(x = condition, y = odometer)) + geom_boxplot(outlier.shape = NA) + scale_y_continuous(limit = c(0,3.5 * 10^5))
ggplot(vpostsCond,aes(x = condition, y = price)) + geom_boxplot(outlier.shape = NA) + scale_y_continuous(limit = c(0,3.5 * 10^4))
ggplot(vpostsCond,aes(x = condition, y = age)) + geom_boxplot(outlier.shape = NA) + scale_y_continuous(limit = c(0,30))