<?xml version="1.0" encoding="iso-8859-1"?>
<!--
  =====================================================================
  INU3011 - Documents structurés
  Auteurs: Arnaud d'Alayer et Marilou Bourque
  Création:						2006-04-04
  Modifications YMA:
								2012-02-16
								2013-04-22
								2014-04-14
								2015-12-23
								2016-01-02
  ====================================================================
-->
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:html="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  extension-element-prefixes=""
  exclude-result-prefixes="rdf dc" -->

  <xsl:param name="système" select="'métrique'" />
  <!--  <xsl:param name="système" select="'anglais'" />-->
  <xsl:param name="nomBD" select="'BD'" />
  <xsl:param name="appURI" select="'sysFich'" />
  
  <!-- Précision sur la sortie désirée :
    - La sortie sera valide XHTML 1.0 Strict et contiendra l'entête XML
    - La sortie sera indentée
    - La sortie sera encodée en UTF-8
    - le namespace par défaut sera celui de HTML, sans préfixer les éléments -->
  <xsl:output
    method="xml" 
    version="1.0" 
    indent="yes" 
    encoding="UTF-8" 
    omit-xml-declaration="no" 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
  
  <!-- Importation du fichier contenant les popups d'informations -->

<!--	YMA 2012-02-16 Même si le préfixe html réfère au namespace par défaut, on doit
		l'utiliser explicitement dans l'instruction ci-dessous, sinon, aucun élément
		n'est repêché... -->

  <xsl:variable name="popups" select="document('popup.xml')//html:div" />
  
  <!--
    ========
    FICHE
    ========
  -->
  <xsl:template match="fiche">
    <html lang="fr-ca" xml:lang="fr-ca">
      <head>
        <!-- meta http-equiv="Content-type" content="text/html; UTF-8"/ -->
        <title><xsl:value-of select="poisson/noms/nom-scientifique"/></title>
        <meta name="DC.Title" content="{poisson/noms/nom-scientifique}" />
        <meta name="DC.Description" content=
