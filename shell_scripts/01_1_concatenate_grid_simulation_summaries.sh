#!/bin/sh

dir=$1
fileName=$2

echo $header > $fileName

for r in $rodadas; do
	for u in $usersPerPeer; do
		eval "tail -q -n1 $dir/oursim-trace-persistent_*_machines_7_dias_*_sites_${u}_upp_"$r".txt | sed -e 's/#/"$r"" ""${u}"/g'" >> $fileName
	done		
done

