library(gemini.R)
library(dplyr)

# schema to be parsed
schema <- list(
   type = "ARRAY",
   items = list(
      type = "OBJECT",
      properties = list(
         name = list(type = "STRING"),
         location = list(type = "STRING"),
         confidence = list(type = "NUMBER")
      ),
      propertyOrdering = c("name", "location", "confidence")
   )
)

# initial prompt
prompt_header <- "you are an experienced geographer; analyze this text and 
                  give me its single most important location as a name and 
                  as a POINT in simple features WKT format 
                  and state your confidence on a scale from 0 to 100 \n\n"

# text to be analyzed
text_input <- "Na den svatého Rufa,
               Na poli Moravském
               Krev česká tekla proudem,
               Až zrůžověla zem.
               Tam české pluky stály,
               Otakar vede voj;
               Ó slavný, zlatý králi,
               To poslední tvůj boj!
               Král Otakar vítězný,
               Jenž jméno české nes
               Až k moři baltickému –
               U své Moravy kles.
               Morava hučí temně,
               I pláče všechen lid,
               Tak jakby v zemi zhynul
               Poslední slunce svit."

# let Gemini perform its magic!
location <- gemini_structured(prompt = paste(prompt_header, text_input),
                           model = "2.5-flash-lite", # nejlevnější a nejrychlejší z aktuálních modelů
                           schema = schema)

# interpet the result as sf object
location %>% 
   jsonlite::fromJSON() %>% 
   as.data.frame() %>% 
   sf::st_as_sf(wkt = "location", crs = 4326) %>% 
   mapview::mapview()