source( paste(Sys.getenv("VALOR_GRADES_P2P_HOME"),"/r_scripts/header.R",sep=""))

# input:
	inputFile1 <- cmd_args[1]
	inputFile2 <- cmd_args[2]
# output:
	outputFile <- cmd_args[3]

gridCis <- read.table( inputFile1, header=T )
spotCis <- read.table( inputFile2, header=T )

members=sort(unique(spotCis$nPeers))
machines=sort(unique(spotCis$nMachines))
users=sort(unique(spotCis$upp))
instances=sort(unique(factor(spotCis$instance)))

betas <- seq(0,1,0.1)

valuations <- data.frame() 
for (p in members) {
 for (m in machines) {
  for (u in users) {
   for (i in instances) {
			
    public <- subset(spotCis, nPeers == p & nMachines == m & upp==u & instance==as.character(i) )
			
    cp <- public$costMean
    mp <- public$mkspMean
				
    communal <- subset(gridCis, nPeers == p & nMachines == m & upp==u )
				
    cc <- communal$costMean
    mc <- communal$mkspMean

    for (beta in betas) {

	    eff = (cp/cc)*(1-beta) + (mp/mc)*beta
	    #eff = (cp/cc)*(beta) + (mp/mc)*(1-beta)
					
	    rel_mksp = mp/mc
	    rel_cost = cp/cc
					
	    val <- data.frame(
		nPeers     = p,
		nMachines  = m,
		nUsers     = u,
		instance   = i,
		beta       = beta,
		eff        = eff,
		rel_mksp   = rel_mksp,
		rel_cost   = rel_cost
	    ) 
	    #val <- val[ order(val$eff), ]

	    valuations <- rbind( valuations, val ) 
    }
   }
  }
 }
}

saveDataset( valuations, outputFile )

