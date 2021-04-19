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
    all.args <- commandArgs(trailingOnly=TRUE)
    container.mode <- tolower(all.args[1])
    package.list <- strsplit(all.args[2], ',')
    args.len <- length(all.args)
    leftovers <- NA
    if (container.mode == "predict") {
        init.fn.name <- all.args[3]
        run.fn.name <- all.args[4]
        if (args.len >= 5) {
            leftovers <- all.args[5:length(all.args)]
        }
    } else {
        init.fn.name <- NA
        run.fn.name <- all.args[3]
        if (args.len >= 4) {
            leftovers <- all.args[4:length(all.args)]
        }
    }
    list(
        container_mode=container.mode,
        package_list=package.list, 
        init_fn_name=init.fn.name,
        run_fn_name=run.fn.name,
        leftovers=leftovers
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
        pr_run(
            host = "0.0.0.0",
            port = 8080
        )
}

launch_training <- function(run_fn_name, args) {
    call_namespace_fn(run_fn_name, args)
}

main <- function() {
    args <- parse_bootstrap_args()
    print(paste('Got args: ', args))
    print('Starting package installation')
    sapply(args$package_list, FUN=install_user_package)
    if (args$container_mode == "predict") {
        print("Starting prediction server")
        launch_plumber(args$init_fn_name, args$leftovers, args$run_fn_name)
    } else {
        print("Starting training script")
        launch_training(args$run_fn_name, args$leftovers)
    }
}

main()
