clear all
capture log close
set more off
set graphics off

//open dataset
import excel "/Users/peggychau/Desktop/capstone_survey/Household Cleaning Survey-report.xlsx", sheet("results") firstrow clear
tostring DO MaleChildren AM AS Allergiesasthma Attic Drum Lownoiselevel Notsure Desertegsandetc, replace

//Change inconsistent variables across datasets to match
rename DI VR1
rename DJ VR2
rename DK VR3
rename DL VR4
rename DM VR5
rename DN VR6
rename DO VR7
rename DP VR8

rename GH AC1
rename GI AC2
rename GJ AC3
rename GK AC4
rename GM AC5
rename GO AC6
rename GP AC7

save householdcleaning, replace

import excel "/Users/peggychau/Desktop/capstone_survey/Household Cleaning Survey (1)-report.xlsx", sheet("results") firstrow clear
tostring BQ LaundryDryer Robotic EnergyEfficient Lownoiselevel Withrobotvacuum DP Icurrentlyownarobotvacuum Yesaroommatedoes, replace

//Change inconsistent variables across datasets to match
rename DJ VR1
rename DK VR2
rename DL VR3
rename DM VR4
rename DN VR5
rename DO VR6
rename DP VR7
rename DQ VR8

rename GG AC1
rename GH AC2
rename GI AC3
rename GJ AC4
rename GL AC5
rename GO AC6
rename GP AC7

append using householdcleaning 
save householdcleaning_merged, replace

clear all
capture log close
set more off
set graphics off

use householdcleaning_merged

//make log recording
log using "/Users/peggychau/Desktop/capstone_survey/Log_householdcleaning.log", replace

//move into the capstone_survey folder (and export all future graphs into this folder)
cd "/Users/peggychau/Desktop/capstone_survey/graphs"

rename A UniqueID

//Exited survey after 2 questions
drop if UniqueID == "370a051438be3fbae293b4deeb1c44a9"

/*
//Recruitment for Cultural Probe
drop if Whichindustrydoyouprimarily == "Student"
drop if Whatagegroupdoyoubelongto == "18 - 22"
drop if Whatagegroupdoyoubelongto == "23 - 29"
drop if Wouldyoubeinterestedinparti == "No"
*/


//HomeType
rename Other HomeOther
gen HomeType = 0
replace HomeType = 1 if Whattypeofhomedoyoucurrent == "Apartment"
replace HomeType = 2 if Whattypeofhomedoyoucurrent == "House"
replace HomeType = 3 if Whattypeofhomedoyoucurrent == "Rental (Hotel / AirBnb, etc.)"
replace HomeType = 4 if HomeOther == "dorm" | HomeOther == "College dorm" | HomeOther == "Dorm" | HomeOther == "Greek Housing" | HomeOther == "Residence Hall"
replace HomeType = 9 if Whattypeofhomedoyoucurrent == ""
label define hometype 0 "N/A" 1 "Apartment" 2 "House" 3 "Rental" 4 "Dorm" 9 "Other"
label values HomeType hometype

twoway histogram HomeType if (HomeType == 1 | HomeType == 2 | HomeType == 3 | HomeType == 4), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 3 4) xlabel(1 2 3 4) note("1 Apartment 2 House 3 Temporary 4 Dorm", size(small)) name(HomeType, replace) 


//NumFloors
rename Howmanyfloorsdoesyourhomeh NumFloors
replace NumFloors = "5" if NumFloors == "5+"
destring NumFloors, replace
recast int NumFloors
label define floors 5 "5+"
label values NumFloors floors

twoway histogram NumFloors, frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 3 4 5) xlabel(1 2 3 4 5) name(NumFloors, replace) 


//RoomMostTime
rename F RoomMostTimeOther
gen RoomMostTime = 0
replace RoomMostTime = 1 if Ofalltheareasinyourhomew == "Bedroom"
replace RoomMostTime = 2 if Ofalltheareasinyourhomew == "Living Room"
replace RoomMostTime = 3 if Ofalltheareasinyourhomew == "Kitchen"
replace RoomMostTime = 4 if Ofalltheareasinyourhomew == "Home Office"
replace RoomMostTime = 5 if Ofalltheareasinyourhomew == "Bathroom"
replace RoomMostTime = 6 if Ofalltheareasinyourhomew == "Hallway(s)"
replace RoomMostTime = 7 if Ofalltheareasinyourhomew == "Basement"
replace RoomMostTime = 8 if Ofalltheareasinyourhomew == "Attic"
replace RoomMostTime = 9 if Ofalltheareasinyourhomew == "Garage"
replace RoomMostTime = 10 if RoomMostTimeOther == "Kids play room"
replace RoomMostTime = 99 if Ofalltheareasinyourhomew == "None"

label define rooms 0 "N/A" 1 "Bedroom" 2 "Living Room" 3 "Kitchen" 4 "Home Office" 5 "Bathroom" 6 "Hallway(s)" 7 "Basement" 8 "Attic" 9 "Garage" 10 "Kids playroom" 99 "N/A" 11 "Daughter's Room" 12 "Windows" 13 "All rooms"  
label values RoomMostTime rooms

replace RoomMostTime = 5 if inrange(RoomMostTime,5,99)

twoway histogram RoomMostTime if (RoomMostTime == 1 | RoomMostTime == 2 | RoomMostTime == 3 | RoomMostTime == 4), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 3 4) xlabel(1 2 3 4) note("1 Bedroom 2 Living Room 3 Kitchen 4 Home Office 5 Other", size(small)) name(RoomMostTime, replace) 

graph combine HomeType NumFloors RoomMostTime
graph export Combo_HomeType_NumFloors_RoomMostTime.eps, replace 

//Drop all descriptive cleaning graphs into this folder
cd "/Users/peggychau/Desktop/capstone_survey/graphs/descriptive_cleaning"


//WhoCleans
replace Me = "1" if Me == "Me"
replace MalePartner = "20" if MalePartner == "Male Partner"
replace FemalePartner = "300" if FemalePartner == "Female Partner"
replace MaleRoommates = "4000" if MaleRoommates == "Male Roommate(s)"
replace FemaleRoommates = "50000" if FemaleRoommates == "Female Roommate(s)"
replace MaleChildren = "600000" if MaleChildren == "Male Child(ren)"
replace FemaleChildren = "7000000" if FemaleChildren == "Female Child(ren)"
replace Hiredhelp = "80000000" if Hiredhelp == "Hired help"
gen Mom = "900000000" if Q == "Mom" | Q == "Mother" | Q == "Mother" | Q ==  "Mom, Dad"
replace Noone = "9999" if Noone == "No one"
rename Q WhoCleansOther

/*
//This respondent was weird and answered Other w/ 'Me' and 'roommate' (non gender specific).
replace Me = "1" if WhoCleansOther == "Both my roommate and I share chores (although they're done very sporadically this way"
replace MaleRoommates = "4000" if WhoCleansOther=="Both my roommate and I share chores (although they're done very sporadically this way)"
replace FemaleRoommates = "50000" if WhoCleansOther=="Both my roommate and I share chores (although they're done very sporadically this way)"
*/

destring Me MalePartner FemalePartner MaleRoommates FemaleRoommates MaleChildren FemaleChildren Hiredhelp Noone Mom, replace
egen WhoCleans = rowtotal(Me MalePartner FemalePartner MaleRoommates FemaleRoommates MaleChildren FemaleChildren Hiredhelp Mom Noone)

tab WhoCleans, sort

replace WhoCleans = 2 if WhoCleans == 21
replace WhoCleans = 3 if WhoCleans == 300
replace WhoCleans = 4 if WhoCleans == 301
replace WhoCleans = 5 if WhoCleans == 4001
replace WhoCleans = 6 if WhoCleans == 9999
replace WhoCleans = 7 if WhoCleans == 50001
replace WhoCleans = 8 if WhoCleans == 54001
replace WhoCleans = 9 if WhoCleans == 80000000
replace WhoCleans = 10 if WhoCleans == 80000024

//Weird 4 in 1s unit result...rounding error?
label define whocleans 0 "N/A" 1 "Me only" 2 "Me & M Partner" 20 "M Partner only" 3 "F Partner only" 4 "Me & F Partner" 4000 "M Room only" 5 "Me & M Room" 50000 "F Room only" 7 "Me & F Room" 54000 "F Room & M Room" 8 "F Room & Male Room & Me" 7000000 "F Child only" 7000001 "Me & F Child" 7000021 "F Child & M Partner & Me" 9 "Hired Help only" 80000001 "Me & Hired help" 10 "Hired Help & M Partner & Me" 6 "No one"  
label values WhoCleans whocleans

twoway histogram WhoCleans if (WhoCleans == 1 | WhoCleans == 2 | WhoCleans == 5 | WhoCleans == 7 | WhoCleans == 9), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 5 7 9) xlabel(1 2 5 7 9) note("1 Me only 2 Me & M Partner 5 Me & M Room" "7 Me & F Room 9 Hired Help", size(small)) name(WhoCleans, replace) 


//WhoCleansMF
gen WhoCleansMF = 0
replace WhoCleansMF = 1 if WhoCleans == 1
replace WhoCleansMF = 2 if Me == . & (FemalePartner == 300 | FemaleRoommates == 50000 | FemaleChildren == 7000000 | Mom == 900000000)
replace WhoCleansMF = 3 if Me == . & (MalePartner == 20 | MaleRoommates == 4000 | MaleChildren == 600000)
replace WhoCleansMF = 4 if Me == 1 & (FemalePartner == 300 | FemaleRoommates == 50000 | FemaleChildren == 7000000 | Mom == 900000000)
replace WhoCleansMF = 5 if Me == 1 & (MalePartner == 20 | MaleRoommates == 4000 | MaleChildren == 600000)
replace WhoCleansMF = 6 if Me == 1 & (MalePartner == 20 | MaleRoommates == 4000 | MaleChildren == 600000) & (FemalePartner == 300 | FemaleRoommates == 50000 | FemaleChildren == 7000000 | Mom == 900000000)
replace WhoCleansMF = 7 if Me == . & (MalePartner == 20 | MaleRoommates == 4000 | MaleChildren == 600000) & (FemalePartner == 300 | FemaleRoommates == 50000 | FemaleChildren == 7000000 | Mom == 900000000)

