library(openxlsx)
library(dplyr)
library(scales)
library(ggplot2)

# Get the list of stocks for dropdown
if(!file.exists("./data/lse_sept19.xlsx")){
  fileurl<-"https://www.londonstockexchange.com/statistics/companies-and-issuers/companies-defined-by-mifir-identifiers-list-on-lse.xlsx"
  download.file(fileurl,destfile = "./data/lse_sept19.xlsx",method="curl")
}
data<-read.xlsx("./data/lse_sept19.xlsx",sheet = 1,startRow = 6,colNames = TRUE)
data<-na.omit(data)

# Returns list of stocks
stockdf<-function(){
  data[,2]
}

# Returns list of sectors
industry<-function(){
  c("London Stock Exchange",unique(data[,3]))
}

# Returns market cap of selected input
mcap<-function(stock,industry){
  gbp<-dollar_format(prefix = "\u00a3 ",suffix = " m" )
  if(!is.null(stock)&is.null(industry)){
   gbp(as.numeric(data[which(data[,2]==stock),9]))
  }
  else {
     names(data)[9]="cap"
     group<-data%>%mutate(cap=as.numeric(cap))%>%group_by(ICB.Industry)%>%summarise(sum=sum(cap,na.rm=TRUE))
     group<-as.data.frame(group)
     if(industry=="London Stock Exchange")
       gbp(round(sum(group[,2]),0))
     else{
       gbp(round(group[which(group[,1]==industry),2],0))
     }
  }
}

#Returns graph of market cap vs selected category
plot_graph<-function(xvalue){
  num<-which(names(data)==xvalue)
  names(data)[9]="cap"
  group<-data%>%mutate(cap=as.numeric(cap))%>%group_by(!!!syms(names(data)[num]))%>%summarise(sum=sum(cap,na.rm = TRUE))
  group<-as.data.frame(group)
  names(group)<-c("x","y")
  group%>%ggplot(aes(x=x,y=y))+geom_col(fill="lightblue",color="grey")+ggtitle(paste("Market Capitalization by",xvalue))+theme(axis.title.x=element_blank())+scale_y_continuous(labels = comma)+ylab(paste("\u00a3"," m"))+theme(axis.text.x = element_text(angle = 90, hjust = 1))
}
