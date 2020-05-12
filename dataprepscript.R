install.packages("tidyverse")
library(tidyverse)

d = read_xlsx("C:/Users/All Other Users/Documents/germdata/Germination_survey_field_data_20200413_EEB.xlsx")

head(d)

e=d %>%
  select(-orange.m,-yellow.m, -green.m., -`collected by`)

e$orange = as.numeric(e$orange.p)
e$yellow = as.numeric(e$yellow.p)
e$green = as.numeric(e$green.p)
e$quadrat = as.character(e$quadrat)
head(e)

# Table with color counts
f = e %>%
  select(-orange.p,-yellow.p,-green.p) %>%
  pivot_longer(cols=c(orange, yellow, green),
               names_to='color',
               values_to='colorcount') %>%
  group_by(plot, quadrat, color) %>%
  summarize('n'= max(colorcount, 
                     na.rm=TRUE))

# Dealing with absent 1/24 data for lower site`
g = f %>%
  filter(n != '-Inf')
head(g)
g$quadratnum = as.numeric(g$quadrat)

potato = g %>%
  uncount(n) %>%
  arrange(plot,quadratnum,color) %>% 
  select(-quadratnum) %>%
  as.data.frame()

write.xlsx(potato,
           "C:/Users/All Other Users/Documents/germdata/AnnualCensusPrefill2020.xlsx")
?write.xlsx

