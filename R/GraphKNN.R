# ----------------------------------------------------------------------
# UNDER CONSTRUCTION Graph function of the boundries in Knn method
# ----------------------------------------------------------------------
#' Can wee do packages that do graph?
#' 
#' Find the Discriminant Function that separates three different categories.
#'
#' @param X A data frame or a matrix where rows are observations and columns are features. 
#' @param Y A vector with labels for each row in \code{data}.
#' @param k Number of neighbors that the classifier should use. It has to be an odd number.
#' @return A graph that plots the boundries and how the categories are delimited.
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
#' Graph.KNN(c$BouPoints,c$Popoints,c$TrueData)


Graph.KNN<- function(BouPoints,Popoints,TrueData){
  BouPoints<-as.data.frame(BouPoints)
  Popoints<-as.data.frame(Popoints)
  TrueData<-as.data.frame(TrueData)
  
  ggplot()+
    geom_point(aes(x=BouPoints[,1],y=BouPoints[,2]),data=BouPoints, lwd=1)+
    geom_point(aes(x=Popoints[,1],y=Popoints[,2], colour=category),data=Popoints, alpha=1/4, pch=1, lwd=1)+
    geom_point(aes(x=TrueData[,1], y=TrueData[,2], colour=category), data=TrueData, pch=18, lwd=3)+
    xlab("Weight") +
    ylab("Height")
  
}



