<ul> {
    for $doc in fn:collection("/db/demo")
    return
        <li>
            <a href="document.php?document={document-uri($doc)}&amp;format=xslt&amp;xslt=stylage.xsl">{string($doc//nom-scientifique)}</a>
        </li>
} </ul>