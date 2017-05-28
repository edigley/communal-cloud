source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile <- cmd_args[1]
# output:
	dir <- cmd_args[2]
	filePrefix <- cmd_args[3] 

valuations <- read.table( inputFile, header=T )

members=sort(unique(valuations$nPeers))
machines=sort(unique(valuations$nMachines))
users=sort(unique(valuations$nUsers))
instances=sort(unique(factor(valuations$instance)))
selectedInstances=strsplit(selectedInstances, " ")[[1]]

prefix = filePrefix
sufix = ".png"

for (p in members) {
 for (m in machines) {
  for (u in users) {
   pngFilePath = paste(dir, prefix, p, "p_", m, "m_", u, "u", sufix, sep="")
   png(pngFilePath)
   
   val <- subset(valuations, nPeers == p & nMachines == m & nUsers==u & instance %in% selectedInstances )
   
   print(
    xYplot(  
    	eff ~ beta, #Cbind(value,valueMin,valueMax) ~ pc, 
        data=val, 
        groups=instance, 
        #subset=(instance=="c1.medium"|instance=="c1.xlarge"|instance=="m2.4xlarge"),
        subset=(instance %in% selectedInstances),
        #auto.key=T,
        #auto.key=list(lines=TRUE, points=TRUE, columns=2),
	main="Relative Efficiency: Communal and Public Clouds",
        #col=rainbow(length(instances)),
        col=c("blue","red","green","purple"),
        lwd=2,
        ylab="Relative Efficiency",
        pch=c(1,2,3,4), 
        type="l", 
        lty=c(3,4,5,6),
	panel=function(x,y,...){ 
                panel.xYplot(x, y, ...) ; 
                panel.abline(h = seq(.5,6,.5), col = c("lightgray","gray",rep("lightgray",6+5)), lty=3, cex=.2)
        },
        strip=strip.custom(strip.names=TRUE, strip.levels=TRUE,bg="white",fg="white"),
        cex=.7,
        #xlab="B",
        ylim=c(0,2.5)
    )
   )
  }
 }
}

dev.off()

