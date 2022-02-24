# Login to Motus repository
motus_login <- function() {
  tryCatch({
    motus:::sessionVariable('userLogin', val = Sys.getenv('user'))
    motus:::sessionVariable('userPassword', val = Sys.getenv('pass'))
    message("Motus Login successful")
  }, error = function(e) {
    stop("Motus Login failed '", e$message, "'", call. = F)
  })
}

# Install packages if necessary
ipak <- function(pkg){
  new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
  if (length(new.pkg)) 
    install.packages(new.pkg, dependencies = TRUE)
  sapply(pkg, require, character.only = TRUE)
}

# Retrieve Max hitID
get_max_hitID <- function() {
  sql.motus <- tagme(projRecv = proj.num, new = FALSE, update = FALSE)
  tbl.alltags <- tbl(sql.motus, "alltags") # virtual table
  
  return_value <- tbl.alltags %>%
    select(hitID) %>%
    arrange(desc(hitID)) %>%
    head(n=1) %>%
    as.data.frame()
  
  return_me <- return_value[1, 'hitID']
  return(return_me)
}

# Update local Motus SQlite database
update_db <- function(max_value) {
  sql.motus <- tagme(proj.num, new=F, update=T, forceMeta =T, skipNodes = TRUE)
  tbl.alltags <- tbl(sql.motus, "alltags") # virtual table
  
  df_return <- tbl.alltags %>% 
    filter(hitID > max_value) %>%
    collect() %>%
    mutate(ts = as_datetime(ts, tz = "UTC", origin = "1970-01-01")) %>%
    as.data.frame()  
  
  return(df_return)
}

# Authenticate BigQuery with service key 
bigquery_authenticate <- function() {
  gcp_key = Sys.getenv("key")
  bq_auth(path = gcp_key)
  message("BigQuery Authenticated")
}