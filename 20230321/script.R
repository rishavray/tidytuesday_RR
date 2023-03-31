library(tidyverse)
library(tidytuesdayR)
library(janitor)
library(ggdoctheme)
library(ggrepel)
library(ggtext)

#Programming language

#tuesdata = tidytuesdayR::tt_load('2023-03-21')
#languages = tuesdata$languages
#write.csv(languages, "languages.csv", row.names = FALSE)
languages = read.csv("data/languages.csv", as.is = TRUE)

# Let's first filter the data with interesting variables
languages_filter = languages %>% select(pldb_id, title, type, number_of_users, number_of_jobs, is_open_source)

# Removing HTTP since it is a protocol and inflates the correlation
# Add a label if number of user is greater than 1M and also scale the user and jobs by a factor of 1000000 and 1000
languages_filter = languages_filter %>% filter(title != "HTTP") %>% mutate(label = ifelse(number_of_users>1000000, title, NA_character_)) %>% 
mutate(user_per_M = number_of_users/1000000, jobs_per_k = number_of_jobs/1000)


languages_filter %>%
ggplot(aes(x = user_per_M, y = jobs_per_k, label = label))+
geom_point()+
theme_doc()+
coord_cartesian(expand = TRUE, clip = 'off') +# removes white spaces at edge of plot
theme(axis.title.x = element_textbox_simple(hjust = 0.5, halign = 0.5, family="Go Book"),
	axis.title.y = element_textbox_simple(family="Go Book", hjust = 0.5, halign = 0.5, orientation = "left-rotated"),
	plot.caption = element_markdown(color = "grey30", family = "acme", size = rel(0.5)),
	plot.title = element_text(family="oswald", size=20, hjust = 0),
	plot.title.position = 'plot')+
geom_text_repel(colour = "grey30", alpha = 1, size = 4.5, box.padding = 0.6, point.padding = 0.2, family = "Go Book", segment.color = "grey70")+
labs(x = "Number of users<br><span style = 'font-size:12pt'>(in million)</span>",
	y = "Number of estimated jobs<br><span style = 'font-size:12pt'>(in thousand)</span>",
	title = str_wrap('Number of estimated programming language user vs job opportunity', width = 35),
	caption = "Tidytuesday Week-12 2023<br> Data from **Programming Language database**")

# see if the estimated user count and number of jobs are correlated min.segment.length = unit(0.5, "lines"),