label define whocleansmf 0 "Other" 1 "Me only" 2 "Female, not Me" 3 "Male, not Me" 4 "Me & Female" 5 "Me & Male" 6 "Me & Male & Female" 7 "Male & Female, not Me" 
label values WhoCleansMF whocleansmf

twoway histogram WhoCleansMF, frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(0 1 2 3 4 5 6 7) xlabel(0 1 2 3 4 5 6 7) note("0 Other 1 Me only 2 Female, not Me" "3 Male, Not me 4 Me & Female 5 Me & Male" "6 Me & Male & Female 7 Male & Female, not Me", size(small)) name(WhoCleansMF, replace) 


//WhoCleansType
gen WhoCleansType = 0
replace WhoCleansType = 1 if WhoCleans == 1
replace WhoCleansType = 2 if Me == 1 & (MalePartner == 20 | FemalePartner == 300)
replace WhoCleansType = 3 if Me == . & (MalePartner == 20 | FemalePartner == 300)
replace WhoCleansType = 4 if Me == 1 & (MaleRoommates == 4000 | FemaleRoommates == 50000)  
replace WhoCleansType = 6 if Me == 1 & Hiredhelp == 80000000 
replace WhoCleansType = 7 if Me == . & Hiredhelp == 80000000 

label define whocleanstype 0 "Other" 1 "Me only" 2 "Me & Partner" 3 "Partner, not Me" 4 "Me & Roommate(s)" 5 "Me & Hired Help" 6 "Hired Help, not Me"
label values WhoCleansType whocleanstype

twoway histogram WhoCleansType, frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(0 1 2 3 4 5 6 7) xlabel(0 1 2 3 4 5 6 7) note("0 Other 1 Me only 2 Me & Partner" "3 Partner, not Me 4 Me & Roommate 5 6 Me & Hired Help 7 Hired Help, not Me", size(small)) name(WhoCleansType, replace) 

graph combine WhoCleans WhoCleansMF WhoCleansType
graph export WhoCleans.eps, replace


//PercentIClean
rename Whatfrom0100oftheho PercentIClean
label variable PercentIClean "PercentIClean"
replace PercentIClean = 0 if PercentIClean == .

tabulate PercentIClean, generate(PIC)
graph pie PIC1 PIC2 PIC3 PIC4 PIC5 PIC6 PIC7 PIC8 PIC9 PIC10 PIC11 PIC12 PIC13 PIC14

replace PercentIClean = 1 if PercentIClean > 0  & PercentIClean < 26
replace PercentIClean = 2 if PercentIClean > 25 & PercentIClean < 51
replace PercentIClean = 3 if PercentIClean > 50 & PercentIClean < 76
replace PercentIClean = 4 if PercentIClean > 75 & PercentIClean < 101
label define percentages 0 "0%" 1 "1 - 25%" 2 "26 - 50%" 3 "51 - 75%" 4 "76 - 100%"
label values PercentIClean percentages

tabulate PercentIClean, generate(PIC_)
graph pie PIC_1 PIC_2 PIC_3 PIC_4 PIC_5, legend(cols(1)) name(PercentIClean, replace) 


//MostRecentClean
rename Whendidyoumostrecentlydoso MostRecentClean
replace MostRecentClean = "1" if MostRecentClean == "Within the past day"
replace MostRecentClean = "2" if MostRecentClean == "Within the past week"
replace MostRecentClean = "3" if MostRecentClean == "Within the past 2 weeks"
replace MostRecentClean = "4" if MostRecentClean == "Within the past month"
replace MostRecentClean = "5" if MostRecentClean == "Within the past 6 months"

destring MostRecentClean, replace
label define mostrecentclean 1 "Past day" 2 "Past week" 3 "Past 2 weeks" 4 "Past month" 5 "Past 6 Months"  
label values MostRecentClean mostrecentclean

tabulate MostRecentClean, generate(MRC)
graph pie MRC1 MRC2 MRC3 MRC4 MRC5, legend(cols(1)) name(MostRecentClean, replace)


//CleanDistRating
rename Iamhappywithhowhouseholdcl CleanDistRating
label variable CleanDistRating "Cleaning Distribution Rating"
label define opinionscale 1 "Completely Dissatisfied" 3 "Neither Satisfied nor Dissatisfied" 5 "Completely Satisfied" 
label values CleanDistRating opinionscale

tabulate CleanDistRating, generate(CDR)
graph pie CDR1 CDR2 CDR3 CDR4 CDR5, legend(cols(1)) name(CleanDistRating, replace)


//HomeCleanRating
rename Iamsatisfiedwithmyhomescu HomeCleanRating
label variable HomeCleanRating "Home Clean Rating"
label values HomeCleanRating opinionscale

tabulate HomeCleanRating, generate(HCR)
graph pie HCR1 HCR2 HCR3 HCR4 HCR5, legend(cols(1)) name(HomeCleanRating, replace)

graph combine PercentIClean MostRecentClean CleanDistRating HomeCleanRating
graph export CleaningDistribution_Satisfaction.eps, replace


//DifficultRoom
rename W DifficultRoomOther
gen DifficultRoom = 0
replace DifficultRoom = 1 if Whichisthemostdifficultroom == "Bedroom"
replace DifficultRoom = 2 if Whichisthemostdifficultroom == "Living Room"
replace DifficultRoom = 3 if Whichisthemostdifficultroom == "Kitchen"
replace DifficultRoom = 4 if Whichisthemostdifficultroom == "Home Office"
replace DifficultRoom = 5 if Whichisthemostdifficultroom == "Bathroom"
replace DifficultRoom = 6 if Whichisthemostdifficultroom == "Hallway(s)"
replace DifficultRoom = 7 if Whichisthemostdifficultroom == "Basement"
replace DifficultRoom = 8 if Whichisthemostdifficultroom == "Attic"
replace DifficultRoom = 9 if Whichisthemostdifficultroom == "Garage"
replace DifficultRoom = 999 if Whichisthemostdifficultroom == "None"
replace DifficultRoom = 12 if DifficultRoomOther == "daughter's room"
replace DifficultRoom = 13 if DifficultRoomOther == "Windows throughout apartment"
label variable DifficultRoom "Most Difficult Room Clean"
label values DifficultRoom rooms

replace DifficultRoom = 7 if inrange(DifficultRoom,8,999) | DifficultRoom == 2 | DifficultRoom == 4

twoway histogram DifficultRoom if (DifficultRoom == 1 | DifficultRoom == 3 | DifficultRoom == 5| DifficultRoom == 7), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 3 5 7) xlabel(1 3 5 7) note("1 Bedroom 3 Kitchen 5 Bathroom 7 Other", size(small)) name(DifficultRoom, replace) 

//TimeConsumingRoom
//Takes care of same as above option
gen TimeConsumingSame = ""
gsort UniqueID Whichisthemosttimeconsuming
by UniqueID: replace TimeConsumingSame = "Same" if Whichisthemosttimeconsuming == "Same as above"
by UniqueID: replace Whichisthemosttimeconsuming = Whichisthemostdifficultroom[1] if Whichisthemosttimeconsuming == "Same as above"

gen TimeConsumingRoom = 0
replace TimeConsumingRoom = 1 if Whichisthemosttimeconsuming == "Bedroom"
replace TimeConsumingRoom = 2 if Whichisthemosttimeconsuming == "Living Room"
replace TimeConsumingRoom = 3 if Whichisthemosttimeconsuming == "Kitchen"
replace TimeConsumingRoom = 4 if Whichisthemosttimeconsuming == "Home Office"
replace TimeConsumingRoom = 5 if Whichisthemosttimeconsuming == "Bathroom"
replace TimeConsumingRoom = 6 if Whichisthemosttimeconsuming == "Hallway(s)"
replace TimeConsumingRoom = 7 if Whichisthemosttimeconsuming == "Basement"
replace TimeConsumingRoom = 8 if Whichisthemosttimeconsuming == "Attic"
replace TimeConsumingRoom = 9 if Whichisthemosttimeconsuming == "Garage"
replace TimeConsumingRoom = 999 if Whichisthemosttimeconsuming == "None"
label variable TimeConsumingRoom "Most Time Consuming Room Clean"
label values TimeConsumingRoom rooms

replace TimeConsumingRoom = 7 if inrange(TimeConsumingRoom,6,999) | TimeConsumingRoom == 4

twoway histogram TimeConsumingRoom if (TimeConsumingRoom == 1 | TimeConsumingRoom == 2 | TimeConsumingRoom == 3 | TimeConsumingRoom == 5 | TimeConsumingRoom == 7), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 3 5 7) xlabel(1 2 3 5 7) note("1 Bedroom 2 Living Room 3 Kitchen 5 Bathroom 7 Other", size(small)) name(TimeConsumingRoom, replace) 


//DislikeRoom
rename AC DislikeRoomOther 
gen DislikeRoomSame = ""
gsort UniqueID Whichistheroomyoudislikecl
by UniqueID: replace DislikeRoomSame = "Same" if Whichistheroomyoudislikecl == "Same as above"
by UniqueID: replace Whichistheroomyoudislikecl = Whichisthemosttimeconsuming[1] if Whichistheroomyoudislikecl == "Same as above"

