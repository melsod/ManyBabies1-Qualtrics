install.packages("tidyverse")
library(tidyverse)

# Read qualtrics data

secondary_header <- read_csv("qualtricsraw/Secondary-data-analysis-numeric.csv", col_names = TRUE, n_max = 2)
secondary_data_raw <- read_csv("qualtricsraw/Secondary-data-analysis-numeric.csv", col_names = FALSE, skip = 3)
names(secondary_data_raw) <- names(secondary_header)

lab_debrief_header <- read_csv("qualtricsraw/Lab-debrief-numeric.csv", col_names = TRUE, n_max = 2)
lab_debrief_raw <- read_csv("qualtricsraw/Lab-debrief-numeric.csv", col_names = FALSE, skip = 3)
names(lab_debrief_raw) <- names(lab_debrief_header)

lab_questionnaire_header <- read_csv("qualtricsraw/Lab-Questionnaire.csv", col_names = TRUE, n_max = 2)
lab_questionnaire_raw <- read_csv("qualtricsraw/Lab-Questionnaire.csv", col_names = FALSE, skip = 3)
names(lab_questionnaire_raw) <- names(lab_questionnaire_header)

#clean lab_questionnaire



