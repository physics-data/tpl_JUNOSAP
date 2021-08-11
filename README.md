# JUNO 模拟与分析软件包

人类最难能可贵的智慧，就是对于未知的领域保有充分的好奇心。他们会穷尽一切手段，使用各种超出一般人认知的方法满足它。例如，在粒子物理领域，中微子的许多性质尚未确定。由于中微子只参与弱相互作用，以 [IBD](https://en.wikipedia.org/wiki/Inverse_beta_decay) 为例，其反应截面要比铀裂变低20个数量级。因此，妄图像化学家那样在烧杯中观察中微子是不现实的。

计算机科学的发展给了我们进一步开展中微子实验的底气。只要我们准备的质子足够多，总能观察到中微子的 IBD 反应。于是，一个个大坑相继出现。这之中较早的是[超级神冈](https://en.wikipedia.org/wiki/Super-Kamiokande)，虽然它一开始是设计用来观测质子衰变的，但是这个圆柱形的大坑很快成为了中微子实验的优质场地。而我们今天要讨论的探测器，是在建的[江门地下中微子实验（JUNO）](https://en.wikipedia.org/wiki/Jiangmen_Underground_Neutrino_Observatory)。其球对称的构造更是为数据处理带来了方便。

反应容器的增大带来的是探测器的数量的急剧增加。如果我们的反应容器只有一升，可能只需要一两个光电倍增管（PMT）；而如果反应容器有一百万升，两个 PMT 显然不够。还好，我们的课程是**大数据**分析，其核心思想就在于，两个和114514个的区别只在于数量。只要我们能够搞定一个，就能搞定17612个。

## 物理过程

这一节看不懂**会影响**后面作业的完成。其中有一些公式，可以选择使用较新版本的 VS Code 预览。

在 JUNO 探测器中，最里面是一个装满了液体闪烁体（液闪，liquid scintillator, LS）的大球，球的半径 $R=900mm$，粒子在这之中会发光；外面是一层水球包裹，水球外面有 PMT。液闪是一种特殊的有机物，在正负电子的激发下会发生能级跃迁，各向同性地发出光子，被 PMT 探测到。这些发光的点被称作顶点。

通常来说，MeV 量级的电子可以近似看作一个顶点，它们会迅速在某个位置耗尽所有动能。MeV 量级的正电子可以近似看作一个电子与两个方向相反的 $\gamma$。$\gamma$ 能量较高，与许多电子发生康普顿散射，可以看作一群顶点。

顶点的动能不会完全转化为发光光子的总能量（也称为可见能量）。这之间的转化满足 [Birks 定律](https://en.wikipedia.org/wiki/Birks%27_law)：
$$
\frac{dL}{dx}=S\frac{\frac{dE}{dx}}{1+kB\frac{dE}{dx}}
$$
其中 $L$ 为光子数，$x$ 为距离，$S$ 为光产额，$kB$ 为 Birks 常数，$\frac{dE}{dx}$ 为电离能损。

光子进入 PMT，在光阴极上发生光电效应，打出光电子（PE）。PE 在 PMT 内经历放大过程，最终电子打到阳极上，生成波形信号。

## 第一阶段

这一阶段的工作是正向的**模拟**。为了响应教育部给大学增负的号召，我们把基础要求定得低一些，并提供额外的加分项。我们强烈建议各位同学仔细考虑这些加分项的性价比，不要为了一两分影响暑假的美好心情。

### 基础要求：模拟 - 70'

给定 JUNO 探测器几何，随机生成4000个顶点，并给出17612个 PMT 上激发得到的 PE 的击中时间（hit time）。注意，并不一定所有 PMT 都会触发。击中时间的时间零点取为顶点的时间。

顶点对位置分布与动量分布有要求（30'）。要求顶点在探测器内的数体积密度均匀。

要求顶点的动量为1 MeV，考虑到 Birks 定律不是考察重点，可以认为每个顶点产生约10000个光子。这些光子实际上经过[非齐次泊松过程](https://en.wikipedia.org/wiki/Poisson_point_process)采样得到，这个泊松过程的期望可以近似认为
$$
\lambda(t)=N \exp{\left(-\frac{t}{\tau}\right)}
$$
其中 $\tau=100ns, N=100$。应当注意到这个函数在 $[0,\infty)$ 上的积分为10000。这些光子的发射方向应当是随机的。

光子击中 PMT 后，有一定概率引发光电效应。为了简便起见，我们认为完全会引发光电效应，并一定产生一个 PE。

为了检验这些结果，需要通过编写画图的程序。要求能够画出如下图像：
* 顶点的数体积密度关于半径的图像（10'）；
* PE 的击中时间的直方图（10'）。

我们会根据生成的模拟数据画图，并和你的画图程序输出比较。

提交的实验报告（20'）应该有完整的对于作业实现的描述、思路、算法等。

### 基础要求：光学过程 - 30'

在实现探测器的响应的时候，最简单的方法是根据平方反比计算。然而，实际情况中，我们可能需要考虑一次反射的情况。

考虑到一次反射，可能出现的情况主要有两种：全反射（10'）和球内成像（10'）。对于光学过程的考察，我们不要求实现细节，但是要求给出 PMT 对于顶点的响应分布。

这个分布我们一般称为 Probe 函数（实际上是忽略了时间和能量的 Probe）。它表示一个 PMT 对探测器内任意一点的顶点的接收的光子产生的 PE 的电荷数期望。我们可以近似认为这上万个 PMT 除了位置不同，其它性质完全相同，因而这个函数只需要考虑顶点与 PMT 的相对位置 $(r,\theta)$，其中 $r\in[0,1]$ 为顶点距离球心的位置，$\theta\in[0,\pi]$ 为顶点与 PMT 相对球心的夹角。对于 Probe 函数 $R(r,\theta)$，你应该给出一个圆盘图像（10'）。

![相对位置](images/pos.png)

### 基础要求：代码 - 1*

提交所使用的代码的 git 仓库链接。代码应该能够运行，且能够在助教正式提交成绩之前停止（注意！时间太长会根据心情扣分）。不满足该条件**0分**。考虑到大家可能还没有学过 Makefile，这次我们提供了基础模板。

|文件名|说明|
|-|-|
|`Makefile`|Makefile|
|`simulate.py`|模拟程序文件|
|`draw.py`|画图程序文件|
|`test.py`|测试程序文件\*|
|`README.md`|说明文件|
|`REPORT.md`|实验报告文件|
|`geo.h5`|PMT 几何数据|
|`data.h5`|模拟输出数据*|
|`figures.pdf`|画图输出*|

\* 会被 `.gitignore` 忽略，你的 git 仓库中不应该出现这些文件。

在完成这个作业之前，建议先看看已经准备好的实验报告模板，那里有一些温馨提示。

`geo.h5` 格式：

`Geometry` 表
|名称|说明|类型|
|-|-|-|
|`ChannelID`|PMT 编号|`'<u4'`|
|`theta`|球坐标 $\theta$|`'<f4'`|
|`phi`|球坐标 $\phi$|`'<f4'`|

`data.h5` 格式：

`ParticleTruth` 表
|名称|说明|类型|
|-|-|-|
|`EventID`|事件编号|`'<i4'`|
|`x`|顶点坐标x/mm|`'<f8'`|
|`y`|顶点坐标y/mm|`'<f8'`|
|`z`|顶点坐标z/mm|`'<f8'`|
|`p`|顶点动量/MeV|`'<f8'`|

`PETruth` 表
|名称|说明|类型|
|-|-|-|
|`EventID`|事件编号|`'<i4'`|
|`ChannelID`|PMT 编号|`'<i4'`|
|`PETime`|PE 击中时间/ns|`'<f8'`|

### 加分项目：康普顿散射 - 5'
考虑顶点是由 $\gamma$ 在液闪内康普顿散射形成的。从数体密度均匀的 $\gamma$ 源开始模拟。不要求顶点的数体密度。实验报告中的顶点密度图像应换成 $\gamma$ 密度图像。

### 加分项目：电子学 - 5'
光子打到 PMT 上，激发出 PE，在 PMT 上留下波形输出。唯象地说，PE 激发得到的波形可以认为是一个双指数模型与随机的电子学噪声的叠加。其中这个双指数函数为
$$
t_l\sim\exp{\left(\frac{t}{\tau_d}\right)}\left(1-\exp{\left(\frac{t}{\tau_r}\right)}\right)
$$
其中$\tau_d$与$\tau_r$为两个待定常数，你可以分别取10ns和5ns，也可以取其它数据观察波形的变化，并在实验报告内说明。

根据电压的不同方向，PE 的波形既可以是向上的，也可以是向下的，不做要求。

当你计算得到波形之后，应该在0到1000ns每1ns采样一个数据点，作为波形的输出结果。这是因为 PMT 输出的并不是模拟信号，而是电子采样之后的信号（联想电视的模拟信号与数字信号）。

电子学噪声可以视作对一个周期无理（或者不是很有理）的正弦函数的采样。要求周期无理是因为看起来随机，要求正弦函数是因为要求很大的区域内积分趋近于0。如果你有别的好办法也可以，并在实验报告内说明。

在 `data.h5` 中增加如下的表：

`Waveform` 表
|名称|说明|类型|
|-|-|-|
|`EventID`|事件编号|`'<i4'`|
|`ChannelID`|PMT 编号|`'<i4'`|
|`Waveform`|波形|`'<i2', (1000,)`|
