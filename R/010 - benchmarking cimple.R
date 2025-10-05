library(glitter) # SPARQL query
library(dplyr)

vystup <- "./output/benchmark_cimple.txt"



# the real thing ... https://lvaudor.github.io/glitter/articles/explore.html
query_basis = spq_init(
   endpoint = "https://data.cimple.eu/sparql"
)

cat("Basic basic - beer 10\n", file = vystup)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s rdf:type schema:ClaimReview") %>%
   spq_add("?s schema:mentions dbr:Beer") %>% 
   spq_head(10) %>% 
   spq_perform()

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nBasic advanced - Climate_change 10\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s rdf:type schema:ClaimReview") %>%
   spq_add("?s schema:mentions dbr:Climate_change") %>% 
   spq_head(10) %>% 
   spq_perform()
cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nCount - beer\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Beer") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_summarise(n = n()) %>% 
   spq_perform() -> nbeer

cat(paste("count of mentions:", nbeer$n, "\n"), file = vystup, append = T)
cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nCount - climate\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Climate_change") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_summarise(n = n()) %>% 
   spq_perform() -> nclima

cat(paste("count of mentions:", nclima$n, "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nCount - Ukraine\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Ukraine") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_summarise(n = n()) %>% 
   spq_perform() -> nukr

cat(paste("count of mentions:", nukr$n, "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nCount - Trump\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Donald_Trump") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_summarise(n = n()) %>% 
   spq_perform() -> ntr

cat(paste("count of mentions:", ntr$n, "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nCount - period\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_summarise(n = n()) %>% 
   spq_perform() -> ntr

cat(paste("count of mentions:", ntr$n, "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)


cat("\nFull load - beer\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Beer") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_perform() -> beer

cat(paste("count of mentions:", nrow(beer), "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nFull load - climate\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Climate_change") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_perform() -> clima

cat(paste("count of mentions:", nrow(clima), "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nFull load - Ukraine\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Ukraine") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_perform() -> ukr

cat(paste("count of mentions:", nrow(ukr), "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nFull load - Trump\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Donald_Trump") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_perform() -> dtr

cat(paste("count of mentions:", nrow(dtr), "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)

cat("\nFull load - period\n", file = vystup, append = T)
cat(paste(Sys.time(), "start\n"), file = vystup, append = T)

query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_perform() -> everything

cat(paste("count of mentions:", nrow(everything), "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\n"), file = vystup, append = T)
