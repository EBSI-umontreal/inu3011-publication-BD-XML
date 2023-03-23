(: La collation semble sans effet pour la recherche "contains text" :)
declare default collation '?lang=fr;strength=primary';

let $res := (
    for $doc in collection('NOMBASEDONNEE')
    where (RECHERCHEXPATH)
    return
    <li>
        {substring-after(substring(document-uri($doc), 2), "/")} &#32;
        <a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source XML]</a>
        <a href="document.php?document={document-uri($doc)}">[Document styl&#233;]</a>
    </li>
)
return
    <div>
    <p>Nombre de documents trouv&#233;s: {count($res)} sur
        {count(collection('NOMBASEDONNEE'))}</p>
    <ul>
        {$res}
    </ul>
    </div>
