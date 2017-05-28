#!/bin/sh
# Analisar os Resultados (shell script)
#  1 - definir parametros em setup_name.R
#  2 - alterar o diretorio do arquivo de resultados
#  3 - descomentar as linhas de interesse

TEMPFILE=$(mktemp)
dos2unix -q -n $VALOR_GRADES_P2P_HOME"/00_args.properties" $TEMPFILE
. $TEMPFILE 2> /dev/null
export numOfPeers
export numOfMachinesByPeer
export usersPerPeer
export cloudLimit
export rodadas
export header
export p_max
export p_hib
export cost_p_w

# As instâncias que serão utilizados no gráfico da efficiência relativa.
selectedInstances="c1.medium c1.xlarge m2.4xlarge"


# Diretórios com os scripts
	rScriptsDir=$VALOR_GRADES_P2P_HOME"/r_scripts"
	shellScriptsDir=$VALOR_GRADES_P2P_HOME"/shell_scripts"
	
# Diretórios de resultados
	gridOutputsDir=/home/edigley/valor_grades_p2p/work_dir/outputs
	cloudOutputsDir=/home/edigley/valor_grades_p2p/work_dir/outputs
	resultsDir=$VALOR_GRADES_P2P_HOME"/results"

# R command
	R="R --slave --no-save --no-restore --no-environ --silent --args"

# Scripts Shell
	ConcatenateGridSimulationSummaries=$shellScriptsDir"/01_1_concatenate_grid_simulation_summaries.sh"
	ConcatenateCloudSimulationSummaries=$shellScriptsDir"/01_2_concatenate_cloud_simulation_summaries.sh"

# Scripts R
	calculateGridMakespanAndCost=$rScriptsDir"/02_1_calculate_grid_makespan_and_cost.R"
	calculateCloudMakespanAndCost=$rScriptsDir"/02_2_calculate_cloud_makespan_and_cost.R"
	calculateGridMakespanAndCostCI=$rScriptsDir"/03_1_calculate_grid_makespan_and_cost_ci.R"
	calculateCloudMakespanAndCostCI=$rScriptsDir"/03_2_calculate_cloud_makespan_and_cost_ci.R"
	calculateRelativeEfficiency=$rScriptsDir"/04_calculate_relative_efficiency.R"
	linePlotRelativeEfficiency=$rScriptsDir"/05_1_line_plot_relative_efficiency.R"
	latticeLinePlotRelativeEfficiency=$rScriptsDir"/05_2_lattice_line_plot_relative_efficiency.R"

# Arquivos de resultados
	gridSimulationSummaries=$resultsDir"/01_1_grid_simulation_summaries.txt"
	cloudSimulationSummaries=$resultsDir"/01_2_cloud_simulation_summaries.txt"
	gridMakespanAndCost=$resultsDir"/02_1_grid_makespan_cost.txt"
	cloudMakespanAndCost=$resultsDir"/02_2_cloud_makespan_cost.txt"
	gridMakespanAndCostCI=$resultsDir"/03_1_grid_makespan_cost_ci.txt"
	cloudMakespanAndCostCI=$resultsDir"/03_2_cloud_makespan_cost_ci.txt"
	relativeEfficiency=$resultsDir"/04_relative_efficiency.txt" 

# Graficos de resultados
	linePlotRelativeEfficiencyDIR=$resultsDir"/"
	linePlotRelativeEfficiencyPrefix="/05_1_line_plot_relative_efficiency_"
	latticeLinePlotRelativeEfficiencyPNG=$resultsDir"/05_2_lattice_line_plot_relative_efficiency.png"

# Execuções
	echo "---- - Begin of execution"
	echo "01-1 - Concatenar todos os resultados da grade" && \
	sh $ConcatenateGridSimulationSummaries  $gridOutputsDir  $gridSimulationSummaries  && \
	echo "01-2 - Concatenar todos os resultados da nuvem" && \
	sh $ConcatenateCloudSimulationSummaries $cloudOutputsDir $cloudSimulationSummaries && \
	echo "02-1 - Calcular makespan e custo da grade" && \
	$R $gridSimulationSummaries $gridMakespanAndCost < $calculateGridMakespanAndCost  && \
	echo "02-2 - Calcular makespan e custo da cloud" && \
	$R $cloudSimulationSummaries $cloudMakespanAndCost < $calculateCloudMakespanAndCost  && \
	echo "03-1 - Calcular CI makespan e custo da grade" && \
	$R $gridMakespanAndCost $gridMakespanAndCostCI < $calculateGridMakespanAndCostCI  && \
	echo "03-2 - Calcular CI makespan e custo da cloud" && \
	$R $cloudMakespanAndCost $cloudMakespanAndCostCI < $calculateCloudMakespanAndCostCI  && \
	echo "04-0 - Calcular a Eficiência Relativa" && \
	$R $gridMakespanAndCostCI $cloudMakespanAndCostCI $relativeEfficiency < $calculateRelativeEfficiency  && \
	echo "05-1 - Plotar a Eficiência Relativa" && \
	$R $relativeEfficiency $linePlotRelativeEfficiencyDIR $linePlotRelativeEfficiencyPrefix < $linePlotRelativeEfficiency  && \
	echo "05-2 - Plotar a Eficiência Relativa - Lattice" && \
	$R $relativeEfficiency $latticeLinePlotRelativeEfficiencyPNG < $latticeLinePlotRelativeEfficiency  && \
	echo "---- - End of execution"

