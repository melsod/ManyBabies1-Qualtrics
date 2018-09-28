#install.packages("tidyverse")
library(tidyverse)

#########
####
# READ IN AND FIX UP VAR NAMES/DATA DICTIONARIES
####
#########
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

#Get dictionaries so we can add meaningful column names
secondary_header <- secondary_header %>%
  rownames_to_column %>% 
  gather(var, value, -rowname) %>% 
  spread(rowname, value)
write_csv(secondary_header, 'metadata/secondary_dict_raw.csv')

lab_debrief_header <- lab_debrief_header %>%
  rownames_to_column %>% 
  gather(var, value, -rowname) %>% 
  spread(rowname, value)
write_csv(lab_debrief_header, 'metadata/lab_debrief_dict_raw.csv')

lab_questionnaire_header <- lab_questionnaire_header %>%
  rownames_to_column %>% 
  gather(var, value, -rowname) %>% 
  spread(rowname, value)
write_csv(lab_questionnaire_header, 'metadata/lab_questionnaire_dict_raw.csv')

#Read in dicts with better column names and add them

secondary_names <- read_csv('metadata/secondary_dict_literate.csv')
lab_debrief_names <- read_csv('metadata/lab_debrief_dict_literate.csv')
lab_questionnaire_names <- read_csv('metadata/lab_questionnaire_dict_literate.csv')

secondary_data_raw <- secondary_data_raw %>%
  rename_at(vars(secondary_names$var), ~ secondary_names$NewColName)

lab_debrief_raw <- lab_debrief_raw %>%
  rename_at(vars(lab_debrief_names$var), ~ lab_debrief_names$NewColName)

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  rename_at(vars(lab_questionnaire_names$var), ~ lab_questionnaire_names$NewColName)

#########
####
# FIX LAB IDS FOR MERGING
####
#########

#Standardize spaces and capitalization in lab IDs first
lab_questionnaire_raw <- lab_questionnaire_raw %>%
  mutate(lab = str_replace_all(LabID, '[^[:alnum:]]',''))%>%
  mutate(lab = tolower(lab)) %>%
  filter(!is.na(lab))

lab_debrief_raw <- lab_debrief_raw %>%
  mutate(lab = str_replace_all(labID, '[^[:alnum:]]',''))%>%
  mutate(lab = tolower(lab)) %>%
  filter(!is.na(lab))

secondary_data_raw <- secondary_data_raw %>%
  mutate(lab = str_replace_all(LabID, '[^[:alnum:]]',''))%>%
  mutate(lab = tolower(lab)) %>%
  filter(!is.na(lab))

#Read in the list of main analysis lab strings, attempt to coerce labIDs in questionnaire dataframes 
#to something that matches.

final_labids <- read.csv('metadata/labid_main.csv',header = F)

lab_debrief_raw$lab[lab_debrief_raw$lab == "mindevlabbicocca"] <- "minddevlabbicocca"
lab_debrief_raw$lab[lab_debrief_raw$lab == "unlvbcrl"] <- "bcrlunlv" 
lab_debrief_raw$lab[lab_debrief_raw$lab == "utkinfantlanguagelab"] <- "infantlanglabutk"
lab_debrief_raw$lab[lab_debrief_raw$lab == "utrechtbabylab"] <- "babylabutrecht"
lab_debrief_raw$lab[lab_debrief_raw$lab ==  "lllliverpoollanguagelab"] <- "lllliv"

secondary_data_raw$lab[secondary_data_raw$lab == "mindevlabbicocca"] <- "minddevlabbicocca"
secondary_data_raw$lab[secondary_data_raw$lab == "umbbabylab"] <- "babylabumassb"
secondary_data_raw$lab[secondary_data_raw$lab ==  "plymouthbabylab"] <- "babylabplymouth"
secondary_data_raw$lab[secondary_data_raw$lab == "utrechtbabylab"] <- "babylabutrecht"
secondary_data_raw$lab[secondary_data_raw$lab ==  "lancslab"] <- "lancaster" 
secondary_data_raw$lab[secondary_data_raw$lab == "babylinguio" ] <- "babyling-oslo"
secondary_data_raw$lab[secondary_data_raw$lab == "babylabparisdescartes2"] <- "lppparisdescartes2"
secondary_data_raw$lab[secondary_data_raw$lab == "utkinfantlanglab" ] <- "infantlanglabutk"
secondary_data_raw$lab[secondary_data_raw$lab == "bciccl"] <- "icclbc"

lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "babylabparisdescartes2"] <- "lppparisdescartes2"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "lcd"] <- "lcdfsu"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "kokulabhamburg"] <- "kokuhamburg"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "bclbogazici"] <- "bounbcl"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "infstudiesubc"] <- "infantstudiesubc"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "cfnnewcastle"] <- "cfnuofn"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "trainorlabmcmaster"] <- "trainorlab"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "musiclabunlv" ] <- "unlvmusiclab"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "cdschosun"] <- "chosunbaby"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "escompicbs"] <- "escompicbsleipzig"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "minddevlabmilan"] <- "minddevlabbicocca"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "babylabsaarland"] <- "udssaarland"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "baldwinamloregon"] <- "baldwinlabuoregon"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "baldwinlaboregon"] <- "baldwinlabuoregon"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "lancslab" ] <- "lancaster" 
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "babylablancaster"] <- "lancaster" 
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "babylablscp"] <- "lscppsl"


#########
####
# REMAINING LABID ISSUES - TODO: Reconcile all this!
####
#########

####----->
#Issue #8 Labs still un-matched in questionnaire - did they participate in MB1 or drop out after initial questionnaire?
setdiff(lab_questionnaire_raw$lab, final_labids$V1)

#lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "elpgeorgetown"] <-
#lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "ellskidmore"] <- 
#lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "nusbabylab"] <- "infantlabsingapore"
#lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "mqcll"] <- 
#lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "infantlabsingapore"] <- 

# AS A TEMPORARY MEASURE, Drop these non-matching IDs from the sheet:

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab %in% c("elpgeorgetown", "ellskidmore", "nusbabylab", "mqcll", "infantlabsingapore")))


####-----> Issue #9 - (final dataset) labs that didn't fill out one of the surveys. Is this okay?
no_secondary <- setdiff(final_labids$V1, secondary_data_raw$lab)
no_debrief <- setdiff(final_labids$V1, lab_debrief_raw$lab)
  
# These labs DID fill out the debrief, but didn't participate in secondary analysis - OKAY!
setdiff(no_secondary, no_debrief) 

# These labs DID fill out the secondary, but DIDN'T fill out the debrief. Is this okay? 
setdiff(no_debrief, no_secondary) 

# These labs filled out neither final worksheet
intersect(no_debrief, no_secondary)




