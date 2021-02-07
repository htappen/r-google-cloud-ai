init <- function(args) {
    download_model(args$model_path)
}

predict <- function(instances, context) {
    # Note: model is expected to be loaded in global context
    predict.lm(model, instances)
}

download_model <- function(gcs_path) {
    out.path <- paste('/root/model.Rda', file.name, sep='/')
    cmd <- paste(
      "gsutil cp",
      gcs_path,
      out.path
    )
    system(cmd)
    load(out.path, envir=globalenv())
}
