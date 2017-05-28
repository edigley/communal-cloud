source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile <- cmd_args[1]
# output:
	outputFile <- cmd_args[2]

valuations <- read.table( inputFile, header=T )

selectedInstances=strsplit(selectedInstances, " ")[[1]]

panel.func <- function(x,y,...){ 
	panel.xYplot(x, y, ...) ; 
	panel.abline(h = seq(.5,6,.5), col = c("lightgray","gray",rep("lightgray",6+5)), lty=3, cex=.2)
}

mainLabel="Relative Efficiency: Communal and Public Clouds"
yLabel="Relative Efficiency"
ylim=c(0,5.5)

png(outputFile)

print(xYplot(  
	eff ~ beta | nPeers * nUsers, 
	data=valuations, 
	groups=instance, 
	subset=(instance %in% selectedInstances),
	main=mainLabel,
	ylab=yLabel,
	col=c("blue","red","green","purple"),
	type="l", 
	lwd=2,
	pch=c(1,2,3,4), 
	lty=c(3,4,5,6),
	strip=strip.custom(strip.names=TRUE, strip.levels=TRUE,bg="white",fg="white"),
	ylim=ylim,
	cex=.7,
	panel=panel.func
))

dev.off()