gen DislikeRoom = 0
label variable DislikeRoom "Most Disliked Room Clean"

replace DislikeRoom = 1 if Whichistheroomyoudislikecl == "Bedroom"
replace DislikeRoom = 2 if Whichistheroomyoudislikecl == "Living Room"
replace DislikeRoom = 3 if Whichistheroomyoudislikecl == "Kitchen"
replace DislikeRoom = 4 if Whichistheroomyoudislikecl == "Home Office"
replace DislikeRoom = 5 if Whichistheroomyoudislikecl == "Bathroom"
replace DislikeRoom = 6 if Whichistheroomyoudislikecl == "Hallway(s)"
replace DislikeRoom = 7 if Whichistheroomyoudislikecl == "Basement"
replace DislikeRoom = 8 if Whichistheroomyoudislikecl == "Attic"
replace DislikeRoom = 9 if Whichistheroomyoudislikecl == "Garage"
replace DislikeRoom = 14 if DislikeRoomOther == "I hate to clean any and all rooms!"
replace DislikeRoom = 999 if Whichistheroomyoudislikecl == "None"

label values DislikeRoom rooms

replace DislikeRoom = 7 if inrange(DislikeRoom,6,999) | DislikeRoom == 4
twoway histogram DislikeRoom if (DislikeRoom == 1 | DislikeRoom == 3 | DislikeRoom == 5 | DislikeRoom == 7), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 3 5 7) xlabel(1 3 5 7) note("1 Bedroom 3 Kitchen 5 Bathroom 7 Other", size(small)) name(DislikeRoom, replace) 

graph combine DifficultRoom TimeConsumingRoom DislikeRoom RoomMostTime
graph export Combo_Dislike_Difficult_DislikeRoom.eps, replace 


//SatisfyRoom
gen SatisfyRoom = 0
label variable SatisfyRoom "Most Satisfying Room Clean"
replace SatisfyRoom = 1 if Oftheroomsinyourhomewhich == "Bedroom"
replace SatisfyRoom = 2 if Oftheroomsinyourhomewhich == "Living Room"
replace SatisfyRoom = 3 if Oftheroomsinyourhomewhich == "Kitchen"
replace SatisfyRoom = 4 if Oftheroomsinyourhomewhich == "Home Office"
replace SatisfyRoom = 5 if Oftheroomsinyourhomewhich == "Bathroom"
replace SatisfyRoom = 6 if Oftheroomsinyourhomewhich == "Hallway(s)"
replace SatisfyRoom = 7 if Oftheroomsinyourhomewhich == "Basement"
replace SatisfyRoom = 8 if Oftheroomsinyourhomewhich == "Attic"
replace SatisfyRoom = 9 if Oftheroomsinyourhomewhich == "Garage"
replace SatisfyRoom = 99 if Oftheroomsinyourhomewhich == "None"
label values SatisfyRoom rooms


replace SatisfyRoom = 7 if inrange(SatisfyRoom ,8,99) | SatisfyRoom == 4 | SatisfyRoom == 6

twoway histogram SatisfyRoom if (SatisfyRoom == 1 | SatisfyRoom == 2 | SatisfyRoom == 3 | SatisfyRoom == 5 | SatisfyRoom == 7), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 3 5 7) xlabel(1 2 3 5 7) note("1 Bedroom 2 Living Room 3 Kitchen 5 Bathroom 7 Other", size(small)) name(SatisfyRoom, replace) 


//OneCleanRoom
gen OneCleanRoom = 0
label variable OneCleanRoom "Choose 1 Room to Clean"
replace OneCleanRoom = 1 if Ifforyournextcleaningsessio == "Bedroom"
replace OneCleanRoom = 2 if Ifforyournextcleaningsessio == "Living Room"
replace OneCleanRoom = 3 if Ifforyournextcleaningsessio == "Kitchen"
replace OneCleanRoom = 4 if Ifforyournextcleaningsessio == "Home Office"
replace OneCleanRoom = 5 if Ifforyournextcleaningsessio == "Bathroom"
replace OneCleanRoom = 6 if Ifforyournextcleaningsessio == "Hallway(s)"
replace OneCleanRoom = 7 if Ifforyournextcleaningsessio == "Basement"
replace OneCleanRoom = 8 if Ifforyournextcleaningsessio == "Attic"
replace OneCleanRoom = 9 if Ifforyournextcleaningsessio == "Garage"
replace OneCleanRoom = 999 if Ifforyournextcleaningsessio == "None"
label values OneCleanRoom rooms

replace OneCleanRoom = 7 if inrange(OneCleanRoom ,8,99) | OneCleanRoom == 4 | OneCleanRoom == 6

twoway histogram OneCleanRoom if (OneCleanRoom == 1 | OneCleanRoom == 2 | OneCleanRoom == 3 | OneCleanRoom == 5 | OneCleanRoom == 7), frequency discrete ysize(10) xsize(10) barwidth(1) xmtick(1 2 3 5 7) xlabel(1 2 3 5 7) note("1 Bedroom 2 Living Room 3 Kitchen 5 Bathroom 7 Other", size(small)) name(OneCleanRoom, replace) 

graph combine SatisfyRoom OneCleanRoom
graph export Combo_Satisfy_OneClean_Room.eps,replace

//~~Most recent cleaning session ~~//
//RCS_TimeSpentCleaning
gen RCS_TimeSpentCleaning = 0
replace RCS_TimeSpentCleaning = 1 if Howmuchtimedidyouspendclea == "5 minutes or less"
replace RCS_TimeSpentCleaning = 2 if Howmuchtimedidyouspendclea == "15 minutes or less"
replace RCS_TimeSpentCleaning = 3 if Howmuchtimedidyouspendclea == "30 minutes or less"
replace RCS_TimeSpentCleaning = 4 if Howmuchtimedidyouspendclea == "60 minutes or less"
replace RCS_TimeSpentCleaning = 5 if Howmuchtimedidyouspendclea == "2 hours or less"
replace RCS_TimeSpentCleaning = 6 if Howmuchtimedidyouspendclea == "Over 2 hours"
label define timespentcleaning 0 "N/A" 1 "< 5min" 2 "< 15min" 3 "< 30min" 4 "< 60min" 5 "< 2 hours" 6 "> 2 hours"
label values RCS_TimeSpentCleaning timespentcleaning

tabulate RCS_TimeSpentCleaning, generate(TSC)
graph pie TSC2 TSC3 TSC4 TSC5 TSC6 TSC7, name(RCS_TimeSpentCleaning, replace) legend(cols(1)) 
graph export TimeSpentCleaning.eps, replace

//RCS_WhodYouCleanWith`
gen RCS_WhodYouCleanWith = 0
replace RCS_WhodYouCleanWith = 1 if Didyoucleanbyyourselforhav == "Self"
replace RCS_WhodYouCleanWith = 2 if Didyoucleanbyyourselforhav == "With companion"
replace RCS_WhodYouCleanWith = 3 if Didyoucleanbyyourselforhav == "Hired help"
replace RCS_WhodYouCleanWith = 4 if Didyoucleanbyyourselforhav == "With automation (dishwasher, robot vacuum, Alexa, etc.)"
label define whodyoucleanwith 0 "N/A" 1 "Self" 2 "With companion" 3 "Hired help" 4 "With automation"
label values RCS_WhodYouCleanWith whodyoucleanwith

tabulate RCS_WhodYouCleanWith, generate(WYCW)
graph pie WYCW1 WYCW2 WYCW3 WYCW4 WYCW5, name(RCS_WhodYouCleanWith, replace) legend(cols(1)) 


/*
//Skip this for now cause only 4 ppl used automation
//RCS_AutomationType
replace Dishwasher = "1" if Dishwasher == "Dishwasher"
replace LaundryWasher = "20" if LaundryWasher == "Laundry Washer"
replace LaundryDryer = "300" if LaundryDryer == "Laundry Dryer"
replace LaundryDryer = "300" if LaundryDryer == "Laundry Dryer"

destring Dishwasher LaundryWasher LaundryDryer, replace
egen RCS_AutomationType = rowtotal(Dishwasher LaundryWasher LaundryDryer)
*/


//RCS_CleaningMotivation
replace Scheduledcleaningday = "1" if Scheduledcleaningday == "Scheduled cleaning day"
replace Feelingdisorganizedmessy = "20" if Feelingdisorganizedmessy == "Feeling disorganized / messy"
replace Hadfreetime = "300" if Hadfreetime == "Had free time"
replace Visitors = "4000" if Visitors == "Visitors"
replace Messoccurredspillsaccidents = "50000" if Messoccurredspillsaccidents == "Mess occurred (spills, accidents, etc.)"

destring Scheduledcleaningday Feelingdisorganizedmessy Hadfreetime Visitors Messoccurredspillsaccidents, replace
egen RCS_CleaningMotivation = rowtotal(Scheduledcleaningday Feelingdisorganizedmessy Hadfreetime Visitors Messoccurredspillsaccidents)

replace RCS_CleaningMotivation = 2 if RCS_CleaningMotivation == 20
replace RCS_CleaningMotivation = 3 if RCS_CleaningMotivation == 300
replace RCS_CleaningMotivation = 4 if RCS_CleaningMotivation == 301
replace RCS_CleaningMotivation = 5 if RCS_CleaningMotivation == 320
replace RCS_CleaningMotivation = 6 if RCS_CleaningMotivation == 4320
replace RCS_CleaningMotivation = 7 if RCS_CleaningMotivation == 50000
replace RCS_CleaningMotivation = 8 if RCS_CleaningMotivation == 50020

