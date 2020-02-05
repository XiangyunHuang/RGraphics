
# 高级数据操作 {#advanced-manipulation}

data.table 诞生于2006年4月15日（以在 CRAN 上发布的第一个版本时间为准），是基于 `data.frame` 的扩展和 Base R 的数据操作连贯一些，dplyr 诞生于2014年1月29日，号称数据操作的语法，其实二者套路一致，都是借用 SQL 语言的设计，实现方式不同罢了，前者主要依靠 C 语言完成底层数据操作，总代码量1.29M，C 占65.6%，后者主要依靠 C++ 语言完成底层数据操作，总代码量1.2M，C++ 占34.4%，上层的高级操作接口都是 R 语言。像这样的大神在写代码，码力应该差不多，编程语言会对数据操作的性能有比较大的影响，我想这也是为什么在很多场合下 data.table 霸榜！

关于 data.table 和 dplyr 的对比，参看爆栈网的帖子 <https://stackoverflow.com/questions/21435339>

::: rmdtip
学习 data.table 包最快的方式就是在 R 控制台运行 `example(data.table)` 并研究其输出。
:::


```r
library(data.table)
library(magrittr)
```

介绍 data.table 处理数据的方式，对标 dplyr 的基本操作

## 选择 {#subsec:select-j}

选择操作是针对数据框的列（变量/特征/字段）


```r
mtcars$cars <- rownames(mtcars)
mtcars_df <- as.data.table(mtcars)
```


```r
mtcars_df[, .(mpg, disp)] %>% head()
#>     mpg disp
#> 1: 21.0  160
#> 2: 21.0  160
#> 3: 22.8  108
#> 4: 21.4  258
#> 5: 18.7  360
#> 6: 18.1  225
```

::: dplyr


```r
mtcars %>% 
  dplyr::select(mpg, disp) %>% 
  head()
#>                    mpg disp
#> Mazda RX4         21.0  160
#> Mazda RX4 Wag     21.0  160
#> Datsun 710        22.8  108
#> Hornet 4 Drive    21.4  258
#> Hornet Sportabout 18.7  360
#> Valiant           18.1  225
```

:::

## 过滤 {#subsec:filter-i}

过滤 cyl = 6 并且 gear = 4 的记录


```r
mtcars_df[cyl == 6 & gear == 4]
#>     mpg cyl  disp  hp drat    wt  qsec vs am gear carb          cars
#> 1: 21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4     Mazda RX4
#> 2: 21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4 Mazda RX4 Wag
#> 3: 19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4      Merc 280
#> 4: 17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4     Merc 280C
```


过滤操作是针对数据框的行（记录）




```r
mtcars_df[cyl == 6 & gear == 4, .(mpg, disp)]
#>     mpg  disp
#> 1: 21.0 160.0
#> 2: 21.0 160.0
#> 3: 19.2 167.6
#> 4: 17.8 167.6
```


```r
subset(x = mtcars_df, subset = cyl == 6 & gear == 4, select = c(mpg, disp))
#>     mpg  disp
#> 1: 21.0 160.0
#> 2: 21.0 160.0
#> 3: 19.2 167.6
#> 4: 17.8 167.6
```

::: dplyr


```r
mtcars %>% 
  dplyr::filter(cyl == 6 & gear == 4)  %>% 
  dplyr::select(mpg, disp)
#>    mpg  disp
#> 1 21.0 160.0
#> 2 21.0 160.0
#> 3 19.2 167.6
#> 4 17.8 167.6
```

:::

## 变换 {#subsec:mutate-j}

根据已有的列生成新的列，或者修改已有的列，一次只能修改一列


