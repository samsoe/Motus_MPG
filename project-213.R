proj.num <- 213

file.name <- dbConnect(SQLite(), "project-213.motus")

sql.motus <- tagme(projRecv = proj.num, new = FALSE, update = TRUE)