label define cleaningmotivation 1 "Scheduled" 2 "Feel Messy" 3 "Had Free Time" 4 "Free time & Scheduled" 5 "Free Time & Feel messy" 6 "Visitors, Free Time, Feel Messy" 7 "Mess Happened" 8 "Mess Happened & Feel Messy"
label values RCS_CleaningMotivation cleaningmotivation

twoway histogram RCS_CleaningMotivation if (RCS_CleaningMotivation == 1 | RCS_CleaningMotivation == 2 | RCS_CleaningMotivation == 5 | RCS_CleaningMotivation == 6), frequency discrete barwidth(1) xmtick(1 2 5 6) xlabel(1 2 5 6) note("1 Scheduled 2 Feel Messy 5 Free Time & Feel messy" "6 Visitors, Free Time, Feel Messy", size(small)) name(RCS_CleaningMotivation, replace) 


//RCS_HomeAreasCleaned
replace Bedroom = "1" if Bedroom == "Bedroom"
replace HomeOffice = "20" if HomeOffice == "Home Office"
replace LivingRoom = "300" if LivingRoom == "Living Room"
replace Bathroom = "4000" if Bathroom == "Bathroom"
replace Kitchen = "50000" if Kitchen == "Kitchen"
replace Basement = "600000" if Basement == "Basement"
replace Hallways = "7000000" if Hallways == "Hallway(s)"
destring Bedroom HomeOffice LivingRoom Bathroom Kitchen Basement Hallways, replace
egen RCS_HomeAreasCleaned = rowtotal(Bedroom HomeOffice LivingRoom Bathroom Kitchen Basement Hallways)

replace RCS_HomeAreasCleaned = 2 if RCS_HomeAreasCleaned == 50000
replace RCS_HomeAreasCleaned = 3 if RCS_HomeAreasCleaned == 50001
replace RCS_HomeAreasCleaned = 4 if RCS_HomeAreasCleaned == 50300
replace RCS_HomeAreasCleaned = 5 if RCS_HomeAreasCleaned == 54301 | RCS_HomeAreasCleaned == 54321
replace RCS_HomeAreasCleaned = 6 if RCS_HomeAreasCleaned == 7054301 | RCS_HomeAreasCleaned == 7054321

label define homeareascleaned 1 "Bedroom" 2 "Kitchen" 3 "Kitchen & Bedroom" 4 "Kitchen & Living Room" 5 "Kitchen & Bathroom & Living Room & Bedroom" 6 "Hallways & 3+ Rooms"
label values RCS_HomeAreasCleaned homeareascleaned

twoway histogram RCS_HomeAreasCleaned if (RCS_HomeAreasCleaned == 1 | RCS_HomeAreasCleaned == 2 | RCS_HomeAreasCleaned == 4 | RCS_HomeAreasCleaned == 5), frequency discrete barwidth(1) xmtick(1 2 4 5) xlabel(1 2 4 5) note("1 Bedroom 2 Kitchen 4 Kitchen & Living Room" "5 Kitchen & Bathroom & Living Room & Bedroom", size(small)) name(RCS_HomeAreasCleaned, replace) 


//RCS_CleaningTasksDone
replace Reorganizingclutter = "1" if Reorganizingclutter == "Reorganizing clutter"
replace Movingclutterwithoutreorgani = "1" if Movingclutterwithoutreorgani == "Moving clutter (without reorganizing)"
replace Floorcleaningswifferingmopp = "1" if Floorcleaningswifferingmopp == "Floor cleaning (swiffering, mopping, vacuuming etc.)"
replace Nonfloorsurfacecleaningwind = "1" if Nonfloorsurfacecleaningwind == "Non-floor surface cleaning (windows, countertops, toilets, tables, etc.)"
replace Spotcleaningspillaccident = "1" if Spotcleaningspillaccident == "Spot cleaning (spill, accident, etc.)"
replace Washingcookwareanddishes = "1" if Washingcookwareanddishes == "Washing cookware and dishes"
replace Laundry = "1" if Laundry == "Laundry"
destring Reorganizingclutter Movingclutterwithoutreorgani Floorcleaningswifferingmopp Nonfloorsurfacecleaningwind Spotcleaningspillaccident Washingcookwareanddishes Laundry, replace

gen RCS_CleaningTasksDone = 0
replace RCS_CleaningTasksDone = 1 if Reorganizingclutter == 1
replace RCS_CleaningTasksDone = 2 if Movingclutterwithoutreorgani == 1
replace RCS_CleaningTasksDone = 3 if Floorcleaningswifferingmopp == 1
replace RCS_CleaningTasksDone = 4 if Nonfloorsurfacecleaningwind == 1
replace RCS_CleaningTasksDone = 5 if Spotcleaningspillaccident == 1
replace RCS_CleaningTasksDone = 6 if Washingcookwareanddishes == 1
replace RCS_CleaningTasksDone = 7 if Laundry == 1

graph pie Reorganizingclutter Movingclutterwithoutreorgani Floorcleaningswifferingmopp Nonfloorsurfacecleaningwind Spotcleaningspillaccident Washingcookwareanddishes Laundry, name(RCS_CleaningTasksDone, replace) legend(cols(1)) 

/*
replace Reorganizingclutter = "1" if Reorganizingclutter == "1"
replace Movingclutterwithoutreorgani = "20" if Movingclutterwithoutreorgani == "1"
replace Floorcleaningswifferingmopp = "300" if Floorcleaningswifferingmopp == "1"
replace Nonfloorsurfacecleaningwind = "4000" if Nonfloorsurfacecleaningwind == "1"
replace Spotcleaningspillaccident = "50000" if Spotcleaningspillaccident == "1"
replace Washingcookwareanddishes = "600000" if Washingcookwareanddishes == "1"
replace Laundry = "7000000" if Laundry == "1"
destring Reorganizingclutter Movingclutterwithoutreorgani Floorcleaningswifferingmopp Nonfloorsurfacecleaningwind Spotcleaningspillaccident Washingcookwareanddishes Laundry, replace
egen RCS_CleaningTasksCompleted = rowtotal(Reorganizingclutter Movingclutterwithoutreorgani Floorcleaningswifferingmopp Nonfloorsurfacecleaningwind Spotcleaningspillaccident Washingcookwareanddishes Laundry)

//Finish up later
//label define cleaningtaskscompleted 1 "Reorganize Clutter" 2 "Spot Clean" 3 "Spot Clean & Organize Clutter" 4 "Spot & Floor Clean" 5 "Spot, Floor, Surface Clean, Organize Clutter" 6 "Spot, Surface, Floor Clean, Organize Clutter" 7 "Laundry & 3+ Other Cleaning Tasks"
//label values RCS_CleaningTasksCompleted cleaningtaskscompleted
*/

//Combine graphs
graph combine RCS_WhodYouCleanWith RCS_CleaningTasksDone, ysize(20) xsize(20) 
graph export Combo_RecentCleaningSession1.eps, replace

graph combine RCS_CleaningMotivation RCS_HomeAreasCleaned 
graph export Combo_RecentCleaningSession2.eps, replace

cd "/Users/peggychau/Desktop/capstone_survey/graphs/descriptive_vacuum"


//VacuumModel
replace Handheld = "1" if Handheld == "Handheld"
replace Upright = "20" if Upright == "Upright"
replace Canister = "300" if Canister == "Canister"
replace Stick = "4000" if Stick == "Stick"
replace Drum = "50000" if Drum == "Drum"
replace Robotic = "600000" if Robotic == "Robotic"
replace Donotownanyvacuums = "0" if Donotownanyvacuums == "Do not own any vacuums"

destring Handheld Upright Canister Stick Drum Robotic Donotownanyvacuums, replace
egen VacuumModel = rowtotal(Handheld Upright Canister Stick Drum Robotic Donotownanyvacuums)

tab VacuumModel, sort

replace VacuumModel = 2 if VacuumModel == 20
replace VacuumModel = 3 if VacuumModel == 21
replace VacuumModel = 4 if VacuumModel == 300

label define vacuummodel 1 "Handheld" 2 "Upright" 3 "Upright & Handheld" 4 "Canister"
label values VacuumModel vacuummodel

twoway histogram VacuumModel if (VacuumModel == 2 | VacuumModel == 3 | VacuumModel == 4), frequency discrete barwidth(1) xmtick(2 3 4) xlabel(2 3 4) note("2 Upright 3 Upright & Handheld 4 Canister", size(small)) name(VacuumModel, replace) 

/*
replace Handheld = 1 if Handheld == 1
replace Upright = 2 if Upright == 20
replace Canister = 3 if Canister == 300
replace Stick = 4 if Stick == 4000
replace Drum = 7 if Drum == 50000
replace Robotic = 5 if Robotic == 600000
replace Donotownanyvacuums = 6 if Donotownanyvacuums == 0

graph pie Handheld Upright Canister Stick Drum Robotic Donotownanyvacuums, name(VacuumModel, replace) legend(cols(1)) 
*/

//VacuumPurchaser
replace BZ = "1" if BZ == "Me"
replace Roommates = "2" if Roommates == "Roommate(s)"
replace Partners = "3" if Partners == "Partner(s)"
replace Previoustenant = "4" if Previoustenant == "Previous tenant"
replace Wasgiftedtoyou = "5" if Wasgiftedtoyou == "Was gifted to you"
//replace CF = "6" if CF == "Parent" | CF == "Parents"
rename Wasgiftedtoyou Gifted
destring BZ Roommates Partners Previoustenant Gifted, replace

