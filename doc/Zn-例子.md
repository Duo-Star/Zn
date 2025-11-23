这里给出一些例子

1. 阶乘函数
```Zn
Factorial = (x){
	<< r
	{r = 1}??(x <= 1)
	r = x * f(x-1)
}
```

2. 判定素数
```
isPrime=(i){
	<< r
	f=(k){k+=2 {r=0}??(i?%k)}
	(f)loop(i-2)
	r=1
}
```

3. 2-100 质数检测
```
(i,v){
	{print(v+"is prime")} ?? (
		(i){<<r 
			(k){
				k+=2
				{r=0}??(i?%k)
			}loop(i-2)
			r=1
		} (v)
	)
}for<2..100>
```

4. 数组排序
```
a=<>:fill(20, (i){rand()*100})
bubbleSort=(arr){
	<<r
	n = #arr
	(i){swapped = 0
		(j){
			{arr[j] <-> arr[j+1]}
			??
			(swapped = arr[j]?>arr[j + 1])
		}loop(n-i)
		{r=arr} ?? (~swapped)
	}loop(n-1)
	r=arr
}
print(bubbleSort(a))
```

