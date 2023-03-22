(: Note : cette requête XQuery ne peut être exploitée directement,
elle doit être adaptée par l'application PHP :)

let $drop := string-length('NOMBASEDONNEE')+6
let $res := (
	for $doc in collection('/db/NOMBASEDONNEE')
	 where (RECHERCHEXPATH)
	 return
	  <li>
		{substring(base-uri($doc), $drop)}
		<a href="document.php?document={base-uri($doc)}&amp;format=pre">[Source XML]</a>
		<a href="document.php?document={base-uri($doc)}&amp;format=xslt&amp;xslt=stylage.xsl"
		>[Document styl&#233;]</a>
	  </li>
)
return
	<div>
	<p>Nombre de documents trouv&#233;s: {count($res)} sur
		{count(collection('/db/NOMBASEDONNEE'))}</p>
	<ul> {$res} </ul>
	</div>
