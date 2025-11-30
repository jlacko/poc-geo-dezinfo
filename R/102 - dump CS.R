library(glitter) # SPARQL query
library(dplyr)
library(stringr)
library(sf)

vystup <- "./output/benchmark_cs.txt"

cat(paste(Sys.time(), "start\n"), file = vystup, append = T)
start_time <- Sys.time()

# the real thing ... https://lvaudor.github.io/glitter/articles/explore.html
query_basis = spq_init(
   endpoint = "http://data.climatesense-project.eu/sparql"
)

# compose the query
query <- query_basis %>%
   spq_prefix(prefixes = c("schema" = "http://schema.org/",
                           "dbr" = "http://dbpedia.org/resource/",
                           "geo" = "http://www.w3.org/2003/01/geo/wgs84_pos",
                           "cs" = "http://data.climatesense-project.eu/ontology#",
                           "dbp" = "http://dbpedia.org/property/")) %>% 
#   spq_add("?subject schema:mentions dbr:Aigle") %>% # Nostradamus & his Eagle is mentioned exactly once
   spq_add("?subject rdf:type schema:ClaimReview") %>%
   spq_add("?subject schema:mentions ?mentioned") %>% 
   spq_add("?subject schema:datePublished ?date") %>% 
   spq_add("?subject schema:author ?reviewer") %>% 
   spq_add("?reviewer schema:name ?org") %>% 
   spq_add("?subject schema:itemReviewed ?claim") %>% 
   spq_add("?claim cs:isClimateRelated true") %>% # who cares about climate unrelated claims?
   spq_add("?mentioned geo:geometry ?geo") %>% 
   spq_head(500000) # not an issue for climate related claims only (~200K rows)

sequins::plot_query(query) # check the query layout visually

result <- spq_perform(query) # let the magic happen!

# digest the results & save for future use
result %>% 
   unique() %>% 
   mutate(claim = str_remove(claim, "http://data.climatesense-project.eu/claim/2")) %>% 
   mutate(mentioned = str_remove(mentioned, "http://dbpedia.org/resource/")) %>% 
   mutate(subject = str_remove(subject, "http://data.climatesense-project.eu/claim-review/")) %>% 
   select(-reviewer) %>% 
   st_as_sf(wkt = "geo", crs = 4326) %>% 
   st_write("./data/dezinfo.gpkg", append = F)

cat(paste("count of mentions:", nrow(result), "\n"), file = vystup, append = T)

cat(paste(Sys.time(), "finish\nelapsed time", round(Sys.time() - start_time, 2), "seconds\n"), file = vystup, append = T)
   