gen VacuumPurchaser = 0
replace VacuumPurchaser = 1 if BZ == 1
replace VacuumPurchaser = 2 if Roommates == 2
replace VacuumPurchaser = 3 if Partners == 3
replace VacuumPurchaser = 4 if Previoustenant == 4
replace VacuumPurchaser = 5 if Gifted == 5

graph pie BZ Roommates Partners Children Previoustenant Gifted, name(VacuumPurchaser, replace) legend(cols(1)) 


/*
replace BZ = "1" if BZ == "Me"
replace Roommates = "20" if Roommates == "Roommate(s)"
replace Partners = "300" if Partners == "Partner(s)"
replace Previoustenant = "4000" if Previoustenant == "Previous tenant"
replace Wasgiftedtoyou = "50000" if Wasgiftedtoyou == "Was gifted to you"
replace CF = "600000" if CF == "Parent" | CF == "Parents"

destring BZ Roommates Partners Previoustenant Wasgiftedtoyou CF, replace
egen VacuumPurchaser = rowtotal(BZ Roommates Partners Previoustenant Wasgiftedtoyou CF)

replace VacuumPurchaser = 2 if VacuumPurchaser == 20
replace VacuumPurchaser = 3 if VacuumPurchaser == 301
replace VacuumPurchaser = 4 if VacuumPurchaser == 4000
replace VacuumPurchaser = 5 if VacuumPurchaser == 50000

label define vacuumpurchaser 1 "Me" 2 "Roommate(s)" 3 "Partner & Me" 4 "Previous Tenant" 5 "Gifted"
label values VacuumPurchaser vacuumpurchaser
*/

//twoway histogram VacuumPurchaser if (VacuumPurchaser == 1 | VacuumPurchaser == 2 | VacuumPurchaser == 3 | VacuumPurchaser == 4 | VacuumPurchaser == 5), frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3 4 5) xmtick(1 2 3 4 5) note("1 Me 2 Roommates 3 Partner & Me 4 Previous Tenants 5 Gifted", size(small)) name(VacuumPurchaser, replace)


//VacuumPurchaseFactors
replace Performance = "1" if Performance == "Performance"
replace Price = "1" if Price == "Price"
replace Goodvalue = "1" if Goodvalue == "Good value"
replace Easytomaneuver = "1" if Easytomaneuver == "Easy to maneuver "
replace EnergyEfficient = "1" if EnergyEfficient == "Energy Efficient"
replace Howlongthevacuumwilllast = "1" if Howlongthevacuumwilllast == "How long the vacuum will last"
replace Convenience = "1" if Convenience == "Convenience"
replace Lightweight = "1" if Lightweight == "Lightweight"
replace Aestheticallylooksgood = "1" if Aestheticallylooksgood == "Aesthetically looks good"
replace Easytouse = "1" if Easytouse == "Easy to use"
replace Trustedbrand = "1" if Trustedbrand == "Trusted brand"
replace Compactness = "1" if Compactness == "Compactness"
replace Lownoiselevel = "1" if Lownoiselevel == "Low noise level"

destring Performance Price Goodvalue Easytomaneuver EnergyEfficient Howlongthevacuumwilllast Convenience Compactness Lightweight Aestheticallylooksgood Easytouse Lownoiselevel Trustedbrand, replace

gen VacuumPurchaseFactors = 0
replace VacuumPurchaseFactors = 1 if Performance == 1
replace VacuumPurchaseFactors = 2 if Price == 1
replace VacuumPurchaseFactors = 3 if Goodvalue == 1
replace VacuumPurchaseFactors = 4 if Easytomaneuver == 1
replace VacuumPurchaseFactors = 5 if EnergyEfficient == 1
replace VacuumPurchaseFactors = 6 if Howlongthevacuumwilllast == 1
replace VacuumPurchaseFactors = 7 if Lightweight == 1
replace VacuumPurchaseFactors = 8 if Aestheticallylooksgood == 1
replace VacuumPurchaseFactors = 9 if Easytouse == 1
replace VacuumPurchaseFactors = 10 if Trustedbrand == 1
replace VacuumPurchaseFactors = 11 if Compactness == 1
replace VacuumPurchaseFactors = 12 if Lownoiselevel == 1
replace VacuumPurchaseFactors = 13 if Convenience == 1

graph pie Performance Price Goodvalue Easytomaneuver EnergyEfficient Howlongthevacuumwilllast Convenience Compactness Lightweight Easytouse Lownoiselevel Trustedbrand, name(VacuumPurchaseFactors, replace) legend(cols(1))


/*
replace Performance = "1" if Performance == "Performance"
replace Price = "20" if Price == "Price"
replace Goodvalue = "300" if Goodvalue == "Good value"
replace Easytomaneuver = "4000" if Easytomaneuver == "Easy to maneuver "
replace EnergyEfficient = "50000" if EnergyEfficient == "Energy Efficient"
replace Howlongthevacuumwilllast = "600000" if Howlongthevacuumwilllast == "How long the vacuum will last"
replace Convenience = "7000000" if Convenience == "Convenience"
replace Lightweight = "80000000" if Lightweight == "Lightweight"
replace Aestheticallylooksgood = "90000000" if Aestheticallylooksgood == "Aesthetically looks good"
replace Easytouse = "0.1" if Easytouse == "Easy to use"
replace Trustedbrand = "0.02" if Trustedbrand == "Trusted brand"
replace Compactness = "0.003" if Compactness == "Compactness"
replace Lownoiselevel = "0.0004" if Lownoiselevel == "Low noise level"


destring Performance Price Goodvalue Easytomaneuver EnergyEfficient Howlongthevacuumwilllast Convenience Compactness Lightweight Aestheticallylooksgood Easytouse Lownoiselevel Trustedbrand, replace
egen VacuumPurchaseFactors = rowtotal(Performance Price Goodvalue Easytomaneuver EnergyEfficient Howlongthevacuumwilllast Convenience Compactness Lightweight Aestheticallylooksgood Easytouse Lownoiselevel Trustedbrand)
*/

graph combine VacuumPurchaser VacuumPurchaseFactors
graph export VacPurchaseFactors.eps, replace


//MostRecentTimeVacuum
gen MostRecentTimeVacuum = 0
replace MostRecentTimeVacuum = 1 if CU == "Within the past day"
replace MostRecentTimeVacuum = 2 if CU == "Within the past week"
replace MostRecentTimeVacuum = 3 if CU == "Within the past 2 weeks"
replace MostRecentTimeVacuum = 4 if CU == "Within the past month"
replace MostRecentTimeVacuum = 5 if CU == "Within the past 6 months"

label define mostrecenttimevacuumed 0 "N/A" 1 "Past day" 2 "Past week" 3 "Past 2 weeks" 4 "Past month" 5 "Past 6 months"
label values MostRecentTimeVacuum mostrecenttimevacuumed

tabulate MostRecentTimeVacuum, generate(MRTV)
graph pie MRTV2 MRTV3 MRTV4 MRTV5 MRTV6, name(MostRecentTimeVacuum, replace) legend(cols(1))


//CarpetCleanliness
gen CarpetCleanliness = 0
replace CarpetCleanliness = 1 if Whichpicturebestmatcheswhat == "Carpet A"
replace CarpetCleanliness = 2 if Whichpicturebestmatcheswhat == "Carpet B"
replace CarpetCleanliness = 3 if Whichpicturebestmatcheswhat == "Carpet C"
replace CarpetCleanliness = 4 if Whichpicturebestmatcheswhat == "Do not have carpet"

label define carpetcleanliness 0 "N/A" 1 "Dirty" 2 "Clean" 3 "Average" 4 "Don't have carpet"
label values CarpetCleanliness carpetcleanliness

tabulate CarpetCleanliness, generate(CaCl)
graph pie CaCl2 CaCl3 CaCl4 CaCl5, name(CarpetCleanliness, replace) legend(cols(1))


//VacuumType
replace Generalvacuuming = "1" if Generalvacuuming == "General vacuuming"
replace Spotcleaningcleanedupaspil = "20" if Spotcleaningcleanedupaspil == "Spot cleaning (cleaned up a spill, etc.)"
destring Generalvacuuming Spotcleaningcleanedupaspil, replace
egen VacuumType = rowtotal(Generalvacuuming Spotcleaningcleanedupaspil)

replace VacuumType = 2 if VacuumType == 20
replace VacuumType = 3 if VacuumType == 21

label define vacuumtype 1 "General Vacuuming" 2 "Spot Clean" 3 "General Vacuuming & Spot Clean"
label values VacuumType vacuumtype

twoway histogram VacuumType if (VacuumType == 1 | VacuumType == 2 | VacuumType == 3), frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3) xmtick(1 2 3) note("1 General Vacuuming 2 Spot Vacuuming 3 General & Spot Vacuuming", size(small)) name(VacuumType, replace)


//WhodYouVacuumWith
replace Bymyself = "1" if Bymyself == "By myself"
replace Withcompanion = "1" if Withcompanion == "With companion"
replace Withrobotvacuum = "1" if Withrobotvacuum == "With robot vacuum"
replace Withhiredhelp = "1" if Withhiredhelp == "With hired help"

destring Bymyself Withcompanion Withrobotvacuum Withhiredhelp, replace

gen WhodYouVacuumWith = 0
replace WhodYouVacuumWith = 1 if Bymyself == 1
replace WhodYouVacuumWith = 2 if Withcompanion == 1
replace WhodYouVacuumWith = 3 if Withrobotvacuum == 1
replace WhodYouVacuumWith = 4 if Withhiredhelp == 1

graph pie Bymyself Withcompanion Withrobotvacuum Withhiredhelp, name(WhodYouVacuumWith, replace) legend(cols(1))

graph combine MostRecentTimeVacuum CarpetCleanliness VacuumType WhodYouVacuumWith
graph export Vac1.eps, replace

