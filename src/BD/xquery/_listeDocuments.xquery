(: Note : cette requête XQuery ne peut être exploitée directement, elle doit être adaptée par le serveur :)
<ul> {
    for $doc in fn:collection("/db/NOMBASEDONNEE")
    return
        <li>
            {document-uri($doc)} &#160;<a href="document.php?document={document-uri($doc)}&amp;format=pre">[Source]</a> <a href="document.php?document={document-uri($doc)}&amp;format=xml">[XML]</a> <a href="document.php?document={document-uri($doc)}&amp;format=xslt&amp;xslt=demo_poissons.xsl">[Sortie XSLT]</a>
        </li>
} </ul>