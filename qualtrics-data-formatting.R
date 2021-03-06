#install.packages("tidyverse")
library(tidyverse)
library(testthat)

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
lab_debrief_raw$lab[lab_debrief_raw$lab == "ispdevlabmcgill"] <- "isplabmcgill"
lab_debrief_raw$lab[lab_debrief_raw$lab == "babylabparisdescartes2"] <- "lppparisdescartes2"
lab_debrief_raw$lab[lab_debrief_raw$lab == "babylabwesternsydney"] <- "babylabkingswood"

# also get rid of test trial in lab_debrief_raw
lab_debrief_raw <- lab_debrief_raw %>% 
  filter(lab != "btibil")

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
lab_secondary_raw$lab[lab_secondary_raw$lab == "babylabwesternsydney"] <- "babylabkingswood"

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
View(filter(lab_questionnaire_raw, lab == 'nusinfantlanguagecentre'))

# StartDate is not being recognized in filter commands because its class is POSIXct (date format). 
# Here I'm changing it to a character so it will be recognized.
lab_questionnaire_raw$StartDate <- as.character(lab_questionnaire_raw$StartDate) 

# 1 babylableiden           2
# Most info is in second fill-out only, completed 21-03-18. Earlier version (08-02-2018) states collection to an 
#N, starting 25-01-18, updated version states collection to last day (04-30-2018). No PCF entry. 
#RESOLUTION: Copy start date to 2nd version, drop first. 
#TODO: Contact about protocol change?

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  mutate(PlannedStart = ifelse(lab == 'babylableiden', 'January 25, 2018', PlannedStart)) %>%
  filter(!(lab == 'babylableiden' & StartDate == "2018-02-01 04:48:42"))

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
  mutate(dBA = ifelse(lab == 'babylabutrecht',"The maximum reached power during playback of the reference audio was 75.0±0 dB(A) SPL, 35.6±1.6 without (n=3, 10 sec.).",dBA))

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
  mutate(Recruitment = ifelse(lab == 'baldwinlabuoregon',middle$Recruitment[1],Recruitment))%>%
  mutate(Screening = ifelse(lab == 'baldwinlabuoregon',middle$Screening[1],Screening))%>%
  mutate(Compensation_toysBooks = ifelse(lab == 'baldwinlabuoregon',middle$Compensation_toysBooks[1],Compensation_toysBooks))%>%
  mutate(Compensation_cash = ifelse(lab == 'baldwinlabuoregon',middle$Compensation_cash[1],Compensation_cash))
  
# 8 cfnuofn                 2
#Keep most recent, add more informative answers from older one
#older versions
old <- lab_questionnaire_raw %>%
  filter((lab == 'cfnuofn' & StartDate == '2017-05-11 22:26:20'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'cfnuofn' & StartDate == '2017-05-11 22:26:20')) %>%
  mutate(Compensation_parkingBus = ifelse(lab == 'cfnuofn',old$Compensation_parkingBus[1],Compensation_parkingBus))%>%
  mutate(CaregiverHeadphones = ifelse(lab == 'cfnuofn',old$CaregiverHeadphones[1],CaregiverHeadphones))%>%
  mutate(InfantHeld = ifelse(lab == 'cfnuofn',old$InfantHeld[1],InfantHeld))

# 9 chosunbaby              2

#Keep most recent, add more informative answers from older one
#older versions
old <- lab_questionnaire_raw %>%
  filter((lab == 'chosunbaby' & StartDate == '2017-09-27 03:48:09'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'chosunbaby' & StartDate == '2017-09-27 03:48:09')) %>%
  mutate(PlannedEnd = ifelse(lab == 'chosunbaby',old$PlannedEnd[1],PlannedEnd))

# 10 escompicbsleipzig       2

#Keep most recent, add more informative answers from older one
#older version has more specific end date, so keeping that
old <- lab_questionnaire_raw %>%
  filter((lab == 'escompicbsleipzig' & StartDate == '2017-10-20 03:23:47'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'escompicbsleipzig' & StartDate == '2017-10-20 03:23:47')) %>%
  mutate(PlannedEnd = ifelse(lab == 'escompicbsleipzig',old$PlannedEnd[1],PlannedEnd))

