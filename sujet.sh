#!/bin/bash

liste=()
 
parcours_dossiers()
{
    dossiers=`ls -d */`
    for i in $dossiers
    do
	    liste[${#liste[*]}]=$i
    done
    chemin=`pwd`
    for dossier in ${liste[@]}
    do
	cd $chemin/$dossier
	parcours_dico
    done
    cd $chemin
    tri_contenu
}

#le dictionnaire est composé de lignes, chaque ligne ressemble à ça : nom_dossier,extension1,extension2...

parcours_dico(){            #cette fonction classifie le dossier pour chaque ligne
	lignes=`wc -l ../dico_triExtension.txt | sed -e "s| ../dico_triExtension.txt||g"` #on récupère le nombre de lignes 
	for i in `seq 1 $lignes`    #et on classe (fonction classify) pour chaque ligne du dico
 	do
       	    ligne=`cat ../dico_triExtension.txt | awk -v i=$i 'NR == i {print;}'`
       	    listeExt=()
       	    for mot in $ligne; do
		listeExt[${#listeExt[*]}]=$mot
       	    done
       	    tri_extension
	done
}

tri_extension()
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

function tri_contenu()
{
    if [ -d Documents ]; then
	cd $chemin/Documents
	lignes2=`wc -l ../dico_triContenu.txt | sed -e "s| ../dico_triContenu.txt||g"` #on récupère le nombre de lignes 
	for i in `seq 1 $lignes2`    #et on classe (fonction classify) pour chaque ligne du dico
 	do
       	    ligne2=`cat ../dico_triContenu.txt | awk -v i=$i 'NR == i {print;}'`
       	    listeMots=()
       	    for mot in $ligne2; do
		listeMots[${#listeMots[*]}]=$mot
       	    done
       	    
	done
    fi
}

parcours_dossiers
# on peut faire sh s.sh param
