(: Note : cette requ�te XQuery ne peut �tre exploit�e directement,
elle doit �tre adapt�e par le serveur :)
let $collFiltree := collection()[(.|.//@*) contains text RECHERCHETEXTE]
return
<div>
<p>Nombre de documents trouv&#233;s:
  {count($collFiltree)}
  sur
  {count(collection())}
</p>
<ul> {
	for $doc in $collFiltree
	return
		<li>
{substring-after(document-uri($doc), "/")} &#32;
<a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
<a href="document.php?document={document-uri($doc)}&amp;format=xslt">[Document styl&#233;]</a>
		</li>
}
</ul>
</div>