# 11 infantstudiesubc        2
#Keep most recent, add more informative answers from older one
#older version has more specific end date, so keeping that
old <- lab_questionnaire_raw %>%
  filter((lab == 'infantstudiesubc' & StartDate == '2017-05-05 12:41:48'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'infantstudiesubc' & StartDate == '2017-05-05 12:41:48')) %>%
  mutate(RA_achievement_coursework = ifelse(lab == 'infantstudiesubc',old$RA_achievement_coursework[1],RA_achievement_coursework))

# 12 kokuhamburg             3
# keep middle because it's most complete, add extra info from newest

newest <- lab_questionnaire_raw %>%
  filter((lab == 'kokuhamburg' & StartDate == '2017-05-15 10:30:35'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'kokuhamburg' & StartDate == '2017-05-15 10:30:35')) %>%
  filter(!(lab == 'kokuhamburg' & StartDate == '2017-04-28 03:23:47')) %>% 
  mutate(PlannedStart = ifelse(lab == 'kokuhamburg',newest$PlannedStart[1],PlannedStart))

# 13 kyotobabylab            2
#Keep most things from most recent completion, but add a few columns that are present in older version and missing in new version

old <- lab_questionnaire_raw %>%
  filter((lab == 'kyotobabylab' & StartDate == '2017-05-05 08:17:04'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'kyotobabylab' & StartDate == '2017-05-05 08:17:04')) %>%
  mutate(GazeFollow_stoppingrule = ifelse(lab == 'kyotobabylab', old$GazeFollow_stoppingrule[1],GazeFollow_stoppingrule)) %>% 
  mutate(Contrib_GazeFollowN_12_15_mono = ifelse(lab == 'kyotobabylab', old$Contrib_GazeFollowN_12_15_mono[1],Contrib_GazeFollowN_12_15_mono)) %>% 
  mutate(GazeFollow_SecondSession = ifelse(lab == 'kyotobabylab', old$GazeFollow_SecondSession[1],GazeFollow_SecondSession)) %>% 
  mutate(GazeFollow_method = ifelse(lab == 'kyotobabylab', old$GazeFollow_method[1],GazeFollow_method)) 
  
# 14 lancaster               2
#Keep most things from most recent completion, but ExperimenterLocation_other from older version

old <- lab_questionnaire_raw %>%
  filter((lab == 'lancaster' & StartDate == '2018-03-12 04:28:47'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'lancaster' & StartDate == '2018-03-12 04:28:47')) %>%
  mutate(ExperimenterLocation_other = ifelse(lab == 'lancaster', old$ExperimenterLocation_other[1],ExperimenterLocation_other))

# 15 langlabucla             2
# Second version is complete, first version has some of the same information but it incomplete, keeping second version
lab_questionnaire_raw <- lab_questionnaire_raw %>% 
  filter(!(lab == 'langlabucla' & StartDate == '2017-05-09 10:53:50'))

# 16 lscppsl                 2
# Second version is complete, first version has some of the same information but it incomplete, keeping second version
lab_questionnaire_raw <- lab_questionnaire_raw %>% 
  filter(!(lab == 'lscppsl' & StartDate == '2017-11-30 10:47:16'))

# 17 trainorlab              4
# Last version is complete, earlier versions have some of the same information but are incomplete, keeping only most recent version
lab_questionnaire_raw <- lab_questionnaire_raw %>% 
  filter(!(lab == 'trainorlab' & StartDate == '2017-07-15 11:43:28')) %>% 
  filter(!(lab == 'trainorlab' & StartDate == '2017-07-17 09:16:51')) %>% 
  filter(!(lab == 'trainorlab' & StartDate == '2017-07-17 09:12:28')) 


# 18 unlvmusiclab            2
# Second version seems to be most current and complete
lab_questionnaire_raw <- lab_questionnaire_raw %>% 
  filter(!(lab == 'unlvmusiclab' & StartDate == '2017-08-12 16:11:09')) 

# 19 weescienceedinburgh     2
# Second version is complete, first version has some of the same information but it incomplete, keeping second version
lab_questionnaire_raw <- lab_questionnaire_raw %>% 
  filter(!(lab == 'weescienceedinburgh' & StartDate == '2017-06-08 10:19:54'))

# 20 nusinfantlanguagecentre
#Keep most things from most recent completion, but ExperimenterLocation_other from older version

