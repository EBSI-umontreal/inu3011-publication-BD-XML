<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-24
/*	YMA 2010-04-05
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

// Traitement identique à celui de XPathDoc.php:
// quoteAwareStrRep fait un remplacement de chaîne de façon "attentive aux guillemets"
// N.B.: Cela fonctionne avec la syntaxe XQuery, où les guillemets à l'intérieur des
// chaînes sont simplement doublés (ou encore on utilise les entités &amp; ou &apos;)
// Tous ces cas sont traités correctement par quoteAwareStrRep
	$XPathOrig = quoteAwareStrRep(' ', '', $XPathOrig); // Remove all spaces (except within quotes)
	$XPathOrig = quoteAwareStrRep('	', '', $XPathOrig); // Remove all tabs (except within quotes)
// Un peu drastique, enlever les espaces et des tabs, mais au pire ça corrige des erreurs, ça ne peut pas en causer

	$rechercheXPath = $XPathOrig;

	$rechercheXPath = quoteAwareStrRep('(/', '($doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('|/', '|$doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('[/', '[$doc/', $rechercheXPath);
	if (substr($rechercheXPath, 0, 1) == '/') $rechercheXPath = '$doc' . $rechercheXPath;

//Vérifier qu'une expression XPath absolue est fournie
	if ($rechercheXPath == $XPathOrig)
// Si rien n'a changé, ce n'est pas une expression XPath absolue
		die("Veuillez sp&#233;cifier une expression XPath absolue");

	$xquery = lireFichier("xquery/_XPath.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	$xquery = str_replace("RECHERCHEXPATH", $rechercheXPath, $xquery);
	
	//Inclure le fichier XPath.inc.html personnalisant l'aspect du résultat
	include("XPath.inc.html");
?>
