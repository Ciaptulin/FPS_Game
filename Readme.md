# 蓝图进阶

蓝图通信的一种方式

我们已经在BP_ChallengeCharacter里面创建了自定义的Dead节点，在这里通过cast to类型转换，就可以访问到这个Dead节点了

![img](https://cdn.nlark.com/yuque/0/2026/png/25470454/1781324383023-f5616d7d-9c2e-4962-bbba-65e0170d2049.png)

*BP_ChallengeCharacter*内的Dead节点

![img](https://cdn.nlark.com/yuque/0/2026/png/25470454/1781324166749-c1cf925c-9180-45fd-8f8a-1c6957af6a50.png)

缺点：cast to类型转换节点非常消耗内存，我们只需要使用dead，其他节点不管用不用全部加载，但是蓝图通信是点对点的，性能更好



![img](https://cdn.nlark.com/yuque/0/2026/png/25470454/1782149170842-3cdc08b0-9600-4a29-b1be-d94363a3b5fe.png)![img](https://cdn.nlark.com/yuque/0/2026/png/25470454/1782149230073-622c6e78-d1bd-47e9-98be-e3b23ac5f5f3.png)

其实就是并行计算转串行计算



![img](https://cdn.nlark.com/yuque/0/2026/png/25470454/1782384360286-d90439f4-ab5d-4fdf-8f5f-afa4e022f95e.png)

这张表记录了开火特效的用户参数调整效果

