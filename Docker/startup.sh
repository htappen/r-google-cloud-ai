if [ -z "$1" ] && [ "$1" =~ ^(predict|train)$ ]; then
    echo "Starting bootstrap script..."
    Rscript /root/bootstrap.R "$@"
else
    echo "'predict' or 'train' command not found. Starting notebook"
    python3 /root/make_config.py
    nginx
    /init
fi

