<ul> {
    for $doc in fn:collection('NOMBASEDONNEE')
    return
        <li>
            <a href="document.php?document={document-uri($doc)}&amp;format=xslt">
                {string($doc//nom-scientifique)}
            </a>
        </li>
} </ul>
