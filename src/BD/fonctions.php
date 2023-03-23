<?php
//Auteur : Arnaud d'Alayer	Date : 2010-03-29
//Dernières modifications : Yves Marcoux 2021-04-17

  include ((file_exists("YMAconfig.php")) ? "YMAconfig.php" : "configuration.php");
  $codeUdeM = $_SERVER["REQUEST_URI"];
  $codeUdeM = substr($codeUdeM, 1, strpos($codeUdeM, "/", 1)-1);
  $serveurAdresse = "localhost";
  $serveurPort = 1984;

  if (!$feuilleXSLT) $feuilleXSLT = "HTML-C.xsl";
//	if (!$afficherReqXQuery) $afficherReqXQuery = false;

	$appURI = appURI();

	include "BaseXClient.php";

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
			  $output .= fgets($file, 4096);
			}
			fclose ($file);
		}
		return $output;
	}

	/*executerXquery()
	Description : fonction permettant d'exécuter une requête Xquery envoyée en paramètre (string)
	Paramètre(s) :
	- $xquery (string - obligatoire) : requête XQuery à exécuter dans la base de données configurée 
	dans configuration.php
	- $nePasMasquer (booléen - facultatif) : permet de désactiver l'affichage de l'entête même si 
	l'affichage est activé dans configuration.php (utile pour les sorties XML)
	Retour :
	- (string) : Chaîne de caractères contenant le résultat de la requête XQuery
	*/
	function executerXquery($xquery, $nePasMasquerReq = true){
		global $serveurAdresse; global $serveurPort; global $utilisateurNom; 
		global $utilisateurMotDePasse; global $afficherReqXQuery; global $nomBaseDeDonnees;
		try {
			$session = new Session($serveurAdresse, $serveurPort, $utilisateurNom, $utilisateurMotDePasse);
			$session->execute("OPEN ". $nomBaseDeDonnees);

			if ($afficherReqXQuery and $nePasMasquerReq)
				echo ("<p><strong>Requête XQuery : <br/>" . str_replace("\r", "<br />", 
				htmlspecialchars($xquery)) . "</strong></p>");

			$query = $session->query($xquery);
			// get results
			$sortie = $query->execute()."\n";
			// close query instance
			$query->close();
			// close session
			$session->close();

			return $sortie;

		} catch (Exception $e) {
		  // print exception
		  echo $e->getMessage();
		}
	}

	/*executerFichierXquery()
	Description : fonction permettant d'exécuter une requête Xquery stockée dans un fichier
	Paramètre(s) :
	- $filename (string - obligatoire) : adresse du fichier XQuery à ouvrir
	Retour :
	- (string) : Chaine de caractères contenant le résultat de la requête XQuery
	*/
	function executerFichierXquery($filename, $nePasMasquerReq = true){
		$xquery = lireFichier("xquery/" . $filename);
		return executerXquery($xquery, $nePasMasquerReq);
	}

	/*afficherResultat()
	Description : permet d'afficher un résultat de requête XQuery selon un format déterminé
	Paramètre(s) :
	- $result (string) : résultat XQuery de executerXquery()
	- $format
		- xml : le serveur ajoute une entête XML suivi du contenu du document XML
		- pre : le serveur retourne le contenu du document XML sous forme HTML dans un conteneur <pre>
		- brut : le serveur retourne le contenu du résultat de la requête XQuery directement 
		(utile si la requête XQuery retourne du code HTML)
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
// ce cas est inutile (car revient à afficher directement le résultat de executerXquery()),
// mais pour des raisons pédagogiques, nous l'avons ajouté
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
		global $appURI;
		global $nomBaseDeDonnees;
		$sortie = "";

		$docATransformer = new DOMDocument();
		$docATransformer->loadXML($docXML);

		$xp = new XsltProcessor();
		$xsl = new DOMDocument();
		if (file_exists("../xslt/" . $feuilleXSLT)){
			$xsl->load("../xslt/" . $feuilleXSLT);
			$xp->importStylesheet($xsl);
			$xp->setParameter("", "appURI", $appURI);
			$xp->setParameter("", "nomBD", $nomBaseDeDonnees);
			$sortie = $xp->transformToXML($docATransformer);
		}
		else {
			echo ("Feuille XSLT inconnue: " . $feuilleXSLT);
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
// Remove segment just processed
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

function quoteAwareNormalizeSpace($str) {
// Removes leading spaces and multiple spaces (will leave one trailing space)
// of each segment not between quotes in $str.
// YMA 2015-03-26
	$res = '';
	while (strlen($str) > 0) {
		$posDelim = min(num_strpos($str, '\'', 0), num_strpos($str, '"', 0));
// We can safely do the multiple space elimination until the first ' or "
		$curSeg = substr($str, 0, $posDelim);
// Current segment to process
		$lastChar = ' ';
// Do not keep any initial space
		while (strlen($curSeg) > 0) {
//Process current segment
			$curChar = substr($curSeg, 0, 1);
			if (($curChar . $lastChar) !== '  ') $res = $res . $curChar;
// If not both spaces
			$lastChar = $curChar;
			$curSeg = substr($curSeg, 1);
// Shave off the char just processed
		};
		$str = substr($str, $posDelim);
// Remove segment just processed
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

function preprocessXPath($XPathOrig) {
// YMA 2015-03-26
// Effectue le prétraitement nécessaire à une expression XPath absolue formulée
// relativement au noeud racine d'un document pour qu'elle
// fonctionne dans le contexte d'une BD Exist à plusieurs documents, en supposant
// que la variable "$doc" est la variable d'itération sur les documents
// (essentiellement, les / initiaux sont remplacés par des "$doc/").
// Vérifie que l'expression XPath fournie était absolue et avorte sinon.

	$XPathOrig = quoteAwareStrRep('\t', ' ', $XPathOrig);

// Replace all tabs by spaces (except within quotes)
// On ne peut pas juste enlever toutes les espaces, parce qu'une expression XPath
// peut contenir les opérateurs "and" et "or". Il faut donc y aller plus mollo.

	$XPathOrig = quoteAwareNormalizeSpace($XPathOrig);

// À cause d'un bug de eXist, il faut remplacer les * par *[position()] (croyez-le ou non!!!)
// qui, en principe, est un synonyme exact:
//		$rechercheXPath = quoteAwareStrRep('*', '*[position()]', $rechercheXPath);
// 2012-09-23: Après tests, ça ne semble plus nécessaire avec la nouvelle version d'eXist (2.0)
// 2016-01-06 YMA: ... et bien sûr, ce n'est plus nécessaire avec BaseX (joie...)!

	$rechercheXPath = $XPathOrig;

	$rechercheXPath = quoteAwareStrRep('(/', '($doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('( /', '( $doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('|/', '|$doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('| /', '| $doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('[/', '[$doc/', $rechercheXPath);
	$rechercheXPath = quoteAwareStrRep('[ /', '[ $doc/', $rechercheXPath);
	if (substr($rechercheXPath, 0, 1) == '/') $rechercheXPath = '$doc' . $rechercheXPath;

//Vérifier qu'une expression XPath absolue avait été fournie
	if ($rechercheXPath == $XPathOrig)
// Si rien n'a changé, ce n'est pas une expression XPath absolue; fix it up!
		$rechercheXPath = '$doc/'.$XPathOrig;
//		return "'Veuillez sp&#233;cifier une expression XPath absolue'";
	return $rechercheXPath;
};

function curPageURL() {
// http://webcheatsheet.com/php/get_current_page_url.php
 $pageURL = 'http';
 if ($_SERVER["HTTPS"] == "on") $pageURL .= "s";
 $pageURL .= "://";
 if ($_SERVER["SERVER_PORT"] != "80") {
  $pageURL .= $_SERVER["SERVER_NAME"].":".$_SERVER["SERVER_PORT"].$_SERVER["REQUEST_URI"];
 } else {
  $pageURL .= $_SERVER["SERVER_NAME"].$_SERVER["REQUEST_URI"];
 }
 return $pageURL;
};

function appURI() {
	$URI = curPageURL();
	$pos = strpos($URI, "?");
	if ($pos != false) { $URI = substr($URI, 0, $pos); }
	$URI = substr($URI, 0, strrpos($URI, "/") + 1);
	return $URI;
};
?>
