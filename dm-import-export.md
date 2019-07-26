
# 数据搬运工 {#data-import-export}

导入数据与导出数据，各种数据格式，数据库

## 导入数据 {#import-data}

Base R 针对不同的数据格式文件，提供了大量的数据导入和导出函数，不愧是专注数据分析20余年的优秀统计软件。 除了函数 `write.ftable` 和 `read.ftable` 来自 stats 包，都来自 base 和 utils 包


```r
# 当前环境的搜索路径
searchpaths()
#> [1] ".GlobalEnv"                   "/usr/lib/R/library/stats"    
#> [3] "/usr/lib/R/library/graphics"  "/usr/lib/R/library/grDevices"
#> [5] "/usr/lib/R/library/utils"     "/usr/lib/R/library/datasets" 
#> [7] "/usr/lib/R/library/methods"   "Autoloads"                   
#> [9] "/usr/lib/R/library/base"
# 返回匹配结果及其所在路径的编号
apropos("^(read|write)", where = TRUE, mode = "function")
#>                  5                  5                  9 
#>         "read.csv"        "read.csv2"         "read.dcf" 
#>                  5                  5                  5 
#>       "read.delim"      "read.delim2"         "read.DIF" 
#>                  5                  2                  5 
#>     "read.fortran"      "read.ftable"         "read.fwf" 
#>                  5                  5                  9 
#>      "read.socket"       "read.table"          "readBin" 
#>                  9                  5                  9 
#>         "readChar" "readCitationFile"         "readline" 
#>                  9                  9                  9 
#>        "readLines"          "readRDS"     "readRenviron" 
#>                  9                  5                  5 
#>            "write"        "write.csv"       "write.csv2" 
#>                  9                  2                  5 
#>        "write.dcf"     "write.ftable"     "write.socket" 
#>                  5                  9                  9 
#>      "write.table"         "writeBin"        "writeChar" 
#>                  9 
#>       "writeLines"
```

### `scan` {#scan-file}


```r
scan(file = "", what = double(), nmax = -1, n = -1, sep = "",
     quote = if(identical(sep, "\n")) "" else "'\"", dec = ".",
     skip = 0, nlines = 0, na.strings = "NA",
     flush = FALSE, fill = FALSE, strip.white = FALSE,
     quiet = FALSE, blank.lines.skip = TRUE, multi.line = TRUE,
     comment.char = "", allowEscapes = FALSE,
     fileEncoding = "", encoding = "unknown", text, skipNul = FALSE)
```

首先让我们用 `cat` 函数创建一个练习数据集 `ex.data`


```r
cat("TITLE extra line", "2 3 5 7", "11 13 17")
#> TITLE extra line 2 3 5 7 11 13 17
cat("TITLE extra line", "2 3 5 7", "11 13 17", file = "data/ex.data", sep = "\n")
```

以此练习数据集，介绍 `scan` 函数最常用的参数


```r
scan("data/ex.data")
#> Error in scan("data/ex.data"): scan() expected 'a real', got 'TITLE'
```

从上面的报错信息，我们发现 `scan` 函数只能读取同一类型的数据，如布尔型 logical， 整型 integer，数值型 numeric(double)， 复数型 complex，字符型 character，raw 和列表 list。所以我们设置参数 `skip = 1` 把第一行跳过，就成功读取了数据


```r
scan("data/ex.data", skip = 1)
#> [1]  2  3  5  7 11 13 17
```

如果设置参数 `quiet = TRUE` 就不会报告读取的数据量


```r
scan("data/ex.data", skip = 1, quiet = TRUE)
#> [1]  2  3  5  7 11 13 17
```

参数 `nlines = 1` 表示只读取一行数据


```r
scan("data/ex.data", skip = 1, nlines = 1) # only 1 line after the skipped one
#> [1] 2 3 5 7
```

默认参数 `flush = TRUE` 表示读取最后一个请求的字段后，刷新到行尾，下面对比一下读取的结果


```r
scan("data/ex.data", what = list("", "", "")) # flush is F -> read "7"
#> Warning in scan("data/ex.data", what = list("", "", "")): number of items
#> read is not a multiple of the number of columns
#> [[1]]
#> [1] "TITLE" "2"     "7"     "17"   
#> 
#> [[2]]
#> [1] "extra" "3"     "11"    ""     
#> 
#> [[3]]
#> [1] "line" "5"    "13"   ""
scan("data/ex.data", what = list("", "", ""), flush = TRUE)
#> [[1]]
#> [1] "TITLE" "2"     "11"   
#> 
#> [[2]]
#> [1] "extra" "3"     "13"   
#> 
#> [[3]]
#> [1] "line" "5"    "17"
```

临时文件 ex.data 用完了，我们调用 `unlink` 函数将其删除，以免留下垃圾文件


```r
unlink("data/ex.data") # tidy up
```

### `read.table` {#read-write-table}


```r
read.table(file, header = FALSE, sep = "", quote = "\"'",
           dec = ".", numerals = c("allow.loss", "warn.loss", "no.loss"),
           row.names, col.names, as.is = !stringsAsFactors,
           na.strings = "NA", colClasses = NA, nrows = -1,
           skip = 0, check.names = TRUE, fill = !blank.lines.skip,
           strip.white = FALSE, blank.lines.skip = TRUE,
           comment.char = "#",
           allowEscapes = FALSE, flush = FALSE,
           stringsAsFactors = default.stringsAsFactors(),
           fileEncoding = "", encoding = "unknown", text, skipNul = FALSE)

read.csv(file, header = TRUE, sep = ",", quote = "\"",
         dec = ".", fill = TRUE, comment.char = "", ...)

read.csv2(file, header = TRUE, sep = ";", quote = "\"",
          dec = ",", fill = TRUE, comment.char = "", ...)

read.delim(file, header = TRUE, sep = "\t", quote = "\"",
           dec = ".", fill = TRUE, comment.char = "", ...)

read.delim2(file, header = TRUE, sep = "\t", quote = "\"",
            dec = ",", fill = TRUE, comment.char = "", ...)
```

