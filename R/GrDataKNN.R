# ----------------------------------------------------------------------
# Creates the data that makes it possible to Graph the KNNs
# ----------------------------------------------------------------------
#' GrDataKNN
#' 
#' Finds the boundries of each category through the KNN method.
#'
#' @param X A data frame or a matrix where rows are observations and columns are features. 
#' @param Y A vector with labels for each row in \code{data}.
#' @param k Number of neighbors that the classifier should use. It has to be an odd number.
#' @return A List with 3 data sets. Boundries are the points from the region where there is a change of categories, Popoints are all the points in the graph and the category and truedata the original points.
#' @export
#' @import ggplot2
#' @examples
#' # create artificial dataset
#' x1 <- c(978783,1052488,1039495,1056795,1125545,1536011,1616461,1388507,1608121,1416574,1704919,2653310,2208399,1896304,1957401)
#' x2 <- c(12645844,12343453,4137266,12229065, 12554668,8856611,12137668,11545424,9253718,8863474,15145969,12793921,14593861,15161586,15785243)
#' Y <- c(rep("Cats",5),rep("Dogs",5),rep("Lions",5))
#' X <- as.data.frame(cbind(x1,x2))
#' data <- cbind(X,Y)
#' # get the kNN predictions for the test set
#' c<-GrDataKNN(X=data[,1:2],Y=data[,3],k=5)
#' #The Graph that shows the data:
#'  ggplot()+
#'  geom_point(aes(x=c$BouPoints[,1],y=c$BouPoints[,2]),data=c$BouPoints, lwd=1)+
#'  geom_point(aes(x=c$Popoints[,1],y=c$Popoints[,2], colour=category),data=c$Popoints, alpha=1/4, pch=1, lwd=1)+
#'  geom_point(aes(x=c$TrueData[,1], y=c$TrueData[,2], colour=category), data=c$TrueData, pch=18, lwd=3)+
#'  xlab("Weight") +
#'  ylab("Height")


GrDataKNN<- function(X,Y,k){
  #take the categories we are working with
  realcategories<-unique(Y)
  realcategories<-as.character(realcategories)
  
  #take the name of the X's
  realcolnames<-colnames(X)
  
  #creating the grid 
  xlen <- ylen <- 100
  X1<-seq(min(X[,1]),max(X[,1]),len=xlen)
  X2<-seq(min(X[,2]),max(X[,2]),len=ylen)
  data<-matrix(0,(xlen*ylen),2)
  colnames(data)<-c(realcolnames[1],realcolnames[2])
  is<-1
  for (i in 1:xlen){
    for (j in 1: ylen){
      data[is,]<-c(X1[i],X2[j])
      is<-is+1
    }
  }
  ##getting the labels for grid points
  labels<- MLtools::KNN.k(X=data,Y=Y,k=k,obj="predict",RealData=X)
  dataLabel<-cbind(data,labels$predictedClasses)
  ##diferentiate between point or boundary
  Tpoints<-matrix(0,xlen*ylen,4)
  plus <- 0
  for (i in 1:xlen){
    for (j in 2:ylen){
      if(dataLabel[(j+plus),3] == dataLabel[(j+plus-1),3]){
        Tpoints[(j+plus),4]<-0
        Tpoints[(j+plus),1:3]<-as.numeric(dataLabel[(j+plus),1:3])
      }else{
        Tpoints[(j+plus),4]<-1
        Tpoints[(j+plus),1:3]<-as.numeric(dataLabel[(j+plus),1:3])
        
      }
    }
    plus <- plus + ylen 
  }
  
  Tpoints<-as.data.frame(Tpoints)
  
  ##Changing the animals to it's category name
  for(i in 1:nrow(Tpoints)){
    if(Tpoints[i,3]==1){
      Tpoints[i,3]<-realcategories[1]
    }
    if(Tpoints[i,3]==2){
      Tpoints[i,3] <- realcategories[2]
    }
    if(Tpoints[i,3]==3){
      Tpoints[i,3] <- realcategories[3]
    }
  }
  ##Changing the type of point to either Boundary or Point
  for(i in 1:nrow(Tpoints)){
    if(Tpoints[i,4]==1){
      Tpoints[i,4]<-"Boundary"
    }
    if(Tpoints[i,4]==0){
      Tpoints[i,4] <- "Point"
    }
  }
  colnames(Tpoints)<-c(realcolnames[1],realcolnames[2],"category","type")
  Tpoints<- Tpoints[Tpoints$category != 0, ]
  BouPoints<-Tpoints[Tpoints$type == "Boundary",]
  Popoints<-Tpoints[Tpoints$type == "Point",]
  TrueData <- cbind(X,Y)
  colnames(TrueData)<-c(realcolnames[1],realcolnames[2],"category")

  return(list(BouPoints=BouPoints,
              Popoints=Popoints,
              TrueData=TrueData))
}



