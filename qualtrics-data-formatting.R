#install.packages("tidyverse")
library(tidyverse)

#########
####
# READ IN AND FIX UP VAR NAMES/DATA DICTIONARIES
####
#########
# Read qualtrics data
lab_secondary_header <- read_csv("qualtricsraw/Lab-secondary-data-analysis-numeric.csv", col_names = TRUE, n_max = 2)
lab_secondary_raw <- read_csv("qualtricsraw/Lab-secondary-data-analysis-numeric.csv", col_names = FALSE, skip = 3)
names(lab_secondary_raw) <- names(lab_secondary_header)

lab_debrief_header <- read_csv("qualtricsraw/Lab-debrief-numeric.csv", col_names = TRUE, n_max = 2)
lab_debrief_raw <- read_csv("qualtricsraw/Lab-debrief-numeric.csv", col_names = FALSE, skip = 3)
names(lab_debrief_raw) <- names(lab_debrief_header)

lab_questionnaire_header <- read_csv("qualtricsraw/Lab-Questionnaire.csv", col_names = TRUE, n_max = 2)
lab_questionnaire_raw <- read_csv("qualtricsraw/Lab-Questionnaire.csv", col_names = FALSE, skip = 3)
names(lab_questionnaire_raw) <- names(lab_questionnaire_header)

#Get dictionaries so we can add meaningful column names
lab_secondary_header <- lab_secondary_header %>%
  rownames_to_column %>% 
  gather(var, value, -rowname) %>% 
  spread(rowname, value)
write_csv(lab_secondary_header, 'metadata/lab_secondary_dict_raw.csv')

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

lab_secondary_names <- read_csv('metadata/lab_secondary_dict_literate.csv')
lab_debrief_names <- read_csv('metadata/lab_debrief_dict_literate.csv')
lab_questionnaire_names <- read_csv('metadata/lab_questionnaire_dict_literate.csv')

lab_secondary_raw <- lab_secondary_raw %>%
  rename_at(vars(lab_secondary_names$var), ~ lab_secondary_names$NewColName)

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

lab_secondary_raw <- lab_secondary_raw %>%
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
lab_debrief_raw$lab[lab_debrief_raw$lab == "cfnuon"] <- "cfnuofn"
lab_debrief_raw$lab[lab_debrief_raw$lab == "infantlabsingapore"] <- "nusinfantlanguagecentre"
lab_debrief_raw$lab[lab_debrief_raw$lab == "nusbabylab"] <- "nusinfantlanguagecentre"

lab_secondary_raw$lab[lab_secondary_raw$lab == "mindevlabbicocca"] <- "minddevlabbicocca"
lab_secondary_raw$lab[lab_secondary_raw$lab == "umbbabylab"] <- "babylabumassb"
lab_secondary_raw$lab[lab_secondary_raw$lab ==  "plymouthbabylab"] <- "babylabplymouth"
lab_secondary_raw$lab[lab_secondary_raw$lab == "utrechtbabylab"] <- "babylabutrecht"
lab_secondary_raw$lab[lab_secondary_raw$lab ==  "lancslab"] <- "lancaster" 
lab_secondary_raw$lab[lab_secondary_raw$lab == "babylinguio" ] <- "babyling-oslo"
lab_secondary_raw$lab[lab_secondary_raw$lab == "babylabparisdescartes2"] <- "lppparisdescartes2"
lab_secondary_raw$lab[lab_secondary_raw$lab == "utkinfantlanglab" ] <- "infantlanglabutk"
lab_secondary_raw$lab[lab_secondary_raw$lab == "bciccl"] <- "icclbc"
lab_secondary_raw$lab[lab_secondary_raw$lab == "infantlabsingapore"] <- "nusinfantlanguagecentre"
lab_secondary_raw$lab[lab_secondary_raw$lab == "nusbabylab"] <- "nusinfantlanguagecentre"
lab_secondary_raw$lab[lab_secondary_raw$lab == "cfnuon"] <- "cfnuofn"
lab_secondary_raw$lab[lab_secondary_raw$lab == "babyling-oslo"] <- "babylingoslo"

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
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "infantlabsingapore"] <- "nusinfantlanguagecentre"
lab_questionnaire_raw$lab[lab_questionnaire_raw$lab == "nusbabylab"] <- "nusinfantlanguagecentre"

