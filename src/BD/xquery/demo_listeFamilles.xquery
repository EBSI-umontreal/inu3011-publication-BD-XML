<ul> {
    for $famille in fn:collection("/db/demo")//famille
    return
        <li>
            {string($famille)}
        </li>
} </ul>