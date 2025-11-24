# 简单例子

1. 判定素数
```
isPrime=(i){
	<< r
	f=(k){k+=2 {r=0}??(i?%k)}
	(f)loop(i-2)
	r=1
}
```

2. 阶乘
```
Factorial = (x){
	<< r
	{r = 1}??(x <= 1)
	r = x * Factorial(x-1)
}
```

3. 斐波那契数列
```
fib(n) = n?n<2:fib(n-1)+fib(n-2)
```

4. 康威生命游戏 (Game of Life) 核心逻辑
```
// a, n: 当前状态(1活/0死)，邻居数量
nextState(a, n) = (n?=3)|(a&n?=2)

```

5. 参数曲线
```
// o, r, t : 圆心，半径，参数
circle(o, r, t) = o + r * <cos(t), sin(t)>
```

6. 隐式曲线
```
// p, o, r : 自变量点，圆心，半径
circle(p, o, r) = (p - o).len - r
```