```r
mtcars_df[, mean_mpg := mean(mpg)
          ][, mean_disp := mean(disp)
            ][, .(mpg, disp, cars, mean_mpg, mean_disp)] 
#>      mpg  disp                cars mean_mpg mean_disp
#>  1: 21.0 160.0           Mazda RX4 20.09062  230.7219
#>  2: 21.0 160.0       Mazda RX4 Wag 20.09062  230.7219
#>  3: 22.8 108.0          Datsun 710 20.09062  230.7219
#>  4: 21.4 258.0      Hornet 4 Drive 20.09062  230.7219
#>  5: 18.7 360.0   Hornet Sportabout 20.09062  230.7219
#>  6: 18.1 225.0             Valiant 20.09062  230.7219
#>  7: 14.3 360.0          Duster 360 20.09062  230.7219
#>  8: 24.4 146.7           Merc 240D 20.09062  230.7219
#>  9: 22.8 140.8            Merc 230 20.09062  230.7219
#> 10: 19.2 167.6            Merc 280 20.09062  230.7219
#> 11: 17.8 167.6           Merc 280C 20.09062  230.7219
#> 12: 16.4 275.8          Merc 450SE 20.09062  230.7219
#> 13: 17.3 275.8          Merc 450SL 20.09062  230.7219
#> 14: 15.2 275.8         Merc 450SLC 20.09062  230.7219
#> 15: 10.4 472.0  Cadillac Fleetwood 20.09062  230.7219
#> 16: 10.4 460.0 Lincoln Continental 20.09062  230.7219
#> 17: 14.7 440.0   Chrysler Imperial 20.09062  230.7219
#> 18: 32.4  78.7            Fiat 128 20.09062  230.7219
#> 19: 30.4  75.7         Honda Civic 20.09062  230.7219
#> 20: 33.9  71.1      Toyota Corolla 20.09062  230.7219
#> 21: 21.5 120.1       Toyota Corona 20.09062  230.7219
#> 22: 15.5 318.0    Dodge Challenger 20.09062  230.7219
#> 23: 15.2 304.0         AMC Javelin 20.09062  230.7219
#> 24: 13.3 350.0          Camaro Z28 20.09062  230.7219
#> 25: 19.2 400.0    Pontiac Firebird 20.09062  230.7219
#> 26: 27.3  79.0           Fiat X1-9 20.09062  230.7219
#> 27: 26.0 120.3       Porsche 914-2 20.09062  230.7219
#> 28: 30.4  95.1        Lotus Europa 20.09062  230.7219
#> 29: 15.8 351.0      Ford Pantera L 20.09062  230.7219
#> 30: 19.7 145.0        Ferrari Dino 20.09062  230.7219
#> 31: 15.0 301.0       Maserati Bora 20.09062  230.7219
#> 32: 21.4 121.0          Volvo 142E 20.09062  230.7219
#>      mpg  disp                cars mean_mpg mean_disp
```



```r
mtcars_df[, .(mean_mpg = mean(mpg), mean_disp = mean(disp))]
#>    mean_mpg mean_disp
#> 1: 20.09062  230.7219
```

::: rmdnote


```r
# mtcars_df[, .(mean_mpg := mean(mpg), mean_disp := mean(disp))] # 报错
# 正确的姿势
mtcars_df[, `:=`(mean_mpg = mean(mpg), mean_disp = mean(disp))          
          ][, .(mpg, disp, mean_mpg, mean_disp)] %>% head()
#>     mpg disp mean_mpg mean_disp
#> 1: 21.0  160 20.09062  230.7219
#> 2: 21.0  160 20.09062  230.7219
#> 3: 22.8  108 20.09062  230.7219
#> 4: 21.4  258 20.09062  230.7219
#> 5: 18.7  360 20.09062  230.7219
#> 6: 18.1  225 20.09062  230.7219
```

:::

::: dplyr


```r
mtcars %>% 
  dplyr::summarise(mean_mpg = mean(mpg), mean_disp = mean(disp))
#>   mean_mpg mean_disp
#> 1 20.09062  230.7219
```



```r
mtcars %>% 
  dplyr::mutate(mean_mpg = mean(mpg), mean_disp = mean(disp)) %>% 
  dplyr::select(mpg, disp, mean_mpg, mean_disp) %>% head()
#>    mpg disp mean_mpg mean_disp
#> 1 21.0  160 20.09062  230.7219
#> 2 21.0  160 20.09062  230.7219
#> 3 22.8  108 20.09062  230.7219
#> 4 21.4  258 20.09062  230.7219
#> 5 18.7  360 20.09062  230.7219
#> 6 18.1  225 20.09062  230.7219
```

