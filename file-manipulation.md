
# 文件管理员 {#file-manipulation}

> 考虑添加 Shell 下的命令实现，参考 [命令行的艺术](https://github.com/jlevy/the-art-of-command-line/blob/master/README-zh.md)


```r
library(magrittr) # 提供管道命令 %>%
```

::: sidebar
[fs](https://github.com/r-lib/fs) 由 [Jim Hester](https://www.jimhester.com/) 开发，提供文件系统操作的统一接口，相比于 R 默认的文件系统的操作函数有显而易见的优点，详情请看 <https://fs.r-lib.org/>

对于文件操作，Jim Hester 开发了 [fs 包](https://github.com/r-lib/fs) 目的是统一文件操作的命令，由于时间和历史原因，R内置的文件操作函数的命名很不统一，如 `path.expand()` 和 `normalizePath()`，`Sys.chmod()` 和 `file.access()` 等
:::



```r
# 加载 R 包
library(fs)
```


## 查看文件 {#list}

文件夹只包含文件，目录既包含文件又包含文件夹，`list.dirs` 列出目录或文件夹，`list.files` 列出文件或文件夹 

*  `list.dirs(path = ".", full.names = TRUE, recursive = TRUE)`
   +  path: 指定完整路径名，默认使用当前路径 `getwd()`
   +  full.names: TRUE 返回相对路径，FALSE 返回目录的名称
   +  recursive: 是否递归的方式列出目录，如果是的话，目录下的子目录也会列出

   
   ```r
   # list.dirs(path = '.', full.names = TRUE, recursive = TRUE)
   list.dirs(path = '.', full.names = TRUE, recursive = FALSE)
   #>  [1] "./_book"                        "./_bookdown_files"             
   #>  [3] "./.git"                         "./cs-cran-network_cache"       
   #>  [5] "./cs-cran-network_files"        "./data"                        
   #>  [7] "./dc-regular-expressions_cache" "./dc-string-manipulation_cache"
   #>  [9] "./dm-base-r_cache"              "./dm-base-r_files"             
   #> [11] "./dm-dplyr_cache"               "./dm-import-export_cache"      
   #> [13] "./dv-ggplot2_cache"             "./dv-ggplot2_files"            
   #> [15] "./dv-plot_cache"                "./dv-plot_files"               
   #> [17] "./dv-plotly_cache"              "./dv-spatio-temporal_cache"    
   #> [19] "./dv-spatio-temporal_files"     "./figures"                     
   #> [21] "./file-manipulation_cache"      "./includes"                    
   #> [23] "./index_cache"                  "./interactives"                
   #> [25] "./preface_cache"
   list.dirs(path = '.', full.names = FALSE, recursive = FALSE)
   #>  [1] "_book"                        "_bookdown_files"             
   #>  [3] ".git"                         "cs-cran-network_cache"       
   #>  [5] "cs-cran-network_files"        "data"                        
   #>  [7] "dc-regular-expressions_cache" "dc-string-manipulation_cache"
   #>  [9] "dm-base-r_cache"              "dm-base-r_files"             
   #> [11] "dm-dplyr_cache"               "dm-import-export_cache"      
   #> [13] "dv-ggplot2_cache"             "dv-ggplot2_files"            
   #> [15] "dv-plot_cache"                "dv-plot_files"               
   #> [17] "dv-plotly_cache"              "dv-spatio-temporal_cache"    
   #> [19] "dv-spatio-temporal_files"     "figures"                     
   #> [21] "file-manipulation_cache"      "includes"                    
   #> [23] "index_cache"                  "interactives"                
   #> [25] "preface_cache"
   ```

*  `list.files(path = ".", pattern = NULL, all.files = FALSE, full.names = FALSE, recursive = FALSE,ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)`

   是否递归的方式列出目录，如果是的话，目录下的子目录也会列出

   +  path: 指定完整路径名，默认使用当前路径 `getwd()`
   +  full.names: TRUE 返回相对路径，FALSE 返回目录的名称
   +  recursive: 是否递归的方式列出目录，如果是的话，目录下的子目录也会列出

* `file.show(..., header = rep("", nfiles), title = "R Information", delete.file = FALSE, pager = getOption("pager"),encoding = "")` 

   打开文件内容，`file.show` 会在R终端中新开一个窗口显示文件

    
    ```r
    rinternals <- file.path(R.home("include"), "Rinternals.h")
    # file.show(rinternals)
    ```

* `file.info(..., extra_cols = TRUE)` 

   获取文件信息，此外 `file.mode(...)` 、 `file.mtime(...)` 和 `file.size(...)` 分别表示文件的读写权限，修改时间和文件大小。

    
    ```r
    file.info(rinternals)
    #>                                    size isdir mode               mtime
    #> /usr/share/R/include/Rinternals.h 57273 FALSE  644 2019-07-09 04:18:09
    #>                                                 ctime               atime
    #> /usr/share/R/include/Rinternals.h 2019-07-31 13:53:26 2019-07-09 04:18:09
    #>                                   uid gid uname grname
    #> /usr/share/R/include/Rinternals.h   0   0  root   root
    file.mode(rinternals)
    #> [1] "644"
    file.mtime(rinternals)
    #> [1] "2019-07-09 04:18:09 UTC"
    file.size(rinternals)
    #> [1] 57273
    # 查看当前目录的权限
    file.info(".")
    #>   size isdir mode               mtime               ctime
    #> . 4096  TRUE  775 2019-07-31 13:55:31 2019-07-31 13:55:31
    #>                 atime  uid  gid uname grname
    #> . 2019-07-31 13:55:32 2000 2000  <NA>   <NA>
    # 查看指定目录权限
    file.info("./_book/")    
    #>          size isdir mode               mtime               ctime
    #> ./_book/ 4096  TRUE  775 2019-07-31 13:55:29 2019-07-31 13:55:29
    #>                        atime  uid  gid uname grname
    #> ./_book/ 2019-07-31 13:55:29 2000 2000  <NA>   <NA>
    ```

* `file.access(names, mode = 0)`  

   文件是否可以被访问，第二个参数 mode 一共有四种取值 0，1，2，4，分别表示文件的存在性，可执行，可写和可读四种，返回值 0 表示成功，返回值 -1 表示失败。

    
    ```r
    file.access(rinternals,mode = 0)
    #> /usr/share/R/include/Rinternals.h 
    #>                                 0
    file.access(rinternals,mode = 1)
    #> /usr/share/R/include/Rinternals.h 
    #>                                -1
    file.access(rinternals,mode = 2)
    #> /usr/share/R/include/Rinternals.h 
    #>                                 0
    file.access(rinternals,mode = 4)
    #> /usr/share/R/include/Rinternals.h 
    #>                                 0
    ```

* `dir(path = ".", pattern = NULL, all.files = FALSE, full.names = FALSE, recursive = FALSE, ignore.case = FALSE, include.dirs = FALSE, no.. = FALSE)`
   
   查看目录，首先看看和目录操作有关的函数列表

    
    ```r
    apropos("^dir.")
    #>  [1] "dir_copy"   "dir_create" "dir_delete" "dir_exists" "dir_info"  
    #>  [6] "dir_ls"     "dir_map"    "dir_tree"   "dir_walk"   "dir.create"
    #> [11] "dir.exists" "dirname"
    ```
    
   显而易见，`dir.create` 和 `dir.exists` 分别是创建目录和查看目录的存在性。`dirname` 和 `basename` 是一对函数用来操作文件路径。以当前目录/home/docker/workspace为例，`dirname(getwd())` 返回 /home/docker 而 `basename(getwd())` 返回 workspace。对于文件路径而言，`dirname(rinternals)` 返回文件所在的目录/usr/share/R/include， `basename(rinternals)` 返回文件名Rinternals.h。`dir` 函数查看指定路径或目录下的文件，支持以模式匹配和递归的方式查找目录下的文件

    
    ```r
    # 当前目录下的子目录和文件
    dir()
    #>  [1] "_book"                        "_bookdown_files"             
    #>  [3] "_bookdown.yml"                "_build.sh"                   
    #>  [5] "_common.R"                    "_deploy.sh"                  
    #>  [7] "_main.log"                    "_main.rds"                   
    #>  [9] "_output.yml"                  "_render.R"                   
    #> [11] "99-references.Rmd"            "after_body.tex"              
    ....
    # 查看指定目录的子目录和文件
    dir(path = "./")
    #>  [1] "_book"                        "_bookdown_files"             
    #>  [3] "_bookdown.yml"                "_build.sh"                   
    #>  [5] "_common.R"                    "_deploy.sh"                  
    #>  [7] "_main.log"                    "_main.rds"                   
    #>  [9] "_output.yml"                  "_render.R"                   
    #> [11] "99-references.Rmd"            "after_body.tex"              
    ....
    # 只列出以字母R开头的子目录和文件
    dir(path = "./", pattern = "^R")
    #> [1] "README.md"       "RGraphics.Rproj"
    # 列出目录下所有目录和文件，包括隐藏文件
    dir(path = "./", all.files = TRUE)
    #>  [1] "_book"                        "_bookdown_files"             
    #>  [3] "_bookdown.yml"                "_build.sh"                   
    #>  [5] "_common.R"                    "_deploy.sh"                  
    #>  [7] "_main.log"                    "_main.rds"                   
    #>  [9] "_output.yml"                  "_render.R"                   
    #> [11] "."                            ".."                          
    ....
    # 支持正则表达式
    dir(pattern = '^[A-Z]+[.]txt$', full.names=TRUE, system.file('doc', 'SuiteSparse', package='Matrix'))
    #> [1] "/usr/local/lib/R/site-library/Matrix/doc/SuiteSparse/AMD.txt"    
    #> [2] "/usr/local/lib/R/site-library/Matrix/doc/SuiteSparse/CHOLMOD.txt"
    #> [3] "/usr/local/lib/R/site-library/Matrix/doc/SuiteSparse/COLAMD.txt" 
    #> [4] "/usr/local/lib/R/site-library/Matrix/doc/SuiteSparse/SPQR.txt"
    ```
    
    ```r
    # 在临时目录下递归创建一个目录
    dir.create(paste0(tempdir(), "/_book/tmp"), recursive = TRUE)
    ```

查看当前目录下的文件和文件夹 `tree -L 2 .` 或者 `ls -l .` 


## 操作文件 {#manipulation}

实现文件增删改查的函数如下


```r
apropos("^file.")
#>  [1] "file_access"    "file_chmod"     "file_chown"     "file_copy"     
#>  [5] "file_create"    "file_delete"    "file_exists"    "file_info"     
#>  [9] "file_move"      "file_show"      "file_size"      "file_temp"     
#> [13] "file_temp_pop"  "file_temp_push" "file_test"      "file_touch"    
#> [17] "file.access"    "file.append"    "file.choose"    "file.copy"     
#> [21] "file.create"    "file.edit"      "file.exists"    "file.info"     
#> [25] "file.link"      "file.mode"      "file.mtime"     "file.path"     
#> [29] "file.remove"    "file.rename"    "file.show"      "file.size"     
#> [33] "file.symlink"   "fileSnapshot"
```

1. `file.create(..., showWarnings = TRUE)`

   创建/删除文件，检查文件的存在性
   
    
    ```r
    file.create('demo.txt')
    #> [1] TRUE
    file.exists('demo.txt')
    #> [1] TRUE
    file.remove('demo.txt')
    #> [1] TRUE
    file.exists('demo.txt')
    #> [1] FALSE
    ```

1. `file.rename(from, to)` 文件重命名

    
    ```r
    file.create('demo.txt')
    #> [1] TRUE
    file.rename(from = 'demo.txt', to = 'tmp.txt')
    #> [1] TRUE
    file.exists('tmp.txt')
    #> [1] TRUE
    ```

1. `file.append(file1, file2)` 追加文件 `file2` 的内容到文件 `file1` 上

    
    ```r
    if(!dir.exists(paths = 'data/')) dir.create(path = 'data/')
    # 创建两个临时文件
    # file.create(c('data/tmp1.md','data/tmp2.md'))
    # 写入内容
    cat("AAA\n", file = 'data/tmp1.md')
    cat("BBB\n", file = 'data/tmp2.md')
    # 追加文件
    file.append(file1 = 'data/tmp1.md', file2 = 'data/tmp2.md')
    #> [1] TRUE
    # 展示文件内容
    readLines('data/tmp1.md')
    #> [1] "AAA" "BBB"
    ```

1. `file.copy(from, to, overwrite = recursive, recursive = FALSE,copy.mode = TRUE, copy.date = FALSE)` 复制文件，参考 <https://blog.csdn.net/wzj_110/article/details/86497860>

    
    ```r
    file.copy(from = 'Makefile', to = 'data/Makefile')
    #> [1] TRUE
    ```

1. `file.symlink(from, to)` 创建符号链接 `file.link(from, to)` 创建硬链接

1. `Sys.junction(from, to)` windows 平台上的函数，提供类似符号链接的功能

1. `Sys.readlink(paths)` 读取文件的符号链接（软链接）

1. `choose.files` 在 Windows 环境下交互式地选择一个或多个文件，所以该函数只运行于 Windows 环境

    
    ```r
    # 选择 zip 格式的压缩文件或其它
    if (interactive())
         choose.files(filters = Filters[c("zip", "All"),])
    ```
    
    `Filters` 参数传递一个矩阵，用来描述或标记R识别的文件类型，上面这个例子就能筛选出 zip 格式的文件

1. `download.file` 文件下载

    
    ```r
    download.file(url = 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-latest.tar.gz',
                  destfile = 'data/R-latest.tar.gz', method = 'auto')
    ```
    



## 压缩文件 {#compression}

tar 和 zip 是两种常见的压缩文件工具，具有免费和跨平台的特点，因此应用范围广^[<https://github.com/libarchive/libarchive/wiki/FormatTar>]。 R 内对应的压缩与解压缩命令是 `tar/untar` 

```r
tar(tarfile, files = NULL,
    compression = c("none", "gzip", "bzip2", "xz"),
    compression_level = 6, tar = Sys.getenv("tar"),
    extra_flags = "")
```

比较常用的压缩文件格式是 `.tar.gz` 和 `.tar.bz2`，将目录 `_book/`及其文件分别压缩成 `_book.tar.gz` 和 `_book.tar.bz2` 压缩包的名字可以任意取，后者压缩比率高。`.tar.xz` 的压缩比率最高，需要确保系统中安装了 gzip，bzip2 和 xz-utils 软件，R 软件自带的 tar 软件来自 [Rtools](https://github.com/rwinlib/rtools35)[^rtools40]，我们可以通过设置系统环境变量 `Sys.setenv(tar="path/to/tar")` 指定外部 tar。`tar` 实际支持的压缩类型只有 `.tar.gz`^[<https://github.com/rwinlib/utils>]。`zip/unzip` 压缩与解压缩就不赘述了。


```r
# 打包目录 _book
tar(tarfile = 'data/_book.tar', files = '_book', compression = 'none')
# 文件压缩成 _book.xz 格式
tar(tarfile = 'data/_book.tar.xz', files = 'data/_book', compression = 'xz')
# tar -cf data/_book.tar _book 然后 xz -z data/_book.tar.xz data/_book.tar
# 或者一次压缩到位 tar -Jcf data/_book.tar.xz _book/

# 解压 xz -d data/_book.tar.xz 再次解压 tar -xf data/_book.tar
# 或者一次解压 tar -Jxf data/_book.tar.xz

# 文件压缩成 _book.tar.gz 格式
# tar -czf data/_book.tar.gz _book
tar(tarfile = 'data/_book.tar.gz', files = '_book', compression = 'gzip')
# 解压 tar -xzf data/_book.tar.gz

# 文件压缩成 .tar.bz2 格式
# tar -cjf data/book2.tar.bz2 _book
tar(tarfile = 'data/_book.tar.bz2', files = '_book', compression = 'bzip2')
# 解压 tar -xjf data/book2.tar.bz2
```

```r
untar(tarfile, files = NULL, list = FALSE, exdir = ".",
      compressed = NA, extras = NULL, verbose = FALSE,
      restore_times =  TRUE, tar = Sys.getenv("TAR"))
```

[^rtools40]: 继 Rtools35 之后， [RTools40](https://cloud.r-project.org/bin/windows/testing/rtools40.html) 主要为 R 3.6.0 准备的，包含有 GCC 8 及其它编译R包需要的[工具包](https://github.com/r-windows/rtools-packages)，详情请看的[幻灯片](https://jeroen.github.io/uros2018)


## 路径操作 {#paths}

环境变量算是路径操作


```r
# 获取环境变量
Sys.getenv("PATH")
#> [1] "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
# 设置环境变量 Windows
# Sys.setenv(R_GSCMD = "C:/Program Files/gs/gs9.26/bin/gswin64c.exe")
# 设置 pandoc 环境变量
pandoc_path <- Sys.getenv("RSTUDIO_PANDOC", NA)
if (Sys.which("pandoc") == "" && !is.na(pandoc_path)) {
  Sys.setenv(PATH = paste(
    Sys.getenv("PATH"), pandoc_path,
    sep = if (.Platform$OS.type == "unix") ":" else ";"
  ))
}
```

操作文件路径

1. `file.path` Construct Path to File

    
    ```r
    file.path('./_book')
    #> [1] "./_book"
    ```

1. `path.expand(path)` Expand File Paths

    
    ```r
    path.expand('./_book')
    #> [1] "./_book"
    path.expand('~')
    #> [1] "/root"
    ```

1. `normalizePath()` Express File Paths in Canonical Form

    
    ```r
    normalizePath('~')
    #> [1] "/root"
    normalizePath('./_book')
    #> [1] "/home/docker/workspace/_book"
    ```

1. `shortPathName(path)`  只在 Windows 下可用，Express File Paths in Short Form

    
    ```r
    cat(shortPathName(c(R.home(), tempdir())), sep = "\n")
    ```

1. `Sys.glob`  Wildcard Expansion on File Paths

    
    ```r
    Sys.glob(file.path(R.home(), "library", "*", "R", "*.rdx")) 
    #>  [1] "/usr/lib/R/library/base/R/base.rdx"          
    #>  [2] "/usr/lib/R/library/compiler/R/compiler.rdx"  
    #>  [3] "/usr/lib/R/library/graphics/R/graphics.rdx"  
    #>  [4] "/usr/lib/R/library/grDevices/R/grDevices.rdx"
    #>  [5] "/usr/lib/R/library/grid/R/grid.rdx"          
    #>  [6] "/usr/lib/R/library/methods/R/methods.rdx"    
    ....
    ```

## 查找文件 {#find}

[here](https://github.com/r-lib/here) 包用来查找你的文件，查找文件、可执行文件的完整路径、R 包

1. `Sys.which` Find Full Paths to Executables

    
    ```r
    Sys.which('pandoc')
    #>                  pandoc 
    #> "/usr/local/bin/pandoc"
    ```

1. `system.file`  Find Names of R System Files

    
    ```r
    system.file('CITATION',package = 'base')
    #> [1] "/usr/lib/R/library/base/CITATION"
    ```

1. `R.home`

    
    ```r
    # R 安装目录
    R.home()
    #> [1] "/usr/lib/R"
    # R执行文件目录
    R.home('bin')
    #> [1] "/usr/lib/R/bin"
    # 配置文件目录
    R.home('etc')
    #> [1] "/usr/lib/R/etc"
    # R 基础扩展包存放目录
    R.home('library')
    #> [1] "/usr/lib/R/library"
    ```

1. `.libPaths()` R 包存放的路径有哪些

    
    ```r
    .libPaths()
    #> [1] "/usr/local/lib/R/site-library" "/usr/lib/R/site-library"      
    #> [3] "/usr/lib/R/library"
    ```

1. `find.package` 查找R包所在目录

    
    ```r
    find.package(package = 'MASS')
    #> [1] "/usr/local/lib/R/site-library/MASS"
    ```

1. `file.exist` 检查文件是否存在

    
    ```r
    file.exists(paste(R.home('etc'),"Rprofile.site",sep = .Platform$file.sep))
    #> [1] TRUE
    ```

1. `apropos` 和 `find` 查找对象


```r
apropos(what, where = FALSE, ignore.case = TRUE, mode = "any")
find(what, mode = "any", numeric = FALSE, simple.words = TRUE)
```

匹配含有 find 的函数


```r
apropos("find")
#>  [1] ".find.package"        "find"                 "Find"                
#>  [4] "find.package"         "findClass"            "findFunction"        
#>  [7] "findInterval"         "findLineNum"          "findMethod"          
#> [10] "findMethods"          "findMethodSignatures" "findPackageEnv"      
#> [13] "findRestart"          "findUnique"
```

问号 `?` 加函数名搜索R软件内置函数的帮助文档，如 `?regrex`。如果不知道具体的函数名，可采用关键词搜索，如


```r
help.search(keyword = "character", package = "base")
```

`browseEnv` 函数用来在浏览器中查看当前环境下，对象的列表，默认环境是 `sys.frame()`

## 文件权限 {#permissions}

操作目录和文件的权限 Manipulation of Directories and File Permissions

1. `dir.exists(paths)` 检查目录是否存在

    
    ```r
    dir.exists(c('./_book','./book'))
    #> [1]  TRUE FALSE
    ```

1. `dir.create(path, showWarnings = TRUE, recursive = FALSE, mode = "0777")` 创建目录

    
    ```r
    dir.create('./_book/tmp')
    ```

1. `Sys.chmod(paths, mode = "0777", use_umask = TRUE)` 修改权限

    
    ```r
    Sys.chmod('./_book/tmp')
    ```

1. `Sys.umask(mode = NA)`

    


## 区域设置 {#locale}

1. `Sys.getlocale(category = "LC_ALL")` 查看当前区域设置

    
    ```r
    Sys.getlocale(category = "LC_ALL")
    #> [1] "LC_CTYPE=en_US.UTF-8;LC_NUMERIC=C;LC_TIME=en_US.UTF-8;LC_COLLATE=en_US.UTF-8;LC_MONETARY=en_US.UTF-8;LC_MESSAGES=en_US.UTF-8;LC_PAPER=en_US.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.UTF-8;LC_IDENTIFICATION=C"
    ```

1. `Sys.setlocale(category = "LC_ALL", locale = "")` 设置区域

    
    ```r
    # 默认设置
    Sys.setlocale(category = "LC_ALL", locale = "")
    #> [1] "LC_CTYPE=en_US.UTF-8;LC_NUMERIC=C;LC_TIME=en_US.UTF-8;LC_COLLATE=en_US.UTF-8;LC_MONETARY=en_US.UTF-8;LC_MESSAGES=en_US.UTF-8;LC_PAPER=en_US.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.UTF-8;LC_IDENTIFICATION=C"
    # 保存当前区域设置
    old <- Sys.getlocale()
    
    Sys.setlocale("LC_MONETARY", locale = "")
    #> [1] "en_US.UTF-8"
    Sys.localeconv()
    #>     decimal_point     thousands_sep          grouping   int_curr_symbol 
    #>               "."                ""                ""            "USD " 
    #>   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
    #>               "$"               "."               ","        "\003\003" 
    #>     positive_sign     negative_sign   int_frac_digits       frac_digits 
    #>                ""               "-"               "2"               "2" 
    #>     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
    #>               "1"               "0"               "1"               "0" 
    #>       p_sign_posn       n_sign_posn 
    #>               "1"               "1"
    Sys.setlocale("LC_MONETARY", "de_AT")
    #> Warning in Sys.setlocale("LC_MONETARY", "de_AT"): OS reports request to set
    #> locale to "de_AT" cannot be honored
    #> [1] ""
    Sys.localeconv()
    #>     decimal_point     thousands_sep          grouping   int_curr_symbol 
    #>               "."                ""                ""            "USD " 
    #>   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
    #>               "$"               "."               ","        "\003\003" 
    #>     positive_sign     negative_sign   int_frac_digits       frac_digits 
    #>                ""               "-"               "2"               "2" 
    #>     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
    #>               "1"               "0"               "1"               "0" 
    #>       p_sign_posn       n_sign_posn 
    #>               "1"               "1"
    
    # 恢复区域设置
    Sys.setlocale(locale = old)
    #> Warning in Sys.setlocale(locale = old): OS reports request to set locale to
    #> "LC_CTYPE=en_US.UTF-8;LC_NUMERIC=C;LC_TIME=en_US.UTF-8;LC_COLLATE=en_US.UTF-8;LC_MONETARY=en_US.UTF-8;LC_MESSAGES=en_US.UTF-8;LC_PAPER=en_US.UTF-8;LC_NAME=C;LC_ADDRESS=C;LC_TELEPHONE=C;LC_MEASUREMENT=en_US.UTF-8;LC_IDENTIFICATION=C"
    #> cannot be honored
    #> [1] ""
    ```

1. `Sys.localeconv()` 当前区域设置下，数字和货币的表示

    
    ```r
    Sys.localeconv()
    #>     decimal_point     thousands_sep          grouping   int_curr_symbol 
    #>               "."                ""                ""            "USD " 
    #>   currency_symbol mon_decimal_point mon_thousands_sep      mon_grouping 
    #>               "$"               "."               ","        "\003\003" 
    #>     positive_sign     negative_sign   int_frac_digits       frac_digits 
    #>                ""               "-"               "2"               "2" 
    #>     p_cs_precedes    p_sep_by_space     n_cs_precedes    n_sep_by_space 
    #>               "1"               "0"               "1"               "0" 
    #>       p_sign_posn       n_sign_posn 
    #>               "1"               "1"
    ```

    本地化信息

    
    ```r
    l10n_info()
    #> $MBCS
    #> [1] TRUE
    #> 
    #> $`UTF-8`
    #> [1] TRUE
    #> 
    #> $`Latin-1`
    #> [1] FALSE
    ```


## 进程管理 {#process}

 [ps](https://github.com/r-lib/ps) 包用来查询进程信息
 
- `Sys.getpid` 获取当前运行中的 R 控制台（会话）的进程 ID

    
    ```r
    Sys.getpid()
    #> [1] 492
    ```

- `proc.time()` R 会话运行时间，常用于计算R程序在当前R控制台的运行时间

    
    ```r
    t1 <- proc.time()
    tmp <- rnorm(1e6)
    proc.time() - t1
    #>    user  system elapsed 
    #>   0.081   0.000   0.080
    ```

- `system.time` 计算 R 表达式/程序块运行耗费的CPU时间

    
    ```r
    system.time({
      rnorm(1e6)
    }, gcFirst = TRUE)
    #>    user  system elapsed 
    #>   0.073   0.000   0.073
    ```

- `gc.time`  报告垃圾回收耗费的时间

    
    ```r
    gc.time()
    #> [1] 0 0 0 0 0
    ```

## 系统命令 {#system-commands}

`system` 和 `system2` 调用系统命令，推荐使用后者，它更灵活更便携。此外，Jeroen Ooms 开发的 [sys 包](https://github.com/jeroen/sys) 可看作 `base::system2` 的替代品


```r
system <- function(...) cat(base::system(..., intern = TRUE), sep = '\n')
system2 <- function(...) cat(base::system2(..., stdout = TRUE), sep = "\n")
```

```r
system(command = "xelatex --version")
#> XeTeX 3.14159265-2.6-0.999991 (TeX Live 2019)
#> kpathsea version 6.3.1
#> Copyright 2019 SIL International, Jonathan Kew and Khaled Hosny.
#> There is NO warranty.  Redistribution of this software is
#> covered by the terms of both the XeTeX copyright and
#> the Lesser GNU General Public License.
#> For more information about these matters, see the file
#> named COPYING and the XeTeX source.
#> Primary author of XeTeX: Jonathan Kew.
#> Compiled with ICU version 63.1; using 63.1
#> Compiled with zlib version 1.2.11; using 1.2.11
#> Compiled with FreeType2 version 2.9.1; using 2.9.1
#> Compiled with Graphite2 version 1.3.13; using 1.3.13
#> Compiled with HarfBuzz version 2.3.1; using 2.3.1
#> Compiled with libpng version 1.6.36; using 1.6.36
#> Compiled with poppler version 0.68.0
#> Compiled with fontconfig version 2.11.0; using 2.13.1
system2(command = 'pdflatex', args = '--version')
#> pdfTeX 3.14159265-2.6-1.40.20 (TeX Live 2019)
#> kpathsea version 6.3.1
#> Copyright 2019 Han The Thanh (pdfTeX) et al.
#> There is NO warranty.  Redistribution of this software is
#> covered by the terms of both the pdfTeX copyright and
#> the Lesser GNU General Public License.
#> For more information about these matters, see the file
#> named COPYING and the pdfTeX source.
#> Primary author of pdfTeX: Han The Thanh (pdfTeX) et al.
#> Compiled with libpng 1.6.36; using libpng 1.6.36
#> Compiled with zlib 1.2.11; using zlib 1.2.11
#> Compiled with xpdf version 4.01
```

## 时间管理 {#time}

1. `Sys.timezone` 获取时区信息

    
    ```r
    Sys.timezone(location = TRUE)
    #> [1] "Etc/UTC"
    ```

1. `Sys.time` 系统时间，可以给定时区下，显示当前时间，精确到秒，返回数据类型为 `POSIXct`

    
    ```r
    # 此时美国洛杉矶时间
    format(Sys.time(), tz = 'America/Los_Angeles', usetz = TRUE)
    #> [1] "2019-07-31 06:55:33 PDT"
    # 此时加拿大东部时间
    format(Sys.time(), tz = 'Canada/Eastern', usetz = TRUE)
    #> [1] "2019-07-31 09:55:33 EDT"
    ```

1. `Sys.Date` 显示当前时区下的日期，精确到日，返回数据类型为 `date`

    
    ```r
    Sys.Date()
    #> [1] "2019-07-31"
    ```

1. `date` 返回当前系统日期和时间，数据类型是字符串

    
    ```r
    date()
    #> [1] "Wed Jul 31 13:55:33 2019"
    ## 也可以这样表示
    format(Sys.time(), "%a %b %d %H:%M:%S %Y")
    #> [1] "Wed Jul 31 13:55:33 2019"
    ```

1. `as.POSIX*` 是一个 Date-time 转换函数

    
    ```r
    as.POSIXlt(Sys.time(), "GMT") # the current time in GMT
    #> [1] "2019-07-31 13:55:33 GMT"
    ```

1. 时间计算

    
    ```r
    (z <- Sys.time())             # the current date, as class "POSIXct"
    #> [1] "2019-07-31 13:55:34 UTC"
    
    Sys.time() - 3600             # an hour ago
    #> [1] "2019-07-31 12:55:34 UTC"
    ```

1. `.leap.seconds` 是内置的日期序列

    
    ```r
    .leap.seconds
    #>  [1] "1972-07-01 UTC" "1973-01-01 UTC" "1974-01-01 UTC" "1975-01-01 UTC"
    #>  [5] "1976-01-01 UTC" "1977-01-01 UTC" "1978-01-01 UTC" "1979-01-01 UTC"
    #>  [9] "1980-01-01 UTC" "1981-07-01 UTC" "1982-07-01 UTC" "1983-07-01 UTC"
    #> [13] "1985-07-01 UTC" "1988-01-01 UTC" "1990-01-01 UTC" "1991-01-01 UTC"
    #> [17] "1992-07-01 UTC" "1993-07-01 UTC" "1994-07-01 UTC" "1996-01-01 UTC"
    #> [21] "1997-07-01 UTC" "1999-01-01 UTC" "2006-01-01 UTC" "2009-01-01 UTC"
    #> [25] "2012-07-01 UTC" "2015-07-01 UTC" "2017-01-01 UTC"
    ```

    计算日期对应的星期`weekdays`，月 `months` 和季度 `quarters`
    
    
    ```r
    weekdays(.leap.seconds)
    #>  [1] "Saturday"  "Monday"    "Tuesday"   "Wednesday" "Thursday" 
    #>  [6] "Saturday"  "Sunday"    "Monday"    "Tuesday"   "Wednesday"
    #> [11] "Thursday"  "Friday"    "Monday"    "Friday"    "Monday"   
    #> [16] "Tuesday"   "Wednesday" "Thursday"  "Friday"    "Monday"   
    #> [21] "Tuesday"   "Friday"    "Sunday"    "Thursday"  "Sunday"   
    #> [26] "Wednesday" "Sunday"
    months(.leap.seconds)
    #>  [1] "July"    "January" "January" "January" "January" "January" "January"
    #>  [8] "January" "January" "July"    "July"    "July"    "July"    "January"
    #> [15] "January" "January" "July"    "July"    "July"    "January" "July"   
    #> [22] "January" "January" "January" "July"    "July"    "January"
    quarters(.leap.seconds)
    #>  [1] "Q3" "Q1" "Q1" "Q1" "Q1" "Q1" "Q1" "Q1" "Q1" "Q3" "Q3" "Q3" "Q3" "Q1"
    #> [15] "Q1" "Q1" "Q3" "Q3" "Q3" "Q1" "Q3" "Q1" "Q1" "Q1" "Q3" "Q3" "Q1"
    ```

1. `Sys.setFileTime()` 使用系统调用 system call 设置文件或目录的时间

    
    ```r
    # 修改时间前
    file.info('./_common.R')
    #>             size isdir mode               mtime               ctime
    #> ./_common.R 2035 FALSE  664 2019-07-31 13:51:22 2019-07-31 13:51:22
    #>                           atime  uid  gid uname grname
    #> ./_common.R 2019-07-31 13:51:22 2000 2000  <NA>   <NA>
    # 修改时间后，对比一下
    Sys.setFileTime(path = './_common.R', time = Sys.time())
    file.info('./_common.R')
    #>             size isdir mode               mtime               ctime
    #> ./_common.R 2035 FALSE  664 2019-07-31 13:55:34 2019-07-31 13:55:34
    #>                           atime  uid  gid uname grname
    #> ./_common.R 2019-07-31 13:55:34 2000 2000  <NA>   <NA>
    ```

1. `strptime` 用于字符串与 `POSIXlt`、 `POSIXct` 类对象之间的转化，`format` 默认 `tz = ""` 且 `usetz = TRUE` 

    
    ```r
    # 存放时区信息的数据库所在目录
    list.files(file.path(R.home("share"), "zoneinfo"))
    #> character(0)
    # 比较不同的打印方式
    strptime(Sys.time(), format ="%Y-%m-%d %H:%M:%S", tz = "Asia/Taipei")
    #> [1] "2019-07-31 13:55:34 CST"
    format(Sys.time(), format = "%Y-%m-%d %H:%M:%S") # 默认情形
    #> [1] "2019-07-31 13:55:34"
    format(Sys.time(), format = "%Y-%m-%d %H:%M:%S", tz = "Asia/Taipei", usetz = TRUE)
    #> [1] "2019-07-31 21:55:34 CST"
    ```

1. 设置时区

    
    ```r
    Sys.timezone()
    #> [1] "Etc/UTC"
    Sys.setenv(TZ = "Asia/Shanghai")
    Sys.timezone()
    #> [1] "Etc/UTC"
    ```
    
    全局修改，在文件 /usr/lib/R/etc/Rprofile.site 内添加`Sys.setenv(TZ="Asia/Shanghai")`。 局部修改，就是在本地R项目下，创建 `.Rprofile`，然后同样添加 `Sys.setenv(TZ="Asia/Shanghai")`。


## R 包管理 {#package}

相关的函数大致有


```r
apropos('package')
#>  [1] ".find.package"                  ".packages"                     
#>  [3] ".packageStartupMessage"         ".path.package"                 
#>  [5] "$.package_version"              "as.package_version"            
#>  [7] "aspell_package_C_files"         "aspell_package_R_files"        
#>  [9] "aspell_package_Rd_files"        "aspell_package_vignettes"      
#> [11] "available.packages"             "CRAN.packages"                 
#> [13] "download.packages"              "find.package"                  
#> [15] "findPackageEnv"                 "format.packageInfo"            
#> [17] "getClassPackage"                "getPackageName"                
#> [19] "install.packages"               "installed.packages"            
....
```

1. `.packages(T)` 已安装的 R 包

    
    ```r
    .packages(T) %>% length()
    #> [1] 322
    ```
   
1. `available.packages` 查询可用的 R 包

    
    ```r
    available.packages()[,"Package"] %>% head()
    #>            A3        abbyyR           abc      abc.data       ABC.RAP 
    #>          "A3"      "abbyyR"         "abc"    "abc.data"     "ABC.RAP" 
    #>   ABCanalysis 
    #> "ABCanalysis"
    ```
    
    查询 repos 的 R 包
    
    
    ```r
    rforge <- available.packages(repos = "https://r-forge.r-project.org/")
    cran <- available.packages(repos = "https://mirrors.tuna.tsinghua.edu.cn/CRAN/")
    setdiff(rforge[, "Package"], cran[, "Package"])
    ```

1. `download.packages` 下载 R 包

    
    ```r
    download.packages("Rbooks", destdir = "~/", repos = "https://r-forge.r-project.org/")
    ```

1. `install.packages` 安装 R 包

    
    ```r
    install.packages("rmarkdown")
    ```

1. `installed.packages` 已安装的 R 包

    
    ```r
    installed.packages(fields = c("Package","Version")) %>% head()
    ```

1. `remove.packages` 卸载/删除/移除已安装的R包

    
    ```r
    remove.packages('rmarkdown')
    ```
 
1. `update.packages` 更新已安装的 R 包

    
    ```r
    update.packages(ask = FALSE)
    ```

1. `old.packages` 查看过时/可更新的 R 包

    
    ```r
    old.packages() %>% head()
    #>           Package     LibPath                         Installed Built  
    #> deldir    "deldir"    "/usr/local/lib/R/site-library" "0.1-22"  "3.6.1"
    #> foreach   "foreach"   "/usr/local/lib/R/site-library" "1.4.4"   "3.6.1"
    #> iterators "iterators" "/usr/local/lib/R/site-library" "1.0.10"  "3.6.1"
    #> parsnip   "parsnip"   "/usr/local/lib/R/site-library" "0.0.2"   "3.6.1"
    #> tidytext  "tidytext"  "/usr/local/lib/R/site-library" "0.2.1"   "3.6.1"
    #> xml2      "xml2"      "/usr/local/lib/R/site-library" "1.2.0"   "3.6.1"
    #>           ReposVer Repository                            
    #> deldir    "0.1-23" "https://cran.rstudio.com/src/contrib"
    #> foreach   "1.4.7"  "https://cran.rstudio.com/src/contrib"
    #> iterators "1.0.12" "https://cran.rstudio.com/src/contrib"
    #> parsnip   "0.0.3"  "https://cran.rstudio.com/src/contrib"
    #> tidytext  "0.2.2"  "https://cran.rstudio.com/src/contrib"
    #> xml2      "1.2.1"  "https://cran.rstudio.com/src/contrib"
    ```

1. `new.packages` 还没有安装的 R 包 

    
    ```r
    new.packages() %>% head()
    #> [1] "A3"          "abbyyR"      "abc"         "abc.data"    "ABC.RAP"    
    #> [6] "ABCanalysis"
    ```

1. `packageStatus` 查看已安装的 R 包状态，可更新、可下载等

    
    ```r
    packageStatus()
    #> Number of installed packages:
    #>                                
    #>                                  ok upgrade unavailable
    #>   /usr/local/lib/R/site-library 296       6           6
    #>   /usr/lib/R/site-library         0       0           0
    #>   /usr/lib/R/library             14       0           0
    #> 
    #> Number of available packages (each package counted only once):
    #>                                       
    #>                                        installed not installed
    #>   https://cran.rstudio.com/src/contrib       302         14332
    ```
    
1. `packageDescription` 查询 R 包描述信息

    
    ```r
    packageDescription('graphics')
    #> Package: graphics
    #> Version: 3.6.1
    #> Priority: base
    #> Title: The R Graphics Package
    #> Author: R Core Team and contributors worldwide
    #> Maintainer: R Core Team <R-core@r-project.org>
    ....
    ```

1. 查询 R 包的依赖关系

    
    ```r
    # rmarkdown 依赖的 R 包
    tools::package_dependencies('rmarkdown', recursive = TRUE)
    #> $rmarkdown
    #>  [1] "tools"     "utils"     "knitr"     "yaml"      "htmltools"
    #>  [6] "evaluate"  "base64enc" "jsonlite"  "mime"      "tinytex"  
    #> [11] "xfun"      "methods"   "stringr"   "digest"    "Rcpp"     
    #> [16] "highr"     "markdown"  "glue"      "magrittr"  "stringi"  
    #> [21] "stats"
    # 依赖 rmarkdown 的 R 包
    tools::dependsOnPkgs('rmarkdown', recursive = TRUE)
    #> [1] "bookdown"  "reprex"    "tidyverse"
    ```
    
    ggplot2 生态，仅列出以 gg 开头的 R 包
    
    
    ```r
    pdb <- available.packages()
    gg <- tools::dependsOnPkgs("ggplot2", recursive = FALSE, installed = pdb)
    grep("^gg", gg, value = TRUE)
    #>  [1] "ggallin"         "ggalluvial"      "ggalt"          
    #>  [4] "gganimate"       "ggasym"          "ggbeeswarm"     
    #>  [7] "ggbuildr"        "ggChernoff"      "ggconf"         
    #> [10] "ggcorrplot"      "ggdag"           "ggdark"         
    #> [13] "ggdemetra"       "ggdendro"        "ggdistribute"   
    #> [16] "ggdmc"           "ggedit"          "ggenealogy"     
    #> [19] "ggetho"          "ggExtra"         "ggfan"          
    #> [22] "ggfittext"       "ggfocus"         "ggforce"        
    #> [25] "ggformula"       "ggfortify"       "gggenes"        
    #> [28] "ggghost"         "ggguitar"        "gghalfnorm"     
    #> [31] "gghighlight"     "ggimage"         "gginference"    
    #> [34] "gginnards"       "ggiraph"         "ggiraphExtra"   
    #> [37] "ggjoy"           "gglogo"          "ggloop"         
    #> [40] "gglorenz"        "ggmap"           "ggmcmc"         
    #> [43] "ggmosaic"        "ggmuller"        "ggnetwork"      
    #> [46] "ggnewscale"      "ggnormalviolin"  "ggpage"         
    #> [49] "ggparallel"      "ggparliament"    "ggparty"        
    #> [52] "ggperiodic"      "ggplotAssist"    "ggplotgui"      
    #> [55] "ggplotify"       "ggpmisc"         "ggPMX"          
    #> [58] "ggpol"           "ggpolypath"      "ggpubr"         
    #> [61] "ggpval"          "ggQC"            "ggQQunif"       
    #> [64] "ggquickeda"      "ggquiver"        "ggRandomForests"
    #> [67] "ggraph"          "ggraptR"         "ggrasp"         
    #> [70] "ggrepel"         "ggResidpanel"    "ggridges"       
    #> [73] "ggROC"           "ggsci"           "ggseas"         
    #> [76] "ggseqlogo"       "ggsignif"        "ggsn"           
    #> [79] "ggsoccer"        "ggsolvencyii"    "ggsom"          
    #> [82] "ggspatial"       "ggspectra"       "ggstance"       
    #> [85] "ggstatsplot"     "ggswissmaps"     "ggtern"         
    #> [88] "ggThemeAssist"   "ggthemes"        "ggTimeSeries"   
    #> [91] "ggupset"         "ggvoronoi"       "ggwordcloud"
    ```
    

1. 重装R包，与 R 版本号保持一致

    
    ```r
    db <- installed.packages()
    db <- as.data.frame(db, stringsAsFactors = FALSE)
    pkgs <- db[db$Built < getRversion(), "Package"]
    install.packages(pkgs)
    ```

## 查找函数 {#lookup-function}

[lookup](https://github.com/jimhester/lookup) R 函数完整定义，包括编译的代码，S3 和 S4 方法。目前 lookup 包处于开发版，我们可以用 `remotes::install_github` 函数来安装它


```r
# install.packages("remotes")
remotes::install_github("jimhester/lookup")
```

R-level 的源代码都可以直接看


```r
body
#> function (fun = sys.function(sys.parent())) 
#> {
#>     if (is.character(fun)) 
#>         fun <- get(fun, mode = "function", envir = parent.frame())
#>     .Internal(body(fun))
#> }
#> <bytecode: 0x55ed1c760100>
#> <environment: namespace:base>
```

此外，`lookup` 可以定位到 C-level 的源代码，需要联网才能查看，lookup 基于 Winston Chang 在 Github 上维护的 [R 源码镜像](https://github.com/wch/r-source) 


```r
lookup(body)
```
```
base::body [closure] 
function (fun = sys.function(sys.parent())) 
{
    if (is.character(fun)) 
        fun <- get(fun, mode = "function", envir = parent.frame())
    .Internal(body(fun))
}
<bytecode: 0x00000000140d6158>
<environment: namespace:base>
// c source: src/main/builtin.c#L264-L277
SEXP attribute_hidden do_body(SEXP call, SEXP op, SEXP args, SEXP rho)
{
    checkArity(op, args);
    if (TYPEOF(CAR(args)) == CLOSXP) {
        SEXP b = BODY_EXPR(CAR(args));
        RAISE_NAMED(b, NAMED(CAR(args)));
        return b;
    } else {
        if(!(TYPEOF(CAR(args)) == BUILTINSXP ||
             TYPEOF(CAR(args)) == SPECIALSXP))
            warningcall(call, _("argument is not a function"));
        return R_NilValue;
    }
}
```

## 运行环境 {#files-session-info}


```r
xfun::session_info(packages = c("magrittr", "fs"))
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
#>   fs_1.3.1        graphics_3.6.1  grDevices_3.6.1 magrittr_1.5   
#>   methods_3.6.1   Rcpp_1.0.2      stats_3.6.1     utils_3.6.1
```

