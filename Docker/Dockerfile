FROM gcr.io/deeplearning-platform-release/r-cpu

# Install nginx to be a reverse proxy
RUN \
  apt-get update && \
  apt install -y curl gnupg2 ca-certificates lsb-release && \
  echo "deb http://openresty.org/package/ubuntu $(lsb_release -sc) main" \
    | tee /etc/apt/sources.list.d/openresty.list && \
  curl -fsSL https://openresty.org/package/pubkey.gpg | apt-key add - && \
  apt-get update && \
  apt-get install -y --no-install-recommends openresty
ENV PATH "/usr/local/openresty/nginx/sbin:${PATH}"
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
ENV USER jupyter
ENV DISABLE_AUTH true
# Add dependencies for the bootstrap files
RUN Rscript \
    -e 'install.packages(c("stringr", "plumber"))'

# Set up container boot
COPY startup.sh /root/startup.sh
COPY bootstrap.R /root/bootstrap.R

# Configure nginx as a proxy
COPY cache_cookies.lua /usr/local/openresty/nginx/
COPY add_cookies.lua /usr/local/openresty/nginx/
COPY nginx.conf /etc/nginx/nginx.conf

# Add rwx permissions to nginx configs
RUN chmod -R 777 /usr/local/openresty

WORKDIR /root
ENTRYPOINT ["/bin/bash", "/root/startup.sh"]
CMD ["/bin/bash", "/root/startup.sh"]