"Fiche descriptive du poisson &quot;{poisson/noms/nom-scientifique}&quot;" />
        <meta name="DC.Date" content="{métadonnées/date-dern-modif}" />
        <xsl:for-each select="métadonnées/créateur">
          <meta name="DC.Creator" content="{.}" />
        </xsl:for-each>        
        <link rel="stylesheet" type="text/css" href="../xslt/template-html/css/template.css"/>
        <script type="text/javascript" src="../xslt/template-html/script/template.js" charset="UTF-8">
		&#160; </script>
      </head>
      <body>
        <xsl:apply-templates select="poisson"/>        
      </body>
    </html>
  </xsl:template>

  <!--
    ===========================
    FICHE SUR LE POISSON (body)
    ===========================
  -->
  <xsl:template match="poisson">
    <!-- Titre de la page : nom scientifique du poisson -->
    <h1><xsl:value-of select="noms/nom-scientifique"/></h1>
    <div id="page">
      <p id="image">
        <xsl:choose>
          <xsl:when test="/fiche/@image = 'oui'">
            <img src="../images/{/fiche/@id}.jpg" alt="{noms/nom-scientifique}"/>
          </xsl:when>
          <xsl:otherwise><img src="../images/NIL" alt="Image non disponible."/></xsl:otherwise>
        </xsl:choose>
      </p>
      <!-- Insérer le cadre des noms et de la famille -->
      <div id="nom">
        <h2>Noms</h2>
        <dl>
          <xsl:apply-templates select="noms"/>
          <xsl:apply-templates select="famille"/>
        </dl>
      </div>
      <div class="clearer">&#160;</div>
      
      <!-- Insérer le cadre sur la description sommaire du poisson. -->
      <div id="info-desc">
        <h2>Information descriptive</h2>
        <dl>
          <xsl:apply-templates select="première-description"/>
          <xsl:apply-templates select="origines"/>
          <xsl:apply-templates select="zone-vie"/>
          <xsl:apply-templates select="longévité-ans"/>
          <xsl:apply-templates select="taille-cm"/>
        </dl>
      </div>
      
      <!--
        Insérer le cadre sur la qualité de l'eau.
        Toutes ces informations étant facultatives, on génère le cadre html dans le template de l'élément qualité-eau.
      -->
      <xsl:apply-templates select="qualité-eau"/>
      <div class="clearer">&#160;</div>
      
      <!--
        Insérer le cadre sur des informations détaillées sur le poisson.
        Toutes ces informations étant facultatives, on génère le cadre html dans un template infolong.
      -->
      <xsl:call-template name="infolong"/>    
    </div>
  </xsl:template>
      
  <!--  ===== Affichage des information détaillées sur le poisson ===== -->
  <xsl:template name="infolong">
    <!-- On affiche le bloc seulement s'il y a au moins un champ présent -->
    <xsl:if test="alimentation | description | dimorphisme | comportement | reproduction">
      <div id="infolong">
        <dl>
          <xsl:apply-templates select="alimentation"/>
          <xsl:apply-templates select="description"/>
          <xsl:apply-templates select="dimorphisme"/>
          <xsl:apply-templates select="comportement"/>
          <xsl:apply-templates select="reproduction"/>
        </dl>
      </div>
    </xsl:if>
  </xsl:template>
    
  <!--  ===== Affichage des noms ===== -->
  <xsl:template match="noms">
    <!-- Afficher le nom scientifique -->
    <dt>Nom scientifique&#160;:</dt>
    <dd><xsl:value-of select="nom-scientifique"/></dd>
    <!-- Afficher l'intitulé et les noms communs s'ils existent. -->
    <xsl:if test="nom-commun">
      <dt>Nom(s) commun(s)&#160;:</dt>
      <!-- Les noms communs sont triés par langue et ensuite par ordre alphabétique -->
      <xsl:apply-templates select="nom-commun">
        <xsl:sort select="@langue"/>
        <xsl:sort select="."/>
      </xsl:apply-templates>
    </xsl:if>
  </xsl:template> 

    <xsl:template match="nom-commun">
    <dd><xsl:value-of select="."/><xsl:text> </xsl:text>(<xsl:value-of select="@langue"/>)</dd>
  </xsl:template>
  
  <!--  ===== Affichage de la famille ===== -->
  <xsl:template match="famille">
    <dt>Famille&#160;:</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>
  
  <!--  ===== Affichage du descripteur ===== -->
  <xsl:template match="première-description">
    <dt>Descripteur&#160;:</dt>
    <dd><xsl:value-of select="nom-du-descripteur"/><xsl:text> </xsl:text>(<xsl:value-of
      select="année"/>)</dd>
  </xsl:template>
  
  <!--  ===== Affichage de l'origine ===== -->
  <xsl:template match="origines">
    <dt>Origine&#160;:</dt>
    <!-- Les origines seront affichées dans l'ordre alphabétique. -->
    <xsl:apply-templates select="origine">
      <xsl:sort select="."/>
    </xsl:apply-templates>
    <xsl:apply-templates select="commentaires"/>
  </xsl:template> 

  <!-- Il n'y a pas de distinction à l'affichage entre les entrées provenant du thésaurus ou de la saisie libre. -->
  <xsl:template match="origine">
    <dd><xsl:value-of select="."/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de la zone de vie ===== -->
  <xsl:template match="zone-vie">
    <dt>Zone de vie&#160;:</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de l'espérance de vie ===== -->
  <xsl:template match="longévité-ans">
    <dt>Espérance de vie&#160;:</dt>
    <xsl:apply-templates/>
  </xsl:template> 

  <!--  ===== Affichage de la taille ===== -->
  <xsl:template match="taille-cm">
    <!-- Si c'est une description de la taille sans distinction du sexe, on affiche un intitulé sans mention du sexe. -->
    <xsl:if test="not(mâle | femelle)">
      <dt>Taille&#160;:</dt>
    </xsl:if>
    <xsl:apply-templates>
      <xsl:with-param name="unité"><xsl:choose>
        <xsl:when test="$système='métrique'">cm</xsl:when>
        <xsl:otherwise>po</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

    <!-- Description de la taille avec distinction du sexe -->
  <xsl:template match="mâle">
    <xsl:param name="unité"/>
    <dt>Taille du mâle&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité" select="$unité"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="femelle">
    <xsl:param name="unité"/>
    <dt>Taille de la femelle&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité" select="$unité"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--  ===== Affichage des informations concernant la qualité de l'eau ===== -->
  <xsl:template match="qualité-eau">
    <div id="info-eau">
      <h2>Qualité de l&#8217;eau</h2>
      <dl>
        <xsl:apply-templates select="température-C"/>
        <xsl:apply-templates select="ph"/>
        <xsl:apply-templates select="dureté"/>
      </dl>

      <!-- Ajout des informations pour les popups -->
      <xsl:copy-of select="$popups"/>
    </div>
  </xsl:template>
  
    <!--  ===== Affichage de la température de l'eau ===== -->
  <xsl:template match="température-C">
    <dt>Température&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité"><xsl:choose>
        <xsl:when test="$système='métrique'">°C</xsl:when>
        <xsl:otherwise>°F</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
  <!--  ===== Affichage du pH idéal de l'eau ===== -->
  <xsl:template match="ph">
    <dt>pH&#160;: <img src="../xslt/template-html/images/question.gif" alt="Plus d'information sur le pH" id="ancre-ph"/></dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité">pH</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template> 
  
  <!--  ===== Affichage du pH idéal de l'eau ===== -->
  <xsl:template match="dureté">
    <dt>Dureté&#160;: <img src="../xslt/template-html/images/question.gif" alt="Plus d'information sur la dureté" id="ancre-gh"/></dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité">°d GH</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template> 
  
  <!--  ===== Affichage de l'alimentation du poisson ===== -->
  <xsl:template match="alimentation">
    <dt>Alimentation&#160;:</dt>
    <dd><xsl:apply-templates/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de la description physique du poisson ===== -->
  <xsl:template match="description">
    <dt>Description&#160;:</dt>
    <dd><xsl:apply-templates/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de la différence entre le mâle et la femelle ===== -->
  <xsl:template match="dimorphisme">
    <dt>Dimorphisme&#160;:</dt>
    <dd><xsl:apply-templates/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage des informations sur le comportement du poisson ===== -->
  <xsl:template match="comportement">
    <dt>Comportement&#160;:</dt>
    <dd><xsl:apply-templates/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage des informations sur le comportement du poisson ===== -->
  <xsl:template match="reproduction">
    <dt>Reproduction&#160;:</dt>
    <dd><xsl:apply-templates/></dd>
  </xsl:template> 

  <!--
    ========================================================
    TRAITEMENT DES ÉLÉMENTS DE TYPE MIN-MAX-MOY-COMMENTAIRES
    ========================================================
  -->
  <!-- Cas général -->
  <xsl:template match="min">
    <xsl:param name="unité"/>
    <dd>Minimum&#160;: <xsl:choose>
      <xsl:when test="$unité='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unité='°F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose><xsl:text> </xsl:text><xsl:value-of select="$unité"/></dd>
  </xsl:template>
  <xsl:template match="max">
    <xsl:param name="unité"/>
    <dd>Maximum&#160;: <xsl:choose>
      <xsl:when test="$unité='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unité='°F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose><xsl:text> </xsl:text><xsl:value-of select="$unité"/></dd>
  </xsl:template>
  <xsl:template match="moy">
    <xsl:param name="unité"/>
    <dd>Moyenne&#160;: <xsl:choose>
      <xsl:when test="$unité='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unité='°F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose><xsl:text> </xsl:text><xsl:value-of select="$unité"/></dd>
  </xsl:template>
  <xsl:template match="commentaires">
    <dd><xsl:apply-templates/></dd>
  </xsl:template>
  
  <!-- Cas spécifique pour la longévité : on veut ajouter un s à 'an' si la valeur est supérieure à 1 an. -->
  <xsl:template match="longévité-ans/min">
    <dd>Minimum&#160;:
      <xsl:call-template name="affiche-âge">
        <xsl:with-param name="âge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <xsl:template match="longévité-ans/max">
    <dd>Maximum&#160;:
      <xsl:call-template name="affiche-âge">
        <xsl:with-param name="âge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <xsl:template match="longévité-ans/moy">
    <dd>Moyen&#160;:
      <xsl:call-template name="affiche-âge">
        <xsl:with-param name="âge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <!-- Pour obtenir la longévité en nombre entier -->
  <xsl:template name="affiche-âge">
    <xsl:param name="âge"/>
    <xsl:variable name="âge-calculé" select="number($âge)"/>
    <xsl:value-of select="$âge-calculé"/>
    <xsl:choose>
      <xsl:when test="$âge-calculé&gt;1"> ans</xsl:when>
      <xsl:otherwise> an</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--
    =======================================
    TRAITEMENT DES ÉLÉMENTS DU MODULE TEXTE
    =======================================
  -->
  <!--  ===== Traitement des blocks ===== -->
  <xsl:template match="titre">
    <p><strong><xsl:value-of select="."/></strong></p>
  </xsl:template>
  <xsl:template match="para">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  <xsl:template match="ol">
    <ol><xsl:apply-templates/></ol>
  </xsl:template>
  <xsl:template match="ul">
    <ul><xsl:apply-templates/></ul>
  </xsl:template>
  <xsl:template match="li">
    <li><xsl:apply-templates/></li>
  </xsl:template>
  
  <!--  ===== Traitement des inlines ===== -->
  <xsl:template match="br">
    <br/>
  </xsl:template>
  <xsl:template match="em">
    <em><xsl:apply-templates/></em>
  </xsl:template>
  <xsl:template match="strong">
    <strong><xsl:apply-templates/></strong>
  </xsl:template>
  <xsl:template match="tempé-C">
	<xsl:choose>
      <xsl:when test="$système!='métrique'"
	  ><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/>&#160;°F</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/>&#160;°C</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="long-cm">
    <xsl:choose>
      <xsl:when test="$système!='métrique'"
        ><xsl:value-of select="format-number(. div 2.54, '#.##')"/>&#160;po</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/>&#160;cm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="vol-litres">
    <xsl:choose>
      <xsl:when test="$système!='métrique'"
        ><xsl:value-of select="format-number(. div 4.54609, '#.##')"/>&#160;gallons impériaux</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/>&#160;litres</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- 2013-04-22 YMA
	 2014-04-14 YMA changé p0699101 pour marcoux
Même si on pourrait penser que l'adresse pour aller chercher le titre du document
destination pourrait être "../document.php?document=..." (puisque les URL relatives
dans "document()" sont par rapport à la feuille elle-même), eh bien non: la récupération
du document doit absolument passer par http, étant donné qu'il sort de la BD, et non du
simple système de fichiers. Donc, il faut utiliser une URL absolue.
("http:../document.php?document=..." ne marche pas non plus; je l'ai essayé.)
-->
	<xsl:template match="lien">
		<xsl:choose>
		<xsl:when test="$appURI = 'sysFich'"
		><a href="{@id}.xml"
		><xsl:value-of select=
			"document(concat('../XML/', @id, '.xml'))/fiche/poisson/noms/nom-scientifique"
			/></a></xsl:when>
		<xsl:otherwise
		><a href="document.php?document={$nomBD}/{@id}.xml&amp;format=xslt"
		><xsl:value-of select="document(concat(
			$appURI, 'document.php?document=', 
			$nomBD, '/', string(@id),
			'.xml&amp;format=xml'
			))/fiche/poisson/noms/nom-scientifique" /></a></xsl:otherwise>
			</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
