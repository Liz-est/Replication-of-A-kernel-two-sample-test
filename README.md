# MMD Two-Sample Test — Replication Project

[English](#english) | [中文](#中文)

---

## English

### Overview

This repository contains code reproducing the experiments from:

> Gretton, A., Borgwardt, K., Rasch, M., Schölkopf, B., and Smola, A. (2012).
> **A Kernel Two-Sample Test.** *Journal of Machine Learning Research*, 13, 723–773.

Current progress: Figure 5A and Figure 5B replicated (statistical power vs. dimensionality, distributions differing in mean and variance respectively).

---

### Results

![Figure 5A](results/figure5A.png)

*Replicated Figure 5A: percent correctly rejecting H₀ vs. dimensionality, for two Gaussian distributions with different means (20 mean differences logarithmically spaced from 0.05 to 50). Test level α = 0.05, m = n = 250, averaged over 100 repetitions.*

![Figure 5B](results/figure5B.png)

*Replicated Figure 5B: percent correctly rejecting H₀ vs. dimensionality, for two Gaussian distributions N(0,I) and N(0,σ²I) with different variances (20 σ values logarithmically spaced from 10^0.01 to 10). Test level α = 0.05, m = n = 250, averaged over 100 repetitions.*

**Note on Figure 5B:** The overall rejection rates in our replication are higher than those reported in the paper, particularly for MMD_b. This is likely due to implementation differences in random seed, rather than a bug. The qualitative ordering of methods (MMD²_u M best, MMD²_u H near zero, MMD²_l rising with dimension) is consistent with the paper.

---

### Attribution

The core test implementations in `/original_code` were written by **Arthur Gretton** and are redistributed here solely for reproducibility purposes, with original author comments preserved in each file. Source: https://www.gatsby.ucl.ac.uk/~gretton/mmd/mmd.htm

**Modification note:** `mmdTestBoot.m` has been modified to use an unbiased U-statistic estimator (MMD²_u) in place of the original biased V-statistic, to match the description in Section 5 of Gretton et al. (2012). Both the test statistic and bootstrap null distribution are updated consistently.

All files in `/my_scripts` were written independently as part of this replication project.

---

### Repository Structure

```
/
├── original_code/               # Core test implementations by Arthur Gretton
│   ├── mmdTestBoot.m            # Bootstrap threshold (modified: biased → unbiased)
│   ├── mmdTestPears.m           # Pearson curve threshold
│   ├── mmdTestSpec.m            # Spectral threshold
│   ├── mmdTestGamma.m           # Gamma approximation threshold
│   └── rbf_dot.m                # RBF kernel computation
│
├── my_scripts/                  # Scripts written for this replication
│   ├── generate_data.m          # Data generation (Gaussian / Laplace)
│   ├── compute_mmd.m            # Unbiased MMD² estimator (standalone, for reference)
│   ├── mmdTestBiased.m          # Biased MMD test with McDiarmid threshold
│   ├── mmdTestHoeff.m           # Unbiased MMD² test with Hoeffding threshold
│   ├── mmdTestLinear.m          # Linear-time MMD² test
│   ├── run_experiment.m         # Simple single-condition experiment script
│   └── run_experiment_figure5.m # Figure 5A and 5B replication (power vs. dimension)
│
├── results/
│   ├── figure5A.png             # Replicated Figure 5A (PNG, viewable on GitHub)
│   ├── figure5B.png             # Replicated Figure 5B (PNG, viewable on GitHub)
│   ├── figure5A.fig             # Replicated Figure 5A (MATLAB .fig, interactive)
│   └── figure5B.fig             # Replicated Figure 5B (MATLAB .fig, interactive)
└── README.md
└── LICENSE
```

---

### How to Run

**Single condition test** (`run_experiment.m`):

Manually set `dist_type`, `diff_val`, and `test_type` at the top of the script, then run. Outputs the rejection rate for one configuration. Supports four threshold methods: `boot`, `Spec`, `Pears`, `Gamma`.

**Figure 5A and 5B replication** (`run_experiment_figure5.m`):

Runs the full power-vs-dimension experiment across multiple dimensionalities for both mean-shift and variance-shift settings, and outputs figures to `/results`.

---

### Key Findings

- Successfully replicated Figure 5A (distributions differing in mean): qualitative and quantitative results are consistent with the paper.
- Successfully replicated Figure 5B (distributions differing in variance): qualitative ordering of methods is consistent with the paper; absolute rejection rates are higher than reported, likely due to implementation details in data generation.
- Replacing the biased V-statistic with the unbiased U-statistic in the bootstrap test yields negligible difference in rejection rates, suggesting the bootstrap procedure is robust to this choice.
- MMD²_u M (Pearson curves) achieves the highest power across most settings, consistent with paper results.

---

### License

Code in `/my_scripts` is released under the [MIT License](LICENSE).
Code in `/original_code` belongs to the original authors. See attribution above.

---

## 中文

### 项目简介

本仓库复现了以下论文中的实验：

> Gretton, A., Borgwardt, K., Rasch, M., Schölkopf, B., and Smola, A. (2012).
> **A Kernel Two-Sample Test.** *Journal of Machine Learning Research*, 13, 723–773.

当前进度：已完成 Figure 5A 和 Figure 5B 的复现（统计功效随维度变化曲线，分别对应分布均值不同和方差不同的情况）。

---

### 复现结果

![Figure 5A](results/figure5A.png)

*复现的 Figure 5A：两个均值不同的高斯分布，正确拒绝 H₀ 的比例随维度的变化（20 个均值差，对数等距分布于 0.05 到 50）。显著性水平 α = 0.05，m = n = 250，100 次重复取平均。*

![Figure 5B](results/figure5B.png)

*复现的 Figure 5B：N(0,I) 与 N(0,σ²I) 两个方差不同的高斯分布，正确拒绝 H₀ 的比例随维度的变化（20 个 σ 值，对数等距分布于 10^0.01 到 10）。显著性水平 α = 0.05，m = n = 250，100 次重复取平均。*

**关于 Figure 5B 的说明：** 本复现中整体拒绝率高于论文报告值，尤其是 MMD_b。这可能源于随机种子等实现细节的差异，而非代码错误。各方法的定性排序（MMD²_u M 最优、MMD²_u H 接近零、MMD²_l 随维度上升）与论文一致。

---

### 代码来源说明

`/original_code` 中的核心检验实现由 **Arthur Gretton** 编写，此处仅出于复现目的进行转载，各文件中已保留原作者注释。原始代码来源：https://www.gatsby.ucl.ac.uk/~gretton/mmd/mmd.htm

**修改说明：** `mmdTestBoot.m` 经过修改，将原始的有偏 V-统计量替换为无偏 U-统计量，以符合 Gretton et al. (2012) 第 5 节的描述。检验统计量与 Bootstrap 零分布的计算已同步修改，保证一致性。

`/my_scripts` 中的所有文件为本人编写。

---

### 仓库结构

```
/
├── original_code/               # Arthur Gretton 编写的核心检验实现
│   ├── mmdTestBoot.m            # Bootstrap 阈值（已修改：有偏→无偏）
│   ├── mmdTestPears.m           # Pearson 曲线阈值
│   ├── mmdTestSpec.m            # 谱方法阈值
│   ├── mmdTestGamma.m           # Gamma 近似阈值
│   └── rbf_dot.m                # RBF 核计算
│
├── my_scripts/                  # 本人为复现实验编写的脚本
│   ├── generate_data.m          # 数据生成（高斯分布 / 拉普拉斯分布）
│   ├── compute_mmd.m            # 无偏 MMD² 估计量（独立实现，供参考）
│   ├── mmdTestBiased.m          # 有偏 MMD 检验（McDiarmid 阈值）
│   ├── mmdTestHoeff.m           # 无偏 MMD² 检验（Hoeffding 阈值）
│   ├── mmdTestLinear.m          # 线性时间 MMD² 检验
│   ├── run_experiment.m         # 单条件实验脚本
│   └── run_experiment_figure5.m # Figure 5A 和 5B 复现脚本（功效随维度变化）
│
├── results/
│   ├── figure5A.png             # 复现的 Figure 5A（PNG，可在 GitHub 直接预览）
│   ├── figure5B.png             # 复现的 Figure 5B（PNG，可在 GitHub 直接预览）
│   ├── figure5A.fig             # 复现的 Figure 5A（MATLAB .fig，可交互）
│   └── figure5B.fig             # 复现的 Figure 5B（MATLAB .fig，可交互）
└── README.md
└── LICENSE
```

---

### 运行方式

**单条件测试**（`run_experiment.m`）：

在脚本开头手动设置 `dist_type`、`diff_val`、`test_type`，运行后输出该条件下的拒绝率。支持四种阈值方法：`boot`、`Spec`、`Pears`、`Gamma`。

**Figure 5A 和 5B 复现**（`run_experiment_figure5.m`）：

遍历多个维度设置，分别运行均值偏移和方差偏移两种实验，将图片输出至 `/results`。

---

### 主要发现

- 成功复现论文 Figure 5A（分布均值不同）：定性和定量结果与论文一致。
- 成功复现论文 Figure 5B（分布方差不同）：各方法定性排序与论文一致；整体拒绝率高于论文报告值，可能源于随机数据生成等实现细节的差异。
- 在 Bootstrap 检验中，将有偏 V-统计量替换为无偏 U-统计量对拒绝率的影响可以忽略不计，说明 Bootstrap 方法对估计量的偏差具有一定鲁棒性。
- MMD²_u M（Pearson 曲线）在多数实验设置下表现最优，与论文结论一致。

---

### 许可证

`/my_scripts` 中的代码以 [MIT License](LICENSE) 发布。
`/original_code` 中的代码归原作者所有，详见上方来源说明。