//VacuumPrepTime
gen VacuumPrepTime = 0
replace VacuumPrepTime = 1 if Howmuchtimedidyouspendprep == "None"
replace VacuumPrepTime = 2 if Howmuchtimedidyouspendprep == "1 - 15 minutes"
replace VacuumPrepTime = 3 if Howmuchtimedidyouspendprep == "16 - 30 minutes"
replace VacuumPrepTime = 4 if Howmuchtimedidyouspendprep == "31 minutes - 1 hour"

label define time 0 "N/A" 1 "No prep" 2 "1 - 15 minutes" 3 "16 - 30 minutes" 4 "31 minutes - 1 hour" 5 "Over 1 hour"
label values VacuumPrepTime time

twoway histogram VacuumPrepTime if (VacuumPrepTime != 0 & VacuumPrepTime != 1), frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3 4) xmtick(1 2 3 4) note("1 None 2: 1 - 15 minutes 3: 16 - 30 minutes 4: 31 minutes - 1 hour 5: Over 1 hour", size(small)) name(VacuumPrepTime, replace)


//VacuumTime
gen VacuumTime = 0
replace VacuumTime = 1 if Howmuchtimedidyouspendvacu == "None"
replace VacuumTime = 2 if Howmuchtimedidyouspendvacu == "1 - 15 minutes"
replace VacuumTime = 3 if Howmuchtimedidyouspendvacu == "16 - 30 minutes"
replace VacuumTime = 4 if Howmuchtimedidyouspendvacu == "31 minutes - 1 hour"
replace VacuumTime = 5 if Howmuchtimedidyouspendvacu == "Over 1 hour"

label values VacuumTime time

twoway histogram VacuumTime if (VacuumTime != 0 & VacuumTime != 1), frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3 4 5) xmtick(1 2 3 4 5) note("1 None 2: 1 - 15 minutes 3: 16 - 30 minutes 4: 31 minutes - 1 hour 5: Over 1 hour", size(small)) name(VacuumTime, replace)


//RoomsVacuumed
replace Theentirehome = "1" if Theentirehome == "The entire home"
replace VR1 = "1" if VR1 == "Bedroom"
replace VR2 = "1" if VR2 == "Living Room"
replace VR3 = "1" if VR3 == "Kitchen"
replace VR4 = "1" if VR4 == "Bathroom"
replace VR5 = "1" if VR5 == "Hallway(s)"
replace VR6 = "1" if VR6 == "Basement"

destring Theentirehome VR1 VR2 VR3 VR4 VR5 VR6, replace
label define vacuumedrooms 1 "The Entire Home" 2 "Bedroom" 3 "Living Room" 4 "Kitchen" 5 "Bathroom" 6 "Hallway(s)" 7 "Basement"

gen RoomsVacuumed = 0
replace RoomsVacuumed = 1 if VR1 == 1
replace RoomsVacuumed = 2 if VR2 == 1
replace RoomsVacuumed = 3 if VR3 == 1
replace RoomsVacuumed = 4 if VR4 == 1
replace RoomsVacuumed = 5 if VR5 == 1
replace RoomsVacuumed = 6 if VR6 == 1
graph pie Theentirehome VR1 VR2 VR3 VR4 VR5 VR6, name(RoomsVacuumed, replace) legend(cols(1))  


//FloorTypesVacuumed
replace Carpet = "1" if Carpet == "Carpet"
replace Hardwood = "2" if Hardwood == "Hardwood"
replace Tile = "3" if Tile == "Tile"
replace Laminate = "4" if Laminate == "Laminate"
replace Rugs = "5" if Rugs == "Rug(s)"
replace Stone = "6" if Stone == "Stone"

destring Carpet Hardwood Tile Laminate Rugs Stone, replace
label define floortypes 1 "Carpet" 2 "Hardwood" 3 "Tile" 4 "Laminate" 5 "Rug(s)" 6 "Stone"

gen FloorTypesVacuumed = 0
replace FloorTypesVacuumed = 1 if Carpet == 1
replace FloorTypesVacuumed = 2 if Hardwood == 2
replace FloorTypesVacuumed = 3 if Tile == 3
replace FloorTypesVacuumed = 4 if Laminate == 4
replace FloorTypesVacuumed = 5 if Rugs == 5
replace FloorTypesVacuumed = 6 if Stone == 6

graph pie Carpet Hardwood Tile Laminate Rugs Stone, name(FloorTypesVacuumed, replace) legend(cols(1))

graph combine VacuumPrepTime VacuumTime FloorTypesVacuumed RoomsVacuumed
graph export Vac2.eps, replace


/*
replace Carpet = "1" if Carpet == "Carpet"
replace Hardwood = "20" if Hardwood == "Hardwood"
replace Tile = "300" if Tile == "Tile"
replace Laminate = "4000" if Laminate == "Laminate"
replace Rugs = "50000" if Rugs == "Rug(s)"
replace Stone = "600000" if Stone == "Stone"

destring Carpet Hardwood Tile Laminate Rugs Stone, replace
egen FloorTypesVacuumed = rowtotal(Carpet Hardwood Tile Laminate Rugs Stone)
*/

//VacuumUsabilityRating
rename Myvacuumiseasytouse VacuumUsabilityRating
label values VacuumUsabilityRating opinionscale

twoway histogram VacuumUsabilityRating, frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3 4 5) xmtick(1 2 3 4 5) note("1 Hard to Use 3 Neutral 5: Easy to Use", size(small)) name(VacuumUsabilityRating, replace)


//VacuumEffectiveRating
rename Myvacuumiseffectiveatcleani VacuumEffectiveRating
label values VacuumEffectiveRating opinionscale
twoway histogram VacuumEffectiveRating, frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3 4 5) xmtick(1 2 3 4 5) note("1 Ineffective 3 Neutral 5: Effective", size(small)) name(VacuumEffectiveRating, replace)


//WhyNoRobovac
replace Poorperformance = "1" if Poorperformance == "Poor performance"
replace Tooexpensive = "2" if Tooexpensive == "Too expensive"
replace Notpractical = "3" if Notpractical == "Not practical"
replace Notenergyefficient = "4" if Notenergyefficient == "Not energy efficient"
replace Preferusingtraditionalcleanin = "5" if Preferusingtraditionalcleanin == "Prefer using traditional cleaning methods"
replace Privacyconcerns = "6" if Privacyconcerns == "Privacy concerns"
replace Neverconsideredit = "7" if Neverconsideredit == "Never considered it"
replace Icurrentlyownarobotvacuum = "8" if Icurrentlyownarobotvacuum == "I currently own a robot vacuum"

destring Poorperformance Tooexpensive Notpractical Notenergyefficient Preferusingtraditionalcleanin Privacyconcerns Neverconsideredit Icurrentlyownarobotvacuum, replace

gen WhyNoRobovac = 0
replace WhyNoRobovac = 1 if Poorperformance == 1
replace WhyNoRobovac = 2 if Tooexpensive == 2
replace WhyNoRobovac = 3 if Notpractical == 3
replace WhyNoRobovac = 4 if Notenergyefficient == 4
replace WhyNoRobovac = 5 if Preferusingtraditionalcleanin == 5
replace WhyNoRobovac = 6 if Privacyconcerns == 6
replace WhyNoRobovac = 7 if Neverconsideredit == 7
replace WhyNoRobovac = 8 if Icurrentlyownarobotvacuum == 8

graph pie Poorperformance Tooexpensive Notpractical Notenergyefficient Preferusingtraditionalcleanin Privacyconcerns Neverconsideredit Icurrentlyownarobotvacuum, name(WhyNoRobovac, replace) legend(cols(1))

graph combine VacuumUsabilityRating VacuumEffectiveRating 
graph export VacRatings.eps, replace

graph combine VacuumModel WhyNoRobovac
graph export VacModels.eps, replace


cd "/Users/peggychau/Desktop/capstone_survey/graphs/descriptive_demographics"

//WorkIndustry
//Do analyses w/ and w/o Student & Unemployed & Technology
gen WorkIndustry = 0
replace WorkIndustry = 1 if Whichindustrydoyouprimarily == "Student"
replace WorkIndustry = 2 if Whichindustrydoyouprimarily == "Education"
replace WorkIndustry = 3 if Whichindustrydoyouprimarily == "Healthcare"
replace WorkIndustry = 4 if Whichindustrydoyouprimarily == "Retail"
replace WorkIndustry = 5 if Whichindustrydoyouprimarily == "Manufacturing"
replace WorkIndustry = 6 if Whichindustrydoyouprimarily == "Banking / Finance"
replace WorkIndustry = 7 if Whichindustrydoyouprimarily == "Insurance"
replace WorkIndustry = 8 if Whichindustrydoyouprimarily == "Communications"
replace WorkIndustry = 9 if Whichindustrydoyouprimarily == "Transportation"
replace WorkIndustry = 10 if Whichindustrydoyouprimarily == "Government"
replace WorkIndustry = 11 if Whichindustrydoyouprimarily == "Hospitality"
replace WorkIndustry = 12 if Whichindustrydoyouprimarily == "Technology"
replace WorkIndustry = 13 if Whichindustrydoyouprimarily == "Unemployed"
replace WorkIndustry = 99 if Whichindustrydoyouprimarily == "Prefer not to respond"

rename EM WorkIndustryOther
replace WorkIndustry = 14 if WorkIndustryOther == "Full time mum"
replace WorkIndustry = 14 if WorkIndustryOther == "Stay at home parent"
replace WorkIndustry = 14 if WorkIndustryOther == "Stay at home mom"
replace WorkIndustry = 15 if WorkIndustryOther == "Legal"
replace WorkIndustry = 16 if WorkIndustryOther == "Social Services"

