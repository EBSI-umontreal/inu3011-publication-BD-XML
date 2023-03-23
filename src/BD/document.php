<?php
	/*
	Auteur : Arnaud d'Alayer	Date : 2010-03-24
	
	fichier : document.php
	Description :
		Ce fichier permet de récupérer dans la base de données un document XML dont le chemin est spécifié dans le (paramètre document)
		Le document XML est affiché selon le format sélectionné (voir paramètre format)
	
	
	Paramètres de cette page :
	- document (obligatoire - string) : nom du document XML à récupérer dans la base de données; le nom du document doit inclure le nom de la collection (exemple : /db/demo/fichier.xml)
	- format (obligatoire - string) : Format de sortie. Les valeurs possibles sont :
		- xml : le serveur ajoute une entête XML suivi du contenu du document XML (veuillez vous assurer que les liens vers les différents fichiers seront fonctionnels pour qu'il s'affiche correctement dans le navigateur)
		- xslt : le serveur retourne le résultat d'une transformation XSLT du document XML; La feuille de style XSLT doit être spécifiée (voir paramètre xslt)
		- pre : le serveur retourne le contenu du document XML sous forme HTML dans un conteneur <pre>
		- brut (non recommandé) : le serveur retourne le contenu du document XML directement (sans ajout d'entête XML)
	- xslt (facultatif - string) : nom de la feuille de styles XSLT (dans le dossier "xslt/") à appliquer lorsque le format de de sortie xslt est spécifié
	
	Exemples :
	- afficher le document "abramites_hypselonotus.xml" de la base de données "/db/demo/" sous format HTML dans un conteneur <pre>
	  document=/db/demo/abramites_hypselonotus.xml&format=pre
	  
	- afficher le résultat de la transformation XSLT du document "abramites_hypselonotus.xml" de la base de données "/db/demo/" par la feuille de styles "poissons-xml2html.xsl" du dossier "xslt/"
	  document.php?document=/db/demo/abramites_hypselonotus.xml&format=xslt&xslt=poissons-xml2html.xsl
	
	Pour personnaliser l'affichage de cette page, vous pouvez :
	- éditer le fichier "document.inc.html" pour les formats "pre" et "brut"
	- éditer une feuille de style XSLT qui sera spécifiée en paramètre pour le format "xslt"
	*/
	
	
	include "fonctions.php";
	$document = $_GET['document'];
	$format = $_GET['format'];
//	$feuilleXSLT = $_GET['xslt'];

function fixdocuri($docuri) {
// YMA 2010-04-02
	return str_replace('%2F', '/', rawurlencode($docuri));
}

	if ($document == ""){
		die("Veuillez specifier un document XML");
	}
	
	switch($format){
	case "xml" :
		$result = executerXquery(
			'doc("' . fixdocuri($document) . '")/*', false);
// YMA 2010-04-02 le "/*" ci-dessus permet d'éliminer les PI xml-stylesheet
		afficherResultat($result, $format);
		break;
	case "xslt" :
		$result = executerXquery(
			'doc("' . fixdocuri($document) . '")/*', false);
// YMA 2010-04-02 le "/*" ci-dessus permet d'éliminer les PI xml-stylesheet
// ce n'est pas absolument nécessaire ici, mais ça ne nuit pas
		if ($feuilleXSLT!=""){
			$sortieXSLT = transformationXSLT($result, $feuilleXSLT);
			afficherResultat($sortieXSLT, "brut");
		}
		else{
			die("Veuillez specifier une feuille XSLT");
		}
		break;
	case "pre" :
	case "brut" :
//contrairement aux autres cas, on execute la recherche à partir du fichier 
//.inc.html pour que le résultat soit valide xhtml si nous demandons l'affichage 
//de la requête
		include("document.inc.html");
		break;
	default :
		die("Veuillez specifier un format de sortie valide");
	}
?>
