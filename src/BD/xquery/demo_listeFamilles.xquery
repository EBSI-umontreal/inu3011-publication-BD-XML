<ul> {
    for $famille in distinct-values(collection()//famille)
    order by $famille
    return
        <li>
            {string($famille)}
        </li>
} </ul>
