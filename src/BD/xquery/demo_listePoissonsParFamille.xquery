<div>{
   for $famille in collection("/db/demo")//famille
   order by $famille/text() descending
   return
   <div>
       <h1>famille {$famille/text()}</h1>
       <ul>
       {
        for $doc in collection("/db/demo")
        where $doc//famille=$famille
        order by $doc//nom-scientifique/text() ascending
            return <li><a href="document.php?document={document-uri($doc)}&amp;format=xslt&amp;xslt=demo_poissons.xsl">{$doc//nom-scientifique/text()}</a></li>
        }
        </ul>
   </div>
}</div>