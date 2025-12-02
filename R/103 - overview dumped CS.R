library(sf)
library(dplyr)
library(giscoR)
library(ggplot2)


csense <- st_read("./data/dezinfo.gpkg") %>% 
   mutate(date = as.Date(date))

# celý svět, 1: 20M
world <- gisco_get_countries(resolution = "20")

# spatial overview
ggplot() +
   geom_sf(data = world, fill = NA, color = "gray45") +
   geom_sf(data = csense, color = "red", alpha = 1/500, size = 1/2) +
   coord_sf(crs = st_crs("ESRI:54019")) +
   theme_minimal() +
   labs(title = "Localities mentioned in climate related fact checks")

ggsave("./output/spatial overview.png",
       width = 2000, height = 1500, units = "px")


# temporal overview
csense %>% 
   st_drop_geometry() %>% 
   select(date, subject) %>% 
   unique() %>% 
   group_by(date) %>% 
   summarise(count = n()) %>% 
   ggplot(aes(x = date, y = count)) + 
   geom_point(pch = 4, alpha = 1/4) +
   geom_smooth(se = F, color = "red") +
   scale_x_date(date_breaks = "2 years",
                date_labels = "%Y") +
   theme_minimal() +
   theme(axis.title = element_blank(),
         axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
   labs(title = "Daily count of climate related fact checks")

ggsave("./output/temporal overview.png",
       width = 2000, height = 1500, units = "px")

# org overview
csense %>% 
   st_drop_geometry() %>% 
   select(org, subject) %>%
   unique() %>% 
   group_by(org) %>% 
   summarise(count = n()) %>% 
   filter(count > 100) %>% 
   ggplot(aes(x = reorder(org, count), y = count)) +
   geom_col(aes(fill = org), show.legend = F) +
   coord_flip() +
   theme_minimal() +
   theme(axis.title = element_blank()) +
   labs(title = "Major fact checking orgs / 100+ reviews")

ggsave("./output/organizational overview.png",
       width = 2000, height = 1500, units = "px")