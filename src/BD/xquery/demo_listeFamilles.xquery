<ul> {
    for $famille in distinct-values(collection('NOMBASEDONNEE')//famille)
    order by $famille
    return
        <li>
            {string($famille)}
        </li>
} </ul>
