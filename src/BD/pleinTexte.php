<?php
	//Auteur : Arnaud d'Alayer	Date : 2010-03-24
/*
	fichier : pleinTexte.php
	Description :
		Ce fichier ex�cute une requ�te XQuery qui affiche sous forme de liste <ul> l'ensemble des documents qui r�pondent � l'expression re�ue (param�tre rechercheTexte).
		Pour ce faire, il va lire le fichier "xquery/_pleinTexte.xquery" et remplacer les cha�nes NOMBASEDONNEE et RECHERCHETEXTE par les bonnes valeurs (NOMBASEDONNEE = $nomBaseDeDonnees de configuration.php).
	
	
	Param�tres de cette page :
	- rechercheTexte (obligatoire - string) : terme ou expression � rechercher
	- afficherRequete (facultatif - bool�en 0/1; 0 par d�faut) : affiche un en-t�te indiquant la requ�te qui est envoy�e � la base de donn�es (ne pas confondre avec $debug dans configuration.php)
	
	Exemples :
	- recherchera le terme "abracadabra" et affichera l'en-t�te : 
	  pleinTexte.php?rechercheTexte=abracadabra&afficherRequete=1 
	  
	- recherchera l'expression "abrac*" et affichera l'en-t�te : 
	  pleinTexte.php?rechercheTexte=abrac*&afficherRequete=0
	  ou
	  pleinTexte.php?rechercheTexte=abrac*
	
	Pour personnaliser l'affichage de cette page, vous pouvez :
	- �diter le fichier "pleinTexte.inc.html"
	- �diter le fichier "xquery/_pleinTexte.xquery"
*/

	include "fonctions.php";
	//R�cup�rer les param�tres HTTP
	$rechercheTexte = stripslashes($_GET['rechercheTexte']);
	$rechercheTexte = str_replace("'", "&apos;", $rechercheTexte);
	$afficherRequete = $_GET['afficherRequete'];
	
	//V�rifier qu'une expression de recherche est existante
	if ($rechercheTexte == ""){
		//Si non, afficher un message d'erreur
		die("Veuillez specifier un terme ou une expression a rechercher");
	}

	//lecture du fichier "xquery/_pleinTexte.xquery" et remplacer les cha�nes NOMBASEDONNEE et RECHERCHETEXTE par les bonnes valeurs
	$xquery = lireFichier("xquery/_pleinTexte.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHETEXTE", $rechercheTexte, $xquery);
	
	//Inclure le fichier pleinTexte.inc.html personnalisant l'aspect du r�sultat
	include("pleinTexte.inc.html");
?>
