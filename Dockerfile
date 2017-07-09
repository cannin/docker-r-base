FROM ubuntu:14.04.4
MAINTAINER cannin

##### UBUNTU
# Update Ubuntu and add extra repositories
RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN apt-get -y install apt-transport-https

RUN echo 'deb https://cran.rstudio.com/bin/linux/ubuntu trusty/' >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
RUN add-apt-repository -y ppa:openjdk-r/ppa

RUN apt-get -y update && apt-get -y upgrade

# Install basic commands
RUN apt-get -y install links nano htop git wget

# Install software needed for common R libraries
## For RCurl
RUN apt-get -y install libcurl4-openssl-dev
## For rJava
RUN apt-get -y install libpcre++-dev
RUN apt-get -y install openjdk-8-jdk
## For XML
RUN apt-get -y install libxml2-dev
## For pandoc for knitr
RUN apt-get -y install libgmp10
RUN wget https://github.com/jgm/pandoc/releases/download/1.19.2/pandoc-1.19.2-1-amd64.deb
RUN dpkg -i pandoc-1.19.2-1-amd64.deb

# Install R using apt-get
#ENV R_BASE_VERSION 3.3.2-1trusty0

## Necessary for getting a specific R version (get oldest working packages by manual date comparison) and set main repository
#RUN apt-cache policy r-cran-matrix
#RUN apt-get install -y --no-install-recommends \
#  littler \
#  r-cran-littler \
#  r-cran-matrix=1.2-4-1trusty0 \
#  r-cran-codetools=0.2-14-1~ubuntu14.04.1~ppa1 \
#  r-cran-survival=2.38-3-1trusty0 \
#  r-cran-nlme=3.1.123-1trusty0 \
#  r-cran-mgcv=1.8-7-1trusty0 \
#  r-cran-kernsmooth=2.23-15-1trusty0 \
#  r-cran-cluster=2.0.3-1trusty0 \
#  r-base=${R_BASE_VERSION}* \
#  r-base-dev=${R_BASE_VERSION}* \
#  r-recommended=${R_BASE_VERSION}* \
#  r-doc-html=${R_BASE_VERSION}* \
#  r-base-core=${R_BASE_VERSION}* \
#  r-base-html=${R_BASE_VERSION}*

# Install R from source
RUN apt-get -y build-dep r-base
RUN wget http://cran.r-project.org/src/base/R-3/R-3.3.2.tar.gz
RUN tar -xzf R-3.3.2.tar.gz
RUN cd R-3.3.2; ./configure --enable-R-shlib # --prefix=...; make; make install

#RUN echo 'options(repos = c(CRAN = "https://cran.rstudio.com/"), download.file.method = "libcurl")' >> /etc/R/Rprofile.site
#RUN echo 'source("/etc/R/Rprofile.site")' >> /etc/littler.r

##### R: COMMON PACKAGES
# To let R find Java
RUN R CMD javareconf

COPY r-requirements.txt /
COPY installPackages.R /
COPY runInstallPackages.R /
RUN R -e 'source("runInstallPackages.R")'
