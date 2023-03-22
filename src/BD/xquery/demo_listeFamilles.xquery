<ul> {
    for $famille in fn:collection("/db/demo")//famille
    return
        <li>
            {$famille}
        </li>
} </ul>