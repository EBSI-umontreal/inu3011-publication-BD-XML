<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-24
// YMA 2010-04-05
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
	$rechercheXPath = $XPathOrig;

// Traitement identique � celui de XPath.php:
// quoteAwareStrRep fait un remplacement de cha�ne de fa�on "attentive aux guillemets"
// N.B.: Cela fonctionne avec la syntaxe XQuery, o� les guillemets � l'int�rieur des
// cha�nes sont simplement doubl�s (ou encore on utilise les entit�s &amp; ou &apos;)
// Tous ces cas sont trait�s correctement par quoteAwareStrRep
	$rechercheXPath = quoteAwareStrRep(' ', '', $rechercheXPath); // Remove all spaces (except within quotes)
	$rechercheXPath = quoteAwareStrRep('	', '', $rechercheXPath); // Remove all tabs (except within quotes)
// Un peu drastique, enlever les espaces et des tabs, mais au pire �a corrige des erreurs, �a ne peut pas en causer
	$rechercheXPath = quoteAwareStrRep('(/', '($doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('|/', '|$doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('[/', '[$doc/', $rechercheXPath);
	if (substr($rechercheXPath, 0, 1) == '/') $rechercheXPath = '$doc' . $rechercheXPath;

//V�rifier qu'une expression XPath absolue a �t� fournie
	if ($rechercheXPath == $XPathOrig)
// Si rien n'a chang�, ce n'est pas une expression XPath absolue
		die("Veuillez sp&#233;cifier une expression XPath absolue");

// � cause d'un bug de eXist, il faut aussi remplacer les * par *[position()] (croyez-le ou non!!!)
// qui, en principe, est un synonyme exact
	$rechercheXPath = quoteAwareStrRep('*', '*[position()]', $rechercheXPath);

// Lecture du fichier "xquery/_XPathDoc.xquery" et remplacer les cha�nes NOMBASEDONNEE 
// et RECHERCHEXPATH par les bonnes valeurs
	$xquery = lireFichier("xquery/_XPathDoc.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHEXPATH", $rechercheXPath, $xquery);
//echo $xquery;
	//Inclure le fichier XPathDoc.inc.html personnalisant l'aspect du r�sultat
	include("XPathDoc.inc.html");
?>