old <- lab_questionnaire_raw %>%
  filter((lab == 'nusinfantlanguagecentre' & StartDate == '2017-11-14 06:11:41'))

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  filter(!(lab == 'nusinfantlanguagecentre' & StartDate == '2017-11-14 06:11:41')) %>%
  mutate(dBA = ifelse(lab == 'nusinfantlanguagecentre', old$dBA[1],dBA))

#######
# The same, for lab_debrief
lab_debrief_raw <- lab_debrief_raw %>%
  arrange(lab) %>%
  select(lab, everything())


d_duplicates <- lab_debrief_raw %>%
  group_by(lab)%>%
  summarize(n=n())%>%
  filter(n > 1)

View(filter(lab_debrief_raw, lab %in% d_duplicates$lab))

#Nobody filled out debrief more than once, hooray!

#######
# The same, for lab_secondary
lab_secondary_raw <- lab_secondary_raw %>%
  arrange(lab) %>%
  select(lab, everything())


s_duplicates <- lab_secondary_raw %>%
  group_by(lab)%>%
  summarize(n=n())%>%
  filter(n > 1)

View(filter(lab_secondary_raw, lab %in% s_duplicates$lab))
View(filter(lab_secondary_raw, lab == 'pocdnorthwestern'))

#1 babylablangessex       2
#just drop an NA row
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylablangessex' & StartDate == '2018-06-29 08:31:07'))

#2 babylabnijmegen        2
#mostlyempty: 2018-06-29 16:11:08, except keep newer FamilyExperience value
#to keep: 2018-06-29 02:08:15
mostlyempty <- lab_secondary_raw %>%
  filter((lab == 'babylabnijmegen' & StartDate == '2018-06-29 16:11:08'))

lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylabnijmegen' & StartDate == '2018-06-29 16:11:08')) %>%
  mutate(FamilyExperience = ifelse(lab == 'babylabnijmegen',mostlyempty$FamilyExperience[1],FamilyExperience))

#3 babylabplymouth        2
# remove empty: 2018-06-29 08:11:01
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylabplymouth' & StartDate == '2018-06-29 08:11:01'))

#4 babylabpotsdam         2
#updated familyExperience & explain @ 2018-06-29 08:09:11
fe <- lab_secondary_raw %>%
  filter((lab == 'babylabpotsdam' & StartDate == '2018-06-29 08:09:11'))

lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylabpotsdam' & StartDate == '2018-06-29 08:09:11')) %>%
  mutate(FamilyExperience = ifelse(lab == 'babylabpotsdam',fe$FamilyExperience[1],FamilyExperience)) %>%
  mutate(FamilyExperience_explain = ifelse(lab == 'babylabpotsdam',fe$FamilyExperience_explain[1],FamilyExperience_explain))

#5 babylabumassb          2
#updated familyExperience & explain @ 2018-06-29 10:08:33
fe <- lab_secondary_raw %>%
  filter((lab == 'babylabumassb' & StartDate == '2018-06-29 10:08:33'))

lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylabumassb' & StartDate == '2018-06-29 10:08:33')) %>%
  mutate(FamilyExperience = ifelse(lab == 'babylabumassb',fe$FamilyExperience[1],FamilyExperience)) %>%
  mutate(FamilyExperience_explain = ifelse(lab == 'babylabumassb',fe$FamilyExperience_explain[1],FamilyExperience_explain))

#6 babylabutrecht         2
#Drop NA at 2018-06-29 03:02:26
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylabutrecht' & StartDate == '2018-06-29 03:02:26'))

#7 babylingoslo           2
# Drop NA line 2018-06-29 08:17:46

lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'babylingoslo' & StartDate == '2018-06-29 08:17:46'))

#8 cdcceu                 2
#Updated FE and FE_explain at 2018-06-29 10:51:35
fe <- lab_secondary_raw %>%
  filter((lab == 'cdcceu' & StartDate == '2018-06-29 10:51:35'))

lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'cdcceu' & StartDate == '2018-06-29 10:51:35')) %>%
  mutate(FamilyExperience = ifelse(lab == 'cdcceu',fe$FamilyExperience[1],FamilyExperience)) %>%
  mutate(FamilyExperience_explain = ifelse(lab == 'cdcceu',fe$FamilyExperience_explain[1],FamilyExperience_explain))

