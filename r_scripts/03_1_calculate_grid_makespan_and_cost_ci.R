source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile <- cmd_args[1]
# output:
	outputFile <- cmd_args[2]

grid <- read.table(inputFile, header=T)

members=sort(unique(grid$nPeers))
machines=sort(unique(grid$nMachines))
users=sort(unique(grid$upp))

gridCis <- data.frame()
for (p in members) {
	for (m in machines) {
		for (u in users) {
			cost <- subset(grid, nPeers == p & nMachines == m & upp == u, select = c(cost))$cost
			icCost <- calculateIC(cost)
			costMean  <- icCost[1]
			costLower <- icCost[2]
			costUpper <- icCost[3]

			mksp <- subset(grid, nPeers == p & nMachines == m & upp == u, select = c(makespan))$makespan
			icMksp <- calculateIC(mksp)
			mkspMean  <- icMksp[1]
			mkspLower <- icMksp[2]
			mkspUpper <- icMksp[3]

			gridCis <- rbind( 
					          gridCis, 
					          data.frame( 
                                          costMean   = costMean, 
                                          costLower  = costLower, 
                                          costUpper  = costUpper, 
                                          mkspMean   = mkspMean,
                                          mkspLower  = mkspLower,
                                          mkspUpper  = mkspUpper,  		  
                                          nPeers     = p, 		
                                          nMachines  = m,
                                          upp        = u, 		 
                                          instance   = NA,
                                          limit      = NA
					                    )
				            )
		}
	}
}

saveDataset( gridCis, outputFile )


