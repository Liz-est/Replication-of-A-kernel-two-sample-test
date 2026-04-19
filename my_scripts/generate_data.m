function [X, Y] = generate_data(m, d, dist_type, diff_val)
    % m: 样本量, d: 维度, dist_type: 分布类型(gauss or laplace), diff_val:分布差异程度

    if strcmp(dist_type, 'gauss')
        X = randn(m, d);
        Y = randn(m, d) ; 
        Y(:, 1) = Y(:, 1) + diff_val;%设定差异
       
    elseif strcmp(dist_type, 'laplace')
        % 1. 生成标准的拉普拉斯分布 (均值为0)
        % u 是在 (-0.5, 0.5) 之间的均匀分布
        u = rand(m, d) - 0.5;
        
        % 2. 使用逆变换采样法生成标准拉普拉斯
        % sign(u) 确定正负，log 部分生成绝对值的大小
        X = sign(u) .* log(1 - 2*abs(u));
        
        % 3. 给 Y 加上均值偏置 (diff_val)
        Y = (sign(u) .* log(1 - 2*abs(u))) + diff_val;
    end
end

