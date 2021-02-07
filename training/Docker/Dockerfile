FROM gcr.io/deeplearning-platform-release/r-cpu

# Install the bootstrap script for loading packages
RUN Rscript \
    -e 'install.packages("stringr"))'

COPY bootstrap.R /root/bootstrap.R
WORKDIR /root/

ENTRYPOINT [ "Rscript", "bootstrap.R"]
CMD [ "Rscript", "bootstrap.R"]