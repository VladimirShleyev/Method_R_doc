#renv::init() # инициализация виртуального окружения
#renv::install("devtools", "UserNetR", "statnet", "UserNetR") # установка библиотеки из CRAN
#renv::snapshot() # делаем снимок версий библиотек в нашем виртуальном окружении
# фиксируем этот список в .lock-файле для возможности восстановления
# renv::restore() # команда отктиться к предыдушему удачному обновления библиотек

# ------------------- 
# Лабораторная работа №12:
# Графы и сети. Визуализация, описание, анализ. 

library(devtools) 
#install_github("DougLuke/UserNetR")
#install.packages("UserNetR")
library(UserNetR)
library(statnet) 

data(Moreno)

gender <- Moreno %v% "gender" 
plot(Moreno, vertex.col = gender + 2, vertex.cex = 1.2) 

network.size(Moreno)  
summary(Moreno,print.adj=FALSE) 
den_hand <- 2*46/(33*32)
den_hand 
gden(Moreno)
components(Moreno) 
lgc <- component.largest(Moreno,result="graph") 
gd <- geodist(lgc)
max(gd$gdist)  
gtrans(Moreno,mode="graph")  

netmat1 <- rbind(c(0,1,1,0,0),                 
                 c(0,0,1,1,0),            		     
                 c(0,1,0,0,0),                 
                 c(0,0,0,0,0),                 
                 c(0,0,1,0,0)) 
rownames(netmat1) <- c("A","B","C","D","E") 
colnames(netmat1) <- c("A","B","C","D","E") 

net1 <- network(netmat1,matrix.type="adjacency") 
class(net1)
summary(net1)
gplot(net1, vertex.col = 2, displaylabels = TRUE) 
netmat2 <- rbind(c(1,2),                 
                 c(1,3),                 
                 c(2,3),                 
                 c(2,4),                 
                 c(3,2),                 
                 c(5,3)) 

net2 <- network(netmat2,matrix.type="edgelist") 
network.vertex.names(net2) <- c("A","B","C","D","E") 
summary(net2)

as.sociomatrix(net1) 
class(as.sociomatrix(net1))
all(as.matrix(net1) == as.sociomatrix(net1)) 

as.matrix(net1,matrix.type = "edgelist") 
set.vertex.attribute(net1, "gender", c("F", "F", "M", "F", "M"))
net1 %v% "alldeg" <- degree(net1) 
list.vertex.attributes(net1)  
summary(net1) 

get.vertex.attribute(net1, "gender")  
net1 %v% "alldeg"  
list.edge.attributes(net1)  
set.edge.attribute(net1,"rndval", runif(network.size(net1),0,1)) 
list.edge.attributes(net1)  
summary(net1 %e% "rndval")  
summary(get.edge.attribute(net1,"rndval"))  
netval1 <- rbind(c(0,2,3,0,0),                 
                 c(0,0,3,1,0),                 
                 c(0,1,0,0,0),                 
                 c(0,0,0,0,0),                 
                 c(0,0,2,0,0)) 

netval1 <- network(netval1,matrix.type="adjacency", ignore.eval=FALSE,names.eval="like") 
network.vertex.names(netval1) <- c("A","B","C","D","E") 

list.edge.attributes(netval1)  
get.edge.attribute(netval1, "like")  

detach(package:statnet) 
#install.packages("igraph")
library(igraph) 
inet1 <- graph.adjacency(netmat1) 
class(inet1) 
summary(inet1)  
str(inet1)  

inet2 <- graph.edgelist(netmat2) 
summary(inet2)  
V(inet2)$name <- c("A","B","C","D","E") 
E(inet2)$val <- c(1:6) 
summary(inet2)  
str(inet2)  

detach("package:igraph", unload=TRUE) 
library(statnet) 
netmat3 <- rbind(c("A","B"),                 
                 c("A","C"),                 
                 c("B","C"),                 
                 c("B","D"),                 
                 c("C","B"),                 
                 c("E","C")) 

net.df <- data.frame(netmat3) 
net.df  
write.csv(net.df, file = "MyData.csv", row.names = FALSE) 
net.edge <- read.csv(file="MyData.csv") 
net_import <- network(net.edge, matrix.type="edgelist") 
summary(net_import)  
gden(net_import)  


data(Moreno) 
op <- par(mar = rep(0, 4),mfrow=c(1,2)) 
plot(Moreno,mode="circle",vertex.cex=1.5) 
plot(Moreno,mode="fruchtermanreingold",vertex.cex=1.5) 
par(op) 
op <- par(mar = c(0,0,4,0),mfrow=c(1,2)) 
gplot(Moreno,gmode="graph",mode="random", vertex.cex=1.5,main="Случайная укладка") 
gplot(Moreno,gmode="graph",mode="fruchtermanreingold", vertex.cex=1.5,main="Фрюхтерман-Рейнгольд") 
par(op) 


data(Bali) 
op <- par(mar=c(0,0,4,0),mfrow=c(2,3)) 
gplot(Bali,gmode="graph",edge.col="grey75", vertex.cex=1.5,mode='circle',main="circle") 
gplot(Bali,gmode="graph",edge.col="grey75", vertex.cex=1.5,mode='eigen',main="eigen") 
gplot(Bali,gmode="graph",edge.col="grey75", vertex.cex=1.5,mode='random',main="random") 
gplot(Bali,gmode="graph",edge.col="grey75", vertex.cex=1.5,mode='spring',main="spring") 
gplot(Bali,gmode="graph",edge.col="grey75", vertex.cex=1.5,mode='fruchtermanreingold', main='fruchtermanreingold') 
gplot(Bali,gmode="graph",edge.col="grey75", vertex.cex=1.5,mode='kamadakawai', main='kamadakawai') 
par(op)


detach(package:statnet) 
library(igraph) 
#install.packages("intergraph")
library(intergraph) 
iBali <- asIgraph(Bali)
op <- par(mar=c(0,0,3,0),mfrow=c(1,3)) 
plot(iBali,layout=layout_in_circle, main="Круговая") 
plot(iBali,layout=layout_randomly, main="Случайная") 
plot(iBali,layout=layout_with_kk,  main="Камада-Каваи") 
par(op)


#install.packages("RColorBrewer")
library(RColorBrewer)
data(Bali)
my_pal <- brewer.pal(5,"Set2")
rolecat <- Bali %v% "role"
gplot(Bali,usearrows=FALSE,displaylabels=TRUE, vertex.col=my_pal[as.factor(rolecat)],
      edge.lwd=0,edge.col="grey25")
legend("topright",legend=c("BM","CT","OA","SB",
                           "TL"),col=my_pal,pch=19,pt.cex=2)
