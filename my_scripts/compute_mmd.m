% This script is to commpute the value of MMD

function mmdu_sq = compute_mmd(X, Y, sigma)
       % X: m x d matrix
       % Y: n x d matrix
       % sigma: nuclear bandwidth parameter核带宽参数
      
       m = size(X, 1);
       n = size(Y, 1);
       
       % 1. call rbf_dot to commpuye kernel matrix
       % rbf_dot return m x m or n x n or m x n matrix
       K = rbf_dot(X, X, sigma);
       L = rbf_dot(Y, Y, sigma);
       KL = rbf_dot(X, Y, sigma);

       %2. Use the unbiased estimaor formula of MMD^2 (P728,Lemma6)
       term1 = (sum(K(:))-trace(K))/(m*(m-1));
       term2 = (sum(L(:))-trace(L))/(n*(n-1));
       term3 = 2*(sum(KL(:)))/(m*n);

       mmdu_sq = term1 + term2 - term3;
end
