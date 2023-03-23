<div>{
   for $famille in distinct-values(collection()//famille)
   order by $famille descending
   return
   <div>
       <h1>Famille des {string($famille)}</h1>
       <ul>
       {
        for $doc in collection()
        where $doc//famille=$famille
        order by $doc//nom-scientifique/text() ascending
            return <li><a href="document.php?document={document-uri($doc)}&amp;format=xslt"
			>{$doc//nom-scientifique/text()}</a></li>
        }
        </ul>
   </div>
}</div>
