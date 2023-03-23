<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML> 
  <HEAD> <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8"> 
	 <TITLE>INU3011 - Base de données «&#160;Les poissons exotiques&#160;»</TITLE>
  </HEAD> 
  <BODY>
	 <H1>INU3011 - Base de données «&#160;Les poissons exotiques&#160;»</H1>
<HR> 
	 <H3>Expression XPath évaluée sur chaque document</H3>
	 <P>Expression XPath <EM>absolue</EM> à évaluer sur chaque document dans la 
	 BD&#160;:</P>
	 <FORM ACTION="XPath.php" METHOD="get">
		<P> <INPUT NAME="rechercheXPath" TYPE="text" SIZE="70">
<INPUT TYPE="submit" 
	VALUE="&Eacute;valuer l&#8217;expression XPath sur chaque document"></P>
		</FORM>
	 <P><SMALL>L&#8217;expression peut retourner 0, 1 ou plusieurs résultats pour chaque 
	 document.</SMALL></P>
<HR>
	 <H3>Recherche de documents entiers par filtre XPath</H3>
<P>Expression XPath <EM>absolue</EM> à utiliser comme critère de sélection de documents 
dans la BD&#160;:</P>
	 <FORM ACTION="XPathDoc.php" METHOD="get">
<P><INPUT NAME="rechercheXPath" TYPE="text" SIZE="70"></strong>
<INPUT TYPE="submit" 
	VALUE="Repêcher des documents avec l&#8217;expression XPath"></P>
		</FORM>
<P><SMALL>Un document est retenu si l&#8217;expression XPath fournie, lorsque appliquée à ce document,
retourne au moins un n&oelig;ud, ou la valeur «&#160;true&#160;», ou une chaîne de caractères non vide,
ou une valeur numérique différente de 0.</SMALL></P>
<HR>
	 <H3>Recherche de documents entiers par critère sur le texte int&eacute;gral</H3>
	 <FORM ACTION="pleinTexte.php" METHOD="get"> 
		<P> <INPUT NAME="rechercheTexte" TYPE="text" SIZE="70">
		  <INPUT TYPE="submit" VALUE="Repêcher les documents qui satisfont le critère"></P>
	</FORM>
	<DIV STYLE="font-size:small;">
<P>Un document est retenu si le critère spécifié est satisfait soit par le contenu textuel du document dans son entier,
	soit par n&#8217;importe quelle des valeurs d&#8217;attribut survenant dans le document.</P>
	<P><EM>À faire d'ici mars 2016: Petit résumé des principales opérations en texte
	intégral possibles et des modificateurs possibles, avec des exemples.</EM></P>
	 <P>Pour plus d&#8217;information sur la recherche en texte int&eacute;gral, voir
		&lt;<A
		HREF="http://docs.basex.org/wiki/Full-Text"
		>http://docs.basex.org/wiki/Full-Text</A>&gt; et
		&lt;<A
		HREF="http://www.w3.org/TR/xpath-full-text-10/"
		>http://www.w3.org/TR/xpath-full-text-10/</A>&gt;.</P>
	</DIV>
<!--
	 <P><STRONG>Note:</STRONG> La recherche n&#8217;est pas sensible &agrave; la casse
		(Am&eacute;rique = am&eacute;rique), mais n&#8217;ignore pas les signes diacritiques
		(Am&eacute;rique diff&eacute;rent de Amerique). Notez aussi que l&#8217;apostrophe
		(') n&#8217;est <EM>pas</EM> consid&eacute;r&eacute;e comme un s&eacute;parateur de
		mots; ainsi, la requ&ecirc;te &laquo;&nbsp;&eacute;cole&nbsp;&raquo; ne
		retrouvera pas les documents qui contiendraient
		&laquo;&nbsp;l&#8217;&eacute;cole&nbsp;&raquo; (sans contenir aussi le mot
		&laquo;&nbsp;&eacute;cole&nbsp;&raquo; tout seul).
		Notez enfin qu&#8217;il n&#8217;y a pas de notion de mot vide.
</P> 
	 <P>Les op&eacute;rations possibles incluent (OR, AND et NOT doivent
		&ecirc;tre inscrits en majuscules):</P> 
	 <TABLE BORDER="1"> 
		<TR><TH>Op&eacute;ration</TH><TH>Syntaxe</TH><TH>Exemple</TH><TH>Notes</TH>
		  
		</TR> 
		<TR><TD>&laquo;&nbsp;ou&nbsp;&raquo;
			 bool&eacute;en</TD><TD>OR</TD><TD>bleu OR vert</TD><TD>Implicite entre deux
			 termes.<BR>
			 Les mots peuvent être n&#8217;importe où dans le texte ou dans une
			 valeur d&#8217;attribut.</TD> 
		</TR> 
		<TR><TD>&laquo;&nbsp;et&nbsp;&raquo;
			 bool&eacute;en</TD><TD>AND</TD><TD>am&eacute;rique AND sud</TD><TD>Les
			 mots peuvent être n&#8217;importe où dans le texte ou dans la <EM>même</EM> 
			 valeur d&#8217;attribut.</TD> 
		</TR> 
		<TR><TD>&laquo;&nbsp;sauf&nbsp;&raquo;
			 bool&eacute;en</TD><TD>NOT</TD><TD>am&eacute;rique NOT p&eacute;rou</TD><TD>On peut
			 utiliser &laquo;&nbsp;!&nbsp;&raquo; au lieu de &laquo;&nbsp;NOT&nbsp;&raquo;.<BR>
			 Le critère est satisfait si le contenu textuel du document contient le premier mot 
			 sans contenir le second ou s&#8217;<EM>il existe au moins un</EM> attribut
			 dont la valeur contient le premier mot sans contenir le second.</TD>
		</TR>
		<TR><TD>troncature</TD><TD>*</TD><TD>mang*</TD><TD>Utilisable au milieu
			 ou &agrave; la fin d&#8217;un terme, mais pas au d&eacute;but.<BR>
			 Peut être combinée avec les opérateurs précédents.</TD>
		</TR> 
		<TR><TD>recherche d&#8217;expression</TD><TD>"&nbsp;"</TD><TD>"nourriture
			v&eacute;g&eacute;tale"</TD><TD>Les
			mots, dans l&#8217;ordre et adjacents, peuvent être dans des éléments différents,
			ou dans la <EM>même</EM> valeur d&#8217;attribut.</TD>
		</TR> 
		<TR><TD>proximit&eacute;</TD><TD>~n</TD><TD>"reproduction corps"~10</TD>
		<TD>Les mots <EM>sans égard à l&#8217;ordre</EM>, doivent se retrouver en dedans 
		de n mots, n&#8217;importe où
		dans le texte ou dans la <EM>même</EM> valeur d&#8217;attribut.<BR>
		Si n=0, le &laquo;&nbsp;~0&nbsp;&raquo; est ignoré et une recherche 
		d&#8217;expression est effectuée.</TD>
		</TR> 
	 </TABLE> 
-->
<HR>
	 <H3>Recherches pr&eacute;enregistr&eacute;es</H3> 
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
	 </UL> <HR> 
	 <H3>Liste de tous les documents dans la BD</H3>
<?php
 	include "fonctions.php";
	$sortie = executerFichierXquery("listeDocuments.xquery", false);
	afficherResultat($sortie, "brut");
?>
<HR>
  </BODY>
</HTML>
