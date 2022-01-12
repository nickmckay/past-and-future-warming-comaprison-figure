library(tidyverse)
library(readxl)
library(geoChronR)
library(cowplot)
library(scales)
library(ggpp)
library(ncdf4)
library(egg)


# Load in the data --------------------------------------------------------

allData <- read_xlsx("data/TemperatureData.xlsx",sheet = 2,skip = 1)

instrumental <- allData[,1:4] %>% 
  rename(year = 1,gmsta = 2,cl05 = 3,cl95 = 4)

temp12k <- allData[,6:9] %>% 
  rename(`Age (BP)` = 1,gmsta = 2,cl05 = 3,cl95 = 4)

#get osman data from netcdf
osmanNc <- nc_open("data/LGMR_GMST_ens.nc")
osmanAge <- seq(to = 23900,from = 100,by = 200)

gmstEns <- ncvar_get(osmanNc, "gmst")
gmstq <- apply(gmstEns,1,quantile,probs = c(0.05,.5,.95))

#get 1850 anomaly
gmst1850 <- gmstq[2,1]

gmstqa <- gmstq - gmst1850

#write out the data for future reference
rbind(osmanAge,gmstqa) %>% 
  t() %>% 
  as.data.frame() %>% 
  setNames(c("Age (yr BP)","5% cl","median GMST","95% cl")) %>% 
  write_csv(file = "data/Osman GMST and Confidence Limits.csv")

#or load from excel
osman <- allData[,11:14] %>% 
  rename(`Age (BP)` = 1,gmsta = 2,cl05 = 3,cl95 = 4)

hansen <- allData[,16:18] %>% 
  rename(gmst = 2,gmsta = 3) %>% mutate(stack = "Hansen et al.")


snyder <- allData[,20:22] %>% 
  rename(gmstOrig = 2,gmsta = 3) %>% mutate(stack = "Snyder et al.")

prehol <- bind_rows(hansen,snyder) %>% filter(`Age (BP)` > 12000)


SSP2_6 <- read_xlsx("data/TemperatureData.xlsx",sheet = 3,skip = 2,range = "A2:D453") %>% 
  mutate(ssp = "SSP1-2.6")
SSP4_5 <- read_xlsx("data/TemperatureData.xlsx",sheet = 3,skip = 2,range = "F2:I453")%>% 
  mutate(ssp = "SSP2-4.5")
SSP7_0 <- read_xlsx("data/TemperatureData.xlsx",sheet = 3,skip = 2,range = "K2:N453")%>% 
  mutate(ssp = "SSP3-7.0")

projections <- bind_rows(SSP2_6,SSP4_5,SSP7_0) %>% 
  filter(year > 2020) %>% 
  filter(ssp %in% c("SSP1-2.6","SSP2-4.5","SSP3-7.0")) %>% 
  rename(mean = `mean (°C)`)

ylimits <- c(-6,8)






#calculate some bins
binvec <- seq(50,160050,by = 200)
benthicBins <- bin(hansen$`Age (BP)...16`,hansen$gmsta,bin.vec = binvec) %>% 
  mutate(stack = "Hansen et al.")
plankticBins <- bin(snyder$`Age (BP)...20`,snyder$gmsta,bin.vec = binvec) %>% 
  mutate(stack = "Snyder et al.")

deepBins <- bind_rows(benthicBins,plankticBins) %>% 
  filter(is.finite(y)) %>% 
  filter(x > 10000)


temp12kBins <- bin(temp12k$`Age (BP)`,values = temp12k$gmsta,bin.vec = binvec)
temp12kBinsHi <- bin(temp12k$`Age (BP)`,values = temp12k$cl95,bin.vec = binvec)
temp12kBinsLo <- bin(temp12k$`Age (BP)`,values = temp12k$cl05,bin.vec = binvec)

#sspbins
yearbinvec <- c(1900,2100,2300)
instp <- rename(instrumental,mean = gmsta) %>% 
  mutate(`0.05` = cl05, `0.95` = cl95)

ssps <- unique(projections$ssp)

