get_config <- function(args) {
    parser <- optparse::OptionParser()
    parser <- optparse::add_option(
        parser,
        "--job-dir",
        type="character",
        help="Location to write output files")
    optparse::parse_args(parser, args=args)
}

upload_model <- function(model, file.name, dest) {
    temp.path <- paste('/tmp', file.name, sep='/')
    gcs.path <- paste(dest, file.name, sep='/')
    cmd <- paste(
      "gsutil cp",
      temp.path,
      gcs.path
    )
    save(model, file=temp.path)
    system(cmd)
}

train_model <- function() {
    lm(mpg ~ wt, mtcars)
}

main <- function(args) {
    cfg <- get_config(args)
    model <- train_model()
    upload_model(model, 'model.Rda', cfg$job_dir)
}