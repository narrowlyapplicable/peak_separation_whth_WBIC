library(rstan)
library(ggplot2)
setwd('~/RScripts/stan/peak_wbic/')

source("data_cauchy.R")


rstan_options(auto_write=TRUE)
options(mc.cores=2)#parallel::detectCores())

data_num <- 3
ggsave(paste("mix-cauchy",data_num,".png", sep=""))

stanmodel <- stan_model(file='wbic-mix-cauchy_lpdf.stan')

wbic_list <- rep(NA,6)
rhat_check_list <- rep(-1,6)
for (K in 2:6){
  d <- list(N=nrow(data), K=K, X=data$x, Y=data$y)
  #init <- list(a=rep(1,K)/K, mu=seq(10,40,len=K), s_mu=20, sigma=rep(1,K))
  
  ##### HMC sampling #####
  fit <- sampling(stanmodel, data=d, 
                  iter=10000, warmup=4000, seed=1234)
  ms <- rstan::extract(fit)
  if(K==K_True){
    write.table(x = rstan::summary(fit)$summary, file =paste("summary",data_num,".csv",sep = ""),
                quote = FALSE, sep = ",",col.names = NA)
  }
  ##### Rec WBIC #####
  if(K==1){
    wbic_list[K] <- sum(ms$log_likelihood)
  }
  else{
    wbic_list[K] <- - mean(rowSums(ms$log_likelihood))
  }
  print(wbic_list[K])
  ##### check number of Rhat > 1.1 #####
  fit_smry <- rstan::summary(fit)$summary
  #rhat_check_list[K] <- length(fit_smry[1:3*K, "Rhat"][fit_smry[1:3*K, "Rhat"] > 1.10])
}

print(wbic_list)
save.image(paste('wbic-mix-cauchy',data_num,'.RData', sep = ''))
wbic <- data.frame(n_line=1:6, wbic=wbic_list)

g <- ggplot(data=wbic, aes(x=n_line, y=-wbic))
g <- g + geom_line(linetype="dotdash")
g <- g + geom_point(aes(colour=wbic))
plot(g)
ggsave(filename = paste("wbic",data_num,".png", sep=""), plot = g)