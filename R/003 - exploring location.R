library(glitter) # SPARQL query
library(dplyr)


# the real thing ... https://lvaudor.github.io/glitter/articles/explore.html
query_basis = spq_init(
#   endpoint = "https://data.cimple.eu/sparql"
)

# cokoliv (bez rozdílu typu) co zmiňuje pivo podle datumu sestupně
query <- query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/",
                           "geo" = "http://www.opengis.net/ont/geosparql")) %>% 
   spq_add("?what geo:hasGeometry ?loc") %>% 
   spq_head(5)


sequins::plot_query(query) 
spq_perform(query)