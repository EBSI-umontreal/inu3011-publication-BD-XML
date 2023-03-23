(: Contenu de la BD :)
<div>
<p>Nombre de documents dans la base de donn&#233;es:
  {count(collection('NOMBASEDONNEE'))}
</p>
<ul> {
    for $doc in collection('NOMBASEDONNEE')
    return
    <li>
        {substring-after(substring(document-uri($doc), 2), '/')} &#160;
        <a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
        <a href="document.php?document={document-uri($doc)}&amp;format=xslt">[Document styl&#233;]</a>
    </li>
}
</ul>
</div>