label define work 0 "N/A" 1 "Student" 2 "Education" 3 "Healthcare" 4 "Retail" 5 "Manufacturing" 6 "Banking / Finance" 7 "Insurance" 8 "Communications" 9 "Transportation" 10 "Government" 11 "Hospitality" 12 "Technology" 13 "Unemployed" 14 "Homemaker" 15 "Legal" 16 "Social Services" 99 "Prefer not to respond"
label values WorkIndustry work

replace WorkIndustry = 3 if WorkIndustry == 8
replace WorkIndustry = 4 if WorkIndustry == 12
replace WorkIndustry = 5 if WorkIndustry > 9

twoway histogram WorkIndustry if(inrange(WorkIndustry,1,5)), frequency discrete ysize(10) xsize(10) barwidth(1) xlabel(1 2 3 4 5) xmtick(1 2 3 4 5) note("1 Student 2 Education 3 Communications 4 Technology 5 Other", size(small)) name(WorkIndustry, replace)


//Income
gen Income = 0
replace Income = 1 if Whatisyourapproximateyearly == "Less than $20,000"
replace Income = 2 if Whatisyourapproximateyearly == "$20,000 - $34,999"
replace Income = 3 if Whatisyourapproximateyearly == "$35,000 - $49,999"
replace Income = 4 if Whatisyourapproximateyearly == "$50,000 - $74,999"
replace Income = 5 if Whatisyourapproximateyearly == "$75,000 - $99,999"
replace Income = 6 if Whatisyourapproximateyearly == "$100,000 - $149,999"
replace Income = 7 if Whatisyourapproximateyearly == "$150,000 - $199,999"
replace Income = 8 if Whatisyourapproximateyearly == "$200,000 or more"
replace Income = 999 if Whatisyourapproximateyearly == "Prefer not to respond"

label define income 0 "N/A" 1 "Less than $20,000" 2 "$20,000 - $34,999" 3 "$35,000 - $49,999" 4 "$50,000 - $74,999" 5 "$75,000 - $99,999" 6 "$100,000 - $149,999" 7 "$150,000 - $199,999" 8 "$200,000 or more" 999 "Prefer not to respond" 
label values Income income

tabulate Income, generate(MI)
graph pie MI1 MI2 MI3 MI4 MI5 MI6 MI7 MI8 MI9, name(Income, replace) legend(cols(1))
 
graph combine WorkIndustry Income 
graph export Work_Income.eps, replace

//Age
gen Age = 0
//take out 17 or younger
replace Age = 1 if Whatagegroupdoyoubelongto == "17 or younger"
replace Age = 2 if Whatagegroupdoyoubelongto == "18 - 22"
replace Age = 3 if Whatagegroupdoyoubelongto == "23 - 29"
replace Age = 4 if Whatagegroupdoyoubelongto == "30 - 39"
replace Age = 5 if Whatagegroupdoyoubelongto == "40 - 49"
replace Age = 6 if Whatagegroupdoyoubelongto == "50 - 59"
replace Age = 7 if Whatagegroupdoyoubelongto == "60 - 69"
replace Age = 8 if Whatagegroupdoyoubelongto == "70 or older"
label define age 0 "N/A" 1 "17 or younger" 2 "18 - 22" 3 "23 - 29" 4 "30 - 39" 5 "40 - 49" 6 "50 - 59" 7 "60 - 69" 8 "70 or older"
label values Age age

tabulate Age, generate(A)
graph pie A1 A2 A3 A4 A5 A6 A7 A8, name(Age, replace)


//Gender
gen Gender = 0
replace Gender = 1 if Whichgenderdoyouidentifyas == "Male"
replace Gender = 2 if Whichgenderdoyouidentifyas == "Female"
label define gender 0 "N/A" 1 "Male" 2 "Female"   
label values Gender gender

tabulate Gender, generate(G)
graph pie G2 G3, name(Gender, replace)


//Race
replace AfricanAmerican = "1" if AfricanAmerican == "African American"
replace AsianPacificIslander = "20" if AsianPacificIslander == "Asian / Pacific Islander"
replace White = "300" if White == "White"
replace HispanicorLatinx = "4000" if HispanicorLatinx == "Hispanic or Latinx"
//replace NativeAmerican = "5" if NativeAmerican == "NativeAmerican"
//replace Prefernottorespond = "999" if Prefernottorespond == "Prefernottorespond"

destring AfricanAmerican AsianPacificIslander White HispanicorLatinx, replace
egen Race = rowtotal(AfricanAmerican AsianPacificIslander White HispanicorLatinx)
label define race 0 "N/A" 1 "African American"  20 "Asian / Pacific Islander" 300 "White" 4000 "Hispanic / Latinx" 50000 "Native American" 999 "Prefer not to respond"
label values Race race

tabulate Race, generate(R)
graph pie R1 R2 R3 R4, name(Race, replace) legend(cols(1))

graph combine Age Gender Race 
graph export Age_Gender_Race.eps, replace

//Region
gen Region = 0
replace Region = 1 if WhichregionoftheUSdoyouli == "Northeast (NY, PA, etc.)"
replace Region = 2 if WhichregionoftheUSdoyouli == "Midwest (IL, ND, etc.)"
replace Region = 3 if WhichregionoftheUSdoyouli == "South (TX, FL, etc.)"
replace Region = 4 if WhichregionoftheUSdoyouli == "West (CA, CO, etc.)"
replace Region = 5 if WhichregionoftheUSdoyouli == "Pacific (AK, HI)"
replace Region = 6 if WhichregionoftheUSdoyouli == "U.S. Territory (Puerto Rico, Guam, etc.)"
replace Region = 99 if WhichregionoftheUSdoyouli == "I do not live in the US"
replace Region = 999 if WhichregionoftheUSdoyouli == "Prefer not to respond"
label define region 0 "N/A" 1 "Northeast" 2 "Midwest" 3 "South" 4 "West" 5 "Pacific" 6 "U.S. Territory" 99 "Not in U.S." 999 "Prefer not to respond"
label values Region region

tabulate Region, generate(Re)
graph pie Re1 Re2 Re3 Re4 Re5 Re6, name(Region, replace)

//Pets
replace Cats = "1" if Cats == "Cat(s)"
replace Dogs = "20" if Dogs == "Dog(s)"
replace Birds = "300" if Birds == "Bird(s)"
replace Smallmammalshamstergerbil = "4000" if Smallmammalshamstergerbil == "Small mammal(s) (hamster, gerbil, guinea pig, hedgehog, etc.)"
replace Idonotownanypets = "999" if Idonotownanypets == "I do not own any pet(s)"
destring Cats Dogs Birds Smallmammalshamstergerbil Idonotownanypets, replace
egen Pets = rowtotal(Cats Dogs Birds Smallmammalshamstergerbil Idonotownanypets)
label define pets 0 "N/A" 1 "Cat(s)" 20 "Dog(s)" 21 "Cat(s) & Dog(s)" 300 "Bird(s)" 321 " Bird(s) Dog(s) & Cat(s)" 4020 "Small mammals & Dog(s)" 4000 "Small mammals" 999 "Don't own pets"  
label values Pets pets

tabulate Pets, generate(Pe)
graph pie Pe1 Pe2 Pe3 Pe4 Pe5 Pe6 Pe7, name(Pets, replace)  legend(cols(1))


//Kids
replace Howmanytoddlerspreschoolers = "1" if Howmanytoddlerspreschoolers == "5 or more" | Howmanytoddlerspreschoolers == "1"  | Howmanytoddlerspreschoolers == "2"
replace Howmanychildrenaged612 = "1"  if Howmanychildrenaged612 == "1"  | Howmanychildrenaged612 == "2"s
replace Howmanyteenagersaged1317 = "1"  if Howmanyteenagersaged1317 == "1"  | Howmanyteenagersaged1317 == "2"s
destring Howmanytoddlerspreschoolers Howmanychildrenaged612 Howmanyteenagersaged1317 Doyouhaveanychildreninyour, replace
replace Doyouhaveanychildreninyour = 2 if Doyouhaveanychildreninyour == 0
label define yn 1 "Yes" 2 "No" 
label values Doyouhaveanychildreninyour yn 

graph pie Doyouhaveanychildreninyour, name(Kids, replace)
graph pie Howmanytoddlerspreschoolers Howmanychildrenaged612 Howmanyteenagersaged1317, name(KidsbyAge, replace)

graph combine Region Pets Kids KidsbyAge 
graph export Region_Pets_Kids.eps, replace


cd "/Users/peggychau/Desktop/capstone_survey/graphs/descriptive_health"

//AllergiesAsthma
replace YesIdo = "1" if YesIdo == "Yes, I do"
replace Yesafamilymemberdoes = "20" if Yesafamilymemberdoes == "Yes, a family member does"
replace Yesapartnerdoes = "300" if Yesapartnerdoes == "Yes, a partner does"
replace Yesaroommatedoes = "4000" if Yesaroommatedoes == "Yes, a roommate does"
replace No = "9999" if No == "No"
destring YesIdo Yesafamilymemberdoes Yesapartnerdoes Yesaroommatedoes No, replace
egen AllergiesAsthma = rowtotal(YesIdo Yesafamilymemberdoes Yesapartnerdoes Yesaroommatedoes No)
label define allergiesasthma 0 "N/A" 1 "Me only" 21 "Me & Family Member" 20 "Family Member only" 300 "Partner only" 301 "Me & Partner" 4000 "Roommate only" 4001 "Me & Roommate" 9999 "No" 
label values AllergiesAsthma allergiesasthma

