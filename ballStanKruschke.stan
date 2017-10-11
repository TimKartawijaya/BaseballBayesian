data {
  int<lower=0> S; //number of players
  int<lower=0> P; //number of positions
  int y[S]; //player
  int s[S]; //position
  int atbats[S]; //data of atbats
}

parameters{
  real<lower=0,upper=1> theta[S]; //biasesabilities of each player
  real<lower=0> alphaP[P]; //alpha beta of lower level, describe biases of each player
  real<lower=0> betaP[P];
  real<lower=0> alpha1; //alpha beta that describes the gamma of alphaP
  real<lower=0> beta1;
  real<lower=0> alpha2; //alpha beta that describes the gamma of betaP
  real<lower=0> beta2;
}

model {
  //prior
  alpha1 ~ gamma(0.01,0.01);
  beta1 ~ gamma(0.01,0.01);
  alpha2 ~ gamma(0.01,0.01);
  beta2 ~ gamma(0.01,0.01);

//each position parameter is different, according to the priors
  for (j in 1:P){
    alphaP[j] ~ gamma(alpha1, beta1);
    betaP[j] ~ gamma(alpha2, beta2);
  }

  for (i in 1:S){
    theta[i] ~ beta(alphaP[s[i]], betaP[s[i]]);
    y[i] ~ binomial(atbats[i], theta[i]);
  }
}

generated quantities{
  vector[9] mu;
  vector[9] stdev;
  for(i in 1:P){
    mu[i] = alphaP[i] / (alphaP[i] + betaP[i]);
    stdev[i] = (alphaP[i]*betaP[i])/((alphaP[i] + betaP[i])^2 * (alphaP[i]+betaP[i]+1));
  }
}
