(: Note : cette requête XQuery ne peut être exploitée directement,
elle doit être adaptée par l'application PHP :)

let $res := (
	for $doc in collection()
	 where (RECHERCHEXPATH)
	 return
	  <li>
		{substring-after(document-uri($doc), "/")} &#32;
		<a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
		<a href="document.php?document={document-uri($doc)}&amp;format=xslt"
		>[Document styl&#233;]</a>
	  </li>
)
return
	<div>
	<p>Nombre de documents trouv&#233;s: {count($res)} sur
		{count(collection())}</p>
	<ul> {$res} </ul>
	</div>
