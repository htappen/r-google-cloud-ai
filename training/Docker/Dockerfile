FROM rocker/r-ver:latest

RUN Rscript \
    -e 'install.packages(c("googleCloudStorageR", "stringr"))'

COPY bootstrap.R /root/bootstrap.R
WORKDIR /root/

ENTRYPOINT [ "Rscript", "bootstrap.R" ]