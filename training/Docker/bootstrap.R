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
        package=all.args[1], 
        fn_name=all.args[2],
        leftovers=all.args[3:length(all.args)]
    )
}

install_train_package <- function(gcs_uri) {
    file.name <- str_replace(
        gcs_uri,
        paste(dirname(gcs_uri), '/', sep=''),
        '')

    cmd <- paste(
      "gsutil cp",
      gcs_uri,
      file.name
    )
    
    system(cmd)

    devtools::install_local(file.name, dependencies=TRUE)
}

main <- function() {
    args <- parse_bootstrap_args()
    install_train_package(args$package)
    call_namespace_fn(args$fn_name, args$leftovers)
}

main()

