FROM gcr.io/deeplearning-platform-release/r-cpu

# Install the bootstrap script for loading packages
RUN Rscript \
    -e 'install.packages("stringr")'

COPY train_bootstrap.R /root/train_bootstrap.R
WORKDIR /root/

ENTRYPOINT [ "Rscript", "train_bootstrap.R"]
CMD [ "Rscript", "train_bootstrap.R"]