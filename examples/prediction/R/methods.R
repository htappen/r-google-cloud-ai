init <- function(args) {
    # TODO: error if NULL
    download_model(args[1])
}

predict <- function(instances, context) {
    # Note: model is expected to be loaded in global context
    predict.lm(model, instances)
}

download_model <- function(gcs_path) {
    # TODO: error if NULL
    out.path <- '/root/model.Rda'
    cmd <- paste(
      "gsutil cp",
      gcs_path,
      out.path
    )
    system(cmd)
    load(out.path, envir=globalenv())
}
