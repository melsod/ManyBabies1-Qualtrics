install.packages("tidyverse")
library(tidyverse)
secondary_data_raw <- read_csv("qualtricsraw/Secondary-data-analysis-numeric.csv", col_names = TRUE, skip = 2)
lab_debrief_raw <- read_csv("qualtricsraw/Lab-debrief-numeric.csv", col_names = TRUE, skip = 2)