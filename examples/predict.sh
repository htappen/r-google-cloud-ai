mname=$(date +%s)
gcp_project=$(gcloud config get-value project)
model_bucket="gs://`gcloud config get-value project`"

model_pkg="$model_bucket/r/model_example.tar.gz"

tar -czvf model_example.tar.gz prediction/
gsutil cp model_example.tar.gz $model_pkg

#curl -X POST -H "Content-Type: application/json" -d '{ "instances": [{ "wt": 10}]}' http://127.0.0.1:8787/predict
#docker run -it --rm -p 8787:8080 r-ssh "predict" "<pkg>" "prediction::init" "prediction::predict" "<mdl>"
