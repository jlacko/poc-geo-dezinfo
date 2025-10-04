library(glitter) # SPARQL query
library(dplyr)

# wikipedia = Hello World!
query <- spq_init() %>%
   spq_add("?film wdt:P31 wd:Q11424") %>%
   spq_label(film) %>%
   spq_add("?film wdt:P577 ?date") %>%
   spq_mutate(date = year(date)) %>%
   spq_head(10)

query

spq_perform(query)

# the real thing ... https://lvaudor.github.io/glitter/articles/explore.html
query_basis = spq_init(
   endpoint = "https://data.cimple.eu/sparql"
)

# seje to?
query_basis %>% 
   spq_add("?s ?p ?o") %>%
   spq_head(n = 10) %>%
   spq_perform()

# počet instancí přes classy
query_basis %>%
   spq_add("?instance a ?class") %>%
   spq_select(class, .spq_duplicate = "distinct")  %>%
   spq_count(class, sort = TRUE) %>%
   spq_head(20) %>%
   spq_perform() 

# claimy o pivu
query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s rdf:type schema:SocialMediaPosting ") %>%
   spq_add("?s schema:mentions dbr:Beer") %>% 
   spq_head(10) %>% 
   spq_perform()

# cokoliv (bez rozdílu typu) co zmiňuje pivo podle datumu sestupně
query <- query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Beer") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_head(100) 

sequins::plot_query(query) 
spq_perform(query)


# dny se zmínkou o pivu (kdekoliv) sestupně podle počtu zmínek
query <- query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/")) %>% 
   spq_add("?s schema:mentions dbr:Beer") %>% 
   spq_add("?s schema:text ?text") %>% 
   spq_add("?s schema:datePublished ?date") %>% 
   spq_group_by(date) %>% 
   spq_summarise(n = n()) %>% 
   spq_arrange(desc(n)) 

sequins::plot_query(query) 
spq_perform(query)