%实验设置
dist_type = 'gauss';
diff_val = 0.1;
alpha = 0.05; %显著性水平
n_repeat = 1000; %重复次数
test_type = 'boot';

%记录有多少次实验拒绝了H0
reject_count = 0;

%参数设置
params.sig = -1; %计算sigma
params.numEigs = -1;
params.plotEigs = 0; %暂时关闭调试功能
params.numNullSamp = 1000; %零假设下的模拟采样次数
params.shuff = 100;
params.bootForce = 1;

%cycle
for i = 1:n_repeat
    [X, Y] = generate_data(250, 2, dist_type, diff_val);
    % --- 计算 MMD 值 ---
    % data = [X,Y];
    % dist_sq = pdist2(data, data).^2;
    % sigma = sqrt(median(dist_sq(:)/2));%使用中位数，对异常值不敏感
    % 
    % mmd_val = compute_mmd(X, Y, sigma);
    
if strcmp(test_type,'boot') == true
    % --- 调用已有的 Bootstrap 测试计算 Threshold ---
    [testStat,thresh,params] = mmdTestBoot(X,Y,alpha,params);

elseif strcmp(test_type,'Spec') == true
    % --- 调用已有的 Spectral 测试计算 Threshold ---
    [testStat,thresh,params] = mmdTestSpec(X,Y,alpha,params);

elseif strcmp(test_type,'Pears') == true
    % --- 调用已有的 Pearson curve fitting 测试计算 Threshold ---
    [testStat,thresh,params] = mmdTestPears(X,Y,alpha,params);

elseif strcmp(test_type,'Gamma') == true
    % --- 调用已有的 Gamma approximation 测试计算 Threshold ---
    [testStat,thresh,params] = mmdTestGamma(X,Y,alpha,params);

else
    error('不支持的测试类型：%s',test_type)
end

if testStat > thresh
        reject_count = reject_count + 1;
end
end

rejection_rate = reject_count / n_repeat * 100;
fprintf('若分布类型为%s, 分布差异为%.20f\n',dist_type,diff_val)
fprintf('使用测试%s的阈值时，拒绝原假设的概率为: %.2f%%\n', test_type, rejection_rate);



