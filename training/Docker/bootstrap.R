library('googleCloudStorageR')
library('stringr')

call_namespace_fn <- function(what, args, ...) {
  if(is.character(what)){
    fn <- strsplit(what, "::")[[1]]
    what <- if(length(fn)==1) {
        get(fn[[1]], envir=parent.frame(), mode="function")
    } else {
        get(fn[[2]], envir=asNamespace(fn[[1]]), mode="function")
    }
  }

  do.call(what, as.list(args), ...)
}

parse_bootstrap_args <- function() {
    all.args <- commandArgs(trailingOnly=TRUE)
    list(
        package=all.args[0], 
        fn_name=all.args[1],
        leftovers=all.args[2:length(all.args)]
    )
}

install_train_package <- function(gcs_uri) {
    file.name <- str_replace(
        gcs_uri,
        dirname(gcs_uri),
        '')
    
    gcs_get_object(gcs_uri, saveToDisk = file.name)

    install.packages(file.name, repos=NULL)
}

run_training <- function(fn_name, args) {
    fn <- call_namespace_fn(fn_name)
    fn(args)
}

main <- function() {
    args <- parse_bootstrap_args()
    install_train_package(args$package)
    run_training(args$fn_name, args$leftovers)
}

main()

