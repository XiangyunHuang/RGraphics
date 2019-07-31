FROM debian:buster

LABEL org.label-schema.license="GPL-2.0" \
      org.label-schema.vcs-url="https://github.com/XiangyunHuang/RGraphics" \
      org.label-schema.vendor="RGraphics Project" \
      maintainer="Xiangyun Huang <xiangyunfaith@outlook.com>"

ARG PANDOC_VERSION=2.7.3

ENV TERM=xterm \
    DEBIAN_FRONTEND=noninteractive \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn

RUN useradd docker \
  && mkdir /home/docker \
  && chown docker:docker /home/docker \
  && addgroup docker staff \
  && mkdir /home/docker/workspace \
  && apt-get update \
  && apt-get install -yq --no-install-recommends apt-utils \
  && apt-get install -y --no-install-recommends \
    wget \
    gnupg \
    dialog \
    locales \
    ca-certificates \
  ## Configure default locale, see https://github.com/rocker-org/rocker/issues/19
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure locales \
  && update-locale LANG=en_US.UTF-8 \
  ## Install r-base-dev
  && apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' \
  && echo "deb https://cloud.r-project.org/bin/linux/debian buster-cran35/" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    r-base-dev \
  && echo "LANG=en_US.UTF-8" >> /usr/lib/R/etc/Renviron.site \
  ## Add a default CRAN mirror
  && echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/lib/R/etc/Rprofile.site \
  ## Add a library directory (for user-installed packages)
  && mkdir -p /usr/local/lib/R/site-library \
  && chown root:staff /usr/local/lib/R/site-library \
  && chmod g+wx /usr/local/lib/R/site-library \
  ## Use littler installation scripts
  && Rscript -e "install.packages(c('littler','codetools', 'remotes'))" \
  && ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
  && ln -s /usr/local/lib/R/site-library/littler/examples/install.r /usr/local/bin/install.r \
  && ln -s /usr/local/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
  && ln -s /usr/local/lib/R/site-library/littler/bin/r /usr/local/bin/r \
  && install.r docopt \
  && mkdir ~/.R \
  && echo "CXXFLAGS += -Wno-ignored-attributes" >> ~/.R/Makevars \
  && echo "CXX14 = g++" >> ~/.R/Makevars \
  && echo "CXX14FLAGS = -fPIC -flto=2 -mtune=native -march=native" >> ~/.R/Makevars \
  && echo "CXX14FLAGS += -Wno-unused-variable -Wno-unused-function -Wno-unused-local-typedefs" >> ~/.R/Makevars \
  && echo "CXX14FLAGS += -Wno-ignored-attributes -Wno-deprecated-declarations -Wno-attributes -O3" >> ~/.R/Makevars \
  && apt-get install -y --no-install-recommends \
## install nloptr
  libnlopt-dev \
## install rjags runjags
  jags \  
## install Cairo plotly
  libcairo2-dev \
## install xml2 igraph
  libxml2-dev \
  libgmp-dev \
  libglpk-dev \
## install openssl
  libssl-dev \
## install curl
  libcurl4-openssl-dev \
## install git2r
  libgit2-dev \
## install v8
  libnode-dev \
## install DBI odbc 
  unixodbc-dev \
  odbc-postgresql \
  libsqliteodbc \
## install webshot
  phantomjs \
  optipng \
  imagemagick \
  ghostscript \
## ebook-convert
  calibre \
## install magick
  libmagick++-dev \
## install sf
  libudunits2-dev \
  libproj-dev \
  libgeos-dev \
  libgdal-dev \
## rgl  
  libcgal-dev \ 
  libglu1-mesa-dev \ 
  libx11-dev \
  tk-dev \
  tcl-dev \
  libxpm-dev \
  libxaw7-dev \
  graphviz \
  file \  
  && install2.r --error \
  bookdown \
  ggplot2 \
  cowplot \
  igraph \
  ggforce \
  ggraph \
  ggbeeswarm \
  ggExtra \
  ggfortify \
  ggridges \
  ggthemes \
  ggwordcloud \
  plotrix \
  plot3D \
  plotly \
  scatterplot3d \
  magick \
  odbc \
  extrafont \
  fontcm \
  showtext \
