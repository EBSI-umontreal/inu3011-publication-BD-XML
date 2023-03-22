<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-24
// YMA 2010-04-05
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
	$rechercheXPath = $XPathOrig;

// Traitement identique à celui de XPath.php:
// quoteAwareStrRep fait un remplacement de chaîne de façon "attentive aux guillemets"
// N.B.: Cela fonctionne avec la syntaxe XQuery, où les guillemets à l'intérieur des
// chaînes sont simplement doublés (ou encore on utilise les entités &amp; ou &apos;)
// Tous ces cas sont traités correctement par quoteAwareStrRep
	$rechercheXPath = quoteAwareStrRep(' ', '', $rechercheXPath); // Remove all spaces (except within quotes)
	$rechercheXPath = quoteAwareStrRep('	', '', $rechercheXPath); // Remove all tabs (except within quotes)
// Un peu drastique, enlever les espaces et des tabs, mais au pire ça corrige des erreurs, ça ne peut pas en causer
	$rechercheXPath = quoteAwareStrRep('(/', '($doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('|/', '|$doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('[/', '[$doc/', $rechercheXPath);
	if (substr($rechercheXPath, 0, 1) == '/') $rechercheXPath = '$doc' . $rechercheXPath;

//Vérifier qu'une expression XPath absolue a été fournie
	if ($rechercheXPath == $XPathOrig)
// Si rien n'a changé, ce n'est pas une expression XPath absolue
		die("Veuillez sp&#233;cifier une expression XPath absolue");

// À cause d'un bug de eXist, il faut aussi remplacer les * par *[position()] (croyez-le ou non!!!)
// qui, en principe, est un synonyme exact
	$rechercheXPath = quoteAwareStrRep('*', '*[position()]', $rechercheXPath);

// Lecture du fichier "xquery/_XPathDoc.xquery" et remplacer les chaînes NOMBASEDONNEE 
// et RECHERCHEXPATH par les bonnes valeurs
	$xquery = lireFichier("xquery/_XPathDoc.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHEXPATH", $rechercheXPath, $xquery);
//echo $xquery;
	//Inclure le fichier XPathDoc.inc.html personnalisant l'aspect du résultat
	include("XPathDoc.inc.html");
?>
