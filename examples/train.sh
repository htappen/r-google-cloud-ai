jname=$(date +%s)
gcp_project=$(gcloud config get-value project)
job_bucket="gs://`gcloud config get-value project`"


job_bucket="gs://ht-cmle-training"

train_pkg="$job_bucket/r/example.tar.gz"

tar -czvf example.tar.gz package/
gsutil cp example.tar.gz $train_pkg

gcloud ai-platform jobs submit training r_$jname \
    --region us-central1 \
    --scale-tier custom \
    --job-dir=$job_bucket/r_train/$jname \
    --master-image-uri=gcr.io/`gcloud config get-value project`/r_train:latest \
    --master-machine-type n1-standard-4 \
    -- \
    "$train_pkg" \
    "training::main"