## install spatial packages
  sp \
  maps \
  mapdata \
  mapproj \
  maptools \
  gstat \
  spatialreg \
  spdep \
  sf \
  stars \
  raster \
  satellite \
  leaflet \
  cartography \
  mapview \
  tmap \
## install modeling packages
  tidyverse \
##  glmnet \
##  caret \
##  xgboost \
##  prophet \
##  brms \
##  BANOVA \
##  rms \
##  car \
##  mlr3 \
##  tidymodels \
## install other packages
  openxlsx \
  microbenchmark \
  pracma \
## spatial modeling
##  BiocManager \
##  && Rscript -e "BiocManager::install(c('Rgraphviz','graph'), update = FALSE, ask = FALSE)" \
##  && install2.r --error --repos https://inla.r-inla-download.org/R/testing/ --deps TRUE \
##    INLA \
##  && install2.r --error inlabru \
  && install2.r --error --repos https://nowosad.github.io/drat/ \
    spDataLarge
  

## Install adobe fonts
RUN mkdir -p /usr/share/fonts/opentype/adobe ~/.fonts \
  && path_prefix="/usr/share/fonts/opentype/adobe" \
  && url_prefix="https://cs.fit.edu/code/projects/ndworld/repository/revisions/11/raw/Resources/Fonts" \
  && wget -q --no-check-certificate $url_prefix/AdobeFangsongStd-Regular.otf -P $path_prefix \
  && wget -q --no-check-certificate $url_prefix/AdobeHeitiStd-Regular.otf -P $path_prefix \
  && wget -q --no-check-certificate $url_prefix/AdobeKaitiStd-Regular.otf -P $path_prefix \
  && wget -q --no-check-certificate $url_prefix/AdobeSongStd-Light.otf -P $path_prefix \
  && fc-cache -fsv \
## Install System fonts for R Graphics  
  && wget -q --no-check-certificate http://simonsoftware.se/other/xkcd.ttf -P ~/.fonts/ \
  && Rscript -e "extrafont::font_import(paths = '~/.fonts', pattern = '[X/x]kcd', prompt = FALSE)" \
  && Rscript -e "extrafont::font_import(prompt = FALSE)" \
  && Rscript -e "extrafont::font_install('fontcm', prompt = FALSE)" \
  && Rscript -e "library(showtext);font_install(source_han_serif());font_install(source_han_sans())" \
## Install pandoc
  && mkdir -p /opt/pandoc \
  && url_prefix="https://github.com/jgm/pandoc/releases/download" \
  && wget -q --no-check-certificate $url_prefix/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux.tar.gz -P /opt/pandoc/ \
  && tar -xzf /opt/pandoc/pandoc-${PANDOC_VERSION}-linux.tar.gz -C /opt/pandoc \
  && ln -s /opt/pandoc/pandoc-${PANDOC_VERSION}/bin/pandoc /usr/local/bin \
  && ln -s /opt/pandoc/pandoc-${PANDOC_VERSION}/bin/pandoc-citeproc /usr/local/bin \
  && rm /opt/pandoc/pandoc-${PANDOC_VERSION}-linux.tar.gz \
## Install TinyTeX
  && wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh -s - --admin --no-path && \
    mv ~/.TinyTeX /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr path add && \
    tlmgr install ctex xecjk courier courier-scaled tocbibind subfig savesym \
      colortbl dvipng dvisvgm environ fancyhdr jknapltx listings \
      makecell mathdesign metalogo microtype ms multirow parskip pdfcrop \
      pgf placeins preview psnfss realscripts relsize rsfs setspace soul \
      standalone subfig symbol tabu tex4ht threeparttable threeparttablex \
      titlesec tocbibind tocloft trimspaces ulem varwidth wrapfig xcolor xltxtra zhnumber \
  && apt-get clean all \
  && rm -rf /var/lib/apt/lists/*

ENV LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

EXPOSE 8787 8080 8181 8282

WORKDIR /home/docker/workspace
