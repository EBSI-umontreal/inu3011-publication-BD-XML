<!DOCTYPE HTML>
<?php include "fonctions.php"; ?>
<HTML> 
  <HEAD>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<TITLE>INU3011 - Base de données «&#160;<?php echo $nomBaseDeDonnees; ?>&#160;»</TITLE>
	<STYLE TYPE="text/css">
*.boite {font-family: sans-serif; color:white; background-color:green;
	padding: 2pt;}
	</STYLE>
  </HEAD> 
  <BODY>
  <H1>INU3011 - Base de données «&#160;<?php echo $nomBaseDeDonnees; ?>&#160;»</H1>
<?php if ($utilisateurNom == $nomBaseDeDonnees ||
          $utilisateurNom == "marcoux"): ?>
  <form method="GET" action="rechargerBD.php" style="float:right">
    <p><input type="submit" value="Recharger la BD"></p>
  </form>
<?php endif; ?>
  <p>Utilisateur&#160;: <?php echo $utilisateurNom; ?></p>
  <HR style="clear:both">
	 <H3>Expression XPath évaluée sur chaque document</H3>
	 <P>Expression XPath à évaluer sur chaque document dans la BD&#160;:</P>
	 <FORM ACTION="XPath.php" METHOD="get">
		<P><SPAN CLASS="boite">Boîte 1 : </SPAN> &#160; <INPUT NAME="rechercheXPath" TYPE="text" SIZE="70">
<INPUT TYPE="submit" 
	VALUE="&Eacute;valuer l&#8217;expression XPath sur chaque document"></P>
		</FORM>
	 <P><SMALL>L&#8217;expression peut retourner 0, 1 ou plusieurs résultats pour chaque 
	 document.<BR>Si l&#8217;expression est relative, elle est évaluée par rapport au n&oelig;ud racine 
	 de chaque document.</SMALL></P>
<HR>
	 <H3>Recherche de documents entiers par filtre XPath</H3>
<P>Expression XPath à utiliser comme critère de sélection de documents dans la BD&#160;:</P>
	 <FORM ACTION="XPathDoc.php" METHOD="get">
<P><SPAN CLASS="boite">Boîte 2 : </SPAN> &#160; <INPUT NAME="rechercheXPath" TYPE="text" SIZE="70"></strong>
<INPUT TYPE="submit" 
	VALUE="Repêcher des documents avec l&#8217;expression XPath"></P>
		</FORM>
  <P><SMALL>Un document est retenu si l&#8217;expression XPath fournie, lorsque appliquée à ce document,
  retourne au moins un n&oelig;ud, ou la valeur «&#160;true&#160;», ou une chaîne de caractères non vide,
  ou une valeur numérique différente de 0.
  <BR>Si l&#8217;expression est relative, elle est évaluée par 
  rapport au n&oelig;ud racine de chaque document.</SMALL></P>
  <HR>
	 <H3>Recherche de documents entiers par critère sur le texte int&eacute;gral</H3>
	 <FORM ACTION="pleinTexte.php" METHOD="get"> 
		<P><SPAN CLASS="boite">Boîte 3 : </SPAN> &#160; <INPUT NAME="rechercheTexte" TYPE="text" SIZE="70">
		  <INPUT TYPE="submit" VALUE="Repêcher les documents qui satisfont le critère"></P>
	</FORM>
	<DIV STYLE="font-size:small;">
<P>Un document est retenu si le critère spécifié est satisfait par le contenu textuel du document dans son entier.</P>
	 <P>Pour plus d&#8217;information sur la recherche en texte int&eacute;gral, se référer au protocole de publication
		web, ou encore à l&#8217;une des ressources suivantes&#160;: &lt;<A
		HREF="http://docs.basex.org/wiki/Full-Text"
		>http://docs.basex.org/wiki/Full-Text</A>&gt; ou &lt;<A
		HREF="http://www.w3.org/TR/xpath-full-text-10/"
		>http://www.w3.org/TR/xpath-full-text-10/</A>&gt; (beaucoup plus aride).</P>
	</DIV>
  <HR>
<?php if ($nomBaseDeDonnees == "poissons"): ?>
	 <H3>Recherches pr&eacute;enregistr&eacute;es (pour la base «&#160;poissons&#160;» seulement)</H3> 
	 <UL> 
		<LI><A
		  HREF="xquery.php?fichierXquery=demo_listePoissons.xquery&amp;format=brut">Liste
		  de tous les poissons dans la base de donn&eacute;es</A></LI> 
		<LI><A
		  HREF="xquery.php?fichierXquery=demo_listeFamilles.xquery&amp;format=brut">Liste
		  des familles de poissons dans la base de donn&eacute;es</A></LI> 
		<LI><A
		  HREF="xquery.php?fichierXquery=demo_listePoissonsParFamille.xquery&amp;format=brut">Liste
		  des poissons par famille (ordre alphab&eacute;tique inverse)</A></LI> 
	 </UL>
	 <HR>
<?php endif ?>
	 <H3>Liste de tous les documents dans la BD</H3>
<?php
	$sortie = executerFichierXquery("listeDocuments.xquery", false);
	afficherResultat($sortie, "brut");
?>
  <HR>
  </BODY>
</HTML>
