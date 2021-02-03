FROM rocker/rstudio:latest

RUN \
  apt-get update && \
  apt install -y curl gnupg2 ca-certificates lsb-release && \
  echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list && \
  curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - && \
  apt-get update && \
  apt-get install -y nginx

COPY nginx.conf.template /root/nginx.conf.template
COPY startup.sh /root/startup.sh
COPY make_config.py /root/make_config.py
    
EXPOSE 8080
ENV DISABLE_AUTH true

CMD ["/bin/bash", "/root/startup.sh"]