变量名是不允许以下划线开头的，同样在数据框里，列名也不推荐使用下划线开头。默认情况下，`read.table` 都会通过参数 `check.names` 检查列名的有效性，该参数实际调用了函数 `make.names` 去检查。如果想尽量保持数据集原来的样子可以设置参数 `check.names = FALSE, stringsAsFactors = FALSE`。 默认情形下，`read.table` 还会将字符串转化为因子变量，这是 R 的历史原因，作为一门统计学家的必备语言，在统计模型中，字符常用来描述类别，而类别变量在 R 环境中常用因子类型来表示，而且大量内置的统计模型也是将它们视为因子变量，如 `lm` 、`glm` 等


```r
dat1 = read.table(header = TRUE, check.names = TRUE, text = "
_a _b _c
1 2 a1
3 4 a2
")
dat1
#>   X_a X_b X_c
#> 1   1   2  a1
#> 2   3   4  a2
dat2 = read.table(header = TRUE, check.names = FALSE, text = "
_a _b _c
1 2 a1
3 4 a2
")
dat2
#>   _a _b _c
#> 1  1  2 a1
#> 2  3  4 a2
dat3 = read.table(header = TRUE, check.names = FALSE, stringsAsFactors = FALSE, text = "
_a _b _c
1 2 a1
3 4 a2
")
dat3
#>   _a _b _c
#> 1  1  2 a1
#> 2  3  4 a2
```

### `readLines` {#read-write-lines}


```r
readLines(con = stdin(), n = -1L, ok = TRUE, warn = TRUE,
          encoding = "unknown", skipNul = FALSE)
```

让我们折腾一波，读进来又写出去，只有 R 3.5.3 以上才能保持原样的正确输入输出，因为这里有一个之前版本包含的 BUG


```r
writeLines(readLines(system.file("DESCRIPTION", package = "splines")), "data/DESCRIPTION")
# 比较一下
identical(
  readLines(system.file("DESCRIPTION", package = "splines")),
  readLines("data/DESCRIPTION")
)
#> [1] TRUE
```

这次我们创建一个真的临时文件，因为重新启动 R 这个文件和文件夹就没有了，回收掉了


```r
fil <- tempfile(fileext = ".data")
cat("TITLE extra line", "2 3 5 7", "", "11 13 17", file = fil,
    sep = "\n")
fil
#> [1] "/tmp/RtmpulzaSd/filedb561e15da.data"
```

设置参数 `n = -1` 表示将文件 fil 的内容从头读到尾


```r
readLines(fil, n = -1)
#> [1] "TITLE extra line" "2 3 5 7"          ""                
#> [4] "11 13 17"
```

作为拥有良好习惯的 R 用户，这种垃圾文件最好用后即焚


```r
unlink(fil) # tidy up
```

再举个例子，我们创建一个新的临时文件 `fil`，文件内容只有


```r
cat("123\nabc")
#> 123
#> abc
```

```r
fil <- tempfile("test")
cat("123\nabc\n", file = fil, append = TRUE)
fil
#> [1] "/tmp/RtmpulzaSd/testdb2e010d94"
readLines(fil)
#> [1] "123" "abc"
```

这次读取文件的过程给出了警告，原因是 fil 没有以空行结尾，`warn = TRUE` 表示这种情况要给出警告，如果设置参数 `warn = FALSE` 就没有警告。我们还是建议大家尽量遵循规范。

再举一个例子，从一个连接读取数据，建立连接的方式有很多，参见 `?file`，下面设置参数 `blocking`


```r
con <- file(fil, "r", blocking = FALSE)
readLines(con)
#> [1] "123" "abc"

cat(" def\n", file = fil, append = TRUE)
readLines(con)
#> [1] " def"
# 关闭连接
close(con)
# 清理垃圾文件
unlink(fil)
```


### `readRDS` {#read-save-rds}

