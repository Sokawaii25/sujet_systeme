#!/bin/bash

liste=()
 
parcours_dossiers()
{
    dossiers=`ls -d */`
    for i in $dossiers
    do
	    liste[${#liste[*]}]=$i
    done
    test=`pwd`
    for dossier in ${liste[@]}
    do
	cd $test/$dossier
	parcours_dico
	echo ${liste[@]}
    done
}

#le dictionnaire est composé de lignes, chaque ligne ressemble à ça : nom_dossier,extension1,extension2...

parcours_dico(){            #cette fonction classifie le dossier pour chaque ligne
	lignes=`wc -l ../classement.txt | sed -e "s| ../classement.txt||g"` #on récupère le nombre de lignes 
	for i in `seq 1 $lignes`    #et on classe (fonction classify) pour chaque ligne du dico
 	do
       	    ligne=`cat ../classement.txt | awk -v i=$i 'NR == i {print;}'`
       	    listeExt=()
       	    for mot in $ligne; do
		listeExt[${#listeExt[*]}]=$mot
       	    done
       	    classify_cat
	done
}

classify_cat()
{
	for file in * 
	do 
		#tester chaque extension de la catégorie sur la commande `ls | grep -e extension`
		extension=`echo $file | sed 's/.*\.//g'`			
	        if [[ " ${listeExt[@]} " =~ " ${extension} " ]]; then #array sera la liste des extensions courantes
                	if [ ! -d ./${listeExt[0]} ]; then
                		mkdir ./${listeExt[0]}
            		fi
                	mv $file ./${listeExt[0]}/
        	fi
    	done
}

parcours_dossiers
# on peut faire sh s.sh param
