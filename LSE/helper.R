library(openxlsx)
library(dplyr)
library(scales)
library(ggplot2)
library(rvest)

# Get the list of stocks for dropdown
 
if(format(Sys.Date(),"%d")=='1'){
  if(file.exists("./data/lse.xlsx"))unlink("./data/lse.xlsx") 
  fileurl<-"https://www.londonstockexchange.com/statistics/companies-and-issuers/companies-defined-by-mifir-identifiers-list-on-lse.xlsx"
  download.file(fileurl,destfile = "./data/lse.xlsx",method="curl")
}
data<-read.xlsx("./data/lse.xlsx",sheet = 1,startRow = 6,colNames = TRUE)
data<-na.omit(data)
ndate<-read.xlsx("./data/lse.xlsx",sheet = 1)
ndate<-ndate[1,1]

#Returns latest date{
datedisp<-function(){
  ndate
}


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

get_ticker<-function(name,root=TRUE){
  url = URLencode(paste0("https://www.google.com/search?q=",name,"+ ticker"))
  page<-xml2::read_html(url)
  nodes<-html_nodes(page,"a")
  links<-html_attr(nodes,"href")
  link<-links[startsWith(links,"/url?q=https://uk.finance.yahoo.com/quote/")][1]
  link<-read.table(text=link,sep="/",as.is = TRUE)$V6
  if(is.null(link)){
    link<-links[startsWith(links,"/url?q=https://www.albion.capital")][1]
    link<-read.table(text=link,sep="/",as.is = TRUE)$V6
    link<-paste0(gsub("&(.*)","",link),".L")
  }
  if(link==".L"){
    link<-links[startsWith(links,"/url?q=https://finance.yahoo.com/quote/")][1]
    link<-read.table(text=link,sep="/",as.is = TRUE)$V6
  }
  if(is.null(link)){
    link<-links[startsWith(links,"/url?q=https://uk.advfn.com/stock-market/london")][1]
    link<-read.table(text=link,sep="/",as.is = TRUE)$V7
    link<-paste0(substr(link,regexpr("-[^-]*$", link)+1,nchar(link)),".L")
  }
  link
}
  

