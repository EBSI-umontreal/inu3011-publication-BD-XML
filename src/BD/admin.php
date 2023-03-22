<?php
	//Auteur : Arnaud d'Alayer	Date : 2010-03-24
	
	include "fonctions.php";
	$rechercheXQuery = stripslashes($_POST['rechercheXQuery']);

?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>SCI6132 - eXist</title>
	</head>
	<body>
		<h1>SCI6132 - eXist</h1>
		<?php
		if ($rechercheXQuery != ''){
			echo "<h2>Résultat recherche XQuery</h2>";
			afficherResultat(executerXquery($rechercheXQuery), "pre");
		}
		?>
		<h2>Nouvelle recherche</h2>
		<h3>Recherche plein texte</h3>
		<form action="pleinTexte.php" method="get">
			<input name="rechercheTexte" type="text" value="" size="25" />
			<input type="submit"/>
		</form>
		<h3>Recherche XQuery</h3>
		<p>Entrez une requête XQuery :</p>
		<form action="admin.php" method="post">
			<textarea name="rechercheXQuery" rows="5" cols="50"></textarea>
			<input type="submit"/>
		</form>
		<p>Utiliser des requêtes XQuery préenregistrées :</p>
		<ul>
		<?php
		$iter = new DirectoryIterator("xquery");
		foreach($iter as $file){
			if ( !$file->isDot()){
				echo '<li>' . $file->getFilename() . ' <a href="xquery.php?fichierXquery=' . $file->getFilename() . '&format=pre">[Exécuter]</a> <a href="xquery/' . $file->getFilename() . '">[Source]</a></li>';
			}  
		}
		?>
		</ul>
		<h2>État de la collection ("/db/<?php echo $nomBaseDeDonnées; ?>")</h2>
		<?php
		$xquery = lireFichier("xquery/_listeDocuments.xquery");
		$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnées, $xquery);
		echo afficherResultat(executerXquery($xquery), "brut");
		?>
	</body>
</html>