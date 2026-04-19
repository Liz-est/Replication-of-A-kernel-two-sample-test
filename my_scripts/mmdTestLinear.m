%This function implements the Linear Time MMD two-sample test 
%using the asymptotic normal distribution (Corollary 16).

%Inputs: 
%        X contains dx columns, m rows. Each row is an i.i.d sample
%        Y contains dy columns, m rows. Each row is an i.i.d sample
%        alpha is the level of the test
%        params.sig is kernel size. If -1, use median distance heuristic.

%Outputs: 
%        thresh: test threshold for level alpha test (CLT based)
%        testStat: test statistic: MMD_l^2 (linear, unbiased)

function [testStat,thresh,params] = mmdTestLinear(X,Y,alpha,params)

m=size(X,1);

%Set kernel size to median distance between points in aggregate sample
if params.sig == -1
  Z = [X;Y];  
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

% 线性时间 MMD 计算准备 (Lemma 14)
m2 = floor(m/2);

% 把 X 和 Y 拆分成奇数行和偶数行
Xodd = X(1:2:2*m2-1, :);
Xeven = X(2:2:2*m2, :);
Yodd = Y(1:2:2*m2-1, :);
Yeven = Y(2:2:2*m2, :);

% 为了复用原作者的 rbf_dot 引擎，我们算出矩阵后只取对角线 diag()
% 这实现了公式里的：k(x_{2i-1}, x_{2i})
K_oe = diag(rbf_dot(Xodd, Xeven, params.sig));
L_oe = diag(rbf_dot(Yodd, Yeven, params.sig));
KL_oe = diag(rbf_dot(Xodd, Yeven, params.sig));
LK_oe = diag(rbf_dot(Yodd, Xeven, params.sig));

% 构建 h 向量 (长度为 m2)
hvec = K_oe + L_oe - KL_oe - LK_oe;

% MMD_l^2 就是 h 向量的平均值
testStat = mean(hvec);

% 计算基于中心极限定理的阈值 (Corollary 16)
% 寻找正态分布的 1-alpha 分位数
try
    % 如果安装了 Statistics Toolbox，可以直接用 norminv
    z_alpha = norminv(1-alpha);
catch
    % 如果没有该工具箱，使用基础函数 erfinv 等价计算
    z_alpha = sqrt(2) * erfinv(1 - 2*alpha);
end

% Asymptotic Normal Threshold: z_alpha * std(h) / sqrt(m2)
thresh = z_alpha * std(hvec) / sqrt(m2);

end