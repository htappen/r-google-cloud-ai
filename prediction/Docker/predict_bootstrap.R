library('stringr')
library('plumber')

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
    # TODO: replace with env variables
    all.args <- commandArgs(trailingOnly=TRUE)
    list(
        package=all.args[1], 
        init_fn_name=all.args[2],
        run_fn_name=all.args[3],
        leftovers=all.args[4:length(all.args)]
    )
}

install_user_package <- function(gcs_uri) {
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

launch_plumber <- function(init_fn_name, init_params, run_fn_name) {
    context <- call_namespace_fn(init_fn_name, init_params)

    pr() %>%
        pr_get('/health', function() "Healthy") %>%
        pr_post('/predict', function(req, res) {
            instances <- data.frame(req$body$instances)
            predictions <- call_namespace_fn(
                run_fn_name,
                list(
                    instances,
                    context
                )
            )
            list(predictions=predictions)
        }) %>%
        pr_run(port = 8080) # TODO: control with env variable
}

main <- function() {
    args <- parse_bootstrap_args()
    install_user_package(args$package)
    call_namespace_fn(args$fn_name, args$leftovers)
}

main()

