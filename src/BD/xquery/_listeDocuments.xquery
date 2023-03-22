(: Note : cette requête XQuery ne peut être exploitée directement,
elle doit être adaptée par le serveur :)
<div>
<p>Nombre de documents dans la base de donn&#233;es:
  {count(collection('/db/NOMBASEDONNEE'))}
</p>
<ul> {
    for $doc in collection("/db/NOMBASEDONNEE")
    return
        <li>
{substring(document-uri($doc), string-length('NOMBASEDONNEE')+6)} &#160;
<a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
<!-- <a href="document.php?document={document-uri($doc)}&amp;format=xml">[XML]</a> -->
<a href="document.php?document={document-uri($doc)}&amp;format=xslt&amp;xslt=stylage.xsl"
>[Document styl&#233;]</a>
        </li>
}
</ul>
</div>