序列化数据操作，Mark Klik 开发的 [fst](https://github.com/fstpackage/fst) 和 [Travers Ching](https://travers.im/) 开发的 [qs](https://github.com/traversc/qs)， Hadley Wickham 开发的 [feather](https://github.com/wesm/feather/tree/master/R) 包实现跨语言环境快速的读写数据

Table: (\#tab:fst-vs-others) fst 序列化数据框对象性能比较 BaseR、 data.table 和 feather [^fst-performance]

| Method         | Format  | Time (ms) | Size (MB) | Speed (MB/s) | N       |
| :------------- | :------ | :-------- | :-------- | :----------- | :------ |
| readRDS        | bin     | 1577      | 1000      | 633          | 112     |
| saveRDS        | bin     | 2042      | 1000      | 489          | 112     |
| fread          | csv     | 2925      | 1038      | 410          | 232     |
| fwrite         | csv     | 2790      | 1038      | 358          | 241     |
| read\_feather  | bin     | 3950      | 813       | 253          | 112     |
| write\_feather | bin     | 1820      | 813       | 549          | 112     |
| **read\_fst**  | **bin** | **457**   | **303**   | **2184**     | **282** |
| **write\_fst** | **bin** | **314**   | **303**   | **3180**     | **291** |

目前比较好的是 qs 和 fst 包 

[^fst-performance]: https://www.fstpackage.org/ 

## 其它数据格式 {#other-data-source}

来自其它格式的数据形式，如 JSON、XML、YAML 需要转化清理成 R 中数据框的形式 data.frame 

1. [Data Rectangling with jq](https://www.carlboettiger.info/2017/12/11/data-rectangling-with-jq/)
1. [Mongolite User Manual](https://jeroen.github.io/mongolite/) introduction to using MongoDB with the mongolite client in R

[jsonlite](https://github.com/jeroen/jsonlite) 读取 `*.json` 格式的文件，`jsonlite::write_json` 函数将 R对象保存为 JSON 文件，`jsonlite::fromJSON` 将 json 字符串或文件转化为 R 对象，`jsonlite::toJSON` 函数正好与之相反


```r
library(jsonlite)
# 从 json 格式的文件导入
# jsonlite::read_json(path = "path/to/filename.json")
# A JSON array of primitives
json <- '["Mario", "Peach", null, "Bowser"]'

# 简化为原子向量atomic vector
fromJSON(json)
#> [1] "Mario"  "Peach"  NA       "Bowser"

# 默认返回一个列表
fromJSON(json, simplifyVector = FALSE)
#> [[1]]
#> [1] "Mario"
#> 
#> [[2]]
#> [1] "Peach"
#> 
#> [[3]]
#> NULL
#> 
#> [[4]]
#> [1] "Bowser"
```

yaml 包读取 `*.yml` 格式文件，返回一个列表，`yaml::write_yaml` 函数将 R 对象写入 yaml 格式 


```r
library(yaml)
yaml::read_yaml(file = '_bookdown.yml')
#> $delete_merged_file
#> [1] TRUE
#> 
#> $language
#> $language$label
#> $language$label$fig
#> [1] "图 "
#> 
#> $language$label$tab
#> [1] "表 "
#> 
#> 
#> $language$ui
#> $language$ui$edit
#> [1] "编辑"
#> 
#> $language$ui$chapter_name
#> [1] "第 " " 章"
#> 
#> 
#> 
#> $output_dir
#> [1] "_book"
#> 
#> $new_session
#> [1] TRUE
#> 
#> $before_chapter_script
#> [1] "_common.R"
#> 
#> $rmd_files
#> [1] "index.Rmd"            "preface.Rmd"          "dm-import-export.Rmd"
#> [4] "dm-base-r.Rmd"        "dm-dplyr.Rmd"         "99-references.Rmd"
```

Table: (\#tab:other-softwares) 导入来自其它数据分析软件产生的数据集

|    统计软件       |         R函数     |        R包
|:------------------|:------------------|:------------------
|ERSI ArcGIS        |  `read.shapefile` |   shapefiles
|Matlab             |  `readMat`        |   R.matlab
|minitab            |  `read.mtp`       |   foreign
|SAS (permanent data)| `read.ssd`       |   foreign
|SAS (XPORT format)|   `read.xport`     |   foreign
|SPSS              |   `read.spss`      |   foreign
|Stata             |   `read.dta`       |   foreign
|Systat            |   `read.systat`    |   foreign
|Octave            |   `read.octave`    |   foreign

Table: (\#tab:other-read-functions) 导入来自其它格式的数据集

|    文件格式       |         R函数     |        R包
|:------------------|:------------------|:------------------
|    列联表数据     |  `read.ftable`    |   stats
|    二进制数据     |  `readBin`        |   base
|    字符串数据     |  `readChar`       |   base
|    剪贴板数据     |  `readClipboard`  |   utils

`read.dcf` 函数读取 Debian 控制格式文件，这种类型的文件以人眼可读的形式在存储数据，如 R 包的 DESCRIPTION 文件或者包含所有 CRAN 上 R 包描述的文件 <https://cran.r-project.org/src/contrib/PACKAGES>


```r
x <- read.dcf(file = system.file("DESCRIPTION", package = "splines"),
              fields = c("Package", "Version", "Title"))
x
#>      Package   Version Title                                    
#> [1,] "splines" "3.6.1" "Regression Spline Functions and Classes"
```

最后要提及拥有瑞士军刀之称的 [rio](https://github.com/leeper/rio) 包，它集合了当前 R 可以读取的所有统计分析软件导出的数据。

## 导入大数据集 {#import-large-dataset}

在不使用数据库的情况下，从命令行导入大数据集，如几百 M 或几个 G 的 csv 文件。利用 data.table 包的 `fread` 去读取

<https://stackoverflow.com/questions/1727772/>

## 从数据库导入 {#import-data-from-database}

[Hands-On Programming with R](https://rstudio-education.github.io/hopr) 数据读写章节[^dataio] 以及 [R, Databases and Docker](https://smithjd.github.io/sql-pet/)

将大量的 txt 文本存进 MySQL 数据库中，通过操作数据库来聚合文本，极大降低内存消耗 [^txt-to-mysql]，而 ODBC 与 DBI 包是其它数据库接口的基础，knitr 提供了一个支持 SQL 代码的引擎，它便是基于 DBI，因此可以在 R Markdown 文档中直接使用 SQL 代码块 [^sql-engine]。这里制作一个归纳表格，左边数据库右边对应其 R 接口，两边都包含链接，如表 \@ref(tab:dbi) 所示

\begin{table}[t]

\caption{(\#tab:dbi)数据库接口}
\centering
\begin{tabular}{l|l|l|l}
\hline
数据库 & 官网 & R接口 & 开发仓\\
\hline
MySQL & https://www.mysql.com/ & RMySQL & https://github.com/r-dbi/RMySQL\\
\hline
SQLite & https://www.sqlite.org & RSQLite & https://github.com/r-dbi/RSQLite\\
\hline
PostgreSQL & https://www.postgresql.org/ & RPostgres & https://github.com/r-dbi/RPostgres\\
\hline
MariaDB & https://mariadb.org/ & RMariaDB & https://github.com/r-dbi/RMariaDB\\
\hline
\end{tabular}
\end{table}



### PostgreSQL

[odbc](https://github.com/r-dbi/odbc) 可以支持很多数据库，下面以连接 [PostgreSQL](https://www.postgresql.org/) 数据库为例介绍其过程

首先在某台机器上，拉取 PostgreSQL 的 Docker 镜像


```bash
docker pull postgres
```

在 Docker 上运行 PostgreSQL，主机端口号 8181 映射给数据库 PostgreSQL 的默认端口号 5432（或其它你的 DBA 分配给你的端口）


```bash
docker run --name psql -d -p 8181:5432 -e ROOT=TRUE \
   -e USER=xiangyun -e PASSWORD=cloud postgres
```

在主机 Ubuntu 上配置


```bash
sudo apt-get install unixodbc unixodbc-dev odbc-postgresql
```

端口 5432 是分配给 PostgreSQL 的默认端口，`host` 可以是云端的地址，如 你的亚马逊账户下的 PostgreSQL 数据库地址 `<ec2-54-83-201-96.compute-1.amazonaws.com>`，也可以是本地局域网IP地址，如`<192.168.1.200>`。通过参数 `dbname` 连接到指定的 PostgreSQL 数据库，如 Heroku，这里作为演示就以默认的数据库 `postgres` 为例

查看配置系统文件路径

```bash
odbcinst -j 
```
```
unixODBC 2.3.6
DRIVERS............: /etc/odbcinst.ini
SYSTEM DATA SOURCES: /etc/odbc.ini
FILE DATA SOURCES..: /etc/ODBCDataSources
USER DATA SOURCES..: /root/.odbc.ini
SQLULEN Size.......: 8
SQLLEN Size........: 8
SQLSETPOSIROW Size.: 8
```

不推荐修改全局配置文件，可设置 `ODBCSYSINI` 环境变量指定配置文件路径，如 `ODBCSYSINI=~/ODBC` <http://www.unixodbc.org/odbcinst.html>

安装完驱动程序，`/etc/odbcinst.ini` 文件内容自动更新，我们可以不必修改，如果你想自定义不妨手动修改，我们查看在 R 环境中注册的数据库，可以看到 PostgreSQL 的驱动已经配置好

```r
odbc::odbcListDrivers()
```
```
                 name   attribute                                    value
1     PostgreSQL ANSI Description    PostgreSQL ODBC driver (ANSI version)
2     PostgreSQL ANSI      Driver                             psqlodbca.so
3     PostgreSQL ANSI       Setup                          libodbcpsqlS.so
4     PostgreSQL ANSI       Debug                                        0
5     PostgreSQL ANSI     CommLog                                        1
6     PostgreSQL ANSI  UsageCount                                        1
7  PostgreSQL Unicode Description PostgreSQL ODBC driver (Unicode version)
8  PostgreSQL Unicode      Driver                             psqlodbcw.so
9  PostgreSQL Unicode       Setup                          libodbcpsqlS.so
10 PostgreSQL Unicode       Debug                                        0
11 PostgreSQL Unicode     CommLog                                        1
12 PostgreSQL Unicode  UsageCount                                        1
```

系统配置文件 `/etc/odbcinst.ini` 已经包含有 PostgreSQL 的驱动配置，无需再重复配置

```
[PostgreSQL ANSI]
Description=PostgreSQL ODBC driver (ANSI version)
Driver=psqlodbca.so
Setup=libodbcpsqlS.so
Debug=0
CommLog=1
UsageCount=1

[PostgreSQL Unicode]
Description=PostgreSQL ODBC driver (Unicode version)
Driver=psqlodbcw.so
Setup=libodbcpsqlS.so
Debug=0
CommLog=1
UsageCount=1
```

只需将如下内容存放在 `~/.odbc.ini` 文件中，

```
[PostgreSQL]
Driver              = PostgreSQL Unicode
Database            = postgres
Servername          = 172.17.0.1
UserName            = postgres
Password            = default
Port                = 8080
```

最后，一行命令 DNS 配置连接 <https://github.com/r-dbi/odbc> 这样就实现了代码中无任何敏感信息，这里为了展示这个配置过程故而把相关信息公开。

> 注意下面的内容需要在容器中运行， Windows 环境下的配置 PostgreSQL 的驱动有点麻烦就不搞了，意义也不大，现在数据库基本都是跑在 Linux 系统上

`docker-machine.exe ip default` 可以获得本地 Docker 的 IP，比如 192.168.99.101。 Travis 上 `ip addr` 可以查看 Docker 的 IP，如 172.17.0.1


```r
library(DBI)
con <- dbConnect(RPostgres::Postgres(),
  dbname = "postgres",
  host = ifelse(is_on_travis, Sys.getenv("DOCKER_HOST_IP"), "192.168.99.101"),
  port = 8080,
  user = "postgres",
  password = "default"
)
```

```r
library(DBI)
con <- dbConnect(odbc::odbc(), "PostgreSQL")
```

列出数据库中的所有表


```r
dbListTables(con)
#> [1] "mtcars"
```

第一次启动从 Docker Hub 上下载的镜像，默认的数据库是 postgres 里面没有任何表，所以将 R 环境中的 mtcars 数据集写入 postgres 数据库

将数据集 mtcars 写入 PostgreSQL 数据库中，基本操作，写入表的操作也不能缓存，即不能缓存数据库中的表 mtcars


```r
dbWriteTable(con, "mtcars", mtcars, overwrite = TRUE)
```

现在可以看到数据表 mtcars 的各个字段


```r
dbListFields(con, "mtcars")
#>  [1] "row_names" "mpg"       "cyl"       "disp"      "hp"       
#>  [6] "drat"      "wt"        "qsec"      "vs"        "am"       
#> [11] "gear"      "carb"
```

最后执行一条 SQL 语句


```r
res <- dbSendQuery(con, "SELECT * FROM mtcars WHERE cyl = 4") # 发送 SQL 语句
dbFetch(res) # 获取查询结果
#>         row_names  mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1      Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 2       Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 3        Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 4        Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 5     Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 6  Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 7   Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 8       Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 9   Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 10   Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 11     Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
dbClearResult(res) # 清理查询通道
```

或者一条命令搞定


```r
dbGetQuery(con, "SELECT * FROM mtcars WHERE cyl = 4")
#>         row_names  mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> 1      Datsun 710 22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> 2       Merc 240D 24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> 3        Merc 230 22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> 4        Fiat 128 32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> 5     Honda Civic 30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> 6  Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> 7   Toyota Corona 21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> 8       Fiat X1-9 27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> 9   Porsche 914-2 26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> 10   Lotus Europa 30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> 11     Volvo 142E 21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```

再复杂一点的 SQL 查询操作


```r
dbGetQuery(con, "SELECT cyl, AVG(mpg) AS mpg FROM mtcars GROUP BY cyl ORDER BY cyl")
#>   cyl      mpg
#> 1   4 26.66364
#> 2   6 19.74286
#> 3   8 15.10000
aggregate(mpg ~ cyl, data = mtcars, mean)
#>   cyl      mpg
#> 1   4 26.66364
#> 2   6 19.74286
#> 3   8 15.10000
```

得益于 knitr [@xie_2015_knitr] 开发的钩子，这里直接写 SQL 语句块，打印出来见表 \@ref(tab:mtcars)，值得注意的是 SQL 代码块不能启用缓存，数据库连接通道也不能缓存，如果数据库中还没有写入表，那么写入表的操作也不能缓存


```sql
SELECT cyl, AVG(mpg) AS mpg FROM mtcars GROUP BY cyl ORDER BY cyl
```


\begin{table}[t]

\caption{(\#tab:mtcars)表格标题}
\centering
\begin{tabular}{r|r}
\hline
cyl & mpg\\
\hline
4 & 26.66364\\
\hline
6 & 19.74286\\
\hline
8 & 15.10000\\
\hline
\end{tabular}
\end{table}

如果将查询结果导出到变量，在 Chunk 设置 `output.var = "agg_cyl"` 可以使用缓存，下面将 mpg 按 cyl 分组聚合的结果打印出来



```r
agg_cyl
#>   cyl      mpg
#> 1   4 26.66364
#> 2   6 19.74286
#> 3   8 15.10000
```

这种基于 odbc 的方式的好处就不需要再安装 R 包 RPostgres 和相关系统依赖，最后关闭连接通道


```r
dbDisconnect(con)
```

### MySQL

MySQL 是一个很常见，应用也很广泛的数据库，数据分析的常见环境是在一个R Notebook 里，我们可以在正文之前先设定数据库连接信息


````
```{r setup}
library(DBI)
# 指定数据库连接信息
db <- dbConnect(RMySQL::MySQL(),
  dbname = 'dbtest',
  username = 'user_test',
  password = 'password',
  host = '10.10.101.10',
  port = 3306
)
# 创建默认连接
knitr::opts_chunk$set(connection = 'db')
# 设置字符编码，以免中文查询乱码
DBI::dbSendQuery(db, 'SET NAMES utf8')
# 设置日期变量，以运用在SQL中
idate <- '2019-05-03'
```
````

SQL 代码块中使用 R 环境中的变量，并将查询结果输出为R环境中的数据框


````
```{sql, output.var='data_output'}
SELECT * FROM user_table where date_format(created_date,'%Y-%m-%d')>=?idate
```
````

以上代码会将 SQL 的运行结果存在 `data_output` 这是数据库中，idate 取之前设置的日期`2019-05-03`，`user_table` 是 MySQL 数据库中的表名，`created_date` 是创建`user_table`时，指定的日期名。

如果 SQL 比较长，为了代码美观，把带有变量的 SQL 保存为`demo.sql`脚本，只需要在 SQL 的 chunk 中直接读取 SQL 文件[^sql-chunck]。


````
```{sql, code=readLines('demo.sql'), output.var='data_output'}
```
````

如果我们需要每天或者按照指定的日期重复地运行这个 R Markdown 文件，可以在 YAML 部分引入参数[^params-knit]

```markdown
---
params:
  date: "2019-05-03"  # 参数化日期
---
```

````
```{r setup, include=FALSE}
idate = params$date # 将参数化日期传递给 idate 变量
```
````

我们将这个 Rmd 文件命名为 `MyDocument.Rmd`，运行这个文件可以从 R 控制台执行或在 RStudio 点击 knit。


```r
rmarkdown::render("MyDocument.Rmd", params = list(
  date = "2019-05-03"
))
```

如果在文档的 YAML 位置已经指定日期，这里可以不指定。注意在这里设置日期会覆盖 YAML 处指定的参数值，这样做的好处是可以批量化操作。

### Spark

当数据分析报告遇上 Spark 时，就需要 [SparkR](https://github.com/apache/spark/tree/master/R)、 [sparklyr](https://github.com/rstudio/sparklyr)、 [arrow](https://github.com/apache/arrow/tree/master/r) 或 [rsparking](https://github.com/h2oai/sparkling-water/tree/master/r) 接口了， Javier Luraschi 写了一本书 [The R in Spark: Learning Apache Spark with R](https://therinspark.com/) 详细介绍了相关扩展和应用

首先安装 sparklyr 包，RStudio 公司 Javier Lurasch 开发了 sparklyr 包，作为 Spark 与 R 语言之间的接口，安装完 sparklyr 包，还是需要 Spark 和 Hadoop 环境


```r
install.packages('sparklyr')
library(sparklyr)
spark_install()
# Installing Spark 2.4.0 for Hadoop 2.7 or later.
# Downloading from:
# - 'https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz'
# Installing to:
# - '~/spark/spark-2.4.0-bin-hadoop2.7'
# trying URL 'https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz'
# Content type 'application/x-gzip' length 227893062 bytes (217.3 MB)
# ==================================================
# downloaded 217.3 MB
# 
# Installation complete.
```

既然 sparklyr 已经安装了 Spark 和 Hadoop 环境，安装 SparkR 后，只需配置好路径，就可以加载 SparkR 包


```r
install.packages('SparkR')
if (nchar(Sys.getenv("SPARK_HOME")) < 1) {
  Sys.setenv(SPARK_HOME = "~/spark/spark-2.4.0-bin-hadoop2.7")
}
library(SparkR, lib.loc = c(file.path(Sys.getenv("SPARK_HOME"), "R", "lib")))
sparkR.session(master = "local[*]", sparkConfig = list(spark.driver.memory = "2g"))
```

[rscala](https://github.com/dbdahl/rscala) 架起了 R 和 Scala 两门语言之间交流的桥梁，使得彼此之间可以互相调用

> 是否存在这样的可能， Spark 提供了大量的 MLib 库的调用接口，R 的功能支持是最少的，Java/Scala 是原生的，那么要么自己开发新的功能整合到 SparkR 中，要么借助 rscala 将 scala 接口代码封装进来 

[^sql-chunck]: https://d.cosx.org/d/419974
[^txt-to-mysql]: https://brucezhaor.github.io/blog/2016/08/04/batch-process-txt-to-mysql
[^params-knit]: https://bookdown.org/yihui/rmarkdown/params-knit.html
[^dataio]: https://rstudio-education.github.io/hopr/dataio.html
[^sql-engine]: https://bookdown.org/yihui/rmarkdown/language-engines.html#sql
[rstudio-spark]: https://spark.rstudio.com/
[rmarkdown-teaching-demo]: https://stackoverflow.com/questions/35459166

## 批量导入数据 {#batch-import-data}


```r
library(tidyverse)
```


```r
read_list <- function(list_of_datasets, read_func) {
  read_and_assign <- function(dataset, read_func) {
    dataset_name <- as.name(dataset)
    dataset_name <- read_func(dataset)
  }

  # invisible is used to suppress the unneeded output
  output <- invisible(
    sapply(list_of_datasets,
      read_and_assign,
      read_func = read_func, simplify = FALSE, USE.NAMES = TRUE
    )
  )

  # Remove the extension at the end of the data set names
  names_of_datasets <- c(unlist(strsplit(list_of_datasets, "[.]"))[c(T, F)])
  names(output) <- names_of_datasets
  return(output)
}
```

批量导入文件扩展名为 `.csv` 的数据文件，即逗号分割的文件
 

```r
data_files <- list.files(path = "path/to/csv/dir",pattern = ".csv", full.names = TRUE)
print(data_files)
```

相比于 Base R 提供的 `read.csv` 函数，使用 readr 包的 `read_csv` 函数可以更快地读取csv格式文件，特别是在读取GB级数据文件时，效果特别明显。


```r
list_of_data_sets <- read_list(data_files, readr::read_csv)
```

使用 tibble 包的`glimpse`函数可以十分方便地对整个数据集有一个大致的了解，展示方式和信息量相当于 `str` 加 `head` 函数 


```r
tibble::glimpse(list_of_data_sets)
```

## 批量导出数据 {#batch-export-data}

假定我们有一个列表，其每个元素都是一个数据框，现在要把每个数据框分别存入 xlsx 表的工作薄中，以 mtcars 数据集为例，将其按分类变量 cyl 分组拆分，获得一个列表 list 


```r
dat <- split(mtcars, mtcars$cyl)
dat
#> $`4`
#>                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Datsun 710     22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
#> Merc 240D      24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
#> Merc 230       22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
#> Fiat 128       32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
#> Honda Civic    30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
#> Toyota Corolla 33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
#> Toyota Corona  21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
#> Fiat X1-9      27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
#> Porsche 914-2  26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
#> Lotus Europa   30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
#> Volvo 142E     21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
#> 
#> $`6`
#>                 mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Mazda RX4      21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
#> Mazda RX4 Wag  21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
#> Hornet 4 Drive 21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
#> Valiant        18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
#> Merc 280       19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
#> Merc 280C      17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
#> Ferrari Dino   19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
#> 
#> $`8`
#>                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
#> Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
#> Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
#> Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
#> Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
#> Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
#> Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
#> Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
#> Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
#> Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
#> AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
#> Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
#> Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
#> Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
#> Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
```

将 xlsx 表格初始化，创建空白的工作薄， [openxlsx](https://github.com/awalker89/openxlsx) 包不依赖 Java 环境，读写效率也高


```r
## 加载 openxlsx 包
library(openxlsx)
## 创建空白的工作薄
wb <- createWorkbook()
```

将列表里的每张表分别存入 xlsx 表格的每个 worksheet，worksheet 的名字就是分组变量的名字


```r
Map(function(data, name){
    addWorksheet(wb, name)
    writeData(wb, name, data)
 
}, dat, names(dat))
```

最后保存数据到磁盘，见图 \@ref(fig:batch-export-xlsx)


```r
saveWorkbook(wb, file = "data/matcars.xlsx", overwrite = TRUE)
```
\begin{figure}[!htb]

{\centering \includegraphics[width=0.7\linewidth]{figures/dm-batch-export-xlsx} 

}

\caption{批量导出数据}(\#fig:batch-export-xlsx)
\end{figure}

::: sidebar
处理 Excel 2003 (XLS) 和 Excel 2007 (XLSX) 文件还可以使用 [WriteXLS](https://github.com/marcschwartz/WriteXLS) 包，不过它依赖于 Perl，另一个 R 包 [xlsx](	https://github.com/dragua/rexcel) 与之功能类似，依赖 Java 环境。Jennifer Bryan 和 Hadley Wickham 开发的 [readxl](https://github.com/tidyverse/readxl) 包和 Jeroen Ooms 开发的 [writexl](https://github.com/ropensci/writexl) 包专门处理 xlsx 格式并且无任何系统依赖
:::

## 导出数据 {#export-data}

### 导出运行结果 {#export-output}


```r
capture.output(..., file = NULL, append = FALSE,
               type = c("output", "message"), split = FALSE)
```

`capture.output` 将一段R代码执行结果，保存到文件，参数为表达式。`capture.output` 和 `sink` 的关系相当于 `with` 和 `attach` 的关系。


```r
glmout <- capture.output(summary(glm(case ~ spontaneous + induced,
  data = infert, family = binomial()
)), file = "data/capture.txt")
capture.output(1 + 1, 2 + 2)
#> [1] "[1] 2" "[1] 4"
capture.output({
  1 + 1
  2 + 2
})
#> [1] "[1] 4"
```

`sink` 函数将控制台输出结果保存到文件，只将 `outer` 函数运行的结果保存到 `ex-sink.txt` 文件，outer 函数计算的是直积，在这里相当于 `seq(10) %*% t(seq(10))`，而在 R 语言中，更加有效的计算方式是 `tcrossprod(seq(10),seq(10))`


```r
sink("data/ex-sink.txt")
i <- 1:10
outer(i, i, "*") 
#>       [,1] [,2] [,3] [,4] [,5] [,6] [,7] [,8] [,9] [,10]
#>  [1,]    1    2    3    4    5    6    7    8    9    10
#>  [2,]    2    4    6    8   10   12   14   16   18    20
#>  [3,]    3    6    9   12   15   18   21   24   27    30
#>  [4,]    4    8   12   16   20   24   28   32   36    40
#>  [5,]    5   10   15   20   25   30   35   40   45    50
#>  [6,]    6   12   18   24   30   36   42   48   54    60
#>  [7,]    7   14   21   28   35   42   49   56   63    70
#>  [8,]    8   16   24   32   40   48   56   64   72    80
#>  [9,]    9   18   27   36   45   54   63   72   81    90
#> [10,]   10   20   30   40   50   60   70   80   90   100
sink()
```

<!-- 记得删除文件 capture.txt 和 ex-sink.txt -->

### 导出数据对象 {#export-data-object}


```r
load(file, envir = parent.frame(), verbose = FALSE)

save(..., list = character(),
     file = stop("'file' must be specified"),
     ascii = FALSE, version = NULL, envir = parent.frame(),
     compress = isTRUE(!ascii), compression_level,
     eval.promises = TRUE, precheck = TRUE)

save.image(file = ".RData", version = NULL, ascii = FALSE,
           compress = !ascii, safe = TRUE)
```

`load` 和`save` 函数加载或保存包含工作环境信息的数据对象，`save.image` 保存当前工作环境到磁盘，即保存工作空间中所有数据对象，数据格式为 `.RData`，即相当于


```r
save(list = ls(all.names = TRUE), file = ".RData", envir = .GlobalEnv)
```

`dump` 保存数据对象 AirPassengers 到文件 `AirPassengers.txt`，文件内容是 R 命令，可把`AirPassengers.txt`看作代码文档执行，dput 保存数据对象内容到文件`AirPassengers.dat`，文件中不包含变量名 AirPassengers。注意到 `dump` 输入是一个字符串，而 `dput` 要求输入数据对象的名称，`source` 函数与 `dump` 对应，而 `dget` 与 `dput`对应。 


```r
# 加载数据
data(AirPassengers, package = "datasets")
# 将数据以R代码块的形式保存到文件
dump('AirPassengers', file = 'data/AirPassengers.txt') 
# source(file = 'data/AirPassengers.txt')
```

接下来，我们读取 `AirPassengers.txt` 的文件内容，可见它是一段完整的 R 代码，可以直接复制到 R 的控制台中运行，并且得到一个与原始 AirPassengers 变量一样的结果


```r
cat(readLines('data/AirPassengers.txt'), sep = "\n")
#> AirPassengers <-
#> structure(c(112, 118, 132, 129, 121, 135, 148, 148, 136, 119, 
#> 104, 118, 115, 126, 141, 135, 125, 149, 170, 170, 158, 133, 114, 
#> 140, 145, 150, 178, 163, 172, 178, 199, 199, 184, 162, 146, 166, 
#> 171, 180, 193, 181, 183, 218, 230, 242, 209, 191, 172, 194, 196, 
#> 196, 236, 235, 229, 243, 264, 272, 237, 211, 180, 201, 204, 188, 
#> 235, 227, 234, 264, 302, 293, 259, 229, 203, 229, 242, 233, 267, 
#> 269, 270, 315, 364, 347, 312, 274, 237, 278, 284, 277, 317, 313, 
#> 318, 374, 413, 405, 355, 306, 271, 306, 315, 301, 356, 348, 355, 
#> 422, 465, 467, 404, 347, 305, 336, 340, 318, 362, 348, 363, 435, 
#> 491, 505, 404, 359, 310, 337, 360, 342, 406, 396, 420, 472, 548, 
#> 559, 463, 407, 362, 405, 417, 391, 419, 461, 472, 535, 622, 606, 
#> 508, 461, 390, 432), .Tsp = c(1949, 1960.91666666667, 12), class = "ts")
```

`dput` 函数类似 `dump` 函数，保存数据对象到磁盘文件


```r
# 将 R 对象保存/导出到磁盘
dput(AirPassengers, file = 'data/AirPassengers.dat')
AirPassengers
     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
1949 112 118 132 129 121 135 148 148 136 119 104 118
1950 115 126 141 135 125 149 170 170 158 133 114 140
1951 145 150 178 163 172 178 199 199 184 162 146 166
1952 171 180 193 181 183 218 230 242 209 191 172 194
1953 196 196 236 235 229 243 264 272 237 211 180 201
1954 204 188 235 227 234 264 302 293 259 229 203 229
1955 242 233 267 269 270 315 364 347 312 274 237 278
1956 284 277 317 313 318 374 413 405 355 306 271 306
1957 315 301 356 348 355 422 465 467 404 347 305 336
1958 340 318 362 348 363 435 491 505 404 359 310 337
1959 360 342 406 396 420 472 548 559 463 407 362 405
1960 417 391 419 461 472 535 622 606 508 461 390 432
# dget 作用与 dput 相反
AirPassengers2 <- dget(file = 'data/AirPassengers.dat')
AirPassengers2
     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec
1949 112 118 132 129 121 135 148 148 136 119 104 118
1950 115 126 141 135 125 149 170 170 158 133 114 140
1951 145 150 178 163 172 178 199 199 184 162 146 166
1952 171 180 193 181 183 218 230 242 209 191 172 194
1953 196 196 236 235 229 243 264 272 237 211 180 201
1954 204 188 235 227 234 264 302 293 259 229 203 229
1955 242 233 267 269 270 315 364 347 312 274 237 278
1956 284 277 317 313 318 374 413 405 355 306 271 306
1957 315 301 356 348 355 422 465 467 404 347 305 336
1958 340 318 362 348 363 435 491 505 404 359 310 337
1959 360 342 406 396 420 472 548 559 463 407 362 405
1960 417 391 419 461 472 535 622 606 508 461 390 432
```

同样地，现在我们观察 `dput` 函数保存的文件 `AirPassengers.dat` 内容，和`dump` 函数保存的文件 `AirPassengers.txt`相比，就缺一个赋值变量


```r
cat(readLines('data/AirPassengers.dat'), sep = "\n")
structure(c(112, 118, 132, 129, 121, 135, 148, 148, 136, 119, 
104, 118, 115, 126, 141, 135, 125, 149, 170, 170, 158, 133, 114, 
140, 145, 150, 178, 163, 172, 178, 199, 199, 184, 162, 146, 166, 
171, 180, 193, 181, 183, 218, 230, 242, 209, 191, 172, 194, 196, 
196, 236, 235, 229, 243, 264, 272, 237, 211, 180, 201, 204, 188, 
235, 227, 234, 264, 302, 293, 259, 229, 203, 229, 242, 233, 267, 
269, 270, 315, 364, 347, 312, 274, 237, 278, 284, 277, 317, 313, 
318, 374, 413, 405, 355, 306, 271, 306, 315, 301, 356, 348, 355, 
422, 465, 467, 404, 347, 305, 336, 340, 318, 362, 348, 363, 435, 
491, 505, 404, 359, 310, 337, 360, 342, 406, 396, 420, 472, 548, 
559, 463, 407, 362, 405, 417, 391, 419, 461, 472, 535, 622, 606, 
508, 461, 390, 432), .Tsp = c(1949, 1960.91666666667, 12), class = "ts")
```

<!-- 记得删除文件 AirPassengers.txt 和 AirPassengers.dat -->

## 运行环境 {#dm-session-info}


```r
xfun::session_info(c("jsonlite", "yaml", "odbc"))
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
#>   assertthat_0.2.1  backports_1.1.4   BH_1.69.0.1      
#>   bit_1.1.14        bit64_0.9.7       blob_1.2.0       
#>   DBI_1.0.0         digest_0.6.20     ellipsis_0.2.0.1 
#>   glue_1.3.1        graphics_3.6.1    grDevices_3.6.1  
#>   hms_0.5.0         jsonlite_1.6      magrittr_1.5     
#>   methods_3.6.1     odbc_1.1.6        pkgconfig_2.0.2  
#>   prettyunits_1.0.2 Rcpp_1.0.2        rlang_0.4.0      
#>   stats_3.6.1       tools_3.6.1       utils_3.6.1      
#>   vctrs_0.2.0       yaml_2.2.0        zeallot_0.1.0
```
