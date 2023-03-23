(: La collation semble sans effet pour la recherche "contains text" :)
declare default collation '?lang=fr;strength=primary';

let $collFiltree := collection('NOMBASEDONNEE')[. contains text RECHERCHETEXTE]
return
<div>
<p>Nombre de documents trouv&#233;s:
  {count($collFiltree)}
  sur
  {count(collection('NOMBASEDONNEE'))}
</p>
<ul> {
    for $doc in $collFiltree
    return
    <li>
        {substring-after(substring(document-uri($doc), 2), "/")} &#32;
        <a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
        <a href="document.php?document={document-uri($doc)}">[Document styl&#233;]</a>
    </li>
}
</ul>
</div>
