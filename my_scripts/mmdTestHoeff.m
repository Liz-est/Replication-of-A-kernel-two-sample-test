%This function implements the MMD two-sample test using a Hoeffding 
%approach to compute the test threshold.


%Xinlu Pan
%26/4/19

%Inputs: 
%        X contains dx columns, m rows. Each row is an i.i.d sample
%        Y contains dy columns, m rows. Each row is an i.i.d sample
%        alpha is the level of the test
%        params.sig is kernel size. If -1, use median distance heuristic.
%        params.shuff is number of bootstrap shuffles used to
%                     estimate null CDF



%Outputs: 
%        thresh: test threshold for level alpha test
%        testStat: test statistic: m * MMD_u (unbiased)
function [testStat,thresh,params] = mmdTestHoeff(X,Y,alpha,params)

    
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
    dists = Q + R - 2*Zmed*Zmed';
    dists = dists-tril(dists);
    dists=reshape(dists,size1^2,1);
    params.sig = sqrt(0.5*median(dists(dists>0)));  %rbf_dot has factor two in kernel
end


K = rbf_dot(X,X,params.sig);
L = rbf_dot(Y,Y,params.sig);
KL = rbf_dot(X,Y,params.sig);


%MMD statistic. Here we use unbiased 
term1 = (sum(K(:))-trace(K))/(m*(m-1));
term2 = (sum(L(:))-trace(L))/(m*(m-1));
term3 = 2*(sum(KL(:)))/(m*m);

testStat = term1 + term2 - term3;

thresh = (4 / sqrt(m)) * sqrt(log(1/alpha));