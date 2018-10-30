# ManyBabies1-Qualtrics

This repo contains ALL the raw data qualtrics surveys given to MB1 participants. This is kept separate from the main analyses initially because it contains lab-identifying data that we don't plan to make public. Data in this repository needs to be cleaned to the point that we can divide and then share the anonymized and/or matched datasets over to the main repository. 

# qualtrics-data-formatting.R

All data cleaning done here

# metadata/

*labid_main.csv* the list of labid strings that result in the main analysis script. Used to (attempt to) coerce all questionnaire lines to existing strings.  

# qualtricsraw/

*Lab-Questionnaire.csv* This is the raw, unedited Qualtrics output of the main “ManyBabies Laboratory Questionnaire” (i.e. the formal sign-up questionnaire for ManyBabies1). Should be final version (as of July 1, 2018).

*Lab-debrief-numeric.csv* This is the raw, unedited Qualtrics output of the “ManyBabies1 Lab Debriefing Questionnaire”, in numeric form, currently updated through September 28, 2018.

*MB1Debriefing_May2-2018.pdf* Text of the questions for the “ManyBabies1 Lab Debriefing Questionnaire”, up through May 2, 2018 (when we started discussing having a separate secondary data analysis quiz). Includes two questions about the lab's experience running MB1 style studies that are missing in the later version (moved to the debrief questionnaire).

*MB1Debriefing_July24-2018.pdf* Text of the questions for the “ManyBabies1 Lab Debriefing Questionnaire”, after May 2018. Excludes two questions about the lab's experience running MB1 style studies that are present in the earlier version (moved to the debrief questionnaire).

*MB1MidWayCheckIn.pdf* Text of the “ManyBabies1 Mid-way Check-in” Questionnaire.

*MB1ProtocolChangeForm.pdf* Text of the protocol change form used by labs to report any changes made to their protocol, sampling, or other edits to the “ManyBabies Laboratory Questionnaire”.

*MB1Questionnaire.pdf* Text of the main “ManyBabies Laboratory Questionnaire”.
*MB1SecondaryExit.pdf* Text of the “Secondary data analysis exit quiz”.

*Lab-secondary-data-analysis-numeric.csv* This is the raw, unedited Qualtrics output of the “Secondary data analysis exit quiz”in numeric form, currently updated through September 28, 2018.

## qualtricsraw/old_data_versions

*Secondary-data-analysis-choicetext.csv* This is the raw, unedited Qualtrics output of the “Secondary data analysis exit quiz” in choice text form, currently updated through August 1, 2018.

*ManyBabiesQuestionnaireSpreadsheetAuthoritativeJune13-2018cleaned.csv* A “cleaned” (by hand) version of the Qualtrics output of the “ManyBabies Laboratory Questionnaire”. Spurious entries removed, columns edited to be more R friendly, a harmonized “language” column added.