:::


## 聚合 {#subsec:summarise-j}

分组统计 多个分组变量



```r
dcast(mtcars_df, cyl ~ gear, value.var = "mpg", fun = mean)
#>    cyl     3      4    5
#> 1:   4 21.50 26.925 28.2
#> 2:   6 19.75 19.750 19.7
#> 3:   8 15.05    NaN 15.4
tapply(mtcars$mpg, list(mtcars$cyl, mtcars$gear), mean)
#>       3      4    5
#> 4 21.50 26.925 28.2
#> 6 19.75 19.750 19.7
#> 8 15.05     NA 15.4
```

```r
mtcars_df[, .(mean_mpg = mean(mpg)), by = .(cyl, gear)]
#>    cyl gear mean_mpg
#> 1:   6    4   19.750
#> 2:   4    4   26.925
#> 3:   6    3   19.750
#> 4:   8    3   15.050
#> 5:   4    3   21.500
#> 6:   4    5   28.200
#> 7:   8    5   15.400
#> 8:   6    5   19.700
aggregate(data = mtcars_df, mpg ~ cyl + gear, FUN = mean)
#>   cyl gear    mpg
#> 1   4    3 21.500
#> 2   6    3 19.750
#> 3   8    3 15.050
#> 4   4    4 26.925
#> 5   6    4 19.750
#> 6   4    5 28.200
#> 7   6    5 19.700
#> 8   8    5 15.400
```

::: dplyr


```r
mtcars %>% 
  dplyr::group_by(cyl, gear) %>% 
  dplyr::summarise(mean_mpg = mean(mpg))
#> # A tibble: 8 x 3
#> # Groups:   cyl [3]
#>     cyl  gear mean_mpg
#>   <dbl> <dbl>    <dbl>
#> 1     4     3     21.5
#> 2     4     4     26.9
#> 3     4     5     28.2
#> 4     6     3     19.8
#> 5     6     4     19.8
#> 6     6     5     19.7
#> # … with 2 more rows
```

:::


## 去重 {#subsec:duplicated-i}

去掉字段 cyl 和 gear 有重复的记录


```r
mtcars_df[!duplicated(mtcars_df, by = c("cyl", "gear"))][,.(mpg, cyl, gear)]
#>     mpg cyl gear
#> 1: 21.0   6    4
#> 2: 22.8   4    4
#> 3: 21.4   6    3
#> 4: 18.7   8    3
#> 5: 21.5   4    3
#> 6: 26.0   4    5
#> 7: 15.8   8    5
#> 8: 19.7   6    5
```

::: dplyr


```r
mtcars %>% 
  dplyr::distinct(cyl, gear, .keep_all = TRUE) %>% 
  dplyr::select(mpg, cyl, gear)
#>    mpg cyl gear
#> 1 21.0   6    4
#> 2 22.8   4    4
#> 3 21.4   6    3
#> 4 18.7   8    3
#> 5 21.5   4    3
#> 6 26.0   4    5
#> 7 15.8   8    5
#> 8 19.7   6    5
```

:::

::: sidebar

dplyr 的去重操作不需要拷贝一个新的数据对象 mtcars_df，并且可以以管道的方式将后续的选择操作连接起来，代码更加具有可读性。


```r
mtcars_df[!duplicated(mtcars_df[, c("cyl", "gear")]), c("mpg","cyl","gear")]
#>     mpg cyl gear
#> 1: 21.0   6    4
#> 2: 22.8   4    4
#> 3: 21.4   6    3
#> 4: 18.7   8    3
#> 5: 21.5   4    3
#> 6: 26.0   4    5
#> 7: 15.8   8    5
#> 8: 19.7   6    5
```

Base R 和 data.table 提供的 `duplicated()` 函数和 `[` 函数一起实现去重的操作，选择操作放在 `[` 实现

