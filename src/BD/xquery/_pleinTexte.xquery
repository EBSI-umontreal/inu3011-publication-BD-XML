(: Note : cette requête XQuery ne peut être exploitée directement,
elle doit être adaptée par le serveur :)
<div>
<p>Nombre de documents trouv&#233;s:
  {count(collection('/db/NOMBASEDONNEE')[ft:query(./*|.//@*, 'RECHERCHETEXTE')])}
  sur
  {count(collection('/db/NOMBASEDONNEE'))}
</p>
<ul> {
	for $doc in collection('/db/NOMBASEDONNEE')
	where ft:query($doc/*|$doc//@*, 'RECHERCHETEXTE')
	return
		<li>
{substring(document-uri($doc), string-length('NOMBASEDONNEE')+6)} &#32;
<a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
<!-- <a href="document.php?document={document-uri($doc)}&amp;format=xml">[XML]</a> -->
<a href="document.php?document={document-uri($doc)}&amp;format=xslt&amp;xslt=stylage.xsl"
>[Document styl&#233;]</a>
		</li>
}
</ul>
</div>