#9 childlabmanchester     2
#Drop NA at 2018-06-30 00:58:06
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'childlabmanchester' & StartDate == '2018-06-30 00:58:06'))

#10 chosunbaby             2
#Drop NA at 2018-06-29 08:27:30
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'chosunbaby' & StartDate == '2018-06-29 08:27:30'))

#11 cogdevlabbyu           2
#Drop NA at 2018-06-29 08:32:55
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'cogdevlabbyu' & StartDate == '2018-06-29 08:32:55'))

#12 irlconcordia           2
#Drop NA at 2018-06-29 10:32:11
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'irlconcordia' & StartDate == '2018-06-29 10:32:11'))

#13 jmucdl                 2
#Drop NA at 2018-06-29 08:45:54
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'jmucdl' & StartDate == '2018-06-29 08:45:54'))

#14 lancaster              2
#Drop NA at 2018-06-29 08:14:55
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'lancaster' & StartDate == '2018-06-29 08:14:55'))

#15 pocdnorthwestern       2
#Drop NA at 2018-06-29 10:21:27
lab_secondary_raw <- lab_secondary_raw %>%
  filter(!(lab == 'pocdnorthwestern' & StartDate == '2018-06-29 10:21:27'))


######
# Double check that duplicates are gone now!
######

q_duplicates <- lab_questionnaire_raw %>%
  group_by(lab)%>%
  summarize(n=n())%>%
  filter(n > 1)

d_duplicates <- lab_debrief_raw %>%
  group_by(lab)%>%
  summarize(n=n())%>%
  filter(n > 1)

s_duplicates <- lab_secondary_raw %>%
  group_by(lab)%>%
  summarize(n=n())%>%
  filter(n > 1)

test_that("no duplicates remain", {
  expect_equal(nrow(q_duplicates),0)
  expect_equal(nrow(d_duplicates),0)
  expect_equal(nrow(s_duplicates),0)
})

####
#TEMPORARYTEMPORARYTEMPORARY
#Keep just one row from the dupes that remain, so we can write the rest of the merge code!!!
lab_questionnaire_raw <- lab_questionnaire_raw %>%
  distinct(lab, .keep_all = TRUE)


######
# ASSUMPTION: At this point, all three questionnaires contain exactly 1 row at most from each lab, and
# every lab that has a row is a 'legal' labname.  Let's try to merge them!!!!

#Drop 'nuisance' qualtrics columns
col_to_drop <- c('IPAddress', 'Progress', 'Status', 'Duration_seconds', 'RecordedDate',
                 'RecipientFirstName', 'RecipientLastName', 'RecipientEmail', 'ExternalReference', 'LocationLatitude', 
                 'LocationLongitude', 'DistributionChannel', 'UserLanguage')

lab_questionnaire_raw <- lab_questionnaire_raw %>%
  select(-c(col_to_drop))

lab_debrief_raw <- lab_debrief_raw %>%
  select(-c(col_to_drop))

lab_secondary_raw <- lab_secondary_raw %>%
  select(-c(col_to_drop))


lab_mega_qualtrics <- left_join(lab_questionnaire_raw, lab_debrief_raw, by = "lab", suffix = c(".quest", ".debrief"))

lab_mega_qualtrics <- left_join(lab_mega_qualtrics, lab_secondary_raw, by = "lab", suffix = c(".qd", ".2ary"))

#Holy moly it works! Before exporting to the main repository, we need to:
#1 - Probably drop columns that are qualtrics cruft that nobody needs
#2 - Determine which (if any) responses should not be associated with their lab's name when
#merged

col_to_drop<- c('OverallExperience', 'ChangePractices_YN', 'ChangePracticesSelect', 'ChangePractices_explain', 
'CommunicationClear', 'ContactPreferences','ContactPreferences_other','SetupProblems', 'SetupProblems_comment',
'AskHelp','ResponseSatisfying','Suggestions','Suggestions_comment', 'CompleterEmail', 'ImproveCommunication','OtherFeedback')

lab_mega_qualtrics <- lab_mega_qualtrics %>%
  select(-c(col_to_drop))

#....And print out for export to the main repository!!!
write_tsv(lab_mega_qualtrics, 'lab_qualtrics_merged_data.tsv')