::: rmdtip

`[` 其实是一个函数


```r
x <- 2:4
x[1]
#> [1] 2
`[`(x, 1)
#> [1] 2
```

:::
:::


## 命名 {#subsec:setname}

修改列名，另存一份生效


```r
sub_mtcars_df <- mtcars_df[, .(mean_mpg = mean(mpg)), by = .(cyl, gear)] 
setNames(sub_mtcars_df, c("cyl", "gear", "ave_mpg"))
#>    cyl gear ave_mpg
#> 1:   6    4  19.750
#> 2:   4    4  26.925
#> 3:   6    3  19.750
#> 4:   8    3  15.050
#> 5:   4    3  21.500
#> 6:   4    5  28.200
#> 7:   8    5  15.400
#> 8:   6    5  19.700
# 注意 sub_mtcars_df 并没有修改列名
sub_mtcars_df
#>    cyl gear mean_mpg
#> 1:   6    4   19.750
#> 2:   4    4   26.925
#> 3:   6    3   19.750
#> 4:   8    3   15.050
#> 5:   4    3   21.500
#> 6:   4    5   28.200
#> 7:   8    5   15.400
#> 8:   6    5   19.700
```

修改列名并直接起作用，在原来的数据集上生效


```r
setnames(sub_mtcars_df, old = c("mean_mpg"), new = c("ave_mpg"))
# sub_mtcars_df 已经修改了列名
sub_mtcars_df
#>    cyl gear ave_mpg
#> 1:   6    4  19.750
#> 2:   4    4  26.925
#> 3:   6    3  19.750
#> 4:   8    3  15.050
#> 5:   4    3  21.500
#> 6:   4    5  28.200
#> 7:   8    5  15.400
#> 8:   6    5  19.700
```

::: rmdtip
修改列名最好使用 **data.table** 包的函数 `setnames()` 明确指出了要修改的列名，
:::

## 排序 {#subsec:order-by-j}

按照某（些）列从大到小或从小到大的顺序排列， 先按 cyl 升序，然后按 gear 降序


```r
mtcars_df[, .(mpg, cyl, gear)          
          ][cyl == 4            
            ][order(cyl, -gear)]
#>      mpg cyl gear
#>  1: 26.0   4    5
#>  2: 30.4   4    5
#>  3: 22.8   4    4
#>  4: 24.4   4    4
#>  5: 22.8   4    4
#>  6: 32.4   4    4
#>  7: 30.4   4    4
#>  8: 33.9   4    4
#>  9: 27.3   4    4
#> 10: 21.4   4    4
#> 11: 21.5   4    3
```


::: dplyr


```r
mtcars %>%
  dplyr::select(mpg, cyl, gear) %>%
  dplyr::filter(cyl == 4) %>%
  dplyr::arrange(cyl, desc(gear))
#>     mpg cyl gear
#> 1  26.0   4    5
#> 2  30.4   4    5
#> 3  22.8   4    4
#> 4  24.4   4    4
#> 5  22.8   4    4
#> 6  32.4   4    4
#> 7  30.4   4    4
#> 8  33.9   4    4
#> 9  27.3   4    4
#> 10 21.4   4    4
#> 11 21.5   4    3
```

:::


## 变形 {#subsec:reshape}

melt 宽的变长的


```r
DT <- data.table(
  i_1 = c(1:5, NA),
  i_2 = c(NA, 6, 7, 8, 9, 10),
  f_1 = factor(sample(c(letters[1:3], NA), 6, TRUE)),
  f_2 = factor(c("z", "a", "x", "c", "x", "x"), ordered = TRUE),
  c_1 = sample(c(letters[1:3], NA), 6, TRUE),
  d_1 = as.Date(c(1:3, NA, 4:5), origin = "2013-09-01"),
  d_2 = as.Date(6:1, origin = "2012-01-01")
)
```



```r
DT[, .(i_1, i_2, f_1, f_2)]
#>    i_1 i_2  f_1 f_2
#> 1:   1  NA    c   z
#> 2:   2   6    c   a
#> 3:   3   7    c   x
#> 4:   4   8 <NA>   c
#> 5:   5   9    a   x
#> 6:  NA  10    b   x
```



```r
melt(DT, id = 1:2, measure = c("f_1", "f_2"))
#>     i_1 i_2 variable value
#>  1:   1  NA      f_1     c
#>  2:   2   6      f_1     c
#>  3:   3   7      f_1     c
#>  4:   4   8      f_1  <NA>
#>  5:   5   9      f_1     a
#>  6:  NA  10      f_1     b
#>  7:   1  NA      f_2     z
#>  8:   2   6      f_2     a
#>  9:   3   7      f_2     x
#> 10:   4   8      f_2     c
#> 11:   5   9      f_2     x
#> 12:  NA  10      f_2     x
```

dcast 长的变宽的


```r
sleep <- as.data.table(sleep)
dcast(sleep, group ~ ID, value.var = "extra")
#>    group   1    2    3    4    5   6   7   8   9  10
#> 1:     1 0.7 -1.6 -0.2 -1.2 -0.1 3.4 3.7 0.8 0.0 2.0
#> 2:     2 1.9  0.8  1.1  0.1 -0.1 4.4 5.5 1.6 4.6 3.4
# 如果有多个值
dcast(mtcars_df, cyl ~ gear, value.var = "mpg")
#> Aggregate function missing, defaulting to 'length'
#>    cyl  3 4 5
#> 1:   4  1 8 2
#> 2:   6  2 4 1
#> 3:   8 12 0 2
dcast(mtcars_df, cyl ~ gear, value.var = "mpg", fun = mean)
#>    cyl     3      4    5
#> 1:   4 21.50 26.925 28.2
#> 2:   6 19.75 19.750 19.7
#> 3:   8 15.05    NaN 15.4
```

::: sidebar
tidyr 包提供数据变形的函数 `tidyr::pivot_longer()` 和 `tidyr::pivot_wider()` 相比于 Base R 提供的 `reshape()` 和 data.table 提供的 `melt()` 和 `dcast()` 更加形象的命名


```r
tidyr::pivot_wider(data = sleep, names_from = "ID", values_from = "extra")
#> # A tibble: 2 x 11
#>   group   `1`   `2`   `3`   `4`   `5`   `6`   `7`   `8`   `9`  `10`
#>   <fct> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
#> 1 1       0.7  -1.6  -0.2  -1.2  -0.1   3.4   3.7   0.8   0     2  
#> 2 2       1.9   0.8   1.1   0.1  -0.1   4.4   5.5   1.6   4.6   3.4
reshape(data = sleep, v.names = "extra", idvar = "group", timevar = "ID", direction = "wide")
#>    group extra.1 extra.2 extra.3 extra.4 extra.5 extra.6 extra.7 extra.8
#> 1:     1     0.7    -1.6    -0.2    -1.2    -0.1     3.4     3.7     0.8
#> 2:     2     1.9     0.8     1.1     0.1    -0.1     4.4     5.5     1.6
#>    extra.9 extra.10
#> 1:     0.0      2.0
#> 2:     4.6      3.4
```

- `idvar` 分组变量
- `timevar` 组内编号
- `v.names` 个体观察值

::: rmdnote
`sep` 新的列名是由参数 `v.names` (extra) 和参数值 `timevar` (ID) 拼接起来的，默认 `sep = "."` 推荐使用下划线来做分割 `sep = "_"`
:::


```r
ToothGrowth %>% head
#>    len supp dose
#> 1  4.2   VC  0.5
#> 2 11.5   VC  0.5
#> 3  7.3   VC  0.5
#> 4  5.8   VC  0.5
#> 5  6.4   VC  0.5
#> 6 10.0   VC  0.5
ToothGrowth$time <- rep(1:10, 6)
reshape(ToothGrowth, v.names = "len", idvar = c("supp", "dose"),
        timevar = "time", direction = "wide")
#>    supp dose len.1 len.2 len.3 len.4 len.5 len.6 len.7 len.8 len.9 len.10
#> 1    VC  0.5   4.2  11.5   7.3   5.8   6.4  10.0  11.2  11.2   5.2    7.0
#> 11   VC  1.0  16.5  16.5  15.2  17.3  22.5  17.3  13.6  14.5  18.8   15.5
#> 21   VC  2.0  23.6  18.5  33.9  25.5  26.4  32.5  26.7  21.5  23.3   29.5
#> 31   OJ  0.5  15.2  21.5  17.6   9.7  14.5  10.0   8.2   9.4  16.5    9.7
#> 41   OJ  1.0  19.7  23.3  23.6  26.4  20.0  25.2  25.8  21.2  14.5   27.3
#> 51   OJ  2.0  25.5  26.4  22.4  24.5  24.8  30.9  26.4  27.3  29.4   23.0
```
:::

以数据集 ToothGrowth 为例，变量 supp（大组），dose（小组） 和 time（组内个体编号） 一起决定唯一的一个数据 len，特别适合纵向数据的变形操作



## 分组 {#subsec:group-by}

分组切片，取每组第一个和最后一个值


```r
Loblolly %>% 
  dplyr::group_by(Seed) %>% 
  dplyr::arrange(height, age, Seed) %>% 
  dplyr::slice(1, dplyr::n())
#> # A tibble: 28 x 3
#> # Groups:   Seed [14]
#>   height   age Seed 
#>    <dbl> <dbl> <ord>
#> 1   3.93     3 329  
#> 2  56.4     25 329  
#> 3   4.12     3 327  
#> 4  56.8     25 327  
#> 5   4.38     3 325  
#> 6  58.5     25 325  
#> # … with 22 more rows
```

`dplyr::slice()` 和函数 `slice.index()` 有关系吗？

## 合并 {#subsec:merge}

合并操作对应于数据库中的连接操作， dplyr 包的哲学就来源于对数据库操作的进一步抽象， data.table 包的 merge 函数就对应为 dplyr 包的 join 函数

`data.table::merge` 和 `dplyr::join`

给出一个表格，数据操作， data.table 实现， dplyr 实现


```r
dt1 <- data.table(A = letters[1:10], X = 1:10, key = "A")
dt2 <- data.table(A = letters[5:14], Y = 1:10, key = "A")
merge(dt1, dt2) # 内连接
#>    A  X Y
#> 1: e  5 1
#> 2: f  6 2
#> 3: g  7 3
#> 4: h  8 4
#> 5: i  9 5
#> 6: j 10 6
```

参数 key 的作用相当于建立一个索引，通过它实现更快的数据操作速度

`key = c("x","y","z")` 或者 `key = "x,y,z"` 其中 x,y,z 是列名

::: dplyr

```r
data(band_members, band_instruments, package = "dplyr")
band_members
#> # A tibble: 3 x 2
#>   name  band   
#>   <chr> <chr>  
#> 1 Mick  Stones 
#> 2 John  Beatles
#> 3 Paul  Beatles
band_instruments
#> # A tibble: 3 x 2
#>   name  plays 
#>   <chr> <chr> 
#> 1 John  guitar
#> 2 Paul  bass  
#> 3 Keith guitar
dplyr::inner_join(band_members, band_instruments)
#> Joining, by = "name"
#> # A tibble: 2 x 3
#>   name  band    plays 
#>   <chr> <chr>   <chr> 
#> 1 John  Beatles guitar
#> 2 Paul  Beatles bass
```
:::

list 列表里每个元素都是 data.frame 时，最适合用 `data.table::rbindlist` 合并


```r
# 合并列表 https://recology.info/2018/10/limiting-dependencies/
function(x) {
  tibble::as_tibble((x <- data.table::setDF(
    data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id"))
  ))
}
#> function(x) {
#>   tibble::as_tibble((x <- data.table::setDF(
#>     data.table::rbindlist(x, use.names = TRUE, fill = TRUE, idcol = "id"))
#>   ))
#> }
```
