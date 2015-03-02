

# CPU
通过命令 `cat /proc/cpuinfo|grep "model name"` 查看要对比的CPU信息：

* Intel(R) Core(TM) i3-3240 CPU @ 3.40GHz
* Intel(R) Xeon(R) CPU E31230 @ 3.20GHz

以命令 `sysbench --test=cpu --cpu-max-prime=20000 --num-threads=4 run` 在上述环境中分别变更线程数得到以下汇总结果：


|cpu               | --num-threads | total time (s) |
|------------------|---------------|----------------|
|Intel i3-3240     |  1            |        24.9281 |
|Intel i3-3240     |  4            |         8.0153 |
|Intel i3-3240     |  16           |         7.9028 |
|Intel Xeon E31230 |  1            |        26.5138 |
|Intel Xeon E31230 |  8            |         4.1703 |
|Intel Xeon E31230 |  16           |         3.8671 |

说明：

1. 在不超过cpu内核数量的前提下，增加线程数，可以提高性能。
2. 如果线程数超过cpu内核数量，性能将不会提升。（PS：如果程序编写的不好，甚至会由于过多Context Switch 而造成性能下降）
