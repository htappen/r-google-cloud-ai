FROM gcr.io/deeplearning-platform-release/r-cpu

# Install the bootstrap script for loading packages
RUN Rscript \
    -e 'install.packages(c("stringr", "plumber", "jsonlite"))'

COPY predict_bootstrap.R /root/predict_bootstrap.R
WORKDIR /root/

ENTRYPOINT [ "Rscript", "predict_bootstrap.R"]
CMD [ "Rscript", "predict_bootstrap.R"]