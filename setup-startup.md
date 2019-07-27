
# 安装与配置 {#setup-startup}

主要参考 R-admin

## 仓库安装 {#repo-install}

### Ubuntu

安装 openssh zsh 和 Git

```bash
sudo apt-get install zsh openssh-server
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update && sudo apt install git
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

只考虑最新的 Ubuntu 18.04 因为本书写成的时候，该版本应该已经大规模使用了，默认版本的安装和之前版本的安装就不再展示了。安装最新版 R-3.5.x，无论安装哪个版本，都要先导入密钥

```bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E084DAB9
```

* Ubuntu 14.04.5 提供的默认版本 R 3.0.2，安装 R 3.5.x 系列之前的版本，如 R 3.4.4

  ```bash
  sudo apt-add-repository -y "deb http://cran.rstudio.com/bin/linux/ubuntu `lsb_release -cs`/"
  sudo apt-get install r-base-dev
  ```

  添加完仓库后，都需要更新源`sudo apt-get update`，安装 R 3.5.x 系列最新版

  ```bash
  sudo apt-add-repository -y "deb https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/linux/ubuntu trusty-cran35/"
  ```

* Ubuntu 16.04.5  提供的默认版本 R 3.4.4，这是 R 3.4.x 系列的最新版，安装目前最新的 R 3.5.x 版本需要

  ```bash
  sudo apt-add-repository -y "deb https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/linux/ubuntu xenial-cran35/"
  ```
  
* Ubuntu 18.04.1 提供的默认版本 R 3.4.4，安装目前的最新版本需要

  ```bash
  sudo apt-add-repository -y "deb https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/linux/ubuntu bionic-cran35/"
  ```
  
  接下来安装 R，详细安装指导见 [CRAN 官网](https://cran.r-project.org/bin/linux/debian/index.html)。 

  ```bash
  sudo apt-get install -y r-base-dev
  ```
  
  Michael Rutter 维护了编译好的二进制版本 <https://launchpad.net/~marutter>，比如 rstan 包可以通过安装 r-cran-rstan 完成
  
  ```bash
  # R packages for Ubuntu LTS. Based on CRAN Task Views.
  sudo add-apt-repository -y ppa:marutter/c2d4u3.5
  sudo apt-get install r-cran-rstan
  ```

### CentOS

同样适用于 Fedora

安装指导[^install-r]

[^install-r]: 在 CentOS 7 上打造 R 语言编程环境 

## 源码安装 {#source-install}

### Ubuntu

1. 首先启用源码仓库，否则执行 `sudo apt-get build-dep r-base` 会报如下错误

  ```
  E: You must put some 'source' URIs in your sources.list
  ```

  ```bash
  sudo sed -i -- 's/#deb-src/deb-src/g' /etc/apt/sources.list && sudo sed -i -- 's/# deb-src/deb-src/g' /etc/apt/sources.list
  sudo apt-get update
  ```

1. 安装编译 R 所需的系统依赖

  ```bash
  sudo apt-get build-dep r-base-dev
  ```

1. 编译安装 R

  ```bash
  ./configure
  make && make install 
  ```
  
1. 自定义编译选项

  ```bash
  ./configure --help
  ```  

### CentOS

基于 CentOS 7 和 GCC 4.8.5，参考 R-admin 手册

* 下载源码包

  最新发布的稳定版
  
  ```bash
  curl -fLo ./R-latest.tar.gz https://mirrors.tuna.tsinghua.edu.cn/CRAN/src/base/R-latest.tar.gz
  ```
  ```
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
   10 28.7M   10 3232k    0     0   107k      0  0:04:34  0:00:30  0:04:04  118k
  ```

* 安装依赖

  ```bash
  sudo yum install -y yum-utils epel-release && sudo yum-builddep R-devel
  sudo dnf update && sudo dnf builddep R-devel # Fedora 30
  ```

* 解压配置
  
  ```bash
  mkdir R-latest && tar -xzf ./R-latest.tar.gz -C ./R-latest && cd R-3.5.2
  
  ./configure --enable-R-shlib --enable-byte-compiled-packages \
    --enable-BLAS-shlib --enable-memory-profiling
  ```
  ```markdown
  R is now configured for x86_64-pc-linux-gnu
  
    Source directory:          .
    Installation directory:    /usr/local
  
    C compiler:                gcc -std=gnu99  -g -O2
    Fortran 77 compiler:       gfortran  -g -O2
  
    Default C++ compiler:      g++   -g -O2
    C++98 compiler:            g++ -std=gnu++98 -g -O2
    C++11 compiler:            g++ -std=gnu++11 -g -O2
    C++14 compiler:
    C++17 compiler:
    Fortran 90/95 compiler:    gfortran -g -O2
    Obj-C compiler:            gcc -g -O2 -fobjc-exceptions
  
    Interfaces supported:      X11, tcltk
    External libraries:        readline, curl
    Additional capabilities:   PNG, JPEG, TIFF, NLS, cairo, ICU
    Options enabled:           shared R library, shared BLAS, R profiling, memory profiling
  
    Capabilities skipped:
    Options not enabled:
  
    Recommended packages:      yes
  ```

* 编译安装

  ```bash
  make -j 2 all
  sudo make install
  ```

* BLAS 加持（可选）

  BLAS 对于加快矩阵计算至关重要，编译 R 带 [BLAS 支持][BLAS]，添加 OpenBLAS 支持 `--with-blas="-lopenblas"` 或 ATLAS 支持 `--with-blas="-L/usr/lib64/atlas -lsatlas"` 

  ```bash
  sudo yum install -y openblas openblas-threads openblas-openmp 
  
  ./configure --enable-R-shlib --enable-byte-compiled-packages \
    --enable-BLAS-shlib --enable-memory-profiling \
    --with-blas="-lopenblas"
  ```
  ```markdown
  R is now configured for x86_64-pc-linux-gnu

  Source directory:          .
  Installation directory:    /usr/local

  C compiler:                gcc -std=gnu99  -g -O2
  Fortran 77 compiler:       gfortran  -g -O2

  Default C++ compiler:      g++   -g -O2
  C++98 compiler:            g++ -std=gnu++98 -g -O2
  C++11 compiler:            g++ -std=gnu++11 -g -O2
  C++14 compiler:
  C++17 compiler:
  Fortran 90/95 compiler:    gfortran -g -O2
  Obj-C compiler:            gcc -g -O2 -fobjc-exceptions

  Interfaces supported:      X11, tcltk
  External libraries:        readline, **BLAS(OpenBLAS)**, curl
  Additional capabilities:   PNG, JPEG, TIFF, NLS, cairo, ICU
  Options enabled:           shared R library, shared BLAS, R profiling, memory profiling

  Capabilities skipped:
  Options not enabled:

  Recommended packages:      yes
  ```

  配置成功的标志，如 OpenBLAS
  
  ```
  checking for dgemm_ in -lopenblas... yes
  checking whether double complex BLAS can be used... yes
  checking whether the BLAS is complete... yes
  ```

  ATLAS 加持

  ```bash
  sudo yum install -y atlas
  ./configure --enable-R-shlib --enable-byte-compiled-packages \
    --enable-BLAS-shlib --enable-memory-profiling \
    --with-blas="-L/usr/lib64/atlas -lsatlas"
  ```
  ```markdown
  R is now configured for x86_64-pc-linux-gnu

  Source directory:          .
  Installation directory:    /usr/local

  C compiler:                gcc -std=gnu99  -g -O2
  Fortran 77 compiler:       gfortran  -g -O2

  Default C++ compiler:      g++   -g -O2
  C++98 compiler:            g++ -std=gnu++98 -g -O2
  C++11 compiler:            g++ -std=gnu++11 -g -O2
  C++14 compiler:
  C++17 compiler:
  Fortran 90/95 compiler:    gfortran -g -O2
  Obj-C compiler:            gcc -g -O2 -fobjc-exceptions

  Interfaces supported:      X11, tcltk
  External libraries:        readline, **BLAS(generic)**, curl
  Additional capabilities:   PNG, JPEG, TIFF, NLS, cairo, ICU
  Options enabled:           shared R library, shared BLAS, R profiling, memory profiling

  Capabilities skipped:
  Options not enabled:

  Recommended packages:      yes
  ```
  
  ATLAS 配置成功

  ```
  checking for dgemm_ in -L/usr/lib64/atlas -lsatlas... yes
  checking whether double complex BLAS can be used... yes
  checking whether the BLAS is complete... yes
  ```

后续步骤同上

[BLAS]: https://cran.r-project.org/doc/manuals/r-release/R-admin.html#BLAS

## 忍者安装 {#ninja-install}

从源码自定义安装：加速 Intel MKL 和 大文件支持

https://software.intel.com/en-us/articles/using-intel-mkl-with-r


## 配置 {#settings}

### 初始会话 `.Rprofile` {#init-session}

`.Rprofile` 文件位于 `~/` 目录下或者 R 项目的根目录下

查看帮助 `?.Rprofile`

更多配置设置 [startup](https://github.com/HenrikBengtsson/startup)

### 环境变量 `.Renviron` {#environ-vars}

`.Renviron` 文件位于 `~/` 目录下

### 编译选项 `Makevars` {#make-vars}

`Makevars` 文件位于 `~/.R/` 目录下

## 命令行参数 {#command-line-arguments}

`commandArgs` 从终端命令行中传递参数

- [rdoc](https://github.com/mdequeljoe/rdoc) 高亮 R 帮助文档中的 R 函数、关键字 `NULL`。启用需要在R控制台中执行 `rdoc::use_rdoc()`
- [radian](https://github.com/randy3k/radian) 代码自动补全和语法高亮，进入 R 控制台，终端中输入`radian`
- [docopt](https://github.com/docopt/docopt.R) 提供R命令行工具，如 [littler](https://github.com/eddelbuettel/littler) 包，[getopt](https://github.com/trevorld/r-getopt) 从终端命令行接受参数
- [optparse](https://github.com/trevorld/r-optparse) 命令行选项参数的解析器

安装完 R-littler R-littler-examples (centos) 或 littler r-cran-littler (ubuntu) 后，执行

```bash
# centos
sudo ln -s /usr/lib64/R/library/littler/examples/install.r /usr/bin/install.r 
sudo ln -s /usr/lib64/R/library/littler/examples/install2.r /usr/bin/install2.r
sudo ln -s /usr/lib64/R/library/littler/examples/installGithub.r /usr/bin/installGithub.r 
sudo ln -s /usr/lib64/R/library/littler/examples/testInstalled.r /usr/bin/testInstalled.r
# ubuntu
sudo ln -s /usr/lib/R/site-library/littler/examples/install.r /usr/bin/install.r 
sudo ln -s /usr/lib/R/site-library/littler/examples/install2.r /usr/bin/install2.r
sudo ln -s /usr/lib/R/site-library/littler/examples/installGithub.r /usr/bin/installGithub.r 
sudo ln -s /usr/lib/R/site-library/littler/examples/testInstalled.r /usr/bin/testInstalled.r
```

这样可以载终端中安装 R 包了

```r
install.r docopt
```

```
#!/usr/bin/env Rscript
# 安装 optparse 提供更加灵活的传参方式
# 也可参考 littler https://github.com/eddelbuettel/littler
# if("optparse" %in% .packages(TRUE)) install.packages('optparse',repos = "https://cran.rstudio.com")
# https://cran.r-project.org/doc/manuals/R-intro.html#Invoking-R-from-the-command-line
# http://www.cureffi.org/2014/01/15/running-r-batch-mode-linux/
args = commandArgs(trailingOnly=TRUE)

# 函数功能：在浏览器中同时打开多个 PDF 文档
open_pdf <- function(pdf_path = "./figures/", n = 1) {
  # pdf_path:     PDF文件所在目录
  # n:            默认打开1个PDF文档
  # PDF文档目录
  pdfs <- list.files(pdf_path, pattern = '\\.pdf$')
  # PDF 文档路径
  path_to_pdfs <- paste(pdf_path, pdfs, sep = .Platform$file.sep)
  # 打开 PDF 文档
  invisible(lapply(head(path_to_pdfs, n), browseURL))
}

open_pdf(pdf_path, n = args[1])

# 使用： Rscript --vanilla code/batch-open-pdf.R 20
```
