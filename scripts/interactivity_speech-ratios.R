library(ggplot2)
library(ggpubr)


datadir = paste(getwd(), sep="/")
metadata <- read.csv("D:/OneDrive/UdS/chic/2019-interspeech-gong/data/metadata.csv")
affils <-  read.csv("D:/OneDrive/UdS/Dissertation/manuscript/scripts/speaker_affiliation.csv", sep=",", stringsAsFactors=FALSE)


# calculate interactivity (percentage of slices in which the speaker changes)
calculateInteractivity <- function(df) {
    df <- df[order(df$start), ] # sort data based on start time
    df$speakerSwitch <- with(df, c(FALSE, speaker[-1L] != speaker[-length(speaker)])) # determine whether the speaker changed
    speakerSwitchSequences = rle(df$speakerSwitch) # get length of changed/uncahnged speaker sequences
    rle.df = data.frame(unclass(speakerSwitchSequences))# make a dataframe from that
    noBackchannels = nrow(rle.df[rle.df$lengths == 2 & rle.df$values == TRUE, ]) # two changes in a row means speaker changed for once slice. this is considered a backchannel
    switchFreqs = as.data.frame(table(df$speakerSwitch)) # dataframe of speaker switch indicators
    interactivity = (switchFreqs$Freq[switchFreqs$Var1 == TRUE] - noBackchannels) / length(df$speakerSwitch) # excluding backchanneling
    interactivity_BC = (switchFreqs$Freq[switchFreqs$Var1 == TRUE]) / length(df$speakerSwitch) # including backchanneling
    
    return(c(interactivity, interactivity_BC))
}

# claculate talking percentage of each speaker and speech ratio
calculateTalkingPercentages <- function(df) {
    
    # get speaker affiliations
    speakers = unique(as.character(df$speaker))
    if (length(speakers) > 2) {
        warning(paste("Conversation has", length(speaker), "speakers. Continuing with first two only."))
    }
    
    speaker1ID = gsub("#", "", unique(as.character(df$speaker))[1])
    speaker1affil = toupper(affils$affiliation[affils$speaker_id == as.numeric(speaker1ID)])
    speaker2ID = gsub("#", "", unique(as.character(df$speaker))[2])
    speaker2affil = toupper(affils$affiliation[affils$speaker_id == as.numeric(speaker2ID)])
    
    if (speaker1affil == speaker2affil) {
        warning("speakers have same affiliation!")
    }
    
    df$duration <- df$end - df$start # add slice duration column
    df$affiliation = toupper(df$affiliation)
    durA = sum(df$duration[df$affiliation == speaker1affil]) # total speaker A talking duration
    durB = sum(df$duration[df$affiliation == speaker2affil]) # total speaker B talking duration
    durT = durA + durB # total talking duration
    perA = durA / durT # talking ratio for speaker A
    perB = durB / durT # talking ratio for speaker B
    speechBalance = 1 - abs(perA - perB) # speech balance measure
    speaksMore = ifelse(perA > perB, speaker1affil, speaker2affil)
    
    return(c(speechBalance, speaksMore))
}

table = data.frame(stringsAsFactors=FALSE)

feature = "pitch_1"
swFiles <- gsub(".csv$", "", dir(datadir, pattern =".csv"))
for (swFile in swFiles) {
    # print(paste0("now plotting", swFile, "..."))
    data <- read.csv(paste0(datadir, "/", swFile, ".csv"), sep=",")
    data.sel = data
    data.sel = data.sel[!is.na(data.sel$speaker),]        
    data.sel = data.sel[!is.na(data.sel[feature]),]
    data.sel = data.sel[data.sel[feature] > 0,]  # is this good/necessary?
        
    interactivities = calculateInteractivity(data.sel)
    balance = calculateTalkingPercentages(data.sel)
    success = metadata$Y_stage_backward[metadata$call_id_str == paste0(swFile, "_")]
    
    # print(paste0("interactivity: ", interactivities))
    # print(paste0("speech balance: ", speechBalance))
    # print(paste0("success: ", success))
    
    newvals = c(
        round(interactivities[1], digits=2),
        round(interactivities[2], digits=2),
        round(as.numeric(balance[1]), digits=2),
        balance[2],  # speaks_more
        round(success))
    table = rbind(table, newvals, stringsAsFactors=FALSE)
    
}

colnames(table) <- c("interactivity", "interactivity_BC", "speech_balance", "speaks_more", "success")
# table$interactivity = as.numeric(interactivity)
# table$interactivity_BC = as.numeric(interactivity_BC)
# table$speech_balance = as.numeric(speech_balance)
# table$speaks_more = as.numeric(speaks_more)

table = na.omit(table)

dodge_width <- position_dodge(width=.5)
comparisons_success <- list(c("0", "1"))
ggplot(table, aes(x=success, y=as.numeric(speech_balance), fill=speaks_more)) +
    geom_violin(draw_quantiles=c(.25, .5, .75), position=dodge_width) +
    geom_boxplot(width=.12, position=dodge_width) +
    scale_y_continuous(limits=c(0, 1.12)) +
    stat_compare_means(comparisons=comparisons_success, aes(group=success), method="t.test", label="p.signif", label.y=1.1, label.x=1, vjust=-1, size=8) +
    stat_compare_means(aes(group=speaks_more), method="anova", label="p.signif", label.y=1.05, size=8, vjust=1) +
    theme(legend.position=c(0.85, .1), axis.title = element_text(size=16), axis.text =  element_text(size=12)) +
    scale_fill_manual(values = c("tomato2", "royalblue2"), labels=c("rep", "prospect")) +
    xlab("Call outcome") +
    ylab("Speech balance") 
    scale_x_discrete(labels=c("successful", "failed"))
    

ggplot(table, aes(x=interactivity, y=speech_balance, color=speaks_more, shape=success)) +
    geom_point(size=2)
    # geom_point(aes(shape=speaks_more, color=success), size=2) +
    # geom_smooth(method = "lm") +
    # theme(axis.text.x = element_text(angle=90))

total = nrow(table)

num_company =  nrow(table[table$speaks_more == "COMPANY",])
num_noncompany =  nrow(table[table$speaks_more == "NONCOMPANY",])

perc_company = num_company / total
perc_noncompany = num_noncompany / total

num_company_success = nrow(table[table$speaks_more == "COMPANY" & table$success == 0,])
num_noncompany_success = nrow(table[table$speaks_more == "NONCOMPANY" & table$success == 0,])

num_company_success / num_company 
num_noncompany_success / num_noncompany

num_company_success / total
(total - num_company_success) / total
num_noncompany_success / total
(total - num_noncompany_success) / total





