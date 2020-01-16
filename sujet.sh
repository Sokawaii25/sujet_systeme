#!/bin/bash

function parcours_dossiers()
{
    cheminInitial=`pwd`
    dossiers=`ls -R | grep "./" | sed 's/://g'`
    IFS=$'\t\n'
    listeDossiers=()
    for dossier in $dossiers
    do
	listeDossiers[${#listeDossiers[*]}]=$dossier
    done
    for dossier in ${listeDossiers[@]}
    do
	IFS=$'\t\n'
	cd $cheminInitial/$dossier
	IFS=$' \t\n'
	tri_extension
	cd $cheminInitial
    done
}

#le dictionnaire est composé de lignes, chaque ligne ressemble à ça : nom_dossier,extension1,extension2...

function tri_extension()
{
    echo "Début du tri par extension dans $dossier"
    lignes=`wc -l < $cheminInitial/dico_triExtension.txt` #on récupère le nombre de lignes
    for i in `seq 1 $lignes`   #et on classe pour chaque ligne du dico
    do
       	ligneExt=`cat $cheminInitial/dico_triExtension.txt | awk -v i=$i 'NR == i {print;}'`
	folderExt=`echo $ligneExt | cut -d\  -f1`
       	for ext in $ligneExt
	do
	    #partie tri par extension
	    for file in * 
	    do
		#tester chaque extension de la catégorie
		extension=`echo $file | sed 's/.*\.//g'`			
		if [ $ext = $extension ]; then
                    if [ ! -d ./$folderExt ]; then
                	mkdir ./$folderExt
            	    fi
                    mv $file ./$folderExt/
        	fi
	    done
       	done
	if [ "$folderExt" = "Documents" ] && [ -d Documents ]; then
	    cd Documents
	    tri_contenu
	fi
    done
}

function tri_contenu()
{
    echo "début du tri par contenu dans $dossier"
    nblignes=`wc -l < $cheminInitial/dico_triContenu.txt` #on récupère le nombre de lignes 
    for j in `seq 1 $nblignes`    #et on classe pour chaque ligne du dico
    do
	ligneCon=`cat $cheminInitial/dico_triContenu.txt | awk -v j=$j 'NR == j {print;}'`
	folderCon=`echo $ligneCon | cut -d\  -f1`
	for mot in $ligneCon
	do
	    #partie tri par contenu
	    occurences=`grep -isl $mot *`
	    if [ "$occurences" != "" ]; then 
		extensionCon=`echo $occurences | sed 's/.*\.//g'`
		if [ "$extensionCon" = "txt" ]; then
		    if [ ! -d ./$folderCon ]; then
               		mkdir ./$folderCon
          	    fi
		    mv $occurences ./$folderCon/
 		fi
	    fi
	done
    done
}

parcours_dossiers
