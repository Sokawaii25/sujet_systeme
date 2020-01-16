#!/bin/bash
 
function parcours_dossiers()
{
    liste=()
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
}

#le dictionnaire est composé de lignes, chaque ligne ressemble à ça : nom_dossier,extension1,extension2...

function parcours_dico(){            #cette fonction classifie le dossier pour chaque ligne
    lignes=`wc -l < $chemin/dico_triExtension.txt` #on récupère le nombre de lignes 
    for i in `seq 1 $lignes`    #et on classe (fonction classify) pour chaque ligne du dico
    do
       	ligne=`cat $chemin/dico_triExtension.txt | awk -v i=$i 'NR == i {print;}'`
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
	    if [[ " ${listeExt[@]} " =~ " ${extension} " ]]; then
                    if [ ! -d ./${listeExt[0]} ]; then
                	mkdir ./${listeExt[0]}
            	    fi
                    mv $file ./${listeExt[0]}/
        	fi
    done
    if [ ${listeExt[0]} = "Documents" ]; then
	cd ${listeExt[0]}
	tri_contenu
    fi
}

function tri_contenu()
{
    nblignes=`wc -l < $chemin/dico_triContenu.txt` #on récupère le nombre de lignes 
    for i in `seq 1 $nblignes`    #et on classe pour chaque ligne du dico
    do
	ligne2=`cat $chemin/dico_triContenu.txt | awk -v i=$i 'NR == i {print;}'`
	folder=`echo $ligne2 | cut -d\  -f1`
	for mot in $ligne2; do
	    #partie tri par contenu
	    occurences=`grep -is $mot *`
	    if [ "$occurences" != "" ]; then 
		filenames=`echo $occurences | cut -d: -f1`
		extension2=`echo $filename | sed 's/.*\.//g'`
		if [ "$extension2" = "txt" ]; then
		    if [ ! -d ./$folder ]; then
               		mkdir ./$folder
          	    fi
		    mv $filenames ./$folder/
 		fi
	    fi
	done
    done
}

parcours_dossiers
