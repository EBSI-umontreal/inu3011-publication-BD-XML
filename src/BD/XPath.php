<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-24
/*	YMA 2010-04-05, modif 2015-03-26
	fichier : XPath.php
	Description :
		Ce fichier exécute une expression XPath absolue pouvant retourner un ou plusieurs résultats
		pour chaque document dans la BD. Ces résultats sont présentés sous forme de
		listes <ol> (une pour chaque document) imbriquées dans une <ul> (unique pour la BD).
		Pour ce faire, le fichier "xquery/_XPath.xquery" est lu et on remplace les chaînes NOMBASEDONNEE et
		RECHERCHEXPATH par les bonnes valeurs (NOMBASEDONNEE = $nomBaseDeDonnees de configuration.php).

Paramètres de cette page :
- rechercheXPath (obligatoire - string) : expression XPath à rechercher
- afficherRequete (facultatif - booléen 0/1; 0 par défaut): affiche un en-tête indiquant la requête qui
	est envoyée à la base de données (ne pas confondre avec $debug dans configuration.php)
*/
	include "fonctions.php";
//Récupérer les paramètres HTTP
	$XPathOrig = stripslashes($_GET['rechercheXPath']);

	$rechercheXPath = preprocessXPath($XPathOrig);

	$xquery = lireFichier("xquery/_XPath.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHEXPATH", $rechercheXPath, $xquery);
	
	//Inclure le fichier XPath.inc.html personnalisant l'aspect du résultat
	include("XPath.inc.html");
?>