#########
####
# REMAINING LABID ISSUES - TODO: Reconcile all this!
####
#########


#Are there uncaptured lines (ie IDs not in the labid list, still)?
extra_questionnaire <- setdiff(lab_questionnaire_raw$lab, final_labids$V1)
extra_secondary <- setdiff(lab_secondary_raw$lab, final_labids$V1)
extra_debrief <- setdiff(lab_debrief_raw$lab, final_labids$V1)

####RESOLVED (10/24)
#Issue #8 Labs still un-matched in questionnaire - did they participate in MB1 or drop out after initial questionnaire?
setdiff(lab_questionnaire_raw$lab, final_labids$V1)

# Resolution
#mqcll & ell-skidmore formally withdrew (staffing/database limitations prevented recruitment)
#elpgeorgetown only did gaze following, no main IDS
lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab %in% c("mqcll", "elpgeorgetown", "ellskidmore")))


####-----> Issue #9 - (final dataset) labs that didn't fill out one of the surveys. Is this okay?
no_secondary <- setdiff(final_labids$V1, lab_secondary_raw$lab)
no_debrief <- setdiff(final_labids$V1, lab_debrief_raw$lab)
  
# These labs DID fill out the debrief, but didn't participate in secondary analysis - OKAY!
#setdiff(no_secondary, no_debrief) 

# These labs DID fill out the secondary, but DIDN'T fill out the debrief. Is this okay? 
setdiff(no_debrief, no_secondary) 

# These labs filled out neither final worksheet
intersect(no_debrief, no_secondary)

  
#########
####
# CONSOLIDATE RESPONSES: Some labs have more than one entry in a spreadsheet! 
# Sometimes this is just an initial blank form, but it could also be a mistake/inconsistency we need to
# check. Manually examine these before merging. 
####
#########

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  arrange(lab) %>%
  select(lab, everything())
  

q_duplicates <- lab_questionnaire_raw %>%
  group_by(lab)%>%
  summarize(n=n())%>%
  filter(n > 1)

View(filter(lab_questionnaire_raw, lab %in% q_duplicates$lab))
View(filter(lab_questionnaire_raw, lab == 'baldwinlabuoregon'))

# 1 babylableiden           2
# Most info is in second fill-out only, completed 21-03-18. Earlier version (08-02-2018) states collection to an 
#N, starting 25-01-18, updated version states collection to last day (04-30-2018). No PCF entry. 
#RESOLUTION: Copy start date to 2nd version, drop first. 
#TODO: Contact about protocol change?

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  mutate(PlannedStart = ifelse(lab == 'babylableiden', 'January 25, 2018', PlannedStart))%>%
  filter(!(lab == 'babylableiden' & StartDate == '2018-02-01 04:48:42'))

# 2 babylablmu              2
# Minor updates to text answers
# RESOLUTION: Drop earlier version, add a couple of expanded answers from first version

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'babylablmu' & StartDate == '2017-06-20 04:26:07')) %>%
  mutate(Recruitment = ifelse(lab == 'babylablmu', "The city of Munich provides us with a database of all families. We send invitation letters to families that have children in the age range that we are interested. Approximately 10% or less reply to our letters, so if we want to test for instance 40 children we usually send about 400 letters. We also have a separate database of \"returning\" families, that expressed interest for being contacted for more studies. We call these families directly on the phone. \nWe generally consider that the 5% will contact us back for an appointment. So, for instance, for 20 children we send letters to 400 families."                                                                                                                                       , Recruitment))%>%
  mutate(Compensation_toysBooks = ifelse(lab == 'babylablmu',"5 € value, children can choose one toy/book",Compensation_toysBooks))%>%
  mutate(RA_labTraining = ifelse(lab == 'babylablmu', "one reseach assistant (Alyssa Torske) is a graduate student, is involved in the study and has read all the manybabies material online. She helped setting up the study. Another RA will help with recruiting and data collection but is not intellectually involved in this study. She will try the experimental procedure with me until she is familiar with it. She has already experience testing babies for other studies.\nBoth RAs worked with the eye-tracker previously, so they knew the software. First the RA try the procedure with one another (one plays the participant) under my supervision. Then, each RA tests 3 pilot children."  ,RA_labTraining))

