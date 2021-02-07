FROM gcr.io/deeplearning-platform-release/r-cpu

# Install nginx to be a reverse proxy
RUN \
  apt-get update && \
  apt install -y curl gnupg2 ca-certificates lsb-release && \
  echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list && \
  curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - && \
  apt-get update && \
  apt-get install -y nginx

COPY nginx.conf.template /root/nginx.conf.template
COPY make_config.py /root/make_config.py
    
EXPOSE 8080

# Install R Studio into the container
ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=latest
ENV PATH=/usr/lib/rstudio-server/bin:$PATH

RUN git clone https://github.com/rocker-org/rocker-versioned2.git /root/rocker/ && \
    mv /root/rocker/scripts /rocker_scripts && \
    /rocker_scripts/install_rstudio.sh && \
    /rocker_scripts/install_pandoc.sh && \
    rm -rf /rocker_scripts /root/rocker

# Only single tenant RStudio is supported. Use Cloud IAM for auth.
ENV DISABLE_AUTH true

# Add dependencies for the bootstrap files
RUN Rscript \
    -e 'install.packages(c("stringr", "plumber"))'

# Set up container boot
COPY startup.sh /root/startup.sh
COPY bootstrap.R /root/bootstrap.R

WORKDIR /root
ENTRYPOINT ["/bin/bash", "/root/startup.sh"]
CMD ["/bin/bash", "/root/startup.sh"]