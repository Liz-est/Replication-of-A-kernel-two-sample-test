%This function implements the MMD two-sample test using a McDiarmid
%approach (Corollary 9) to compute the test threshold for Biased MMD.

%Xinlu Pan
%26/4/19

%Inputs: 
%        X contains dx columns, m rows. Each row is an i.i.d sample
%        Y contains dy columns, m rows. Each row is an i.i.d sample
%        alpha is the level of the test
%        params.sig is kernel size. If -1, use median distance heuristic.

%Outputs: 
%        thresh: test threshold for level alpha test (Corollary 9)
%        testStat: test statistic: MMD_b (biased, un-squared)

function [testStat,thresh,params] = mmdTestBiased(X,Y,alpha,params)

m=size(X,1);

%Set kernel size to median distance between points in aggregate sample
if params.sig == -1
  Z = [X;Y];  %aggregate the sample
  size1=size(Z,1);
    if size1>100
      Zmed = Z(1:100,:);
      size1 = 100;
    else
      Zmed = Z;
    end
    G = sum((Zmed.*Zmed),2);
    Q = repmat(G,1,size1);
    R = repmat(G',size1,1);
    dists = Q + R - 2*(Zmed*Zmed');
    dists = dists-tril(dists);
    dists=reshape(dists,size1^2,1);
    params.sig = sqrt(0.5*median(dists(dists>0)));  
end

% 计算核矩阵
K = rbf_dot(X,X,params.sig);
L = rbf_dot(Y,Y,params.sig);
KL = rbf_dot(X,Y,params.sig);

% MMD statistic. Here we use biased v-statistic 
term1 = sum(K(:)) / (m*m);
term2 = sum(L(:)) / (m*m);
term3 = 2 * sum(KL(:)) / (m*m);

% 计算 MMD_b^2
mmd2_b = term1 + term2 - term3;

% 根据 Corollary 9，阈值是给 MMD (未平方) 设定的
testStat = sqrt(max(0, mmd2_b)); % 加 max 防止浮点数误差出现微小负数

% 阈值计算 (Corollary 9), 假设高斯核上界 K_bound = 1
thresh = sqrt(2/m) * (1 + sqrt(2 * log(1/alpha)));

end