for(i in 1:length(ssps)){
  tssp <- ssps[i]
  sp <- filter(projections, ssp == tssp) %>% 
    bind_rows(instp)
  
  SSPbins <- bin(sp$year,values = sp$mean,bin.vec = yearbinvec)
  SSPbinsHi <- bin(sp$year,values = sp$`0.95`,bin.vec = yearbinvec)
  SSPbinsLo <- bin(sp$year,values = sp$`0.05`,bin.vec = yearbinvec)
  
  sspbins <- data.frame(year = SSPbins$x,
                        mean = SSPbins$y,
                        cl05 = SSPbinsLo$y,
                        cl95 = SSPbinsHi$y,
                        ssp = tssp)
  
  if(i == 1){
    allSspBins <- sspbins
  }else{
    allSspBins <- bind_rows(allSspBins,sspbins)
    
  }
  
  #nearest neighbor interp
  year = 1900:2300
  
  sspbins <- bind_rows(sspbins,sspbins) %>% 
    arrange(year)
  dy <- max(diff(sspbins$year))
  sspbins$year[1] <- sspbins$year[1]-dy
  sspbins$year[nrow(sspbins)] <- sspbins$year[nrow(sspbins)]+dy
  
  
  sspbinsnn <- data.frame(year = year,
                          mean = pracma::interp1(sspbins$year,y = sspbins$mean,xi = year,method = "nearest"),
                          cl05 = pracma::interp1(sspbins$year,y = sspbins$cl05,xi = year,method = "nearest"),
                          cl95 = pracma::interp1(sspbins$year,y = sspbins$cl95,xi = year,method = "nearest"),
                          ssp = tssp)
  
  #remove step
  sspbinsnn$mean[sspbinsnn$year==2100] <- NA
  
  
  if(i == 1){
    allSspBinsNN <- sspbinsnn
  }else{
    allSspBinsNN <- bind_rows(allSspBinsNN,sspbinsnn)
    
  }
}

#mean ssp start
mssps <- allSspBins %>% 
  filter(year==2000) %>% 
  summarize(mean = mean(mean)) %>% 
  c()

#panel 1
pan1 <- ggplot(prehol) +
  geom_line(aes(x = `Age (BP)`+50,y = gmsta,color = stack)) + 
  geom_segment(aes(x = 123000, xend = 123000, y = 0.5, yend = 1.5), size = 1, color = "red") +
  scale_x_reverse(name = "Years before 2000 CE",expand = c(0,0),limits = c(150000,12000),labels = c("150,000","100,000","50,000","    12,000"),breaks = c(150000,100000,50000,12000) )+
  scale_y_continuous(name = "Global surface temperature relative to 1850-1900 (°C)",breaks = seq(min(ylimits),max(ylimits),by = 2),minor_breaks = seq(min(ylimits),max(ylimits))) +
  coord_cartesian(ylim = ylimits)+
  theme_bw() + 
  annotate("text", x = 139000, y = -6, label = "A") +
theme(legend.title = element_blank(),legend.position = c(.62,.5),
        legend.background = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())+
  scale_color_brewer(palette = "Paired")



#panel 2 
pan2 <- ggplot() +
  geom_ribbon(data = temp12k,aes(x = `Age (BP)`+50,ymin = cl05,ymax = cl95), fill = "gray70")+
  geom_ribbon(data = osman,aes(x = `Age (BP)`+50,ymin = cl05,ymax = cl95),fill = "DarkRed",alpha = .5) +
  geom_line(data = temp12k,aes(x = `Age (BP)`+50 ,y = gmsta, color = "Kaufman et al."))+
  geom_line(data = osman, aes(x = `Age (BP)`+50 ,y = gmsta, color = "Osman et al."))+
  geom_segment(aes(x = 6500, xend = 6500, y = 0.2, yend = 1), size = 1, color = "red") +
  xlim(c(12000,100))+
  scale_x_reverse(name = "Years before 2000 CE",expand = c(0,0),breaks = c(12000,8000,4000,100),labels = c("",8000, 4000,"100    "))+
  scale_y_continuous(breaks = seq(min(ylimits),max(ylimits),by = 2),minor_breaks = seq(min(ylimits),max(ylimits))) +
  scale_color_manual(values = c("black","DarkRed"))+
  coord_cartesian(xlim = c(12000,50),ylim = ylimits)+
  theme_bw()+
  annotate("text", x = 11000, y = -6, label = "B") +
  theme(axis.title.y=element_blank(),
        legend.title = element_blank(),
        legend.spacing.y = unit(-5, "pt"),
        legend.background = element_blank(),
        legend.position = c(.5,.2),
        axis.text.y=element_blank(),
        axis.ticks.y=element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())

#panel 3

