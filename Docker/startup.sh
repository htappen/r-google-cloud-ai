if [[ -n "$1" ]] && [[ $1 =~ ^(predict|train)$ ]]; then
    echo "Starting bootstrap script..."
    Rscript /root/bootstrap.R "$@"
else
    echo "'predict' or 'train' command not found. Starting notebook"
    python3 /root/make_config.py
    nginx

    # Ensure new user packages get saved to the VM, not the container
    # This has to be at runtime since it touches the containing folder
    if [ ! -f /home/jupyter/.Rprofile ]; then
        mkdir -p /home/jupyter/R/site-library
        echo ".libPaths('/home/jupyter/R/site-library')" > /home/jupyter/.Rprofile
    fi

    /init
fi

