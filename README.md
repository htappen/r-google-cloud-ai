# R on Google Cloud AI Platform
Google Cloud AI Platform offers a flexible set of tools for all steps along the machine learning journey. Although Cloud AI Platform most prominently supports Python-based workflows, it's really possible to use any language thanks to the platform's use of Docker.

This repo offers code and tutorials for how to use R with AI Platform.

## Components
- [Notebooks:](notebooks/) how to use RStudio + R in a managed notebook instance
- [Training:](training/) how to specify R code to run in batch training job
- Prediction: how to serve a model created in R

## Advice on using Cloud APIs
Although there are some R packages for interacting with Google Cloud APIs, you'll find the best luck using `gcloud` in your code (through `system`). To call APIs not available from `gcloud`, you can build the respective discovery client using (googleAuthR)[https://cran.r-project.org/web/packages/googleAuthR/vignettes/building.html]