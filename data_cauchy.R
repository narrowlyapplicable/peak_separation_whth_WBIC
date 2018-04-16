library(rstan)
library(ggplot2)
setwd('~/RScripts/stan/peak_wbic/')

########## create random data from GaussianMixture ##########
x <- seq(-10, 10, 0.5)

K_True <- 3
peak1 <- dcauchy(x = x, location = 0)
#peak2 <- 0.16 * dcauchy(x = x, location = 1, scale = 0.4)
peak3 <- 0.09 * dcauchy(x = x, location = -0.7, scale = 0.3)
peak4 <- 0.36 * dcauchy(x = x, location = 3, scale=0.6)

#data <- data.frame(x=x, y=peak1+peak2+peak3+peak4+rnorm(x,sd = 0.01))
data <- data.frame(x=x, y=peak1+peak3+peak4+rnorm(x,sd = 0.01))
#plot(data)

p <- ggplot(data)
p <- p + geom_line(aes(x=x, y=y), linetype="dotdash")
p <- p + geom_point(aes(x=x, y=y, colour=y))
plot(p)