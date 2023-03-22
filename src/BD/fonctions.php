<?php
	//Auteur : Arnaud d'Alayer	Date : 2010-03-29
	
	include "configuration.php";
	include "bin/exist-phpapi/exist_phpapi.inc";
	
	/*lireFichier()
	Description : fonction permettant de lire un fichier et de retourner son contenu sous forme d'une chaine de caractères (string)
	Source : http://snippetdb.com/php/read-file-to-a-string
	Paramètre(s) :
	- $filename (string - obligatoire) : adresse du fichier à ouvrir
	Retour :
	- (String) : contenu du fichier
	*/
	function lireFichier($filename){
		$output = "";
		
		if (file_exists($filename)){
			$file = fopen($filename, "r");
			while(!feof($file)){
				//read file line by line into variable
			  $output = $output . fgets($file, 4096);
			}
			fclose ($file);
		}
		return $output;
	}
	
	
	/*executerXquery()
	Description : fonction permettant d'exécuter une requête Xquery envoyée en paramètre (string)
	Paramètre(s) :
	- $xquery (string - obligatoire) : requête XQuery à exécuter dans la base de données configurée dans configuration.php
	- $nePasMasquer (booléen - facultatif) : permet de désactiver l'affichage de l'entête même si l'affichage est activé dans configuration.php (utile pour les sorties XML)
	Retour :
	- (string) : Chaine de caractères contenant le résultat de la requête XQuery
	*/
	function executerXquery($xquery, $nePasMasquerEnTete = true){
		global $serveurChemin; global $serveurAdresse; global $serveurport; global $utilisateurNom; global $utilisateurMotDePasse; global $debug; global $afficherEnTeteXQuery;
		
		$db = new eXist($serveurChemin, $serveurAdresse, $serveurport);
		$db->setCredentials ($utilisateurNom, $utilisateurMotDePasse);
		$db->setDebug($debug);
		
		if ($afficherEnTeteXQuery and $nePasMasquerEnTete) {
			echo "<p><strong>Requête XQuery : <br/>" . str_replace("\r", "<br />", htmlspecialchars($xquery)) . "</strong></p>";
		}
		
		$result = $db->executeQuery($xquery);
		//obtenir le résultat de la requête sous forme d'une Chaine de caractères
		$num = 0;
		$sortie = "";
		while ( $db->retrieve($result, $num)!=""){
			$sortie = $sortie . $db->retrieve($result, $num) . "\n";
			$num++;
		}
		/*echo "<hr/>" . $db->retrieve($result, 0);
		echo "<hr/>" . $db->retrieve($result, 1);*/
		
		return $sortie;

	}
	
	
	/*executerFichierXquery()
	Description : fonction permettant d'exécuter une requête Xquery stockée dans un fichier
	Paramètre(s) :
	- $filename (string - obligatoire) : adresse du fichier XQuery à ouvrir
	Retour :
	- (string) : Chaine de caractères contenant le résultat de la requête XQuery
	*/
	function executerFichierXquery($filename, $nePasMasquerEnTete = true){
		$xquery = lireFichier("xquery/" . $filename);
		return executerXquery($xquery, $nePasMasquerEnTete);
	}
	
	
	/*afficherResultat()
	Description : permet d'afficher un résultat de requête XQuery selon un format déterminé
	Paramètre(s) :
	- $result (string) : résultat XQuery de executerXquery()
	- $format
		- xml : le serveur ajoute une entête XML suivi du contenu du document XML
		- pre : le serveur retourne le contenu du document XML sous forme HTML dans un conteneur <pre>
		- brut : le serveur retourne le contenu du résultat de la requête XQuery directement (utile si la requête XQuery retourne du code HTML)
	Retour : NA
	*/
	function afficherResultat($result, $format, $surligne=""){
		switch($format){
			case "xml" :
				header('Content-type: text/xml');
				echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
				echo $result;
				break;
			case "brut" :
				//ce cas est inutile (car revient à afficher directement le résultat de executerXquery()), mais pour des raisons pédagogique nous l'avons ajouté
				echo $result;
				break;
			case "pre" :
				echo "\n<pre>\n";
				echo htmlspecialchars($result);
				echo "\n</pre>\n";
				break;
			default :
				echo "format d'affichage invalide";
		}
	}
	
	
	// Source : http://www.tonymarston.net/php-mysql/xsl.html
	function transformationXSLT($docXML, $feuilleXSLT){
		$sortie = "";
		
		$docATransformer = new DOMDocument();
		$docATransformer->loadXML($docXML);
		
		$xp = new XsltProcessor();
		$xsl = new DOMDocument();
		if (file_exists("xslt/" . $feuilleXSLT)){
			$xsl->load("xslt/" . $feuilleXSLT);
			$xp->importStylesheet($xsl);
			$sortie = $xp->transformToXML($docATransformer);
		}
		else {
			echo "Feuille XSLT n'existe pas";
		}
		return $sortie;
	}
?>