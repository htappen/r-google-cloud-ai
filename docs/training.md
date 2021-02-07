# Training an R model on Cloud AI Platform
Cloud AI Platform Training gives a serverless way to train a model across any range of hardware.

This section shows a workflow for using R within that platform.

## How it works
This repo contains a base Docker image that can be used for every training run. Users will simply put their training procedure into an R package and upload it to GCS. When they run a training job, the Docker container will automatically pick up the package, install it (and dependencies), then run their script.

## Instructions
1. Build the Docker image from the "Docker" directory. Push it to [Google Container Registry](https://cloud.google.com/container-registry). The easiest way to do this is with this command
```bash
gcloud builds submit . -t gcr.io/<YOUR PROJECT>/<YOUR CONTAINER NAME>:latest
```

*Note*: you only need to do this once! Every training from here on out will use the same Docker image.

1. Package your training application as a proper R package. Make sure to `export` a function that runs the actual training procedure.

1. Upload your package to Google Cloud Storage. Make sure that the Cloud AI Platform service account has access to it.

1. Start a training job, specifying the container you created earlier. In the "args" section of the job, set the first two arguments to the list following. Add any other necessary arguments after
    1. The path to your package
    1. The fully namespaced name of the function that runs your script (i.e. `<YOUR PACKAGE NAME>::<YOUR FUNCTION NAME>`)