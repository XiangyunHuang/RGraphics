
---
title: "数据可视化与R语言"
subtitle: "Data Visualization with R"
author: "黄湘云"
date: "2019-07-27 16:39:01 CST"
site: bookdown::bookdown_site
documentclass: book
geometry: margin=1.18in
colorlinks: yes
classoption: "UTF8,oneside"
bibliography: ["refer.bib"]
biblio-style: apalike
link-citations: yes
subparagraph: true
description: "数据操作、数据分析、数据建模和数据可视化"
github-repo: XiangyunHuang/RGraphics
url: 'https\://bookdown.org/xiangyun/RGraphics/'
---

<!-- 

# 欢迎 {#welcome .unnumbered}

::: rmdnote
这本书还处于一个很早期的阶段
:::

## Why R {#why-r .unnumbered}

GNU R 是发布在 GPL-2/3 下的开源自由软件，意味着只要你遵循该协议，就可以自由地获取、修改和发布R 源代码，R 本身的这种开源自由的属性，决定你可以免费地使用它。《The Art of R Programming》的作者 Norm Matloff 给出使用 R 语言的四个优势：它是统计学家开发的，也是为统计学家打造的；内建的矩阵类型和矩阵操作非常高效；不管是来自基础 R 还是 CRAN 上的绘图包，都提供强大的绘图功能；还有优秀的并行能力[^r-over-python]，最近他更是在数据科学中全面比较了 R 与 Python[^r-vs-python-ds]。关于 R 语言和 Python 语言的对比，网络上充斥着很多的文章，除了赞扬，还有表示反对的声音，如 R语言采用的对 GPL 协议 [^python-over-r-gpl]，甚至有人列举了逃离 R 语言阵营的10大上榜理由[^top-ten-bad-r]，datacamp 提供了一份较为完整的对比图，仅供参考[^r-vs-python]。如果你是学统计的学生或者数据分析师，我都建议你先学习 R[^why-r]，如果你是社会科学的学生和研究者， R 社区开发了 GUI 工具，如 [Rcmdr](https://socialsciences.mcmaster.ca/jfox/Misc/Rcmdr/) 和 [rattle](https://rattle.togaware.com/)，还有基于 Shiny 的分析工具 [radiant](https://github.com/radiant-rstats/radiant) 和类似 SPSS 的 [JASP](https://jasp-stats.org/)。

R 语言比较遭人诟病的大概有：

1. R 包总体数量已达到 15000+，年度增长速度大约在 4.6\% 左右，很多 R 包都在重复造轮子，且 R 包之间依赖关系非常复杂。若与 Python 作一个对比，所有的 R 包和 Python 模块必须处于活跃维护，拥有大批粉丝，维护者在社区内享有声誉，有厂子或科研经费支持。我们不打嘴仗，不下结论，只做对比，不完善之处还请大家指出并补充，见表 \@ref(tab:r-vs-python)。
1. 每个 Base R 包内的函数非常多，参数也非常多，功能涉及方方面面，初学者学习起来难度非常大！数据处理和可视化常用基本包最流行的 tidyverse 系列和基础 R 系统存在很多不一致，在不清楚的情况下很难掌握，而陷于已有的函数不能自拔！ 
1. R 是面向对象的程序设计语言，是解释性的语言，也是函数式编程语言，包含的程序设计风格非常多，仅面向对象的设计就有 S3、 S4、 RC、 R5 和 R6。每一个操作都是函数调用，一切皆是对象的环境和闭包概念简洁又复杂。
1. R 内置的数据结构非常多，原子类型的有字符、布尔、整型、复数、双精度浮点、单精度浮点等，此外常见的还有数据框、列表。每个特定的领域往往还有特殊的类型，如时间序列 ts、zoo 等， 空间对象 sp、 raster 和 sf 等。
1. 深入学习 R 实现的统计模型，如 `lm`、`glm` 等，你可能会发现统计学家的程序设计思维如此难懂。

Thomas Lumley, "R Fundamentals and Programming Techniques" <https://faculty.washington.edu/tlumley/Rcourse/R-fundamentals.pdf>

Table: (\#tab:r-vs-python) R 与 Python 常用模块对照表

-----------------------------------------------------------------------------------------------------------------------
  比较内容      具体范围                    R 包                                   Python 模块
--------------- --------------------------- -------------------------------------- ------------------------------------
  数据获取      本地、数据库、远程          内置，RCurl、XML、rvest、data.table、  scrapy
                                            odbc

  数据清理      正则表达式                  内置，stringi、stringr、tidyr          re

  数据聚合      SQL支持的所有操作           内置，dplyr、purrr、dbplyr、sparklyr   Numpy、Scipy、Pandas

  数据分析      统计推断的所有方法          内置，lme4、rstan、mxnet、xgoost、     xgboost、scikit-learn、tensorflow、mxnet  
                                            tensorflow               

  数据展示      数据可视化                  内置，ggplot2、plotly                  matplotlib、bokeh、plotly

  数据报告      网页文档、幻灯片            rmarkdown、bookdown、blogdown 

  数据落地      模型部署，调优，维护        plumber、opencpu、fiery
-----------------------------------------------------------------------------------------------------------------------

[^r-over-python]: https://matloff.wordpress.com/2018/11/20/r-python-a-concrete-example/
[^r-vs-python]: https://www.datacamp.com/community/tutorials/r-or-python-for-data-analysis
[^why-r]: https://www.ejwagenmakers.com/misc/HortonEtAl2004.pdf
[^python-over-r-gpl]: https://r-posts.com/how-gpl-makes-me-leave-r-for-python/
[^top-ten-bad-r]: https://decisionstats.com/2009/01/10/top-ten-rrreasons-r-is-bad-for-you/
[^r-vs-python-ds]: https://github.com/matloff/R-vs.-Python-for-Data-Science

## 目标读者 {#who-read-this-book .unnumbered}

本书起源于自己的学习笔记，侧重统计图形，当然也包括在制作统计图形之前的数据导入和ETL操作，后续的数据可视化。本书的目标可以是接触过 R 语言的读者，也可以是零基础者，书的内容侧重数据处理和可视化分析，数据建模的部分比较少。

## 获取帮助 {#Getting-Help-with-R .unnumbered}

R 语言官网给出了一份如何获取帮助的指导 <https://www.r-project.org/help.html>，RStudio 公司也总结了一份 [Getting Help with R](https://support.rstudio.com/hc/en-us/articles/200552336)，又及 <https://blog.rsquaredacademy.com/getting-help-in-r-updated/>
 

## 发展历史 {#history-of-r .unnumbered}

GNU R 最初由 [Ross Ihaka](https://en.wikipedia.org/wiki/Ross_Ihaka) 和 [Robert Gentleman](https://en.wikipedia.org/wiki/Robert_Gentleman_(statistician)) 开发，它脱胎于 S 语言，S 语言形成于大名鼎鼎的美国贝尔实验室，距今已有40多年的历史了[^forty-s]，R语言的前世今生[^history-r]，Ross Ihaka 总结了过去的经验，展望了 R 语言未来发展的方向[^future-r]。

[^future-r]: https://www.stat.auckland.ac.nz/~ihaka/downloads/JSM-Talk.pdf
[^history-r]: https://www.cnblogs.com/chenkai/archive/2013/05/16/3082889.html
[^forty-s]: https://channel9.msdn.com/Events/useR-international-R-User-conference/useR2016/Forty-years-of-S)

## 记号约定 {#conventions .unnumbered}

\index{TinyTeX}
\index{Pandoc}

写作风格，R 包名称都加粗表示，如 **bookdown**， **rmarkdown** 等，软件、编程语言名称保持原样，如 TinyTeX，LyX，TeXLive，R，Python，Stan，C++，SQL等，在代码块中，我们不使用`R>`或`+`，代码输出结果用`#>`注释。**knitr** [@xie_2015_knitr]、 **bookdown** [@xie_2016_bookdown]、 Pandoc 和 TinyTeX ，请使用 XeLaTeX 编译这本书，等宽字体为 [inconsolata](https://ctan.org/pkg/inconsolata) 默认的文本字体为 [Times](https://ctan.org/pkg/mathptmx)


## 运行环境 {#session-info .unnumbered}

重现书籍本节内容需要的 R 包列表如下


```r
xfun::session_info(c("rmarkdown", "bookdown"))
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
#>   base64enc_0.1.3 bookdown_0.12   digest_0.6.20   evaluate_0.14  
#>   glue_1.3.1      graphics_3.6.1  grDevices_3.6.1 highr_0.8      
#>   htmltools_0.3.6 jsonlite_1.6    knitr_1.23      magrittr_1.5   
#>   markdown_1.0    methods_3.6.1   mime_0.7        Rcpp_1.0.2     
#>   rmarkdown_1.14  stats_3.6.1     stringi_1.4.3   stringr_1.4.0  
#>   tinytex_0.14    tools_3.6.1     utils_3.6.1     xfun_0.8       
#>   yaml_2.2.0     
#> 
#> Pandoc version: 2.7.3
```

::: rmdnote
本书要求 R 软件版本 3.6.1 因为书中涉及 `barplot` 新增的公式方法，新增多维数组操作函数 `asplit`， `axis` 函数的 `gap.axis` ，新增 `hcl.colors` 函数等，完整列表见官网 [What's New?](https://cran.r-project.org/doc/manuals/r-release/NEWS.html)
:::


书籍同时使用 [bookdown.org](https://bookdown.org) 和 [netlify](https://www.netlify.com) 部署，网址分别是 <https://bookdown.org/xiangyun/RGraphics/> 和 <https://r-graphics.netlify.com/>

-->
