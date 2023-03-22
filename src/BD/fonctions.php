<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-29
//Modif: YMA 2011-04-07

	include "configuration.php";

// Section déplacée de "configuration.php" pour simplifier
// ce dernier (YMA 2010-04-01):
	$serveurAdresse = "localhost";
	$serveurport = "8088";
	$serveurProtocole = "http";
	$serveurChemin = "/xmlrpc";
	//Afficher la requête XQuery
	//Afficher la journalisation de exist-phpapi
	$debug = false;
// Fin de la section déplacée de "configuration.php"

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
			echo utf8_encode("<p><strong>Requête XQuery : <br/>" . str_replace("\r", "<br />", htmlspecialchars($xquery)) . "</strong></p>");
		}

// YMA 2011-04-07 Ce qui suit, pour éviter de traîner le résultat d'une ancienne requête
// dans le cas où la requête courante est en erreur...
		$result = $db->executeQuery("'Erreur, d&#233;sol&#233;.'");
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
				echo ("Format d'affichage inconnu: ".$format);
		}
	}
	
	
	// Source : http://www.tonymarston.net/php-mysql/xsl.html
	function transformationXSLT($docXML, $feuilleXSLT) {
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
			echo ("Feuille XSLT inconnue: ".$feuilleXSLT);
		}
		return $sortie;
	}

function num_strpos($str, $rech, $offset) {
// YMA 2011-04-12
/* Une version de strpos qui retourne toujours du numérique:
Si la chaîne recherchée n'est pas trouvée, alors c'est la longueur
de la chaîne soumise qui est retournée.
*/
	$res = strpos($str, $rech, $offset);
	return ($res === false ? strlen($str) : $res);
};

function quoteAwareStrRep($rech, $remp, $str) {
// YMA 2011-04-12
// L'ordre et la signification des arguments est comme str_replace
	$res = '';
	while (strlen($str) > 0) {
		$posDelim = min(num_strpos($str, '\'', 0), num_strpos($str, '"', 0));
// We can safely do the replace until the first ' or "
		$res = $res . str_replace($rech, $remp, substr($str, 0, $posDelim));
		$str = substr($str, $posDelim);
// If a delimiter was found, we must copy without change until and including the matching delimiter
		if (strlen($str) > 0) {
			$posDelim = num_strpos($str, substr($str, 0, 1), 1);
			$res = $res . substr($str, 0, $posDelim+1);
/* Note the "+1" is to include the matching delimiter; if there is
none, $posDelim+1 will be one more than the remaining $str length,
which will exhaust $str */
			$str = substr($str, $posDelim+1);
		};
	};
	return $res;
};
?>
