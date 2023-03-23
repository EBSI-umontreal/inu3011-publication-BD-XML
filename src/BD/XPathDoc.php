<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-24
// YMA 2010-04-05, modif 2015-03-26
/*
	fichier : XPathDoc.php
	Description :
		Ce fichier exécute une requête XQuery qui affiche sous forme de liste <ul> 
		les documents, filtrés par l'expression reçue (paramètre rechercheXPath).
		Pour ce faire, il va lire le fichier "xquery/_XPathDoc.xquery" et remplacer
		les chaînes NOMBASEDONNEE et RECHERCHEXPATH par les bonnes valeurs (NOMBASEDONNEE = 
		$nomBaseDeDonnees de configuration.php).

	Paramètres de cette page :
	- rechercheXPath (obligatoire - string) : terme ou expression à rechercher
	- afficherRequete (facultatif - booléen 0/1; 0 par défaut) : affiche un en-tête indiquant
		la requête qui est envoyée à la base de données (ne pas confondre avec $debug 
		dans configuration.php)
*/

	include "fonctions.php";
//Récupérer les paramètres HTTP
	$XPathOrig = stripslashes($_GET['rechercheXPath']);

	$rechercheXPath = preprocessXPath($XPathOrig);

// Lecture du fichier "xquery/_XPathDoc.xquery" et remplacer les chaînes NOMBASEDONNEE 
// et RECHERCHEXPATH par les bonnes valeurs
	$xquery = lireFichier("xquery/_XPathDoc.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHEXPATH", $rechercheXPath, $xquery);
//echo $xquery;
	//Inclure le fichier XPathDoc.inc.html personnalisant l'aspect du résultat
	include("XPathDoc.inc.html");
?>