pan3 <- ggplot() + 
  #geom_ribbon(data = allSspBinsNN,aes(x = year, ymin = cl05,ymax = cl95, fill = ssp), alpha = 0.3)+
  geom_ribbon(data = projections,aes(x = year,ymin = `0.05`, ymax = `0.95`,fill = ssp),alpha = 0.5) + 
  #geom_line(aes(x = year,y = `0.05`,color = ssp),linetype = 2) +
  #geom_line(aes(x = year,y = `0.95`,color = ssp),linetype = 2) +
  geom_line(data = projections,aes(x = year,y = mean, color = ssp),linetype = 1) +
  geom_ribbon(data = instrumental,aes(x = year,ymin = cl05,ymax = cl95 ),color = "gray70") +
  geom_line(data = instrumental,aes(x = year,y = gmsta ),color = "gray50") +
  geom_line(data = allSspBinsNN,aes(x = year, y = mean, color = ssp),linetype = 2)+
  geom_line(aes(x = c(2000,2000), y =c(0,0), linetype = c("Gulev et al.","200-year means")),color = "gray50")+
  coord_cartesian(ylim = ylimits)+
  annotate("text", x = 1920, y = -6, label = "C") +
  scale_x_continuous(name = "Year (CE)",expand = c(0,0),limits = c(1900,2300),labels = c("   1900",2000,2100,2200,2300),breaks = c(1900,2000,2100,2200,2300))+
  scale_y_continuous(name = "Global surface temperature relative to 1850-1900 (°C)",position = "right", breaks = seq(min(ylimits),max(ylimits),by = 2),
                     minor_breaks = seq(min(ylimits),max(ylimits))) +
  theme_bw() + 
  scale_fill_brewer(palette = "Dark2")+
  scale_color_brewer(palette = "Dark2")+
  scale_linetype_manual(values = c(2,1)) +
  theme(legend.title = element_blank(),
        legend.spacing.y = unit(-5, "pt"),
        legend.position = c(.6,.23),
        legend.background = element_blank(),
        axis.title.y.right = element_text(angle = 90),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())
  


#200 years
cols <- c(RColorBrewer::brewer.pal(2,"Paired")[1],"DarkRed",RColorBrewer::brewer.pal(2,"Paired")[2] , RColorBrewer::brewer.pal(3,"Dark2"),"#000000","gray50")

# allSspBins$year[3:4] <- allSspBins$year[3:4]+1000
# allSspBins$year[5:6] <- allSspBins$year[5:6]+2000

instBin <- data.frame(year = c(1950-temp12kBins$x[1],1950-temp12kBins$x[1]+200),mean = c(temp12kBins$y[1],mssps$mean))
allSspBins <- allSspBins %>%  mutate(ssp = fct_reorder(ssp, desc(ssp))) 
  

inset <- ggplot()+
  geom_line(data = deepBins,aes(x = x+50,y = y, color = stack)) + 
  geom_line(aes(x = osmanAge+50,y = gmstqa[2,], color = "Osman")) + 
  geom_line(data = temp12kBins,aes(x = x+50,y = y,color = "Temp12k")) +
  geom_line(data = instBin,aes(x = 2000-year,y  = mean,color = "TempInst")) +
  
  #geom_ribbon(data = allSspBins,aes(x = year, ymin = cl05,ymax = cl95, fill = ssp), alpha = 0.3)+
  geom_line(data = allSspBins,aes(x = 2000-year, y = mean, color = ssp)) +
  geom_hline(aes(yintercept = 1),linetype = 2,color = "gray50") +
  geom_text(aes(x = 60000,y = 2, label = "1°C multi-century warming level")) + 
  #geom_point(data = allSspBins,aes(x = 1950-year, y = mean, color = ssp),shape = 15) +
  scale_x_reverse(label = comma,expand = c(0,0),limits = c(150000,-3000)) + 
  scale_color_manual(values = cols) +
  xlab("Years before 2000 CE") + 
  ylab(expression(paste(Delta,"Glob. Surf. Temp. (°C)")))+
  theme_bw()+
  #theme(legend.position = c(0.7,0.7),legend.title = element_blank())
  theme(legend.position = "none",
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank())




top <- ggplot() + 
  geom_rect(mapping=aes(xmin=0, xmax=3, ymin=-6, ymax=0), fill="white", alpha=1) +
  scale_x_continuous(expand = c(0,0))+
  scale_y_continuous(expand = c(0,0))+
  theme(legend.position = "none",
        axis.text = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

plot <- egg::ggarrange(plots = list(top,top,top,pan1,pan2,pan3),nrow = 2,heights = c(.1,.9))



full <- ggdraw() +
draw_plot(plot) +
  draw_plot(inset, x = .15, y = .52, width = .6, height = .45) +
  draw_label(x = .81, y = .95, label = "2100-2300 CE",size = 9) +
  draw_line(x = c(.72,.735)+.015, y = c(.93,.95),color = "gray50")


#full

ggsave("figures/WarmingTimescale.pdf",plot = full,width = 7,height = 4)
ggsave("figures/WarmingTimescale.png",plot = full,width = 7,height = 4)

