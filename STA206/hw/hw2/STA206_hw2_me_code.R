# Zhen Zhang
# STA206 ASS2

# a
muscle <- read.table('~/Github/UCDavis/STA206/Data/muscle.txt')
names(muscle) <- c('mass','age')

# Now draw the histogram
hist(muscle$mass)
hist(muscle$age)

# scatterplot
with(muscle, plot(age, mass))

# b
library(MASS)
boxcox(mass ~ age, data = muscle, lambda = seq(0,10,1))

# c
# fit
lmfit <- lm(mass ~ age, data = muscle)
# summary
summary(lmfit)

# d
# scatterplot
with(muscle, plot(age, mass))
abline(lmfit)

# e
# fitted value and residuals
lmfit$fitted.values[c(6,16)]
lmfit$residuals[c(6,16)]

# f
# residuals plot
plot(lmfit, which = 1)
# qqplot
plot(lmfit, which = 2)

# g
# calculate t statistic
t1 <- qt(0.995, 58)

# h

# i
predict(lmfit, data.frame(age = 60), interval="predict")

# j
anovafit <- anova(lmfit)

# k
# use summary to show the r square
summary(lmfit)
