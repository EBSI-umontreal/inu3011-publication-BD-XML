<!DOCTYPE html>
<?php
//Auteur : Yves Marcoux 2021-04-18
include "fonctions.php";
?>
<html>
<head>
<title>Recharge de la BD <?= $nomBaseDeDonnees ?></title>
</head>
<body>
<h1>Recharge de la BD <?= $nomBaseDeDonnees ?></h1>
<h2>À partir des documents du dossier XML</h2>
<p>Sur le point de zéroter la BD.</p>
<p><?php
try {
  $session = new Session($serveurAdresse, $serveurPort, $utilisateurNom, $utilisateurMotDePasse);
  $session->execute("OPEN ". $nomBaseDeDonnees);
  $session->execute("SET CHOP FALSE");
  $session->execute("delete /");
  echo "Opération réussie.";
} catch (Exception $e) {
// print exception
  echo $e->getMessage();
}
?></p>
<?php
if ($codeUdeM == "INU3011") {
  $chemin = $utilisateurNom."\\public_html-inu3011\\".$nomBaseDeDonnees."\\XML";
} else {
  $chemin = $codeUdeM."\\public_html\\3011pubWeb\\pubWebA\\XML";
}
?>
<p>Sur le point d’ajouter les documents dans la BD à partir de
<br><code><?= $chemin ?></code>.</p>
<p><?php
try {
  $session->execute("add d:\\actifs\\".$chemin);
  $session->execute("optimize");
  $session->close();
  echo "Opération réussie.";
} catch (Exception $e) {
// print exception
  echo $e->getMessage();
}
?></p>
<form action="." method="GET">
<p><input type="submit" value="Retour à la BD"></p>
</form>
</body>
</html>
