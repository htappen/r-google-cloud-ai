FROM rocker/r-ver:latest

RUN apt-get update && apt-get install -y \
    curl apt-transport-https ca-certificates gnupg apt-utils \
    && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - \
    && apt-get update -y \
    && apt-get install google-cloud-sdk -y

RUN Rscript \
    -e 'install.packages(c( \
    "devtools", \
    "stringr"))'

COPY bootstrap.R /root/bootstrap.R
WORKDIR /root/

ENTRYPOINT [ "Rscript", "bootstrap.R"]
CMD [ "Rscript", "bootstrap.R"]