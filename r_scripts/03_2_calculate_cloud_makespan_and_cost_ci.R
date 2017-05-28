source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile <- cmd_args[1]
# output:
	outputFile <- cmd_args[2]

cloud <- read.table(inputFile, header=T)

members=sort(unique(cloud$nPeers))
machines=sort(unique(cloud$nMachines))
users=sort(unique(cloud$upp))
instances=sort(unique(cloud$instance))

limit=sort(unique(cloud$limit))

cloudCis <- data.frame()
for (p in members) {
	for (m in machines) {
		for (u in users) {
			for (i in instances) {
			    cost <- subset(cloud, nPeers == p & nMachines == m & upp==u & instance==i, select = c(cost))$cost
			    icCost <- calculateIC(cost)
			    costMean  <- icCost[1]
			    costLower <- icCost[2]
			    costUpper <- icCost[3]

			    mksp <- subset(cloud, nPeers == p & nMachines == m & upp==u & instance==i, select = c(makespan))$makespan
			    icMksp <- calculateIC(mksp)
			    mkspMean  <- icMksp[1]
			    mkspLower <- icMksp[2]
			    mkspUpper <- icMksp[3]

			    cloudCis <- rbind( 
					              cloudCis, 
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
                                              instance   = i,
                                              limit      = limit
					                        )
				                )
            }
		}
	}
}

saveDataset( cloudCis, outputFile )


