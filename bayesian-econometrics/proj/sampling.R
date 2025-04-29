
initialize_S <- function(n_t, P = P_mu) {
  S <- integer(n_t)
  S[1] <- sample(1:m, 1)
  
  for (t in 2:n_t) S[t] <- sample(1:m, 1, prob = P[S[t - 1], ])
  
  S
}

get_eigen <- function(Phi_i_sample) {
  Phi_i_sample <- matrix(Phi_i_sample, ncol = K)[-1, ]
  list_c(map(1:p, ~ abs(eigen(Phi_i_sample[1:3 + K*(p - 1), ])$values)))
}

sample_Phi <- function(X, S, i) {
  ind <- which(S == i)
  
  Y_i <- X[ind[(p + 1):length(ind)], ]
  X_i <- cbind(1, do.call(cbind, lapply(1:p, \(l) X[ind[(p + 1):length(ind)] - l, ])))
  X_i_diag <- as.matrix((t(X_i) %*% X_i) %>% Matrix::bdiag(., ., .))
  
  Sigma_Phii_sample <- solve(solve(Sigma_Phii) + X_i_diag)
  
  prior_contrib <- solve(Sigma_Phii) %*% as.vector(mu_Phii)
  Phi_i_hat <- Sigma_Phii_sample %*% (prior_contrib + as.vector(t(X_i) %*% Y_i))
  
  Phi_i_sample <- rmvnorm(1, as.vector(Phi_i_hat), Sigma_Phii_sample)
  while (any(get_eigen(Phi_i_sample) >= 1)) {
    Phi_i_sample <- rmvnorm(1, as.vector(Phi_i_hat), Sigma_Phii_sample)
  }
  
  list(val = matrix(Phi_i_sample, ncol = K), sd = Sigma_Phii_sample)
}


sample_S <- function(X, Phi, P, Sigma = NULL, prop = 0.05) {
  S_sample <- integer(n_t) #initialize_S(n_t, P)
  S_table <- tabulate(S_sample) / n_t
  
  while (length(S_table) < m || any(S_table < prop)) {
    for (t in n_t:(p + 1)) {
      P_ll <- numeric(m)
      
      for (i in seq_len(m)) {
        X_t <- c(1, list_c(map(1:p, \(l) X[t - l, ])))
        e <- X[t, ] - X_t %*% Phi[[i]]$val
        sigma <- Sigma[[i]] #%||% (t(e) %*% e)
        ll <- dmvnorm(as.numeric(e), sigma = sigma, log = TRUE)
        P_ll[i] <- if (t == n_t) ll else ll + log(P[S[t + 1], i]) #exp(ll + log(P[S[t - 1], i]))
      }
      
      P_ll <- exp(P_ll - max(P_ll))
      P_ll <- P_ll / sum(P_ll)
      S_sample[t] <- sample(seq_len(m), 1, prob = P_ll)
    }
    S_sample[1:p] <- sample(seq_len(m), p, prob = P_ll)
    S_table <- tabulate(S_sample) / n_t
  }
  
  S_sample
}


sample_P <- function(S) {
  counts <- matrix(0, m, m)
  S_diff <- c(0, diff(S))
  ind <- S_diff != 0
  
  counts[c(2, 3)] <- tabulate(S_diff[ind] + 2)[-2]
  counts[c(1, 4)] <- tabulate(S[!ind])
  
  P <- matrix(0, m, m)
  for (i in 1:m) P[i, ] <- rdirichlet(1, P_mu[i, ] + counts[i, ])
  P
}


sample_Sigma <- function(X, Phi, S, P, i) {
  ind <- which(S == i)
  
  Y_i <- X[ind[(p + 1):length(ind)], ]
  X_i <- cbind(1, do.call(cbind, lapply(1:p, \(l) X[ind[(p + 1):length(ind)] - l, ])))
  e <- Y_i - X_i %*% Phi[[i]]$val
  
  riwish(Sigma_df + nrow(e), Sigma_scale + (t(e) %*% e))
}
