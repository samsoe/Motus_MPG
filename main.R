# This is a very important step, and should be part of every working session
Sys.setenv(TZ = "UTC")

# Include addition R scripts
source("basic_update.R")

# Identify packages to use
packages <- c("motus","lubridate","maps","tidyverse","rworldmap","ggmap","DBI", "RSQLite", "rlang", "bigrquery")

# Install/update packages if necessary
ipak(packages)
update.packages(repos = getOption("https://cloud.r-project.org"))

# Set Motus Project Number
proj.num <- 450

# Set Login for Motus data access
motus_login()

# Connect to existing database
file.name <- dbConnect(SQLite(), "project-450.motus")

# Retrive max(hitID) before SQlite database update
hitID_max <- get_max_hitID()

# Update Motus SQlite database
df_update <- update_db(hitID_max)

# Authenticate BigQuery
bigquery_authenticate()

# Define intended BigQuery table
bq_ds <- bq_dataset("motus-mpg", "project_450")
bq_tbl <- bq_table(bq_ds, "alltags_main")

# Push data.frame
bq_table_upload(bq_tbl, df_update, create_disposition='CREATE_IF_NEEDED', write_disposition='WRITE_APPEND')