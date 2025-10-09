library(glitter) # SPARQL query
library(dplyr)


# the real thing ... https://lvaudor.github.io/glitter/articles/explore.html
query_basis = spq_init(
   endpoint = "https://data.cimple.eu/sparql"
)

# cokoliv (bez rozdílu typu) co zmiňuje pivo podle datumu sestupně
query <- query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/",
                           "dbp" = "http://dbpedia.org/property/")) %>% 
   spq_add("?s schema:mentions dbr:Ukraine") %>% 
   spq_add("?s dbo:lo ?text") %>% 
   spq_add("?s schema:datePublished ?date") 


sequins::plot_query(query) 
spq_perform(query)