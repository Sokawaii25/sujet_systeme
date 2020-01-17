#!/bin/bash

function parcours_dossiers()
{
    cheminInitial=`pwd` #on note le chemin de base
    dossiers=`ls -R | grep "./" | sed 's/://g'`#on liste les dossiers et sous-dossiers à trier
    IFS=$'\t\n'
    listeDossiers=()
    for dossier in $dossiers #on met cette liste dans un tableau explitable
    do
	listeDossiers[${#listeDossiers[*]}]=$dossier #
    done
    for dossier in ${listeDossiers[@]} #et pour chaque dossier dans cette liste ...
    do
	IFS=$'\t\n'
	cd $cheminInitial/$dossier #... on rentre dedans ...
	IFS=$' \t\n'
	tri_extension #... et on trie son contenu ...
	cd $cheminInitial #... avant d'en ressortir
    done
}

#le dictionnaire des extensions est composé de lignes, chaque ligne ressemble à ça : nom_dossier  extension1 extension2...
#idem pour le dictionnaire des catégories

function tri_extension()
{
    echo "Début du tri par extension dans $dossier"
    lignes=`wc -l < $cheminInitial/dico_triExtension.txt` #on compte le nombre de lignes
    for i in `seq 1 $lignes`   #pour chaque ligne du dico
    do
       	ligneExt=`cat $cheminInitial/dico_triExtension.txt | awk -v i=$i 'NR == i {print;}'` #on la récupère
	folderExt=`echo $ligneExt | cut -d\  -f1` #on définit le dossier cible
       	for ext in $ligneExt #et pour chaque extension on check tous les fichiers
	do
	    #partie tri par extension
	    files=`ls | grep $ext`			
	    if [ "$files" != "" ]; then
                if [ ! -d ./$folderExt ]; then
                    mkdir ./$folderExt
            	fi
                mv $files ./$folderExt/
            fi
       	done
	if [ "$folderExt" = "Documents" ] && [ -d Documents ]; then #et dans l'éventualité où le dossier cible est Documents ...
	    cd Documents #... alors on se déplace dedans ...
	    tri_contenu #... et on lance le tri par contenu
	fi
    done
}

function tri_contenu()
{
    echo "début du tri par contenu dans $dossier"
    nblignes=`wc -l < $cheminInitial/dico_triContenu.txt` #on récupère le nombre de lignes du dico
    for j in `seq 1 $nblignes`    #et pour chaque ligne du dico ...
    do
	ligneCon=`cat $cheminInitial/dico_triContenu.txt | awk -v j=$j 'NR == j {print;}'` #... on récupère la ligne dans le dico ...
	folderCon=`echo $ligneCon | cut -d\  -f1` # ... le dossier cile ...
	for mot in $ligneCon #... et pour chaque mot ...
	do
	    #partie tri par contenu
	    occurences=`grep -isl $mot *` #... on récupère la liste des fichiers le contenant ...
	    if [ "$occurences" != "" ]; then #... et s'il y en a ...
		extensionCon=`echo $occurences | sed 's/.*\.//g'` #... on vérifie que ce sont bien des fichiers .txt ... 
		if [ "$extensionCon" = "txt" ]; then
		    if [ ! -d ./$folderCon ]; then #... on crée le dossier cible s'il n'existe pas ...
               		mkdir ./$folderCon
          	    fi
		    mv $occurences ./$folderCon/ #... et on déplace les fichiers dans le dossier cible
 		fi
	    fi
	done
    done
}

parcours_dossiers
