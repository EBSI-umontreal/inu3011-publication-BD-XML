<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">
<HTML> 
  <HEAD> <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8"> 
	 <TITLE>INU3011 - Application d'interrogation de votre BD eXist</TITLE> 
  </HEAD> 
  <BODY> 
	 <H1>INU3011 - Application d'interrogation de votre BD eXist</H1> 
	 <P>Rappel: Modifiez le fichier <TT>configuration.php</TT>
	 tel qu'expliqué dans le protocole</P>
<HR> 
	 <H3>Recherche de documents entiers par contenu dans le texte int&eacute;gral</H3>
	 <FORM ACTION="pleinTexte.php" METHOD="get"> 
		<P> <INPUT NAME="rechercheTexte" TYPE="text" SIZE="70">
		  <INPUT TYPE="submit" VALUE="Rechercher dans le texte int&eacute;gral"></P>
		</FORM> 
	 <P><STRONG>Note:</STRONG> La recherche n'est pas sensible &agrave; la casse
		(Am&eacute;rique = am&eacute;rique), mais n'ignore pas les signes diacritiques
		(Am&eacute;rique diff&eacute;rent de Amerique). Notez aussi que l'apostrophe
		(') n'est <EM>pas</EM> consid&eacute;r&eacute;e comme un s&eacute;parateur de
		mots; ainsi, la requ&ecirc;te &laquo;&nbsp;&eacute;cole&nbsp;&raquo; ne
		retrouvera pas les documents qui contiendraient
		&laquo;&nbsp;l'&eacute;cole&nbsp;&raquo; (sans contenir aussi le mot
		&laquo;&nbsp;&eacute;cole&nbsp;&raquo; tout seul).
		Notez enfin qu'il n'y a pas de notion de mot vide.
</P> 
	 <P>Les op&eacute;rations possibles incluent (OR, AND et NOT doivent
		&ecirc;tre inscrits en majuscules):</P> 
	 <TABLE BORDER="1"> 
		<TR><TH>Op&eacute;ration</TH><TH>Syntaxe</TH><TH>Exemple</TH><TH>Notes</TH>
		  
		</TR> 
		<TR><TD>&laquo;&nbsp;ou&nbsp;&raquo;
			 bool&eacute;en</TD><TD>OR</TD><TD>bleu OR vert</TD><TD>Implicite entre deux
			 termes.<BR>
			 Les mots peuvent être n'importe où dans le texte ou dans une
			 valeur d'attribut.</TD> 
		</TR> 
		<TR><TD>&laquo;&nbsp;et&nbsp;&raquo;
			 bool&eacute;en</TD><TD>AND</TD><TD>am&eacute;rique AND sud</TD><TD>Les
			 mots peuvent être n'importe où dans le texte ou dans la <EM>même</EM> 
			 valeur d'attribut.</TD> 
		</TR> 
		<TR><TD>&laquo;&nbsp;sauf&nbsp;&raquo;
			 bool&eacute;en</TD><TD>NOT</TD><TD>am&eacute;rique NOT p&eacute;rou</TD><TD>On peut
			 utiliser &laquo;&nbsp;!&nbsp;&raquo; au lieu de &laquo;&nbsp;NOT&nbsp;&raquo;.<BR>
			 Le critère est satisfait si le contenu textuel du document contient le premier mot 
			 sans contenir le second ou s'<EM>il existe au moins un</EM> attribut
			 dont la valeur contient le premier mot sans contenir le second.</TD>
		</TR>
		<TR><TD>troncature</TD><TD>*</TD><TD>mang*</TD><TD>Utilisable au milieu
			 ou &agrave; la fin d'un terme, mais pas au d&eacute;but.<BR>
			 Peut être combinée avec les opérateurs précédents.</TD>
		</TR> 
		<TR><TD>recherche d'expression</TD><TD>"&nbsp;"</TD><TD>"nourriture
			v&eacute;g&eacute;tale"</TD><TD>Les
			mots, dans l'ordre et adjacents, peuvent être dans des éléments différents,
			ou dans la <EM>même</EM> valeur d'attribut.</TD>
		</TR> 
		<TR><TD>proximit&eacute;</TD><TD>~n</TD><TD>"reproduction corps"~10</TD>
		<TD>Les mots <EM>sans égard à l'ordre</EM>, doivent se retrouver en dedans 
		de n mots, n'importe où
		dans le texte ou dans la <EM>même</EM> valeur d'attribut.<BR>
		Si n=0, le &laquo;&nbsp;~0&nbsp;&raquo; est ignoré et une recherche 
		d'expression est effectuée.</TD>
		</TR> 
	 </TABLE> 
	 <P>Pour plus d'information sur la recherche en texte int&eacute;gral, voir
		&lt;<A
		HREF="http://lucene.apache.org/core/2_9_4/queryparsersyntax.html"
		>http://lucene.apache.org/core/2_9_4/queryparsersyntax.html</A>&gt;.</P>
<HR>
	 <H3>Recherche de documents entiers par filtre XPath</H3>
<P>Expression XPath <EM>absolue</EM> à utiliser comme filtre:</P>
	 <FORM ACTION="XPathDoc.php" METHOD="get">
<P><INPUT NAME="rechercheXPath" TYPE="text" SIZE="70"></strong>
<INPUT TYPE="submit" 
	VALUE="Rechercher les documents avec l'expression XPath"></P>
		</FORM>
<P><SMALL>Un document sera sélectionné si l'expression XPath fournie
retourne "vrai" (ou un ensemble de noeuds non vide, ou une valeur quelconque
non vide) lorsque appliquée à ce document.</SMALL></P>
<HR>
	 <H3>Expression XPath <EM>absolue</EM> évaluée sur chaque document dans la BD</H3>
	 <FORM ACTION="XPath.php" METHOD="get">
		<P> <INPUT NAME="rechercheXPath" TYPE="text" SIZE="70">
<INPUT TYPE="submit" 
	VALUE="&Eacute;valuer l'expression XPath absolue sur chaque document"></P>
		</FORM>
<HR>
	 <H3>Liste de tous les documents dans la BD</H3>
<?PHP 	include "fonctions.php";
	$xquery = lireFichier("xquery/_listeDocuments.xquery");
	$xquery = str_replace("NOMBASEDONNEE", $nomBaseDeDonnees, $xquery);
	afficherResultat(executerXquery($xquery), "brut");
?>
<HR>
  </BODY>
</HTML>
