<?php
	//Auteur : Arnaud d'Alayer	Date : 2010-03-24
/*
	fichier : pleinTexte.php
	Description :
		Ce fichier exécute une requête XQuery qui affiche sous forme de liste <ul> l'ensemble des documents qui répondent à l'expression reçue (paramètre rechercheTexte).
		Pour ce faire, il va lire le fichier "xquery/_pleinTexte.xquery" et remplacer les chaînes NOMBASEDONNEE et RECHERCHETEXTE par les bonnes valeurs (NOMBASEDONNEE = $nomBaseDeDonnees de configuration.php).
	
	
	Paramètres de cette page :
	- rechercheTexte (obligatoire - string) : terme ou expression à rechercher
	- afficherRequete (facultatif - booléen 0/1; 0 par défaut) : affiche un en-tête indiquant la requête qui est envoyée à la base de données (ne pas confondre avec $debug dans configuration.php)
	
	Exemples :
	- recherchera le terme "abracadabra" et affichera l'en-tête : 
	  pleinTexte.php?rechercheTexte=abracadabra&afficherRequete=1 
	  
	- recherchera l'expression "abrac*" et affichera l'en-tête : 
	  pleinTexte.php?rechercheTexte=abrac*&afficherRequete=0
	  ou
	  pleinTexte.php?rechercheTexte=abrac*
	
	Pour personnaliser l'affichage de cette page, vous pouvez :
	- éditer le fichier "pleinTexte.inc.html"
	- éditer le fichier "xquery/_pleinTexte.xquery"
*/

	include "fonctions.php";
	//Récupérer les paramètres HTTP
	$rechercheTexte = stripslashes($_GET['rechercheTexte']);
	$rechercheTexte = str_replace("'", "&apos;", $rechercheTexte);
	$afficherRequete = $_GET['afficherRequete'];
	
	//Vérifier qu'une expression de recherche est existante
	if ($rechercheTexte == ""){
		//Si non, afficher un message d'erreur
		die("Veuillez specifier un terme ou une expression a rechercher");
	}

	//lecture du fichier "xquery/_pleinTexte.xquery" et remplacer les chaînes NOMBASEDONNEE et RECHERCHETEXTE par les bonnes valeurs
	$xquery = lireFichier("xquery/_pleinTexte.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHETEXTE", $rechercheTexte, $xquery);
	
	//Inclure le fichier pleinTexte.inc.html personnalisant l'aspect du résultat
	include("pleinTexte.inc.html");
?>
