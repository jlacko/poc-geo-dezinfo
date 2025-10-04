library(glitter) # SPARQL query
library(dplyr)


# the real thing ... https://lvaudor.github.io/glitter/articles/explore.html
query_basis = spq_init(
   endpoint = "https://data.cimple.eu/sparql"
)

# počet instancí přes classy
query_basis %>%
   spq_add("?instance a ?class") %>%
   spq_select(class, .spq_duplicate = "distinct")  %>%
   spq_count(class, sort = TRUE) %>%
   spq_head(20) %>%
   spq_perform()


# počet claim reviews přes organizaci (= autora)
query <- query_basis %>%
   spq_add("?subject rdf:type schema:ClaimReview ") %>%
   spq_add("?subject schema:author ?reviewer") %>% 
   spq_add("?reviewer schema:name ?org") %>% 
   spq_select(org, .spq_duplicate = "distinct")  %>%
   spq_count(org, sort = TRUE) 
   
sequins::plot_query(query) 
spq_perform(query)
