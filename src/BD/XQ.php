<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<?php
// Auteur : Arnaud d'Alayer	Date : 2010-03-24
// Modifications extensives Yves Marcoux 2011-04-05

	include "fonctions.php";
	$rechercheXQuery = stripslashes($_GET['requete']);

?>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Résultat de la requête XQuery</title>
	</head>
	<body>
		<h1>Résultat de la requête XQuery</h1>
		<h2>Requête:</h2>
		<pre><code><?php echo htmlspecialchars($rechercheXQuery); ?></code></pre>
		<h2>Résultat:</h2>
		<pre><?php
			echo htmlspecialchars(executerXquery($rechercheXQuery));
//			afficherResultat(executerXquery($rechercheXQuery), "pre");
		?></pre>
	</body>
</html>