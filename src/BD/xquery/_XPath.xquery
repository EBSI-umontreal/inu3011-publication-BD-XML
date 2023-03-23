(: Note : cette requête XQuery ne peut être exploitée directement,
elle doit être adaptée par le serveur :)
<_kxz_0>
<_kxz_1> {
	for $doc in collection()
	let $resPourDoc := RECHERCHEXPATH
	return
	<_kxz_2>
	<_kxz_3>{count($resPourDoc)} r&#233;sultat(s) pour 
		{substring-after(document-uri($doc), "/")} &#32;
		<_kxz_6>document.php?document={document-uri($doc)}</_kxz_6>
		<_kxz_7>document.php?document={document-uri($doc)}</_kxz_7>
	:</_kxz_3>
	<_kxz_4> {
		for $res in $resPourDoc
		return
		<_kxz_5>{$res}_kxz_5</_kxz_5>
(: Si $res est un attribut, il ne faut pas que
le <_kxz_5> soit vide :)
		}
	</_kxz_4>
	</_kxz_2>
	}
</_kxz_1>
</_kxz_0>
