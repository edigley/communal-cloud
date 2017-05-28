suppressPackageStartupMessages(library(Hmisc))
suppressPackageStartupMessages(library(lattice))
suppressPackageStartupMessages(require(grid))
library(Hmisc)#,warn.conflicts = FALSE,verbose = FALSE, quietly=TRUE)
library(lattice)

calculateIC <- function(metrics) {
	ic <- numeric()
	if (length(metrics) < 10) {
		m  <- mean(metrics)
		#s  <- sd(metrics)
		s <- ifelse( length(metrics)==1, 0.00001, sd(metrics) )
		ic[1] <- m
		ic[2] <- m - s
		ic[3] <- m + s
	} else {
		t <- t.test(metrics)
		ic[1] <- t$estimate[[1]]
		ic[2] <- t$conf.int[1]
		ic[3] <- t$conf.int[2]
	}
	ic
}

toShortInstanceName <- function(instance) {
	splitName <- unlist(strsplit(instance, split=".", fixed=T))
	type      <- paste(splitName[3], splitName[4], sep=".");
}

toFamilyName <- function(instance) {
	splitName <- unlist(strsplit(instance, split=".", fixed=T))
	#type      <- paste(splitName[3], splitName[4], sep=".");
	splitName[3]
}

getSimpleName <- function(path) {
	splitName <- unlist(strsplit(path, split="/", fixed=T))
	splitName[length(splitName)]
}

myformat <- function(arg, ...){
	format( arg, format="d",digits=4, nsmall=2, justify = "right", decimal.mark = ",", big.mark = ".")
}

myformat2 <- function(arg, ...){
	valuef <- format( arg * 100, format="d",digits=2, nsmall=2, justify = "right", decimal.mark = ",", big.mark = ".")
	#paste(valuef, "\\%")
}

myformat3 <- function(arg, ...){
	valuef <- format( arg , format="d",digits=4, nsmall=6, justify = "right", decimal.mark = ",", big.mark = ".")
}

getDatasetsNames <- function(){

	files <- data.frame( 
			nPeers    = numeric(), 
			nMachines = numeric(), 
			upp	  = numeric(), 
			gname     = character(), 
			cname     = character(), 
			instance  = character(), 
			type      = character(),
			rodada    = numeric()
		)

	#pega os nomes de todos os arquivos com resultados da cloud e da grade
	for (rodada in rodadas) {
		for (instance in instances) {
			for (nPeers in numOfPeers) {
				for (nMachines in numOfMachinesByPeer) {
					for (upp in usersPerPeer) {
						gname <- setUpGName(nPeers, nMachines, upp, oursimDir, scheduler, rodada)
						cname <- setUpCName(nPeers, nMachines, upp, spotsimDir, scheduler, rodada, instance, spotLimit, groupedbypeer)
						if ( file.exists(gname) && file.exists(cname) ) {
							splitName <- unlist(strsplit(instance, split=".", fixed=T))
							type      <- paste(splitName[3], splitName[4], sep=".");
							files     <- rbind( 
									files, 
									data.frame( 
										nPeers    = nPeers, 
										nMachines = nMachines, 
										upp	  = upp,
										gname     = gname, 
										cname     = cname, 
										instance  = instance, 
										type      = type, 
										rodada    = rodada
									)
								)
						}
					}
				}
			}
		}
	}
	files

}

getGridDatasetsNames <- function(){

	files <- data.frame( nPeers    = numeric(), 
			     nMachines = numeric(), 
			     rodada    = numeric(),
			     name      = character()
			   )

	#pega os nomes de todos os arquivos com resultados da grade
	for (rodada in rodadas) {
		for (nPeers in numOfPeers) {
			for (nMachines in numOfMachinesByPeer) {
				for (upp in usersPerPeer) {
					gname <- setUpGName(nPeers, nMachines, upp, oursimDirO, scheduler, rodada)
					#print(paste(rodada,nPeers,nMachines,gname,class(files)))
					if ( file.exists(gname) ) {					
						files <- try(
								rbind( files, 
								data.frame( 
									nPeers    = nPeers, 
									nMachines = nMachines, 
									upp	  = upp, 
									rodada    = rodada,
									name      = gname
								) 
							)
										)
						if (class(files) == "try-error") {
							print(paste("try-error",rodada,nPeers,nMachines,gname))
							#exit
						}
					} else {
							#print(paste(rodada,nPeers,nMachines,gname))
					}
				}
			}
		}
	}

	files

}

getCloudDatasetsNames <- function(nMachines){

	files <- data.frame( 
			nPeers  = numeric(), 
			instance  = character(), 
			type      = character(),
			rodada    = numeric(), 
			name      = character() 
			)

	#pega os nomes de todos os arquivos com resultados da cloud
	for (rodada in rodadas) {
		for (instance in instances) {
			for (nPeers in numOfPeers) {
				for (upp in usersPerPeer) {
					if ( file.exists(cname) ) {
						#nMachines <- 50
						cname <- setUpCName(nPeers, nMachines, upp, spotsimDirO, scheduler, rodada, instance,spotLimit,groupedbypeer)
						splitName <- unlist(strsplit(instance, upp, split=".", fixed=T))
						type <- paste(splitName[3], splitName[4], sep=".");
						files <- rbind( files, 
								data.frame( 
									nPeers   = nPeers, 
									upp	 = upp,
									instance = instance, 
									type     = type, 
									rodada   = rodada,
									name     = cname
									)
						)
					}
				}
			}
		}
	}

	files

}

saveDataset <- function( ds, outputFile ){
    write.table(
                format( ds, format="d", digits=22), 
                outputFile, 
                row.names=F, 
                quote=F
               )
}
