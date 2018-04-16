data {
  int N;
  int K;
  vector[N] X;
  vector[N] Y;
}

parameters {
  //vector<lower=0>[K] a;
  vector[K] mu;
  vector<lower=0>[K] sigma;
  real<lower=0> s_mu;
  real<lower=0> s_noise;
}

model {
  //a ~ dirichlet(alpha);
  mu ~ normal(0, s_mu);
  //a ~ student_t(4, 0, 2);
  sigma ~ student_t(4, 0, 2);
  s_noise ~ student_t(4, 0, 0.05);
  for (n in 1:N) {
    vector[K] line;
    for (k in 1:K){
      line[k] = log(sigma[k]^2) + cauchy_lpdf(X[n] | mu[k], sigma[k]);
    }
    target += 1/log(N) * normal_lpdf(Y[n] | exp(log_sum_exp(line)), s_noise);
  }
}

generated quantities {
  vector[N] log_likelihood;
  for(n in 1:N){
    vector[K] line;
    for (k in 1:K){
      line[k] = log(sigma[k]^2) + cauchy_lpdf(X[n] | mu[k], sigma[k]);
    }
    log_likelihood[n] = normal_lpdf(Y[n] | exp(log_sum_exp(line)), s_noise);
  }
}

