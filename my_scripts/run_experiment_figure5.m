%实验设置
% 在 10^0 (即1) 到 10^3.4 (即约2500) 之间，取 25 个点，保证点分布均匀
d_values = round(logspace(0, 3.4, 25));
num_d = length(d_values);
results = zeros(num_d,4);

dist_type = 'gauss';
m = 250;
alpha = 0.05; %显著性水平
n_repeat = 100; %重复次数
% 生成从 0.05 到 50 的对数等距分布的 20 个差异值
% log10(0.05) 是起点，log10(50) 是终点，20 是点数
diff_vals = logspace(log10(0.05), log10(50), 20); 

%参数设置
params.sig = -1; %计算sigma
params.numEigs = -1;
params.plotEigs = 0; %暂时关闭调试功能
params.numNullSamp = 1000; %零假设下的模拟采样次数
params.shuff = 100;
params.bootForce = 1;

%cycle
for j = 1:num_d
    d = d_values(j);            % 提取当前维度的值
    fprintf('Testing dimension: %d\n', d);

    %记录有多少次实验拒绝了H0
    reject_count_H = 0;
    reject_count_pears = 0;
    reject_count_L = 0;
    reject_count_biased = 0;

    for k = 1:length(diff_vals)
        current_diff = diff_vals(k);

    
    for i = 1:n_repeat
        [X, Y] = generate_data(m, d, dist_type, current_diff);
        
    
    % --- 调用已有的Hoeffding 测试计算 Threshold ---
        [testStat,thresh_H,~] = mmdTestHoeff(X,Y,alpha,params);
    
        if testStat > thresh_H
            reject_count_H = reject_count_H + 1;
        end    
   
    % --- 调用已有的 Pearson curve fitting 测试计算 Threshold ---
        [testStat,thresh_pears,~] = mmdTestPears(X,Y,alpha,params);
    
        if testStat > thresh_pears
            reject_count_pears = reject_count_pears + 1;
        end

    % --- 调用已有的Linear CLT 测试计算 Threshold ---
        [testStat,thresh_L,~] = mmdTestLinear(X,Y,alpha,params);
    
        if testStat > thresh_L
            reject_count_L = reject_count_L + 1;
        end    

    % --- 调用已有的biased McDiarmid 测试计算 Threshold ---
        [testStat,thresh_b,~] = mmdTestBiased(X,Y,alpha,params);
    
        if testStat > thresh_b
            reject_count_biased = reject_count_biased + 1;
        end    
    end
    end
    
    % --- 3. 统计结果 ---
    total_trials = length(diff_vals) * n_repeat;
    results(j, 1) = reject_count_biased / total_trials * 100; % 存入 biased 的拒绝率
    results(j, 2) = reject_count_pears / total_trials * 100; % 存入 Pearson 的拒绝率
    results(j, 3) = reject_count_H / total_trials * 100; % 存入 Hoeffding 的拒绝率
    results(j, 4) = reject_count_L / total_trials * 100; % 存入 linear CLT 的拒绝率
    

end

% --- 4. 绘图板块 (严格对标原论文 Figure 5A 风格) ---

% 创建绘图窗口，设置背景为白色，并指定窗口大小
figure('Name', 'MMD Power vs Dimension', 'Color', 'w', 'Position', [100, 100, 700, 550]);

% 原图 Y 轴是 0~1 的比例，如果你前面的 results 存的是 0~100 的百分比，这里除以 100
plot_results = results / 100; 

% 自定义原图中的橙色 (MATLAB 默认没有纯橙色，需要用 RGB 比例调出)
orange_color =[0.91, 0.41, 0.17]; 

% 使用 semilogx 画对数坐标轴
% LineStyle设为'none'取消连线，只保留 Marker，LineWidth 加粗边框，MarkerSize 调大形状
semilogx(d_values, plot_results(:, 1), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5, 'LineStyle', 'none'); hold on;
semilogx(d_values, plot_results(:, 2), 'b<', 'MarkerSize', 8, 'LineWidth', 1.5, 'LineStyle', 'none');
semilogx(d_values, plot_results(:, 3), 'v', 'Color', orange_color, 'MarkerSize', 8, 'LineWidth', 1.5, 'LineStyle', 'none');
semilogx(d_values, plot_results(:, 4), 'g^', 'MarkerSize', 8, 'LineWidth', 1.5, 'LineStyle', 'none');

% --- 坐标轴与字体细节打磨 ---
% 设置坐标轴线宽加粗，字体加粗，字号变大
set(gca, 'FontSize', 14, 'FontWeight', 'bold', 'LineWidth', 1.5);
% 打开小刻度 (Minor Ticks)，使得对数坐标轴看起来更密集、更专业
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on'); 

% 轴标签 (完全对齐原图名称)
xlabel('Dimension', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('percent correctly rejecting H_0', 'FontSize', 16, 'FontWeight', 'bold');

% 标题
title('Normal dist. having different means', 'FontSize', 16, 'FontWeight', 'bold');

% 在图的左上角强行加上大写的字母 'A'
% 注意：x坐标的 1.2 是指在 d=1 稍微偏右的位置，y坐标 1.02 是指在图框外上方
text(1.2, 1.05, 'A', 'FontSize', 24, 'FontWeight', 'bold'); 

% 图例 (完全对齐原图名称，放置在左下角 southwest)
lgd = legend('MMD_b', 'MMD^2_u M', 'MMD^2_u H', 'MMD^2_l', 'Location', 'southwest');
set(lgd, 'FontSize', 12, 'FontWeight', 'normal'); % 图例字体不加粗，以示区分

% 范围限制：X轴从 1 开始到最大维度，Y轴锁定在 0 到 1
xlim([1, max(d_values)]);
ylim([0, 1.05]); % 顶部留出 0.05 的空隙，使得 1 的点不会紧贴天花板
box on; % 闭合图形边框


