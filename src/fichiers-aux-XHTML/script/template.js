/* chargerEvenements
   Cette fonction ajoute les évènements intéractifs de la page
*/
function chargerEvenements(){
/* YMA 2016-03-09
Il faut tester la présence des éléments, parce qu'ils ne sont pas dans
la page si aucune information sur la qualité de l'eau n'est présente. */
	if (document.getElementById("ancre-ph")) {
	  addEvent(document.getElementById("ancre-ph"), "mouseover", function(e) {afficher("popup-ph")});
	  addEvent(document.getElementById("ancre-ph"), "mouseout",  function(e) {cacher("popup-ph")});
	};
	if (document.getElementById("ancre-gh")) {
	  addEvent(document.getElementById("ancre-gh"), "mouseover", function(e) {afficher("popup-gh")});
	  addEvent(document.getElementById("ancre-gh"), "mouseout",  function(e) {cacher("popup-gh")});
	};
}
addEvent(window,"load",function(e) {chargerEvenements()});


/* afficher - cacher
   Ces fonctions affichent ou cachent les popups d'information
*/
function afficher(popup){
  document.getElementById(popup).style.visibility="visible";
}
function cacher(popup){
  document.getElementById(popup).style.visibility="hidden";
}

/**
  * Generic add/removeEvent functionality
  *
  * @author Tino Zijdel ( crisp@xs4all.nl )
  * @version 1.2 (short version)
  * @date 2005-10-21
  */
function addEvent(obj, evType, fn)
{
	var evTypeRef = '__' + evType;

	if (obj[evTypeRef])
	{
		if (array_search(fn, obj[evTypeRef]) > -1) return;
	}
	else
	{
		obj[evTypeRef] = [];
		if (obj['on'+evType]) obj[evTypeRef][0] = obj['on'+evType];
		obj['on'+evType] = handleEvent;
	}

	obj[evTypeRef][obj[evTypeRef].length] = fn;
}

function removeEvent(obj, evType, fn)
{
	var evTypeRef = '__' + evType;

	if (obj[evTypeRef])
	{
		var i = array_search(fn, obj[evTypeRef]);
		if (i > -1) delete obj[evTypeRef][i];
	}
}

function handleEvent(e)
{
	e = e || window.event;
	var evTypeRef = '__' + e.type, retValue = true;

	for (var i = 0, j = this[evTypeRef].length; i < j; i++)
	{
		if (this[evTypeRef][i])
		{
			this.__fn = this[evTypeRef][i];
			retValue = this.__fn(e) && retValue;
		}
	}

	if (this.__fn) try { delete this.__fn; } catch(e) { this.__fn = null; }

	return retValue;
}

function array_search(val, arr)
{
	var i = arr.length;

	while (i--)
		if (arr[i] && arr[i] === val) break;

	return i;
}