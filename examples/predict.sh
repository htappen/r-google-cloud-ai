mname=$(date +%s)
gcp_project=$(gcloud config get-value project)
model_bucket="gs://`gcloud config get-value project`"

model_bucket="gs://ht-cmle-training"

model_pkg="$model_bucket/r/model_example.tar.gz"

tar -czvf model_example.tar.gz prediction/
gsutil cp model_example.tar.gz $model_pkg