# What is presented in the following is based on R Tutorials by William B.King, Ph.D Coastal Carolina University Link: http://ww2.coastal.edu/kingw/statistics/R-tutorials/factorial.html

data("ToothGrowth")
str(ToothGrowth)
?ToothGrowth

# Make sure the predictors are all factors
ToothGrowth$dose = factor(ToothGrowth$dose, levels = c(0.5,1.0,2.0), labels = c('low', 'med', 'high'))

# Check 
str(ToothGrowth)
ToothGrowth[seq(1,60,5),]

# To check balance design
replications(len ~ supp*dose, data = ToothGrowth)
# Example of an unblanced design
replications(len ~ supp*dose, data = ToothGrowth[1:58,])
?replications

# Treatment means plot
with( ToothGrowth, interaction.plot(dose, supp, len))
with( ToothGrowth, interaction.plot(supp, dose, len))
?interaction.plot

# Numerical summaries
with(ToothGrowth, tapply(len, list(supp, dose), mean))
with(ToothGrowth, tapply(len, list(supp, dose), var))

# Fit anova model
aov.out = aov(len~supp*dose, data = ToothGrowth)
?aov

model.tables(aov.out, type = 'means', se = T)
model.tables(aov.out, type = 'effects', se = T)
?model.tables
summary(aov.out)

plot(aov.out)


