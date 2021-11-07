####
### Violin Plots
### MDG/TDG
### Nicole Schwitter
### 2021-10-18
####

####
### 0. Libraries ----
####
library(haven)
library(ggplot2)
library(ggthemes)

df <- read_dta("Data_Fourcountry_Main_20211007_anonymised_prepared.dta")


# Dropping missing values
df <- df[!is.na(df$percentkepttg ),]
df <- df[!is.na(df$percentgivendg ),]



##Pooled model 
ggplot(df[df$receiverdg!=0 & !is.na(df$percentgivendg),], 
       aes(y=percentgivendg, x=as.factor(receiverdg))) + 
  geom_violin(alpha=0.7, fill= "red") +
  stat_summary(fun.data = "mean_cl_boot", geom = "pointrange",
               colour = "black") +
  ylab("") + xlab("") + # ylab("Percentage shared")
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        panel.grid = element_line(linetype="dotted", colour="black"),
        panel.border = element_blank(),
        axis.line.y = element_line())

ggsave(file="violindg_pooled_col.eps")


ggplot(df[df$receivertg!=0 & !is.na(df$percentkepttg),], 
       aes(y=percentkepttg, x=as.factor(receivertg))) + 
  geom_violin(alpha=0.7, fill= "blue") +
  stat_summary(fun.data = "mean_cl_boot", geom = "pointrange",
               colour = "black") +
  ylab("") + xlab("") + 
  theme_bw() +
  theme(axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        panel.grid = element_line(linetype="dotted", colour="black"),
        panel.border = element_blank(),
        axis.line.y = element_line())

ggsave(file="violintg_pooled_col.eps")