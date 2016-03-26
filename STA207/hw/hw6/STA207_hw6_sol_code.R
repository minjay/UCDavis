library('lme4')

dat = read.table('data/ratdrink.txt', header = TRUE); dat
# center T so T and T^2 are uncorrelated
dat$T = dat$weeks - mean(dat$weeks); dat$wk
dat$T2 = dat$T^2; dat$T2
dat$weeks = as.factor(dat$weeks)
dat$subject = as.factor(dat$subject)

### 2a
dat.split = split(dat, dat$treat); dat.split
# plot multiple panels on one page
par(mfrow = c(2, 2))
# to use same scale for vertical axes and not exclude data, 
# in plot(), set ylim = c(min(dat$weight), max(dat$weight))
with(dat.split[[1]], 
     plot(wk, weight, 
          ylim = c(min(dat$weight), max(dat$weight))))
with(dat.split[[2]], 
     plot(T, weight, 
          ylim = c(min(dat$weight), max(dat$weight))))
with(dat.split[[3]], 
     plot(T, weight, 
          ylim = c(min(dat$weight), max(dat$weight))))

### 2b
par(mfrow = c(1, 1))
with(dat, boxplot(weight ~ weeks*treat))

### 2c
model = 
  lmer(weight ~ (1|subject) + weeks + treat + weeks:treat, 
       data = dat); model
# weight ~ (1|treat:subject) + weeks + treat + weeks:treat
# is also correct
summary(model)

plot(dat$weight, fitted(model))
plot(fitted(model), resid(model))
# boxplot typo: should be residuals instead of weights
with(dat, boxplot(resid(model) ~ weeks*treat))

### 2d
# anova table: just fixed effects is fine.
anova(model)
summary(model)

# stepwise: obtain aic for full model;
# obtain aic's for: 
# weight ~ weeks + treat + weeks:treat
# weight ~ (1|treat:subject) + treat + weeks:treat
# weight ~ (1|treat:subject) + weeks + weeks:treat
# weight ~ (1|treat:subject) + weeks + treat
# update model based on lowest aic;
# then drop 1 again;
# keep going until you get best aic.
# it is ok if you end up dropping main effects but 
# keeping the interaction effect.
AIC(lmer(weight ~ (1|subject) + weeks + treat + weeks:treat, 
         data = dat))
AIC(lmer(weight ~ (1|subject) + treat + weeks:treat, 
         data = dat))
AIC(lmer(weight ~ (1|subject) + weeks + weeks:treat, 
         data = dat))
AIC(lmer(weight ~ (1|subject) + weeks + treat, 
         data = dat))
# can drop 1 main effect or keep all



### 3a
# typo: T = 0:4, not 0:5
model = 
  lmer(weight ~ 
         (1|subject) + T + (0 + T|subject) + treat, 
       data = dat); model

plot(fitted(model), resid(model))
hist(resid(model))
with(dat, boxplot(resid(model) ~ T*treat))

### 3b
model2 = 
  lmer(weight ~ 
         (1|subject) + T + (0 + T|subject) + 
         T2 + (0 + T2|subject) + treat, 
       data = dat); model2

plot(fitted(model2), resid(model2))
hist(resid(model2))
with(dat, boxplot(resid(model2) ~ T*treat))

### 3c
AIC(model)
AIC(model2)

anova(model2)
summary(model2)

### 3d/e
# interpret question as: 
# are there T:treat and T2:treat interaction effects?
model = 
  lmer(weight ~ 
         (1|subject) + T + T2 + treat + T:treat + T2:treat, 
       data = dat); model
anova(model)
summary(model)

AIC(lmer(weight ~ 
           (1|subject) + T + T2 + treat + T:treat + T2:treat, 
         data = dat))
AIC(lm(weight ~ 
         T + T2 + treat + T:treat + T2:treat, 
       data = dat))
AIC(lmer(weight ~ 
           (1|subject) + T2 + treat + T:treat + T2:treat, 
         data = dat))
AIC(lmer(weight ~ 
           (1|subject) + T + treat + T:treat + T2:treat, 
         data = dat))
AIC(lmer(weight ~ 
           (1|subject) + T + T2 + T:treat + T2:treat, 
         data = dat))
AIC(lmer(weight ~ 
           (1|subject) + T + T2 + treat + T2:treat, 
         data = dat))
AIC(lmer(weight ~ 
           (1|subject) + T + T2 + treat + T:treat, 
         data = dat))
# drop T or T2 or keep all

### 3f
# refer to boxplots in (2c) or 
# plot new ones for (2d) if dropped a term
with(dat, boxplot(resid(model) ~ T*treat))


