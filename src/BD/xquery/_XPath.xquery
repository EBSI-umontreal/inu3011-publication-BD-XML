(: Note : cette requête XQuery ne peut être exploitée directement,
elle doit être adaptée par le serveur :)
<_kxz_0>
<_kxz_1> {
	for $doc in collection('/db/NOMBASEDONNEE')
	return
	<_kxz_2>
	<_kxz_3>R&#233;sultat(s) pour {substring(base-uri($doc), string-length('NOMBASEDONNEE')+6)}:</_kxz_3>
	<_kxz_4> {
		for $res in RECHERCHEXPATH
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
