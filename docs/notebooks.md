# RStudio in Cloud AI Platform Notebooks

Google Cloud AI Notebooks present an easy way to get a Notebook instance running in the cloud. The Notebooks come pre-installed with JupyterLab hooked up to R. You might prefer using RStudio, though.

This repo shows you how to create a [custom container](https://cloud.google.com/ai-platform/notebooks/docs/custom-container) for use on the service.

## How it works
Google Cloud AI Notebooks set up an inverting proxy that connects your web browser to the notebook instance running in the Cloud. This inverting proxy expects your instance to have a container running JupyterLab listening for requests on 8080, and responding always to a healthcheck on :8080/api/. Additionally, the inverting proxy disallows cookies or custom headers being sent to or from your container.

In order to get RStudio to comply with these requirements, we add an NGINX reverse proxy in front of it. When the container starts, a Python script adds some configuration to NGINX that makes it always respond to the health checks and send the required cookies to RStudio.

## Instructions
1. Build the Docker image from the "Docker" directory. Push it to [Google Container Registry](https://cloud.google.com/container-registry). The easiest way to do this is with this command
```bash
gcloud builds submit . -t gcr.io/<YOUR PROJECT>/<YOUR CONTAINER NAME>:latest
```

*Note*: you only need to do this once for ALL of notebooks/training/prediction! Every function from here on out will use the same Docker image.

1. Start a new Notebook instance. Make sure to choose a [custom container](https://cloud.google.com/ai-platform/notebooks/docs/custom-container). Pass in the gcr.io address you created earlier.

## Customization
You can swap out the base image or add extra dependencies if you'd like. Just make sure you still have NGINX and Python 3.x installed.

## Caveats
- This only supports single-tenancy (one user per Notebook instance), and uses Google Cloud's IAM for security. Make sure your network and IAM are set up securely!