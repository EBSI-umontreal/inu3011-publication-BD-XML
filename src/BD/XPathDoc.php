<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-24
// YMA 2010-04-05, modif 2015-03-26
/*
	fichier : XPathDoc.php
	Description :
		Ce fichier ex�cute une requ�te XQuery qui affiche sous forme de liste <ul> 
		les documents, filtr�s par l'expression re�ue (param�tre rechercheXPath).
		Pour ce faire, il va lire le fichier "xquery/_XPathDoc.xquery" et remplacer
		les cha�nes NOMBASEDONNEE et RECHERCHEXPATH par les bonnes valeurs (NOMBASEDONNEE = 
		$nomBaseDeDonnees de configuration.php).

	Param�tres de cette page :
	- rechercheXPath (obligatoire - string) : terme ou expression � rechercher
	- afficherRequete (facultatif - bool�en 0/1; 0 par d�faut) : affiche un en-t�te indiquant
		la requ�te qui est envoy�e � la base de donn�es (ne pas confondre avec $debug 
		dans configuration.php)
*/

	include "fonctions.php";
//R�cup�rer les param�tres HTTP
	$XPathOrig = stripslashes($_GET['rechercheXPath']);

	$rechercheXPath = preprocessXPath($XPathOrig);

// Lecture du fichier "xquery/_XPathDoc.xquery" et remplacer les cha�nes NOMBASEDONNEE 
// et RECHERCHEXPATH par les bonnes valeurs
	$xquery = lireFichier("xquery/_XPathDoc.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHEXPATH", $rechercheXPath, $xquery);
//echo $xquery;
	//Inclure le fichier XPathDoc.inc.html personnalisant l'aspect du r�sultat
	include("XPathDoc.inc.html");
?>
