source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile <- cmd_args[1]
# output:
	outputFile <- cmd_args[2]

cloud <- read.table(inputFile, header=T)

cloud$cost <- cloud$totalCost
cloud$makespan <- cloud$sumOfJobsMakespan/cloud$submitted

cloud <- subset(cloud, select = c(rodada, makespan, nPeers, nMachines, upp, instance, limit, goodput, badput, avTime, cost))

saveDataset( cloud, outputFile )


