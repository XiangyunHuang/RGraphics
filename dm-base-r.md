
# 数据操作手 {#data-manipulator}

> 参考 Data Manipulation With R [@Spector_2008_Manipulation] 重新捋一遍本章
> 本章的操作对象是 data.frame

::: sidebar
介绍 Base R 提供的数据操作，关于采用 Base R 还是 tidyverse 做数据操作的 [讨论](https://d.cosx.org/d/420697)

数据操作的动画展示参考 <https://github.com/gadenbuie/tidyexplain> 提供 Base R 对应的实现
:::

什么是 Base R? Base R 指的是 R 语言/软件的核心组件，由 R Core Team 维护


```r
Pkgs <- sapply(list.files(R.home("library")), function(x)
  packageDescription(pkg = x, fields = "Priority"))
names(Pkgs[Pkgs == "base" & !is.na(Pkgs)])
#>  [1] "base"      "compiler"  "datasets"  "graphics"  "grDevices"
#>  [6] "grid"      "methods"   "parallel"  "splines"   "stats"    
#> [11] "stats4"    "tcltk"     "tools"     "utils"
```


```r
names(Pkgs[Pkgs == "recommended" & !is.na(Pkgs)])
#> character(0)
```

数据变形，分组统计聚合等，用以作为模型的输入，绘图的对象，操作的数据对象是数据框(data.frame)类型的，而且如果没有特别说明，文中出现的数据集都是 Base R 内置的，第三方 R 包或者来源于网上的数据集都会加以说明。

## 查看数据 {#show}

查看属性


```r
str(iris)
#> 'data.frame':	150 obs. of  5 variables:
#>  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
#>  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
#>  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
#>  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...
#>  $ Species     : Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1..
```

查看部分数据集


```r
head(iris, 5)
#>   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1          5.1         3.5          1.4         0.2  setosa
#> 2          4.9         3.0          1.4         0.2  setosa
#> 3          4.7         3.2          1.3         0.2  setosa
#> 4          4.6         3.1          1.5         0.2  setosa
#> 5          5.0         3.6          1.4         0.2  setosa
tail(iris, 5)
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 146          6.7         3.0          5.2         2.3 virginica
#> 147          6.3         2.5          5.0         1.9 virginica
#> 148          6.5         3.0          5.2         2.0 virginica
#> 149          6.2         3.4          5.4         2.3 virginica
#> 150          5.9         3.0          5.1         1.8 virginica
```

查看文件前（后）5行

```bash
head -n 5 test.csv
tail -n 5 test.csv
```

对象的类型，存储方式


```r
class(iris)
#> [1] "data.frame"
mode(iris)
#> [1] "list"
typeof(iris)
#> [1] "list"
```

查看对象在R环境中所占空间的大小


```r
object.size(iris)
#> 7256 bytes
object.size(letters)
#> 1712 bytes
object.size(ls)
#> 89904 bytes
format(object.size(library), units = "auto")
#> [1] "1.8 Mb"
```

## 数据变形 {#base-reshape}

重复测量数据的变形 Reshape Grouped Data，将宽格式 wide 的数据框变长格式 long的，反之也行。reshape 还支持正则表达式


```r
str(Indometh)
#> Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':	66 obs. of  3 variables:
#>  $ Subject: Ord.factor w/ 6 levels "1"<"4"<"2"<"5"<..: 1 1 1 1 1 1 1 1 1 ..
#>  $ time   : num  0.25 0.5 0.75 1 1.25 2 3 4 5 6 ...
#>  $ conc   : num  1.5 0.94 0.78 0.48 0.37 0.19 0.12 0.11 0.08 0.07 ...
#>  - attr(*, "formula")=Class 'formula'  language conc ~ time | Subject
#>   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
#>  - attr(*, "labels")=List of 2
#>   ..$ x: chr "Time since drug administration"
#>   ..$ y: chr "Indomethacin concentration"
#>  - attr(*, "units")=List of 2
#>   ..$ x: chr "(hr)"
#>   ..$ y: chr "(mcg/ml)"
summary(Indometh)
#>  Subject      time            conc       
#>  1:11    Min.   :0.250   Min.   :0.0500  
#>  4:11    1st Qu.:0.750   1st Qu.:0.1100  
#>  2:11    Median :2.000   Median :0.3400  
#>  5:11    Mean   :2.886   Mean   :0.5918  
#>  6:11    3rd Qu.:5.000   3rd Qu.:0.8325  
#>  3:11    Max.   :8.000   Max.   :2.7200
```

```r
# 长的变宽
wide <- reshape(Indometh,
  v.names = "conc", idvar = "Subject",
  timevar = "time", direction = "wide"
)
wide[, 1:6]
#>    Subject conc.0.25 conc.0.5 conc.0.75 conc.1 conc.1.25
#> 1        1      1.50     0.94      0.78   0.48      0.37
#> 12       2      2.03     1.63      0.71   0.70      0.64
#> 23       3      2.72     1.49      1.16   0.80      0.80
#> 34       4      1.85     1.39      1.02   0.89      0.59
#> 45       5      2.05     1.04      0.81   0.39      0.30
....

# 宽的变长
reshape(wide, direction = "long")
#>        Subject time conc
#> 1.0.25       1 0.25 1.50
#> 2.0.25       2 0.25 2.03
#> 3.0.25       3 0.25 2.72
#> 4.0.25       4 0.25 1.85
#> 5.0.25       5 0.25 2.05
....
```

宽的格式变成长的格式 <https://stackoverflow.com/questions/2185252>

长的格式变成宽的格式 <https://stackoverflow.com/questions/5890584/>


```r
set.seed(45)
dat <- data.frame(
    name = rep(c("Orange", "Apple"), each=4),
    numbers = rep(1:4, 2),
    value = rnorm(8))
dat
#>     name numbers      value
#> 1 Orange       1  0.3407997
#> 2 Orange       2 -0.7033403
#> 3 Orange       3 -0.3795377
#> 4 Orange       4 -0.7460474
#> 5  Apple       1 -0.8981073
#> 6  Apple       2 -0.3347941
#> 7  Apple       3 -0.5013782
#> 8  Apple       4 -0.1745357

reshape(dat, idvar = "name", timevar = "numbers", direction = "wide")
#>     name    value.1    value.2    value.3    value.4
#> 1 Orange  0.3407997 -0.7033403 -0.3795377 -0.7460474
#> 5  Apple -0.8981073 -0.3347941 -0.5013782 -0.1745357
```

更加复杂的例子， gambia 数据集，重塑的效果是使得个体水平的长格式变为村庄水平的宽格式


```r
# data(gambia, package = "geoR")
# 在线下载数据集
gambia <- read.table(
  file =
    paste("http://www.leg.ufpr.br/lib/exe/fetch.php",
      "pessoais:paulojus:mbgbook:datasets:gambia.txt",
      sep = "/"
    ), header = TRUE
)
head(gambia)
#>          x       y pos  age netuse treated green phc
#> 1 349631.3 1458055   1 1783      0       0 40.85   1
#> 2 349631.3 1458055   0  404      1       0 40.85   1
#> 3 349631.3 1458055   0  452      1       0 40.85   1
#> 4 349631.3 1458055   1  566      1       0 40.85   1
#> 5 349631.3 1458055   0  598      1       0 40.85   1
#> 6 349631.3 1458055   1  590      1       0 40.85   1
# Building a "village-level" data frame
ind <- paste("x", gambia[, 1], "y", gambia[, 2], sep = "")
village <- gambia[!duplicated(ind), c(1:2, 7:8)]
village$prev <- as.vector(tapply(gambia$pos, ind, mean))
head(village)
#>            x       y green phc      prev
#> 1   349631.3 1458055 40.85   1 0.5151515
#> 34  358543.1 1460112 40.85   1 0.3015873
#> 97  360308.1 1460026 40.10   0 0.4117647
#> 114 363795.7 1496919 40.85   0 0.3333333
#> 138 366400.5 1460248 40.85   0 0.3846154
#> 164 366687.5 1463002 40.85   0 0.3888889
```

## 数据转换 {#base-transform}

transform 对数据框中的某些列做计算，取对数，将计算的结果单存一列加到数据框中


```r
transform(iris, scale.sl = (max(Sepal.Length) - Sepal.Length) / (max(Sepal.Length) - min(Sepal.Length)))
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 1            5.1         3.5          1.4         0.2     setosa
#> 2            4.9         3.0          1.4         0.2     setosa
#> 3            4.7         3.2          1.3         0.2     setosa
#> 4            4.6         3.1          1.5         0.2     setosa
#> 5            5.0         3.6          1.4         0.2     setosa
....
```

验证一下 `scale.sl` 变量的第一个值


```r
(max(iris$Sepal.Length) - 5.1) / (max(iris$Sepal.Length) - min(iris$Sepal.Length))
#> [1] 0.7777778
```

::: sidebar
Warning: This is a convenience function intended for use interactively. For programming it is better to use the standard subsetting arithmetic functions, and in particular the non-standard evaluation of argument `transform` can have unanticipated consequences.
:::

## 提取子集 {#base-subset}


```r
subset(x, subset, select, drop = FALSE, ...)
```

参数 `subset`代表行操作，`select` 代表列操作，函数 `subset` 从数据框中提取部分数据


```r
subset(iris, Species == "virginica")
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 101          6.3         3.3          6.0         2.5 virginica
#> 102          5.8         2.7          5.1         1.9 virginica
#> 103          7.1         3.0          5.9         2.1 virginica
#> 104          6.3         2.9          5.6         1.8 virginica
#> 105          6.5         3.0          5.8         2.2 virginica
....
# summary(iris$Sepal.Length)  mean(iris$Sepal.Length)
# 且的逻辑
# subset(iris, Species == "virginica" & Sepal.Length > 5.84333)
subset(iris, Species == "virginica" &
  Sepal.Length > mean(Sepal.Length))
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 101          6.3         3.3          6.0         2.5 virginica
#> 103          7.1         3.0          5.9         2.1 virginica
#> 104          6.3         2.9          5.6         1.8 virginica
#> 105          6.5         3.0          5.8         2.2 virginica
#> 106          7.6         3.0          6.6         2.1 virginica
....
# 在行的子集范围内
subset(iris, Species %in% c("virginica", "versicolor") &
  Sepal.Length > mean(Sepal.Length))
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 51           7.0         3.2          4.7         1.4 versicolor
#> 52           6.4         3.2          4.5         1.5 versicolor
#> 53           6.9         3.1          4.9         1.5 versicolor
#> 55           6.5         2.8          4.6         1.5 versicolor
#> 57           6.3         3.3          4.7         1.6 versicolor
....
# 在列的子集内 先选中列
subset(iris, Sepal.Length > mean(Sepal.Length),
  select = c("Sepal.Length", "Species")
)
#>     Sepal.Length    Species
#> 51           7.0 versicolor
#> 52           6.4 versicolor
#> 53           6.9 versicolor
#> 55           6.5 versicolor
#> 57           6.3 versicolor
....
```

高级操作：加入正则表达式筛选


```r
## sometimes requiring a logical 'subset' argument is a nuisance
nm <- rownames(state.x77)
start_with_M <- nm %in% grep("^M", nm, value = TRUE)
subset(state.x77, start_with_M, Illiteracy:Murder)
#>               Illiteracy Life Exp Murder
#> Maine                0.7    70.39    2.7
#> Maryland             0.9    70.22    8.5
#> Massachusetts        1.1    71.83    3.3
#> Michigan             0.9    70.63   11.1
#> Minnesota            0.6    72.96    2.3
#> Mississippi          2.4    68.09   12.5
#> Missouri             0.8    70.69    9.3
#> Montana              0.6    70.56    5.0
# 简化
subset(state.x77, subset = grepl("^M", rownames(state.x77)), select = Illiteracy:Murder)
#>               Illiteracy Life Exp Murder
#> Maine                0.7    70.39    2.7
#> Maryland             0.9    70.22    8.5
#> Massachusetts        1.1    71.83    3.3
#> Michigan             0.9    70.63   11.1
#> Minnesota            0.6    72.96    2.3
#> Mississippi          2.4    68.09   12.5
#> Missouri             0.8    70.69    9.3
#> Montana              0.6    70.56    5.0
# 继续简化
subset(state.x77, grepl("^M", rownames(state.x77)), Illiteracy:Murder)
#>               Illiteracy Life Exp Murder
#> Maine                0.7    70.39    2.7
#> Maryland             0.9    70.22    8.5
#> Massachusetts        1.1    71.83    3.3
#> Michigan             0.9    70.63   11.1
#> Minnesota            0.6    72.96    2.3
#> Mississippi          2.4    68.09   12.5
#> Missouri             0.8    70.69    9.3
#> Montana              0.6    70.56    5.0
```

::: sidebar
警告：这是一个为了交互使用打造的便捷函数。对于编程，最好使用标准的子集函数，如 `[`，特别地，参数 `subset` 的非标准计算(non-standard evaluation)[^non-standard-eval] 可能带来意想不到的后果。
:::

使用索引 `[` 


```r
iris[iris$Species == "virginica", ]
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 101          6.3         3.3          6.0         2.5 virginica
#> 102          5.8         2.7          5.1         1.9 virginica
#> 103          7.1         3.0          5.9         2.1 virginica
#> 104          6.3         2.9          5.6         1.8 virginica
#> 105          6.5         3.0          5.8         2.2 virginica
....
iris[iris$Species == "virginica" &
  iris$Sepal.Length > mean(iris$Sepal.Length), ]
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
#> 101          6.3         3.3          6.0         2.5 virginica
#> 103          7.1         3.0          5.9         2.1 virginica
#> 104          6.3         2.9          5.6         1.8 virginica
#> 105          6.5         3.0          5.8         2.2 virginica
#> 106          7.6         3.0          6.6         2.1 virginica
....

iris[
  iris$Species == "virginica" &
    iris$Sepal.Length > mean(iris$Sepal.Length),
  c("Sepal.Length", "Species")
]
#>     Sepal.Length   Species
#> 101          6.3 virginica
#> 103          7.1 virginica
#> 104          6.3 virginica
#> 105          6.5 virginica
#> 106          7.6 virginica
....
```

[^non-standard-eval]: Thomas Lumley (2003) Standard nonstandard evaluation rules. https://developer.r-project.org/nonstandard-eval.pdf

## 按列排序 {#base-order}

在数据框内，根据(order)某一列或几列对行进行排序(sort)，根据鸢尾花(iris)的类别(Species)对萼片(sepal)的长度进行排序，其余的列随之变化


```r
# 对萼片的长度排序
iris[order(iris$Species, iris$Sepal.Length), ]
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 14           4.3         3.0          1.1         0.1     setosa
#> 9            4.4         2.9          1.4         0.2     setosa
#> 39           4.4         3.0          1.3         0.2     setosa
#> 43           4.4         3.2          1.3         0.2     setosa
#> 42           4.5         2.3          1.3         0.3     setosa
....
# 对花瓣的长度排序
iris[order(iris$Species, iris$Petal.Length), ]
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 23           4.6         3.6          1.0         0.2     setosa
#> 14           4.3         3.0          1.1         0.1     setosa
#> 15           5.8         4.0          1.2         0.2     setosa
#> 36           5.0         3.2          1.2         0.2     setosa
#> 3            4.7         3.2          1.3         0.2     setosa
....
# 先对花瓣的宽度排序，再对花瓣的长度排序
iris[order(iris$Petal.Width, iris$Petal.Length), ]
#>     Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
#> 14           4.3         3.0          1.1         0.1     setosa
#> 13           4.8         3.0          1.4         0.1     setosa
#> 38           4.9         3.6          1.4         0.1     setosa
#> 10           4.9         3.1          1.5         0.1     setosa
#> 33           5.2         4.1          1.5         0.1     setosa
....
```

sort/ordered 排序， 默认是升序


```r
dd <- data.frame(
  b = factor(c("Hi", "Med", "Hi", "Low"),
    levels = c("Low", "Med", "Hi"), ordered = TRUE
  ),
  x = c("A", "D", "A", "C"), y = c(8, 3, 9, 9),
  z = c(1, 1, 1, 2)
)
str(dd)
#> 'data.frame':	4 obs. of  4 variables:
#>  $ b: Ord.factor w/ 3 levels "Low"<"Med"<"Hi": 3 2 3 1
#>  $ x: chr  "A" "D" "A" "C"
#>  $ y: num  8 3 9 9
#>  $ z: num  1 1 1 2
dd[order(-dd[,4], dd[,1]), ]
#>     b x y z
#> 4 Low C 9 2
#> 2 Med D 3 1
#> 1  Hi A 8 1
#> 3  Hi A 9 1
```

根据变量 z 


```r
dd[order(dd$z, dd$b), ]
#>     b x y z
#> 2 Med D 3 1
#> 1  Hi A 8 1
#> 3  Hi A 9 1
#> 4 Low C 9 2
```

## 数据拆分 {#base-split}

数据拆分通常是按找某一个分类变量分组，分完组就是计算，计算完就把结果按照原来的分组方式合并


```r
## Notice that assignment form is not used since a variable is being added
g <- airquality$Month
l <- split(airquality, g) # 分组
l <- lapply(l, transform, Oz.Z = scale(Ozone)) # 计算：按月对 Ozone 标准化
aq2 <- unsplit(l, g) # 合并
head(aq2)
#>   Ozone Solar.R Wind Temp Month Day       Oz.Z
#> 1    41     190  7.4   67     5   1  0.7822293
#> 2    36     118  8.0   72     5   2  0.5572518
#> 3    12     149 12.6   74     5   3 -0.5226399
#> 4    18     313 11.5   62     5   4 -0.2526670
#> 5    NA      NA 14.3   56     5   5         NA
#> 6    28      NA 14.9   66     5   6  0.1972879
```

tapply 自带分组的功能，按月份 Month 对 Ozone 中心标准化，其返回一个列表


```r
with(airquality, tapply(Ozone, Month, scale))
#> $`5`
#>              [,1]
#>  [1,]  0.78222929
#>  [2,]  0.55725184
#>  [3,] -0.52263993
#>  [4,] -0.25266698
#>  [5,]          NA
#>  [6,]  0.19728792
#>  [7,] -0.02768953
#>  [8,] -0.20767149
....
```

上面的过程等价于


```r
do.call("rbind", lapply(split(airquality, airquality$Month), transform, Oz.Z = scale(Ozone)))
#>       Ozone Solar.R Wind Temp Month Day         Oz.Z
#> 5.1      41     190  7.4   67     5   1  0.782229293
#> 5.2      36     118  8.0   72     5   2  0.557251841
#> 5.3      12     149 12.6   74     5   3 -0.522639926
#> 5.4      18     313 11.5   62     5   4 -0.252666984
#> 5.5      NA      NA 14.3   56     5   5           NA
#> 5.6      28      NA 14.9   66     5   6  0.197287919
#> 5.7      23     299  8.6   65     5   7 -0.027689532
#> 5.8      19      99 13.8   59     5   8 -0.207671494
#> 5.9       8      19 20.1   61     5   9 -0.702621887
....
```

由于上面对 Ozone 正态标准化，所以标准化后的 `Oz.z` 再按月分组计算方差自然每个月都是 1，而均值都是 0。


```r
with(aq2, tapply(Oz.Z, Month, sd, na.rm = TRUE))
#> 5 6 7 8 9 
#> 1 1 1 1 1
with(aq2, tapply(Oz.Z, Month, mean, na.rm = TRUE))
#>             5             6             7             8             9 
#> -4.240273e-17  1.052760e-16  5.841432e-17  5.898060e-17  2.571709e-17
```

> 循着这个思路，我们可以用 tapply 实现分组计算，上面函数 `sd` 和 `mean` 完全可以用自定义的更加复杂的函数替代 

`cut` 函数可以将连续型变量划分为分类变量


```r
set.seed(2019)
Z <- stats::rnorm(10)
cut(Z, breaks = -6:6)
#>  [1] (0,1]   (-1,0]  (-2,-1] (0,1]   (-2,-1] (0,1]   (-1,0]  (0,1]  
#>  [9] (-2,-1] (-1,0] 
#> 12 Levels: (-6,-5] (-5,-4] (-4,-3] (-3,-2] (-2,-1] (-1,0] (0,1] ... (5,6]
# labels = FALSE 返回每个数所落的区间位置
cut(Z, breaks = -6:6, labels = FALSE)
#>  [1] 7 6 5 7 5 7 6 7 5 6
```

我们还可以指定参数 `dig.lab` 设置分组的精度，`ordered` 将分组变量看作是有序的，`breaks` 传递单个数时，表示分组数，而不是断点


```r
cut(Z, breaks = 3, dig.lab = 4, ordered = TRUE)
#>  [1] (0.06396,0.9186]  (-0.7881,0.06396] (-1.643,-0.7881] 
#>  [4] (0.06396,0.9186]  (-1.643,-0.7881]  (0.06396,0.9186] 
#>  [7] (-0.7881,0.06396] (0.06396,0.9186]  (-1.643,-0.7881] 
#> [10] (-0.7881,0.06396]
#> Levels: (-1.643,-0.7881] < (-0.7881,0.06396] < (0.06396,0.9186]
```

此时，统计每组的频数，如图 \@ref(fig:cut)


```r
# 条形图
plot(cut(Z, breaks = -6:6))
# 直方图
hist(Z, breaks = -6:6)
```

<div class="figure" style="text-align: center">
<img src="dm-base-r_files/figure-html/cut-1.png" alt="连续型变量分组统计" width="35%" /><img src="dm-base-r_files/figure-html/cut-2.png" alt="连续型变量分组统计" width="35%" />
<p class="caption">(\#fig:cut)连续型变量分组统计</p>
</div>

在指定分组数的情况下，我们还想获取分组的断点


```r
labs <- levels(cut(Z, 3))
labs
#> [1] "(-1.64,-0.788]" "(-0.788,0.064]" "(0.064,0.919]"
```

用正则表达式抽取断点


```r
cbind(
  lower = as.numeric(sub("\\((.+),.*", "\\1", labs)),
  upper = as.numeric(sub("[^,]*,([^]]*)\\]", "\\1", labs))
)
#>       lower  upper
#> [1,] -1.640 -0.788
#> [2,] -0.788  0.064
#> [3,]  0.064  0.919
```

更多相关函数可以参考 `findInterval` 和 `embed` 

tabulate 和 table 有所不同，它表示排列


```r
t(combn(8, 4, tabulate, nbins = 8))
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8]
#>  [1,]    1    1    1    1    0    0    0    0
#>  [2,]    1    1    1    0    1    0    0    0
#>  [3,]    1    1    1    0    0    1    0    0
#>  [4,]    1    1    1    0    0    0    1    0
#>  [5,]    1    1    1    0    0    0    0    1
....
```

## 数据合并 {#base-merge}

merge 合并两个数据框


```r
authors <- data.frame(
  ## I(*) : use character columns of names to get sensible sort order
  surname = I(c("Tukey", "Venables", "Tierney", "Ripley", "McNeil")),
  nationality = c("US", "Australia", "US", "UK", "Australia"),
  deceased = c("yes", rep("no", 4))
)
authorN <- within(authors, {
  name <- surname
  rm(surname)
})
books <- data.frame(
  name = I(c(
    "Tukey", "Venables", "Tierney",
    "Ripley", "Ripley", "McNeil", "R Core"
  )),
  title = c(
    "Exploratory Data Analysis",
    "Modern Applied Statistics ...",
    "LISP-STAT",
    "Spatial Statistics", "Stochastic Simulation",
    "Interactive Data Analysis",
    "An Introduction to R"
  ),
  other.author = c(
    NA, "Ripley", NA, NA, NA, NA,
    "Venables & Smith"
  )
)

authors
#>    surname nationality deceased
#> 1    Tukey          US      yes
#> 2 Venables   Australia       no
#> 3  Tierney          US       no
#> 4   Ripley          UK       no
#> 5   McNeil   Australia       no
authorN
#>   nationality deceased     name
#> 1          US      yes    Tukey
#> 2   Australia       no Venables
#> 3          US       no  Tierney
#> 4          UK       no   Ripley
#> 5   Australia       no   McNeil
books
#>       name                         title     other.author
#> 1    Tukey     Exploratory Data Analysis             <NA>
#> 2 Venables Modern Applied Statistics ...           Ripley
#> 3  Tierney                     LISP-STAT             <NA>
#> 4   Ripley            Spatial Statistics             <NA>
#> 5   Ripley         Stochastic Simulation             <NA>
#> 6   McNeil     Interactive Data Analysis             <NA>
#> 7   R Core          An Introduction to R Venables & Smith
```

默认找到同名的列，然后是同名的行合并，多余的没有匹配到的就丢掉


```r
merge(authorN, books)
#>       name nationality deceased                         title other.author
#> 1   McNeil   Australia       no     Interactive Data Analysis         <NA>
#> 2   Ripley          UK       no            Spatial Statistics         <NA>
#> 3   Ripley          UK       no         Stochastic Simulation         <NA>
#> 4  Tierney          US       no                     LISP-STAT         <NA>
#> 5    Tukey          US      yes     Exploratory Data Analysis         <NA>
#> 6 Venables   Australia       no Modern Applied Statistics ...       Ripley
```

还可以指定合并的列，先按照 surname 合并，留下 surname


```r
merge(authors, books, by.x = "surname", by.y = "name")
#>    surname nationality deceased                         title other.author
#> 1   McNeil   Australia       no     Interactive Data Analysis         <NA>
#> 2   Ripley          UK       no            Spatial Statistics         <NA>
#> 3   Ripley          UK       no         Stochastic Simulation         <NA>
#> 4  Tierney          US       no                     LISP-STAT         <NA>
#> 5    Tukey          US      yes     Exploratory Data Analysis         <NA>
#> 6 Venables   Australia       no Modern Applied Statistics ...       Ripley
```

留下的是 name


```r
merge(books, authors, by.x = "name", by.y = "surname")
#>       name                         title other.author nationality deceased
#> 1   McNeil     Interactive Data Analysis         <NA>   Australia       no
#> 2   Ripley            Spatial Statistics         <NA>          UK       no
#> 3   Ripley         Stochastic Simulation         <NA>          UK       no
#> 4  Tierney                     LISP-STAT         <NA>          US       no
#> 5    Tukey     Exploratory Data Analysis         <NA>          US      yes
#> 6 Venables Modern Applied Statistics ...       Ripley   Australia       no
```

为了比较清楚地观察几种合并的区别，这里提供对应的动画展示 <https://github.com/gadenbuie/tidyexplain>

(inner, outer, left, right, cross) join 共5种合并方式详情请看 <https://stackoverflow.com/questions/1299871>

cbind 和 rbind 分别是按列和行合并数据框


## 数据去重 {#base-duplicated}

单个数值型向量去重，此时和 unique 函数作用一样


```r
(x <- c(9:20, 1:5, 3:7, 0:8))
#>  [1]  9 10 11 12 13 14 15 16 17 18 19 20  1  2  3  4  5  3  4  5  6  7  0
#> [24]  1  2  3  4  5  6  7  8
## extract unique elements
x[!duplicated(x)]
#>  [1]  9 10 11 12 13 14 15 16 17 18 19 20  1  2  3  4  5  6  7  0  8
unique(x)
#>  [1]  9 10 11 12 13 14 15 16 17 18 19 20  1  2  3  4  5  6  7  0  8
```

数据框类型数据中，去除重复的行，这个重复可以是多个变量对应的向量


```r
set.seed(123)
df <- data.frame(
  x = sample(0:1, 10, replace = T),
  y = sample(0:1, 10, replace = T),
  z = 1:10
)
df
#>    x y  z
#> 1  0 1  1
#> 2  0 1  2
#> 3  0 1  3
#> 4  1 0  4
#> 5  0 1  5
#> 6  1 0  6
#> 7  1 1  7
#> 8  1 0  8
#> 9  0 0  9
#> 10 0 0 10
df[!duplicated(df[, 1:2]), ]
#>   x y z
#> 1 0 1 1
#> 4 1 0 4
#> 7 1 1 7
#> 9 0 0 9
```


## 数据聚合 {#base-aggregate}

分组求和 <https://stackoverflow.com/questions/1660124>

主要是分组统计


```r
apropos("apply")
#>  [1] "apply"      "dendrapply" "eapply"     "kernapply"  "lapply"    
#>  [6] "mapply"     "rapply"     "sapply"     "tapply"     "vapply"
```


```r
# 分组求和 colSums colMeans max
unique(iris$Species)
#> [1] setosa     versicolor virginica 
#> Levels: setosa versicolor virginica
# 分类求和
# colSums(iris[iris$Species == "setosa", -5])
# colSums(iris[iris$Species == "virginica", -5])
colSums(iris[iris$Species == "versicolor", -5])
#> Sepal.Length  Sepal.Width Petal.Length  Petal.Width 
#>        296.8        138.5        213.0         66.3
# apply(iris[iris$Species == "setosa", -5], 2, sum)
# apply(iris[iris$Species == "setosa", -5], 2, mean)
# apply(iris[iris$Species == "setosa", -5], 2, min)
# apply(iris[iris$Species == "setosa", -5], 2, max)
apply(iris[iris$Species == "setosa", -5], 2, quantile)
#>      Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 0%            4.3       2.300        1.000         0.1
#> 25%           4.8       3.200        1.400         0.2
#> 50%           5.0       3.400        1.500         0.2
#> 75%           5.2       3.675        1.575         0.3
#> 100%          5.8       4.400        1.900         0.6
```

aggregate: Compute Summary Statistics of Data Subsets


```r
# 按分类变量 Species 分组求和
# aggregate(subset(iris, select = -Species), by = list(iris[, "Species"]), FUN = sum)
aggregate(iris[, -5], list(iris[, 5]), sum)
#>      Group.1 Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1     setosa        250.3       171.4         73.1        12.3
#> 2 versicolor        296.8       138.5        213.0        66.3
#> 3  virginica        329.4       148.7        277.6       101.3
# 先确定位置，假设有很多分类变量
ind <- which("Species" == colnames(iris))
# 分组统计
aggregate(iris[, -ind], list(iris[, ind]), sum)
#>      Group.1 Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1     setosa        250.3       171.4         73.1        12.3
#> 2 versicolor        296.8       138.5        213.0        66.3
#> 3  virginica        329.4       148.7        277.6       101.3
```

按照 Species 划分的类别，分组计算，使用公式表示形式，右边一定是分类变量，否则会报错误或者警告，输出奇怪的结果，请读者尝试运行`aggregate(Species ~ Sepal.Length, data = iris, mean)`。公式法表示分组计算，`~` 左手边可以做加 `+` 减 `-` 乘 `*` 除 `/` 取余 `%%` 等数学运算。下面以数据集 iris 为例，只对 Sepal.Length 按 Species 分组计算


```r
aggregate(Sepal.Length ~ Species, data = iris, mean)
#>      Species Sepal.Length
#> 1     setosa        5.006
#> 2 versicolor        5.936
#> 3  virginica        6.588
```

与上述分组统计结果一样的命令，在大数据集上， 与 aggregate 相比，tapply 要快很多，by 是 tapply 的包裹，处理速度差不多。读者可以构造伪随机数据集验证。


```r
# tapply(iris$Sepal.Length, list(iris$Species), mean)
with(iris, tapply(Sepal.Length, Species, mean))
#>     setosa versicolor  virginica 
#>      5.006      5.936      6.588
by(iris$Sepal.Length, iris$Species, mean)
#> iris$Species: setosa
#> [1] 5.006
#> -------------------------------------------------------- 
#> iris$Species: versicolor
#> [1] 5.936
#> -------------------------------------------------------- 
#> iris$Species: virginica
#> [1] 6.588
```

对所有变量按 Species 分组计算 


```r
aggregate(. ~ Species, data = iris, mean)
#>      Species Sepal.Length Sepal.Width Petal.Length Petal.Width
#> 1     setosa        5.006       3.428        1.462       0.246
#> 2 versicolor        5.936       2.770        4.260       1.326
#> 3  virginica        6.588       2.974        5.552       2.026
```

对变量 Sepal.Length 和 Sepal.Width 求和后，按 Species 分组计算


```r
aggregate(Sepal.Length + Sepal.Width ~ Species, data = iris, mean)
#>      Species Sepal.Length + Sepal.Width
#> 1     setosa                      8.434
#> 2 versicolor                      8.706
#> 3  virginica                      9.562
```

对多个分类变量做分组计算，在数据集 ChickWeight 中 Chick和Diet都是数字编码的分类变量，其中 Chick 是有序的因子变量，Diet 是无序的因子变量，而 Time 是数值型的变量，表示小鸡出生的天数。


```r
# 查看数据
str(ChickWeight)
#> Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':	578 obs. of  4 variables:
#>  $ weight: num  42 51 59 64 76 93 106 125 149 171 ...
#>  $ Time  : num  0 2 4 6 8 10 12 14 16 18 ...
#>  $ Chick : Ord.factor w/ 50 levels "18"<"16"<"15"<..: 15 15 15 15 15 15 1..
#>  $ Diet  : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "formula")=Class 'formula'  language weight ~ Time | Chick
#>   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
#>  - attr(*, "outer")=Class 'formula'  language ~Diet
#>   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
#>  - attr(*, "labels")=List of 2
#>   ..$ x: chr "Time"
#>   ..$ y: chr "Body weight"
#>  - attr(*, "units")=List of 2
#>   ..$ x: chr "(days)"
#>   ..$ y: chr "(gm)"
```

查看数据集ChickWeight的前几行


```r
head(ChickWeight)
#>   weight Time Chick Diet
#> 1     42    0     1    1
#> 2     51    2     1    1
#> 3     59    4     1    1
#> 4     64    6     1    1
#> 5     76    8     1    1
....
str(ChickWeight)
#> Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':	578 obs. of  4 variables:
#>  $ weight: num  42 51 59 64 76 93 106 125 149 171 ...
#>  $ Time  : num  0 2 4 6 8 10 12 14 16 18 ...
#>  $ Chick : Ord.factor w/ 50 levels "18"<"16"<"15"<..: 15 15 15 15 15 15 1..
#>  $ Diet  : Factor w/ 4 levels "1","2","3","4": 1 1 1 1 1 1 1 1 1 1 ...
#>  - attr(*, "formula")=Class 'formula'  language weight ~ Time | Chick
....
```

对于数据集ChickWeight中的有序变量Chick，aggregate 会按照既定顺序返回分组计算的结果


```r
aggregate(weight ~ Chick, data = ChickWeight, mean)
#>    Chick    weight
#> 1     18  37.00000
#> 2     16  49.71429
#> 3     15  60.12500
#> 4     13  67.83333
#> 5      9  81.16667
....
aggregate(weight ~ Diet, data = ChickWeight, mean)
#>   Diet   weight
#> 1    1 102.6455
#> 2    2 122.6167
#> 3    3 142.9500
#> 4    4 135.2627
```

分类变量没有用数字编码，以 CO2 数据集为例，该数据集描述草植对二氧化碳的吸收情况，Plant 是具有12个水平的有序的因子变量，Type表示植物的源头分别是魁北克(Quebec)和密西西比(Mississippi)，Treatment表示冷却(chilled)和不冷却(nonchilled)两种处理方式，conc表示周围环境中二氧化碳的浓度，uptake表示植物吸收二氧化碳的速率。


```r
# 查看数据集
head(CO2)
#>   Plant   Type  Treatment conc uptake
#> 1   Qn1 Quebec nonchilled   95   16.0
#> 2   Qn1 Quebec nonchilled  175   30.4
#> 3   Qn1 Quebec nonchilled  250   34.8
#> 4   Qn1 Quebec nonchilled  350   37.2
#> 5   Qn1 Quebec nonchilled  500   35.3
#> 6   Qn1 Quebec nonchilled  675   39.2
str(CO2)
#> Classes 'nfnGroupedData', 'nfGroupedData', 'groupedData' and 'data.frame':	84 obs. of  5 variables:
#>  $ Plant    : Ord.factor w/ 12 levels "Qn1"<"Qn2"<"Qn3"<..: 1 1 1 1 1 1 1..
#>  $ Type     : Factor w/ 2 levels "Quebec","Mississippi": 1 1 1 1 1 1 1 1 ..
#>  $ Treatment: Factor w/ 2 levels "nonchilled","chilled": 1 1 1 1 1 1 1 1 ..
#>  $ conc     : num  95 175 250 350 500 675 1000 95 175 250 ...
#>  $ uptake   : num  16 30.4 34.8 37.2 35.3 39.2 39.7 13.6 27.3 37.1 ...
#>  - attr(*, "formula")=Class 'formula'  language uptake ~ conc | Plant
#>   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
#>  - attr(*, "outer")=Class 'formula'  language ~Treatment * Type
#>   .. ..- attr(*, ".Environment")=<environment: R_EmptyEnv> 
#>  - attr(*, "labels")=List of 2
#>   ..$ x: chr "Ambient carbon dioxide concentration"
#>   ..$ y: chr "CO2 uptake rate"
#>  - attr(*, "units")=List of 2
#>   ..$ x: chr "(uL/L)"
#>   ..$ y: chr "(umol/m^2 s)"
```

对单个变量分组统计


```r
aggregate(uptake ~ Plant, data = CO2, mean)
#>    Plant   uptake
#> 1    Qn1 33.22857
#> 2    Qn2 35.15714
#> 3    Qn3 37.61429
#> 4    Qc1 29.97143
#> 5    Qc3 32.58571
#> 6    Qc2 32.70000
#> 7    Mn3 24.11429
#> 8    Mn2 27.34286
#> 9    Mn1 26.40000
#> 10   Mc2 12.14286
#> 11   Mc3 17.30000
#> 12   Mc1 18.00000
aggregate(uptake ~ Type, data = CO2, mean)
#>          Type   uptake
#> 1      Quebec 33.54286
#> 2 Mississippi 20.88333
aggregate(uptake ~ Treatment, data = CO2, mean)
#>    Treatment   uptake
#> 1 nonchilled 30.64286
#> 2    chilled 23.78333
```

对多个变量分组统计，查看二氧化碳吸收速率uptake随类型Type和处理方式Treatment


```r
aggregate(uptake ~ Type + Treatment, data = CO2, mean)
#>          Type  Treatment   uptake
#> 1      Quebec nonchilled 35.33333
#> 2 Mississippi nonchilled 25.95238
#> 3      Quebec    chilled 31.75238
#> 4 Mississippi    chilled 15.81429
tapply(CO2$uptake, list(CO2$Type, CO2$Treatment), mean)
#>             nonchilled  chilled
#> Quebec        35.33333 31.75238
#> Mississippi   25.95238 15.81429
by(CO2$uptake, list(CO2$Type, CO2$Treatment), mean)
#> : Quebec
#> : nonchilled
#> [1] 35.33333
#> -------------------------------------------------------- 
#> : Mississippi
#> : nonchilled
#> [1] 25.95238
#> -------------------------------------------------------- 
#> : Quebec
#> : chilled
#> [1] 31.75238
#> -------------------------------------------------------- 
#> : Mississippi
#> : chilled
#> [1] 15.81429
```

在这个例子中 tapply 和 by 的输出结果的表示形式不一样，aggregate 返回一个 data.frame 数据框，tapply 返回一个表格 table，by 返回特殊的数据类型 by。

Function `by` is an object-oriented wrapper for `tapply` applied to data frames. 


```r
# 分组求和
# by(iris[, 1], INDICES = list(iris$Species), FUN = sum)
# by(iris[, 2], INDICES = list(iris$Species), FUN = sum)
by(iris[, 3], INDICES = list(iris$Species), FUN = sum)
#> : setosa
#> [1] 73.1
#> -------------------------------------------------------- 
#> : versicolor
#> [1] 213
#> -------------------------------------------------------- 
#> : virginica
#> [1] 277.6
by(iris[1:3], INDICES = list(iris$Species), FUN = sum)
#> : setosa
#> [1] 494.8
#> -------------------------------------------------------- 
#> : versicolor
#> [1] 648.3
#> -------------------------------------------------------- 
#> : virginica
#> [1] 755.7
by(iris[1:3], INDICES = list(iris$Species), FUN = summary)
#> : setosa
#>   Sepal.Length    Sepal.Width     Petal.Length  
#>  Min.   :4.300   Min.   :2.300   Min.   :1.000  
#>  1st Qu.:4.800   1st Qu.:3.200   1st Qu.:1.400  
#>  Median :5.000   Median :3.400   Median :1.500  
#>  Mean   :5.006   Mean   :3.428   Mean   :1.462  
#>  3rd Qu.:5.200   3rd Qu.:3.675   3rd Qu.:1.575  
#>  Max.   :5.800   Max.   :4.400   Max.   :1.900  
#> -------------------------------------------------------- 
#> : versicolor
#>   Sepal.Length    Sepal.Width     Petal.Length 
#>  Min.   :4.900   Min.   :2.000   Min.   :3.00  
#>  1st Qu.:5.600   1st Qu.:2.525   1st Qu.:4.00  
#>  Median :5.900   Median :2.800   Median :4.35  
#>  Mean   :5.936   Mean   :2.770   Mean   :4.26  
#>  3rd Qu.:6.300   3rd Qu.:3.000   3rd Qu.:4.60  
#>  Max.   :7.000   Max.   :3.400   Max.   :5.10  
#> -------------------------------------------------------- 
#> : virginica
#>   Sepal.Length    Sepal.Width     Petal.Length  
#>  Min.   :4.900   Min.   :2.200   Min.   :4.500  
#>  1st Qu.:6.225   1st Qu.:2.800   1st Qu.:5.100  
#>  Median :6.500   Median :3.000   Median :5.550  
#>  Mean   :6.588   Mean   :2.974   Mean   :5.552  
#>  3rd Qu.:6.900   3rd Qu.:3.175   3rd Qu.:5.875  
#>  Max.   :7.900   Max.   :3.800   Max.   :6.900
by(iris, INDICES = list(iris$Species), FUN = summary)
#> : setosa
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
#>  Min.   :4.300   Min.   :2.300   Min.   :1.000   Min.   :0.100  
#>  1st Qu.:4.800   1st Qu.:3.200   1st Qu.:1.400   1st Qu.:0.200  
#>  Median :5.000   Median :3.400   Median :1.500   Median :0.200  
#>  Mean   :5.006   Mean   :3.428   Mean   :1.462   Mean   :0.246  
#>  3rd Qu.:5.200   3rd Qu.:3.675   3rd Qu.:1.575   3rd Qu.:0.300  
#>  Max.   :5.800   Max.   :4.400   Max.   :1.900   Max.   :0.600  
#>        Species  
#>  setosa    :50  
#>  versicolor: 0  
#>  virginica : 0  
#>                 
#>                 
#>                 
#> -------------------------------------------------------- 
#> : versicolor
#>   Sepal.Length    Sepal.Width     Petal.Length   Petal.Width   
#>  Min.   :4.900   Min.   :2.000   Min.   :3.00   Min.   :1.000  
#>  1st Qu.:5.600   1st Qu.:2.525   1st Qu.:4.00   1st Qu.:1.200  
#>  Median :5.900   Median :2.800   Median :4.35   Median :1.300  
#>  Mean   :5.936   Mean   :2.770   Mean   :4.26   Mean   :1.326  
#>  3rd Qu.:6.300   3rd Qu.:3.000   3rd Qu.:4.60   3rd Qu.:1.500  
#>  Max.   :7.000   Max.   :3.400   Max.   :5.10   Max.   :1.800  
#>        Species  
#>  setosa    : 0  
#>  versicolor:50  
#>  virginica : 0  
#>                 
#>                 
#>                 
#> -------------------------------------------------------- 
#> : virginica
#>   Sepal.Length    Sepal.Width     Petal.Length    Petal.Width   
#>  Min.   :4.900   Min.   :2.200   Min.   :4.500   Min.   :1.400  
#>  1st Qu.:6.225   1st Qu.:2.800   1st Qu.:5.100   1st Qu.:1.800  
#>  Median :6.500   Median :3.000   Median :5.550   Median :2.000  
#>  Mean   :6.588   Mean   :2.974   Mean   :5.552   Mean   :2.026  
#>  3rd Qu.:6.900   3rd Qu.:3.175   3rd Qu.:5.875   3rd Qu.:2.300  
#>  Max.   :7.900   Max.   :3.800   Max.   :6.900   Max.   :2.500  
#>        Species  
#>  setosa    : 0  
#>  versicolor: 0  
#>  virginica :50  
#>                 
#>                 
#> 
```

Group Averages Over Level Combinations of Factors 分组平均


```r
str(warpbreaks)
#> 'data.frame':	54 obs. of  3 variables:
#>  $ breaks : num  26 30 54 25 70 52 51 26 67 18 ...
#>  $ wool   : Factor w/ 2 levels "A","B": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ tension: Factor w/ 3 levels "L","M","H": 1 1 1 1 1 1 1 1 1 2 ...
head(warpbreaks)
#>   breaks wool tension
#> 1     26    A       L
#> 2     30    A       L
#> 3     54    A       L
#> 4     25    A       L
#> 5     70    A       L
#> 6     52    A       L

ave(warpbreaks$breaks, warpbreaks$wool)
#>  [1] 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704
#>  [8] 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704
#> [15] 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704
#> [22] 31.03704 31.03704 31.03704 31.03704 31.03704 31.03704 25.25926
#> [29] 25.25926 25.25926 25.25926 25.25926 25.25926 25.25926 25.25926
#> [36] 25.25926 25.25926 25.25926 25.25926 25.25926 25.25926 25.25926
#> [43] 25.25926 25.25926 25.25926 25.25926 25.25926 25.25926 25.25926
#> [50] 25.25926 25.25926 25.25926 25.25926 25.25926
with(warpbreaks, ave(breaks, tension, FUN = function(x) mean(x, trim = 0.1)))
#>  [1] 35.6875 35.6875 35.6875 35.6875 35.6875 35.6875 35.6875 35.6875
#>  [9] 35.6875 26.3125 26.3125 26.3125 26.3125 26.3125 26.3125 26.3125
#> [17] 26.3125 26.3125 21.0625 21.0625 21.0625 21.0625 21.0625 21.0625
#> [25] 21.0625 21.0625 21.0625 35.6875 35.6875 35.6875 35.6875 35.6875
#> [33] 35.6875 35.6875 35.6875 35.6875 26.3125 26.3125 26.3125 26.3125
#> [41] 26.3125 26.3125 26.3125 26.3125 26.3125 21.0625 21.0625 21.0625
#> [49] 21.0625 21.0625 21.0625 21.0625 21.0625 21.0625
# 分组求和
with(warpbreaks, ave(breaks, tension, FUN = function(x) sum(x)))
#>  [1] 655 655 655 655 655 655 655 655 655 475 475 475 475 475 475 475 475
#> [18] 475 390 390 390 390 390 390 390 390 390 655 655 655 655 655 655 655
#> [35] 655 655 475 475 475 475 475 475 475 475 475 390 390 390 390 390 390
#> [52] 390 390 390
# 分组求和
with(iris, ave(Sepal.Length, Species, FUN = function(x) sum(x)))
#>   [1] 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3
#>  [12] 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3
#>  [23] 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3
#>  [34] 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3 250.3
#>  [45] 250.3 250.3 250.3 250.3 250.3 250.3 296.8 296.8 296.8 296.8 296.8
#>  [56] 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8
#>  [67] 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8
#>  [78] 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8
#>  [89] 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8 296.8
#> [100] 296.8 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4
#> [111] 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4
#> [122] 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4
#> [133] 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4 329.4
#> [144] 329.4 329.4 329.4 329.4 329.4 329.4 329.4
```


## 表格统计 {#base-table}

> 介绍操作表格的 table, addmargins, prop.table, xtabs, margin.table, ftabe 等函数

table 多个分类变量分组计数统计 

- 介绍 warpbreaks 和 airquality 纽约空气质量监测数据集 二维的数据框
- UCBAdmissions 1973 年加州大学伯克利分校的院系录取数据集 3维的列联表
- Titanic 4维的列联表数据 泰坦尼克号幸存者数据集


```r
with(warpbreaks, table(wool, tension))
#>     tension
#> wool L M H
#>    A 9 9 9
#>    B 9 9 9
```

以 iris 数据集为例，table 的第一个参数是自己制造的第二个分类变量，原始分类变量是 Species


```r
with(iris, table(Sepal.check = Sepal.Length > 7, Species))
#>            Species
#> Sepal.check setosa versicolor virginica
#>       FALSE     50         50        38
#>       TRUE       0          0        12
with(iris, table(Sepal.check = Sepal.Length > mean(Sepal.Length), Species))
#>            Species
#> Sepal.check setosa versicolor virginica
#>       FALSE     50         24         6
#>       TRUE       0         26        44
```

以 airquality 数据集为例，看看月份中臭氧含量比较高的几天


```r
aiq.tab <- with(airquality, table(Oz.high = Ozone > 80, Month))
aiq.tab
#>        Month
#> Oz.high  5  6  7  8  9
#>   FALSE 25  9 20 19 27
#>   TRUE   1  0  6  7  2
```

对表格按行和列求和，即求表格的边际，查看总体情况


```r
addmargins(aiq.tab, 1:2)
#>        Month
#> Oz.high   5   6   7   8   9 Sum
#>   FALSE  25   9  20  19  27 100
#>   TRUE    1   0   6   7   2  16
#>   Sum    26   9  26  26  29 116
```

臭氧含量超 80 的天数在每个月的占比，`addmargins` 的第二个参数 1 表示对列求和


```r
aiq.prop <- prop.table(aiq.tab, 2)
aiq.prop
#>        Month
#> Oz.high          5          6          7          8          9
#>   FALSE 0.96153846 1.00000000 0.76923077 0.73076923 0.93103448
#>   TRUE  0.03846154 0.00000000 0.23076923 0.26923077 0.06896552
aiq.marprop <- addmargins(aiq.prop, 1)
aiq.marprop
#>        Month
#> Oz.high          5          6          7          8          9
#>   FALSE 0.96153846 1.00000000 0.76923077 0.73076923 0.93103448
#>   TRUE  0.03846154 0.00000000 0.23076923 0.26923077 0.06896552
#>   Sum   1.00000000 1.00000000 1.00000000 1.00000000 1.00000000
```

转换成百分比，将小数四舍五入转化为百分数，保留两位小数点


```r
round(100 * aiq.marprop, 2)
#>        Month
#> Oz.high      5      6      7      8      9
#>   FALSE  96.15 100.00  76.92  73.08  93.10
#>   TRUE    3.85   0.00  23.08  26.92   6.90
#>   Sum   100.00 100.00 100.00 100.00 100.00
```


```r
pairs(airquality, panel = panel.smooth, main = "airquality data")
```

以 UCBAdmissions 数据集为例，使用 `xtabs` 函数把数据组织成列联表，先查看数据的内容


```r
UCBAdmissions
#> , , Dept = A
#> 
#>           Gender
#> Admit      Male Female
#>   Admitted  512     89
#>   Rejected  313     19
....
UCBA2DF <- as.data.frame(UCBAdmissions)
UCBA2DF
#>       Admit Gender Dept Freq
#> 1  Admitted   Male    A  512
#> 2  Rejected   Male    A  313
#> 3  Admitted Female    A   89
#> 4  Rejected Female    A   19
#> 5  Admitted   Male    B  353
....
```

接着将 `UCBA2DF` 数据集转化为表格的形式


```r
UCBA2DF.tab <- xtabs(Freq ~ Gender + Admit + Dept, data = UCBA2DF)
ftable(UCBA2DF.tab)
#>                 Dept   A   B   C   D   E   F
#> Gender Admit                                
#> Male   Admitted      512 353 120 138  53  22
#>        Rejected      313 207 205 279 138 351
#> Female Admitted       89  17 202 131  94  24
#>        Rejected       19   8 391 244 299 317
```

将录取性别和院系进行对比


```r
prop.table(margin.table(UCBA2DF.tab, c(1, 3)), 1)
#>         Dept
#> Gender            A          B          C          D          E          F
#>   Male   0.30657748 0.20810108 0.12077295 0.15496098 0.07097733 0.13861018
#>   Female 0.05885559 0.01362398 0.32316076 0.20435967 0.21416894 0.18583106
```

男生倾向于申请院系 A 和 B，女生倾向于申请院系 C 到 F，院系 A 和 B 是最容易录取的。

## 索引访问 {#base-index}

which 与引用 `[` 性能比较，在区间 $[0,1]$ 上生成 10 万个服从均匀分布的随机数，随机抽取其中$\frac{1}{4}$。


```r
n <- 100000
x <- runif(n)
i <- logical(n)
i[sample(n, n / 4)] <- TRUE
microbenchmark::microbenchmark(x[i], x[which(i)], times = 1000)
```

[使用 `subset` 函数与 `[` 比较]{.todo}

## 多维数组 {#base-array}

多维数组的行列是怎么定义的 `?array` 轴的概念，画个图表示数组


```r
array(1:27, c(3, 3, 3))
#> , , 1
#> 
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]    2    5    8
#> [3,]    3    6    9
#> 
#> , , 2
#> 
#>      [,1] [,2] [,3]
#> [1,]   10   13   16
#> [2,]   11   14   17
#> [3,]   12   15   18
#> 
#> , , 3
#> 
#>      [,1] [,2] [,3]
#> [1,]   19   22   25
#> [2,]   20   23   26
#> [3,]   21   24   27
```

垂直于Z轴的平面去截三维立方体，3 代表 z 轴，得到三个截面（二维矩阵）


```r
asplit(array(1:27, c(3, 3, 3)), 3)
#> [[1]]
#>      [,1] [,2] [,3]
#> [1,]    1    4    7
#> [2,]    2    5    8
#> [3,]    3    6    9
#> 
#> [[2]]
#>      [,1] [,2] [,3]
#> [1,]   10   13   16
#> [2,]   11   14   17
#> [3,]   12   15   18
#> 
#> [[3]]
#>      [,1] [,2] [,3]
#> [1,]   19   22   25
#> [2,]   20   23   26
#> [3,]   21   24   27
```

对每个二维矩阵按列求和


```r
lapply(asplit(array(1:27, c(3, 3, 3)), 3), apply, 2, sum)
#> [[1]]
#> [1]  6 15 24
#> 
#> [[2]]
#> [1] 33 42 51
#> 
#> [[3]]
#> [1] 60 69 78
```

`asplit` 和 `lapply` 组合处理多维数组的计算问题，多维数组[^matrix-list]

[三维数组的矩阵运算](https://d.cosx.org/d/107493) [abind](https://CRAN.R-project.org/package=abind) 包提供更多的数组操作，如合并，替换

[^matrix-list]: https://www.brodieg.com/2018/11/23/is-your-matrix-running-slow-try-lists/

## 其它操作 {#base-others}

成对的数据操作有 `list` 与 `unlist`、`stack` 与 `unstack`、`class` 与 `unclass`、`attach` 与 `detach` 以及 `with` 和 `within`，它们在数据操作过程中有时会起到一定的补充作用。

### 列表属性 {#relist-or-unlist}


```r
# 创建列表
list(...)
pairlist(...)
# 转化列表
as.list(x, ...)
## S3 method for class 'environment'
as.list(x, all.names = FALSE, sorted = FALSE, ...)
as.pairlist(x)
# 检查列表
is.list(x)
is.pairlist(x)

alist(...)
```

`list` 函数用来构造、转化和检查 R 列表对象。下面创建一个临时列表对象 tmp ，它包含两个元素 A 和 B，两个元素都是向量，前者是数值型，后者是字符型


```r
(tmp <- list(A = c(1, 2, 3), B = c("a", "b")))
#> $A
#> [1] 1 2 3
#> 
#> $B
#> [1] "a" "b"
```


```r
unlist(x, recursive = TRUE, use.names = TRUE)
```

`unlist` 函数将给定的列表对象 `x` 简化为原子向量 (atomic vector)，我们发现简化之后变成一个字符型向量


```r
unlist(tmp)
#>  A1  A2  A3  B1  B2 
#> "1" "2" "3" "a" "b"
unlist(tmp, use.names = FALSE)
#> [1] "1" "2" "3" "a" "b"
```

unlist 的逆操作是 relist


### 堆叠向量 {#stack-or-unstack}


```r
stack(x, ...)
## Default S3 method:
stack(x, drop = FALSE, ...)
## S3 method for class 'data.frame'
stack(x, select, drop = FALSE, ...)

unstack(x, ...)
## Default S3 method:
unstack(x, form, ...)
## S3 method for class 'data.frame'
unstack(x, form, ...)
```

`stack` 与 `unstack` 将多个向量堆在一起组成一个向量


```r
# 查看数据集 PlantGrowth
class(PlantGrowth)
#> [1] "data.frame"
head(PlantGrowth)
#>   weight group
#> 1   4.17  ctrl
#> 2   5.58  ctrl
#> 3   5.18  ctrl
#> 4   6.11  ctrl
#> 5   4.50  ctrl
#> 6   4.61  ctrl
# 检查默认的公式
formula(PlantGrowth) 
#> weight ~ group
# 根据公式解除堆叠
# 下面等价于 unstack(PlantGrowth, form = weight ~ group)
(pg <- unstack(PlantGrowth)) 
#>    ctrl trt1 trt2
#> 1  4.17 4.81 6.31
#> 2  5.58 4.17 5.12
#> 3  5.18 4.41 5.54
#> 4  6.11 3.59 5.50
#> 5  4.50 5.87 5.37
#> 6  4.61 3.83 5.29
#> 7  5.17 6.03 4.92
#> 8  4.53 4.89 6.15
#> 9  5.33 4.32 5.80
#> 10 5.14 4.69 5.26
```

现在再将变量 pg 堆叠起来，还可以指定要堆叠的列


```r
stack(pg)
#>    values  ind
#> 1    4.17 ctrl
#> 2    5.58 ctrl
#> 3    5.18 ctrl
#> 4    6.11 ctrl
#> 5    4.50 ctrl
....
stack(pg, select = -ctrl)
#>    values  ind
#> 1    4.81 trt1
#> 2    4.17 trt1
#> 3    4.41 trt1
#> 4    3.59 trt1
#> 5    5.87 trt1
....
```

::: sidebar
形式上和 reshape 有一些相似之处，数据框可以由长变宽或由宽变长
:::

### 属性转化 {#class-or-unclass}


```r
class(x)
class(x) <- value
unclass(x)
inherits(x, what, which = FALSE)

oldClass(x)
oldClass(x) <- value
```

`class` 和 `unclass` 函数用来查看、设置类属性和取消类属性，常用于面向对象的编程设计中


```r
class(iris)
#> [1] "data.frame"
class(iris$Species)
#> [1] "factor"
unclass(iris$Species)
#>   [1] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
#>  [36] 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
#>  [71] 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3
#> [106] 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3
#> [141] 3 3 3 3 3 3 3 3 3 3
#> attr(,"levels")
....
```

### 绑定环境 {#attach-or-detach}


```r
attach(what,
  pos = 2L, name = deparse(substitute(what), backtick = FALSE),
  warn.conflicts = TRUE
)
detach(name,
  pos = 2L, unload = FALSE, character.only = FALSE,
  force = FALSE
)
```

`attach` 和 `detach` 是否绑定数据框的列名，不推荐操作，推荐使用 `with`


```r
attach(iris)
head(Species)
#> [1] setosa setosa setosa setosa setosa setosa
#> Levels: setosa versicolor virginica
detach(iris)
```

### 数据环境 {#with-or-within}


```r
with(data, expr, ...)
within(data, expr, ...)
## S3 method for class 'list'
within(data, expr, keepAttrs = TRUE, ...)
```

`data`
:  参数 `data` 用来构造表达式计算的环境。其默认值可以是一个环境，列表，数据框。在 `within` 函数中 `data` 参数只能是列表或数据框。

`expr`
:  参数 `expr` 包含要计算的表达式。在 `within` 中通常包含一个复合表达式，比如
   
    
    ```r
    {
      a <- somefun()
      b <- otherfun()
      ...
      rm(unused1, temp)
    }
    ```

`with` 和 `within` 计算一组表达式，计算的环境是由数据构造的，后者可以修改原始的数据


```r
with(mtcars, mpg[cyl == 8 & disp > 350])
#> [1] 18.7 14.3 10.4 10.4 14.7 19.2 15.8
```

和下面计算的结果一样，但是更加简洁漂亮


```r
mtcars$mpg[mtcars$cyl == 8 & mtcars$disp > 350]
#> [1] 18.7 14.3 10.4 10.4 14.7 19.2 15.8
```

`within` 函数可以修改原数据环境中的多个变量，比如删除、修改和添加等


```r
# 原数据集 airquality
head(airquality)
#>   Ozone Solar.R Wind Temp Month Day
#> 1    41     190  7.4   67     5   1
#> 2    36     118  8.0   72     5   2
#> 3    12     149 12.6   74     5   3
#> 4    18     313 11.5   62     5   4
#> 5    NA      NA 14.3   56     5   5
#> 6    28      NA 14.9   66     5   6
aq <- within(airquality, {
  lOzone <- log(Ozone) # 取对数
  Month <- factor(month.abb[Month]) # 字符串型转因子型
  cTemp <- round((Temp - 32) * 5 / 9, 1) # 从华氏温度到摄氏温度转化
  S.cT <- Solar.R / cTemp # 使用新创建的变量
  rm(Day, Temp)
})
# 修改后的数据集
head(aq)
#>   Ozone Solar.R Wind Month      S.cT cTemp   lOzone
#> 1    41     190  7.4   May  9.793814  19.4 3.713572
#> 2    36     118  8.0   May  5.315315  22.2 3.583519
#> 3    12     149 12.6   May  6.394850  23.3 2.484907
#> 4    18     313 11.5   May 18.742515  16.7 2.890372
#> 5    NA      NA 14.3   May        NA  13.3       NA
#> 6    28      NA 14.9   May        NA  18.9 3.332205
```

下面再举一个复杂的绘图例子，这个例子来自 `boxplot` 函数


```r
with(ToothGrowth, {
  boxplot(len ~ dose,
    boxwex = 0.25, at = 1:3 - 0.2,
    subset = (supp == "VC"), col = "#4285f4",
    main = "Guinea Pigs' Tooth Growth",
    xlab = "Vitamin C dose mg",
    ylab = "tooth length", ylim = c(0, 35)
  )
  boxplot(len ~ dose,
    add = TRUE, boxwex = 0.25, at = 1:3 + 0.2,
    subset = supp == "OJ", col = "#EA4335"
  )
  legend(2, 9, c("Ascorbic acid", "Orange juice"),
    fill = c("#4285f4", "#EA4335")
  )
})
```

<img src="dm-base-r_files/figure-html/subset-in-boxplot-1.png" width="70%" style="display: block; margin: auto;" />

将 `boxplot` 函数的 `subset` 参数单独提出来，调用数据子集选择函数 `subset` ，这里 `with` 中只包含一个表达式，所以也可以不用大括号


```r
with(
  subset(ToothGrowth, supp == "VC"),
  boxplot(len ~ dose,
    boxwex = 0.25, at = 1:3 - 0.2,
    col = "#4285f4", main = "Guinea Pigs' Tooth Growth",
    xlab = "Vitamin C dose mg",
    ylab = "tooth length", ylim = c(0, 35)
  )
)
with(
  subset(ToothGrowth, supp == "OJ"),
  boxplot(len ~ dose,
    add = TRUE, boxwex = 0.25, at = 1:3 + 0.2,
    col = "#EA4335"
  )
)
legend(2, 9, c("Ascorbic acid", "Orange juice"),
  fill = c("#4285f4", "#EA4335")
)
```

<img src="dm-base-r_files/figure-html/subset-out-boxplot-1.png" width="70%" style="display: block; margin: auto;" />

可以作为数据变换 `transform` 的一种替代，它也比较像 **dplyr** 包的 `mutate` 函数


```r
within(mtcars[1:5,1:3],{
  disp.cc <- disp * 2.54^3
  disp.l <- disp.cc / 1e3
})
#>                    mpg cyl disp   disp.l  disp.cc
#> Mazda RX4         21.0   6  160 2.621930 2621.930
#> Mazda RX4 Wag     21.0   6  160 2.621930 2621.930
#> Datsun 710        22.8   4  108 1.769803 1769.803
#> Hornet 4 Drive    21.4   6  258 4.227863 4227.863
#> Hornet Sportabout 18.7   8  360 5.899343 5899.343

# 只能使用已有的列，刚生成的列不能用
# transform(
#   mtcars[1:5, 1:3],
#   disp.cc = disp * 2.54^3,
#   disp.l = disp.cc / 1e3
# )
transform(
  mtcars[1:5, 1:3],
  disp.cc = disp * 2.54^3
)
#>                    mpg cyl disp  disp.cc
#> Mazda RX4         21.0   6  160 2621.930
#> Mazda RX4 Wag     21.0   6  160 2621.930
#> Datsun 710        22.8   4  108 1769.803
#> Hornet 4 Drive    21.4   6  258 4227.863
#> Hornet Sportabout 18.7   8  360 5899.343
```

`transform` 只能使用已有的列，变换中间生成的列不能用，所以相比于 `transform` 函数， `within` 显得更为灵活

## 运行环境 {#dm-base-session-info}


```r
xfun::session_info()
#> R version 3.6.1 (2019-07-05)
#> Platform: x86_64-pc-linux-gnu (64-bit)
#> Running under: Debian GNU/Linux 10 (buster)
#> 
#> Locale:
#>   LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
#>   LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    
#>   LC_MONETARY=en_US.UTF-8    LC_MESSAGES=en_US.UTF-8   
#>   LC_PAPER=en_US.UTF-8       LC_NAME=C                 
#>   LC_ADDRESS=C               LC_TELEPHONE=C            
#>   LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=C       
#> 
#> Package version:
#>   base64enc_0.1.3  bookdown_0.12    codetools_0.2-16 compiler_3.6.1  
#>   curl_4.0         digest_0.6.20    evaluate_0.14    glue_1.3.1      
#>   graphics_3.6.1   grDevices_3.6.1  highr_0.8        htmltools_0.3.6 
#>   jsonlite_1.6     knitr_1.24       magrittr_1.5     markdown_1.1    
#>   methods_3.6.1    mime_0.7         Rcpp_1.0.2       rmarkdown_1.14  
#>   stats_3.6.1      stringi_1.4.3    stringr_1.4.0    tinytex_0.15    
#>   tools_3.6.1      utils_3.6.1      xfun_0.8         yaml_2.2.0
```