# 3 babylabnijmegen         2
# Second is minor expansion of first; no inconsistencies.
# RESOLUTION: Drop earlier, add a couple of expanded answers from first version

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'babylabnijmegen' & StartDate == '2017-09-13 03:27:55')) %>%
  mutate(Compensation_toysBooks = ifelse(lab == 'babylabnijmegen', "1 book worth ca. 10€", Compensation_toysBooks))%>%
  mutate(RA_labTraining = ifelse(lab == 'babylabnijmegen', "the RA was recently trained for another headturn study of the main contributor from this lab. She first observed 3 test sessions run by me, Laura Hahn. Then she ran two mock sessions, with a teddy bear instead of a real baby. The online coding was trained using videos of previous sessions and pressing the respective buttongs on the keyboard (as if she was coding the video), wearing headphones with the same distractor music as in the test session. Then she tested her first baby with me observing the test session. At all stages, she received feedback about her performance.\nRA reads lab instruction doc carefully RA observes studies in the lab RA runs three experimental sessions together with a more senior lab user RA gets feedback from senior lab user throughout the previous step RA practices look coding with videos of previous experimental sessions RA tests independently"       , RA_labTraining))%>%
  mutate(RA_labTraining_criteria = ifelse(lab == 'babylabnijmegen', "1 book worth ca. 10€", RA_labTraining_criteria))%>%
  mutate(BlinkRate_lights_other = ifelse(lab=='babylabnijmegen',"rate of 250ms, meaning the lamp turns off after 250 ms then off after another 250ms then on again and so on, sums up to 4 per second",BlinkRate_lights_other))%>%
  mutate(Exprimenter_HeadphoneType = ifelse(lab == 'babylabnijmegen', "room is dimly lit, experimenter stands behind curtain, observing the infant via camera, experimenter wears cushion headphones and is blind for the condition of the trial but not blind for trial number", Exprimenter_HeadphoneType))
  
# 4 babylabumassb           2
# Second fill-out just has more questions answered; drop first!

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'babylabumassb' & StartDate == '2017-07-05 13:17:17'))

# 5 babylabutrecht          2
# The second one just reports dBA, which was missing from first

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'babylabutrecht' & StartDate == '2018-01-09 04:06:57')) %>%
  mutate(dBA == ifelse(lab == 'babylabutrecht',"The maximum reached power during playback of the reference audio was 75.0±0 dB(A) SPL, 35.6±1.6 without (n=3, 10 sec.).",dBA))

# 6 babylabyork             2
# Second form adds a bit more info, but retain fuller answers on a few columns in old version
#older version: 2017-05-05 08:39:16
#newer version: 2017-05-16 12:21:47
old <- lab_questionnaire_raw %>%
  filter((lab == 'babylabyork' & StartDate == '2017-05-05 08:39:16'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'babylabyork' & StartDate == '2017-05-05 08:39:16')) %>%
  mutate(PlannedStart = ifelse(lab == 'babylabyork',old$PlannedStart[1],PlannedStart))%>%
  mutate(CoAuthors = ifelse(lab == 'babylabyork',old$CoAuthors[1],CoAuthors))


# 7 baldwinlabuoregon       3
#Keep most recent, add more informative answers from middle one
#older versions
middle <- lab_questionnaire_raw %>%
  filter((lab == 'baldwinlabuoregon' & StartDate == '2018-01-15 18:39:07'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'baldwinlabuoregon' & StartDate == '2018-01-15 18:39:07')) %>%
  filter(!(lab == 'baldwinlabuoregon' & StartDate == '2017-11-28 18:49:31')) %>%
  mutate(Recruitment = ifelse(lab == 'babylabyork',middle$Recruitment[1],Recruitment))%>%
  mutate(Screening = ifelse(lab == 'babylabyork',middle$Screening[1],Screening))%>%
  mutate(Compensation_toysBooks = ifelse(lab == 'babylabyork',middle$Compensation_toysBooks[1],Compensation_toysBooks))%>%
  mutate(Compensation_cash = ifelse(lab == 'babylabyork',middle$Compensation_cash[1],Compensation_cash))
  



# 8 cfnuofn                 2
# 9 chosunbaby              2
# 10 escompicbsleipzig       2
# 11 infantstudiesubc        2
# 12 kokuhamburg             3
# 13 kyotobabylab            2
# 14 lancaster               2
# 15 langlabucla             2
# 16 lscppsl                 2
# 17 trainorlab              4
# 18 unlvmusiclab            2
# 19 weescienceedinburgh     2
