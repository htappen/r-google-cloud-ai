jname=$(date +%s)
gcp_project=$(gcloud config get-value project)
job_bucket="gs://`gcloud config get-value project`"

train_pkg="$job_bucket/r/train_example.tar.gz"

tar -czvf train_example.tar.gz training/
gsutil cp train_example.tar.gz $train_pkg

echo "
workerPoolSpecs:
  - machineSpec:
      machineType: n1-standard-4
      containerSpec:
        imageUri: gcr.io/`gcloud config get-value project`/r-google-cloud-ai:latest
        args:
          - train
          - $train_pkg
          - training::main
baseOutputDirectory:
  outputUriPrefix: $job_bucket/r_train/$jname
" > "/tmp/train.yaml"

#gcloud beta ai custom-jobs create training r_$jname \
#    --region us-central1 \
#    --config=/tmp/train.yaml