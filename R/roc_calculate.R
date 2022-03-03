#' Calculate roc from formed input object
#'
#' This function loads a correlation object and a formed database file as input, return a list of calculated roc. 
#'
#' @param tmp_res2 a correlation object
#' @param tmp_J a formed database file
#' @param J_name label
#' @param mark_multiple boolean value representing database file of one category or multiple categories
#' @return A list of the calculated roc in indicated database file (roc_qda,plotx,roc.info).
#' @export
roc_calculate <- function(tmp_res2,tmp_J,J_name="None",mark_multiple=TRUE) {
if(!grepl("^ENS+.*[0-9]+$",unlist(strsplit(tmp_J$GNO,"[;]"))[1])) {
tmp_J$GNS<-tmp_J$GNO
}
tmp_res2$row<-gsub("'","",tmp_res2$row)
tmp_res2$column<-gsub("'","",tmp_res2$column)
tmp_J$GNS<-gsub("'","",tmp_J$GNS)
genes_query<-union(toupper(tmp_res2$row),toupper(tmp_res2$column))
genes_target<-unique(toupper(unlist(strsplit(tmp_J$GNS,"[;]"))))
genes_common<-intersect(genes_query,genes_target)
tmp_res2$row<-toupper(tmp_res2$row)
tmp_res2$column<-toupper(tmp_res2$column)
tmp_J$GNS<-toupper(tmp_J$GNS)
J_name_label<-paste(J_name,"label",sep="_")
J_name_label2<-paste(J_name,"label2",sep="_")
tmp_res2[J_name_label]<-0
tmp_res2[J_name_label2]<-0
tmp_res2[(tmp_res2$row %in% genes_common) & (tmp_res2$column %in% genes_common),J_name_label]<-1
tmp_J$INO<-"NA"
for(i in 1:nrow(tmp_J)){tmp_J[i,"INO"]<-(length(intersect(unlist(strsplit(tmp_J$GNS[i],"[;]")),genes_common))>0)}
tmp_J<-tmp_J[tmp_J$INO=="TRUE",]
mylist<-vector("list",nrow(tmp_J))
for(j in 1:nrow(tmp_J)){ mylist[[j]]<-unlist(strsplit(tmp_J$GNS[j],"[;]")) }
for(i in 1:nrow(tmp_res2)){for(j in mylist){if( (tmp_res2$row[i] %in% j) & (tmp_res2$column[i] %in% j) ){ tmp_res2[i,J_name_label]<-(tmp_res2[i,J_name_label]+1)}}}
tmp_res2[tmp_res2[J_name_label]>1,J_name_label2]<-1
if(mark_multiple) {
tmp_res2<-tmp_res2[tmp_res2[J_name_label]>0,]
}
glm.fit=glm(tmp_res2[,J_name_label2] ~ tmp_res2$cor, family=binomial)
plotx<-roc(tmp_res2[,J_name_label2], glm.fit$fitted.values, plot=TRUE, legacy.axes=TRUE, percent=TRUE, xlab="False Positive Percentage", ylab="True Postive Percentage", col="#377eb8", lwd=4,print.auc=T)
roc.info<-roc(tmp_res2[,J_name_label2], glm.fit$fitted.values,legacy.axes=TRUE)
roc_qda=roc(response=tmp_res2[,J_name_label2], predictor= glm.fit$fitted.values, plot=TRUE)
newList <- list("roc_qda" = roc_qda, "plotx" = plotx, "roc.info" = roc.info)
return(newList)
}