tabulate AllergiesAsthma, generate(AA)
graph pie AA1 AA2 AA3 AA4 AA5 AA6 AA7 AA8, legend(cols(1)) name(AllergiesAsthma, replace)

//AllergyTypes
replace SeasonalAllergiesspringpol = "1" if SeasonalAllergiesspringpol == "Seasonal Allergies (spring / pollen allergies, hay fever, etc.)"
replace CatAllergies = "2" if CatAllergies == "Cat Allergies"
replace DogAllergies = "3" if DogAllergies == "Dog Allergies"
replace MoldAllergies = "4" if MoldAllergies == "Mold Allergies"
replace DustAllergies = "5" if DustAllergies == "Dust Allergies"
replace ChemicalAllergieslotionscle = "6" if ChemicalAllergieslotionscle == "Chemical Allergies (lotions, cleaning products, detergents, etc.)"
destring SeasonalAllergiesspringpol CatAllergies DogAllergies MoldAllergies DustAllergies ChemicalAllergieslotionscle, replace

gen AllergyTypes = 0
replace AllergyTypes = 1 if SeasonalAllergiesspringpol == 1
replace AllergyTypes = 2 if CatAllergies == 2
replace AllergyTypes = 3 if DogAllergies == 3
replace AllergyTypes = 4 if MoldAllergies == 4
replace AllergyTypes = 5 if DustAllergies == 5
replace AllergyTypes = 6 if ChemicalAllergieslotionscle == 6

graph pie SeasonalAllergiesspringpol CatAllergies DogAllergies MoldAllergies DustAllergies ChemicalAllergieslotionscle, legend(cols(1)) name(AllergyTypes, replace)
graph combine AllergiesAsthma AllergyTypes
graph export AllergiesAsthma1.eps, replace

/*
replace SeasonalAllergiesspringpol = "1" if SeasonalAllergiesspringpol == "Seasonal Allergies (spring / pollen allergies, hay fever, etc.)"
replace CatAllergies = "20" if CatAllergies == "Cat Allergies"
replace DogAllergies = "300" if DogAllergies == "Dog Allergies"
replace MoldAllergies = "4000" if MoldAllergies == "Mold Allergies"
replace DustAllergies = "50000" if DustAllergies == "Dust Allergies"
replace ChemicalAllergieslotionscle = "600000" if ChemicalAllergieslotionscle == "Chemical Allergies (lotions, cleaning products, detergents, etc.)"
destring SeasonalAllergiesspringpol CatAllergies DogAllergies MoldAllergies DustAllergies ChemicalAllergieslotionscle, replace
egen AllergyTypes = rowtotal (SeasonalAllergiesspringpol CatAllergies DogAllergies MoldAllergies DustAllergies ChemicalAllergieslotionscle)
label define allergytypes 0 "N/A" 1 "Seasonal" 20 "Cat" 21 "Seasonal, Cat" 300 "Dog" 4000 "Mold" 4001 "Mold, Seasonal" 4021 "Mold, Cat, Seasonal" 50000 "Dust" 600000 "Chemical" 50001 "Dust, Seasonal" 50321 "Dust, Cat, Dog, Seasonal" 
*/

//AllergyAsthmaCleanTasks
replace AC1 = "1" if AC1 == "Reorganizing clutter"
replace AC2 = "2" if AC2 == "Moving clutter (without reorganizing)"
replace AC3 = "3" if AC3 == "Floor cleaning (swiffering, mopping, vacuuming, etc.)"
replace AC4 = "4" if AC4 == "Non-floor surface cleaning (windows, countertops, toilets, tables, etc.)"
replace Spotcleaningspillsaccidents = "5" if Spotcleaningspillsaccidents == "Spot cleaning (spills, accidents, etc.)"
replace Doinglaundry = "6" if Doinglaundry == "Doing laundry"
replace AC5 = "7" if AC5 == "Washing cookware and dishes"
replace AC6 = "8" if AC6 == "None"

destring AC1 AC2 AC3 AC4 Spotcleaningspillsaccidents Doinglaundry AC5 AC6, replace

gen AllergyAsthmaCleanTasks = 0
replace AllergyAsthmaCleanTasks = 1 if AC1 == 1
replace AllergyAsthmaCleanTasks = 2 if AC2 == 2
replace AllergyAsthmaCleanTasks = 3 if AC3 == 3
replace AllergyAsthmaCleanTasks = 4 if AC4 == 4
replace AllergyAsthmaCleanTasks = 5 if AC5 == 7
replace AllergyAsthmaCleanTasks = 6 if AC6 == 8
replace AllergyAsthmaCleanTasks = 7 if Spotcleaningspillsaccidents == 5
replace AllergyAsthmaCleanTasks = 8 if Doinglaundry == 6

graph pie AC1 AC2 AC3 AC4 Spotcleaningspillsaccidents AC5 AC6, legend(cols(1)) name(AllergyAsthmaCleanTasks, replace)

//AllergyAsthmaProducts
replace AirPurifierHEPAFilter = "1" if AirPurifierHEPAFilter == "Air Purifier / HEPA Filter"
replace Humidifier = "2" if Humidifier == "Humidifier"
replace Dehumidifier = "3" if Dehumidifier == "Dehumidifier"
replace Fantablefloor = "4" if Fantablefloor == "Fan (table / floor)"
replace Filtersforfurnaceaircondit = "5" if Filtersforfurnaceaircondit == "Filters for furnace / air conditioner"
replace Allergysafecleaningproducts = "6" if Allergysafecleaningproducts == "Allergy-safe cleaning products"
replace Hypoallergenicbedding = "7" if Hypoallergenicbedding == "Hypoallergenic bedding"
replace GX = "7" if GX == "None" | GX == "none"

destring AirPurifierHEPAFilter Humidifier Dehumidifier Fantablefloor Filtersforfurnaceaircondit Allergysafecleaningproducts Hypoallergenicbedding GX, replace

gen AllergyAsthmaProducts = 0
replace AllergyAsthmaProducts = 1 if AirPurifierHEPAFilter == 1
replace AllergyAsthmaProducts = 2 if Humidifier == 2
replace AllergyAsthmaProducts = 3 if Dehumidifier == 3
replace AllergyAsthmaProducts = 4 if Fantablefloor == 4
replace AllergyAsthmaProducts = 5 if Filtersforfurnaceaircondit == 5
replace AllergyAsthmaProducts = 6 if Allergysafecleaningproducts == 6
replace AllergyAsthmaProducts = 7 if Hypoallergenicbedding == 7


graph pie AirPurifierHEPAFilter Humidifier Dehumidifier Fantablefloor Filtersforfurnaceaircondit Allergysafecleaningproducts Hypoallergenicbedding GX, legend(cols(1)) name(AllergyAsthmaProducts, replace)

graph combine AllergyAsthmaCleanTasks AllergyAsthmaProducts
graph export AllergyAsthmaManagement.eps, replace

//AllergyAsthmaCleanRate
rename Forthenextquestionpleasere AllergyAsthmaCleanRate
label variable AllergyAsthmaCleanRate "Allergy / Asthma Affects my Cleaning Rating"
replace AllergyAsthmaCleanRate = 0 if CleanDistRating == .
label define cleanrate 1 "Completely Disagree" 3 "Neutral" 5 "Completely Agree"
label values AllergyAsthmaCleanRate cleanrate

tabulate AllergyAsthmaCleanRate, generate(AAC)

graph pie AAC1 AAC2 AAC3 AAC4 AAC5 AAC6, legend(cols(1)) name(AllergyAsthmaCleanRate, replace) title("Allergy / Asthma Affects my Cleaning Rating")
graph export AllergyAsthmaCleanRate.eps, replace


cd "/Users/peggychau/Desktop/capstone_survey/graphs/correlations_cleaning_demographics"

//Start the mass correlations of household cleaning x demographics here 
local n = 2
foreach x in RoomMostTime WhoCleans PercentIClean MostRecentClean CleanDistRating HomeCleanRating DifficultRoom TimeConsumingRoom DislikeRoom SatisfyRoom OneCleanRoom RCS_TimeSpentCleaning RCS_WhodYouCleanWith RCS_CleaningMotivation RCS_HomeAreasCleaned RCS_CleaningTasksDone VacuumModel VacuumPurchaser VacuumPurchaseFactors MostRecentTimeVacuum CarpetCleanliness VacuumType WhodYouVacuumWith VacuumPrepTime VacuumTime RoomsVacuumed FloorTypesVacuumed VacuumUsabilityRating VacuumEffectiveRating WhyNoRobovac AllergyAsthmaCleanTasks AllergyAsthmaProducts AllergyAsthmaCleanRate {
	foreach y in WorkIndustry Income Age Gender Race Region Pets AllergiesAsthma AllergyTypes {
		di "Spearman Corr (p = 0.05) `x' vs. `y'"
		spearman `x' `y', stats(rho p) matrix star (0.05) print(.05)
		return list
			putexcel A1 = "Cleaning Variables"
			putexcel B1 = "Demographic Variables"
			putexcel C1 = "Significant p value (p < 0.05)"
		if matrix(r(p)) < 0.05 {
			putexcel set "correlations.xlsx", modify
			putexcel A`n' = "`x'"
			putexcel B`n' = "`y'"
			putexcel C`n' = matrix(r(p))
			local n = `n' + 1
		}
	}
}


//if matrix(r(p)) < 0.05 then 
cd "/Users/peggychau/Desktop/capstone_survey/graphs/correlations_cleaning_demographics"

ssc install catplot




//DO CleanDistRating x PercentIClean For all people

//DO CleanDistRating x PercentIClean For ONLY if other people also clean in my household
//Takes out ppl who live alone for example.

