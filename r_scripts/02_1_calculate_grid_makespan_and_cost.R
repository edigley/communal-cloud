source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile <- cmd_args[1]
# output:
	outputFile <- cmd_args[2]

grid <- read.table(inputFile, header=T)

grid$cost <- (((grid$goodput + grid$badput)/3600)*(p_max/1000)*cost_p_w) + ((grid$avTime - grid$goodput - grid$badput)/3600)*(p_hib/1000)*cost_p_w
grid$makespan <- grid$sumOfJobsMakespan/grid$submitted

grid <- subset(grid, select = c( rodada, makespan, nPeers, nMachines, upp, instance, limit, goodput, badput, avTime, cost))

saveDataset( grid, outputFile )

