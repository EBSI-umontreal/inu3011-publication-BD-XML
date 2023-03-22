<?php
	//Auteur : Arnaud d'Alayer	Date : 2010-03-24
	/*
	fichier : xquery.php
	Description :
		Ce fichier permet d'exécuter une requête XQuery qui est stockée dans un fichier (.xquery) dans le dossier "xquery/"
		Le résultat de la requête XQuery est affiché selon le format sélectionné (voir paramètre format)
	
	
	Paramètres de cette page :
	- fichierXquery (obligatoire - string) : nom du fichier XQuery dans le dossier "xquery/" à exécuter
	- format (obligatoire - string) : Format de sortie. Les valeurs possibles sont :
		- xml : le serveur ajoute une entête XML suivi du contenu du résultat de la requête XQuery
		- xslt : le serveur retourne le résultat d'une transformation XSLT du résultat de la requête XQuery; La feuille de style XSLT doit être spécifiée (voir paramètre xslt)
		- pre : le serveur retourne le contenu du résultat de la requête XQuery sous forme HTML dans un conteneur <pre>
		- brut : le serveur retourne le contenu du résultat de la requête XQuery directement (utile si la requête XQuery retourne du code HTML)
	- xslt (facultatif - string) : nom de la feuille de styles XSLT (dans le dossier "xslt/") à appliquer sur le résultat de la requête XQuery
	
	Exemples :
	- 
	  
	  
	- 
	  
	
	Pour personnaliser l'affichage de cette page, vous pouvez :
	- éditer le fichier "xquery.inc.html" pour les formats "pre" et "brut"
	- éditer une feuille de style XSLT qui sera spécifiée en paramètre pour le format "xslt"
	*/
	
	include "fonctions.php";
	$fichierXquery = $_GET['fichierXquery'];
	$format = $_GET['format'];
	$feuilleXSLT = $_GET['xslt'];

if ($fichierXquery==""){
	die("Veuillez spécifier un fichier XQuery");
}

switch($format){
	case "xml" :
		$result = executerFichierXquery($fichierXquery, false);
		afficherResultat($result, $format);
		break;
	case "xslt" :
		$result = executerFichierXquery($fichierXquery);
		if ($feuilleXSLT!=""){
			$sortieXSLT = transformationXSLT($result, $feuilleXSLT);
			afficherResultat($sortieXSLT, "brut");
		}
		else{
			die("Veuillez spécifier une feuille XSLT");
		}
		break;
	case "pre" :
	case "brut" :
		//contrairement aux autres cas, on execute la recherche à partir du fichier .inc.html pour que le résultat soit valide xhtml si nous demandons l'affichage de la requête
		include("xquery.inc.html");
		break;
	default :
		die("Veuillez spécifier un format de sortie");
}
?>