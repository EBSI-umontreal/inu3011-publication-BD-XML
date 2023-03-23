<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!-- L’instruction <xsl:output /> qui suit précise la forme de l’extrant désiré :
    - HTML5
    - indenté
    - encodé en UTF-8 -->
  <xsl:output method="html" version="5" indent="yes" encoding="UTF-8" 
    omit-xml-declaration="yes" />

  <xsl:template match="/"><xsl:apply-templates /></xsl:template>

<!-- Vous placez vos gabarits ci-dessous, en commençant par celui qui "match" votre
élément de plus haut niveau (EPHN), dont le contenu formera l’infrastructure
HTML principale de vos extrants HTML.

LE GABARIT CI-DESSOUS N’EST QU’UN EXEMPLE ET DOIT ÊTRE MODIFIÉ.
Notamment et entre autres, "EPHN" doit être remplacé par le nom de l’élément de plus haut
niveau de VOTRE modèle. Vous devrez ensuite ajouter les autres gabarits requis, selon la
conception de votre transformation.
-->
  <xsl:param name="nomBD" select="'BD'" />
  <xsl:param name="appURI" select="'sysFich'" />

  <xsl:param name="système" select="'métrique'" />
  <!--  <xsl:param name="système" select="'anglais'" />-->

  <!-- Importation du fichier contenant les popups d'informations -->
  <xsl:variable name="popups"
    select="document('popup.xml')//div" />

  <!--
    =====
    FICHE
    =====
  -->
  <xsl:template match="fiche-poisson">
    <html lang="fr-ca" xml:lang="fr-ca">
      <head>
	    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <title><xsl:value-of select="poisson/noms/nom-scientifique"/></title>
        <meta name="DC.Title" content="{poisson/noms/nom-scientifique}" />
        <meta name="DC.Description" content=
"Fiche descriptive du poisson &quot;{poisson/noms/nom-scientifique}&quot;" />
        <meta name="DC.Date" content="{métadonnées/date-dern-modif}" />
        <xsl:for-each select="métadonnées/créateur">
          <meta name="DC.Creator" content="{.}" />
        </xsl:for-each>        
        <link rel="stylesheet" type="text/css" href="../fichiers-aux-HTML/css/template.css"/>
        <script type="text/javascript" src="../fichiers-aux-HTML/script/template.js" charset="UTF-8">
		&#160; </script>
      </head>
      <body>
        <xsl:apply-templates select="poisson"/>        
      </body>
    </html>
  </xsl:template>

  <!--
    ==========================
    INFORMATION SUR LE POISSON
    ==========================
  -->
  <xsl:template match="poisson">
    <!-- Titre de la page : nom scientifique du poisson -->
    <h1><xsl:value-of select="noms/nom-scientifique"/></h1>
    <div id="page">
      <p id="image">
        <xsl:choose>
          <xsl:when test="/fiche-poisson/@image = 'oui'">
            <img src="../photos/{/fiche-poisson/@id}.jpg" alt="{noms/nom-scientifique}"/>
          </xsl:when>
          <xsl:otherwise><img src="../photos/NIL" alt="Image non disponible."/></xsl:otherwise>
        </xsl:choose>
      </p>
      <!-- Insérer le cadre des noms et de la famille -->
      <div id="nom">
        <h2>Nomenclature</h2>
        <dl>
          <xsl:apply-templates select="noms"/>
          <xsl:apply-templates select="famille"/>
        </dl>
      </div>
      <div class="clearer">&#160;</div>
      
      <!-- Insérer le cadre sur la description sommaire du poisson. -->
      <div id="info-desc">
        <h2>Caractéristiques de l’espèce</h2> 
        <dl>
          <xsl:apply-templates select="première-description"/>
          <xsl:apply-templates select="origines-géo"/>
          <xsl:apply-templates select="zone-de-vie"/>
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
      <!-- On affiche le bloc seulement s'il y a au moins un champ présent -->
      <xsl:if test="alimentation | aspect-physique | dimorphisme | comportement | reproduction">
        <div id="infolong">
          <h2>Aquariophilie</h2>
          <dl>
            <xsl:apply-templates select="alimentation"/>
            <xsl:apply-templates select="aspect-physique"/>
            <xsl:apply-templates select="dimorphisme"/>
            <xsl:apply-templates select="comportement"/>
            <xsl:apply-templates select="reproduction"/>
          </dl>
        </div>
      </xsl:if>
    </div>
  </xsl:template>

  <!--  ===== Affichage des noms ===== -->
  <xsl:template match="noms">
    <!-- Afficher le nom scientifique -->
    <dt>Nom scientifique&#160;:</dt>
    <dd><xsl:value-of select="nom-scientifique"/></dd>
    <!-- Afficher l'intitulé et les noms communs s'ils existent. -->
    <xsl:if test="nom-commun">
      <dt>Noms communs&#160;:</dt>
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
    <dt>Première description&#160;:</dt>
    <dd>par <xsl:value-of select="nom-du-descripteur"/><xsl:text> </xsl:text>(<xsl:value-of
      select="année"/>)</dd>
  </xsl:template>
  
  <!--  ===== Affichage de l'origine ===== -->
  <xsl:template match="origines-géo">
    <dt>Origines géographiques&#160;:</dt>
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
  <xsl:template match="zone-de-vie">
    <dt>Zone de vie (profondeur)&#160;:</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template>

  <!--  ===== Affichage de l'espérance de vie ===== -->
  <xsl:template match="longévité-ans">
    <xsl:call-template name="moyMinMaxComm">
      <xsl:with-param name="intitulé">Espérance de vie&#160;:</xsl:with-param>
      <xsl:with-param name="unité">an(s)</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!--  ===== Affichage de la taille ===== -->
  <xsl:template match="taille-cm">
    <!-- Si c'est une description de la taille sans distinction du sexe, on affiche un intitulé sans mention du sexe. -->
    <xsl:choose>
      <xsl:when test="not(mâle | femelle)">
        <xsl:call-template name="moyMinMaxComm">
          <xsl:with-param name="intitulé">Taille&#160;:</xsl:with-param>
          <xsl:with-param name="unité"><xsl:choose>
            <xsl:when test="$système='métrique'">cm</xsl:when>
            <xsl:otherwise>po</xsl:otherwise>
          </xsl:choose></xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Description de la taille avec distinction du sexe -->
  <xsl:template match="mâle">
    <xsl:call-template name="moyMinMaxComm">
      <xsl:with-param name="intitulé">Taille du mâle&#160;:</xsl:with-param>
      <xsl:with-param name="unité"><xsl:choose>
        <xsl:when test="$système='métrique'">cm</xsl:when>
        <xsl:otherwise>po</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="femelle">
    <xsl:call-template name="moyMinMaxComm">
      <xsl:with-param name="intitulé">Taille de la femelle&#160;:</xsl:with-param>
      <xsl:with-param name="unité"><xsl:choose>
        <xsl:when test="$système='métrique'">cm</xsl:when>
        <xsl:otherwise>po</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!--  ===== Affichage des informations concernant la qualité de l'eau ===== -->
  <xsl:template match="qualité-eau">
    <div id="info-eau">
      <h2>Qualité de l&#8217;eau</h2>
      <dl>
        <xsl:apply-templates select="température-C"/>
        <xsl:apply-templates select="acidité-pH"/>
        <xsl:apply-templates select="dureté-dGH"/>
      </dl>

      <!-- Ajout des informations pour les popups -->
      <xsl:copy-of select="$popups"/>
    </div>
  </xsl:template>
  
    <!--  ===== Affichage de la température de l'eau ===== -->
  <xsl:template match="température-C">
    <xsl:call-template name="moyMinMaxComm">
      <xsl:with-param name="intitulé">Température&#160;:</xsl:with-param>
      <xsl:with-param name="unité"><xsl:choose>
        <xsl:when test="$système='métrique'">°C</xsl:when>
        <xsl:otherwise>°F</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <!--  ===== Affichage du pH idéal de l'eau ===== -->
  <xsl:template match="acidité-pH">
    <xsl:call-template name="moyMinMaxComm">
      <xsl:with-param name="intitulé">Acidité&#160;:
        <img src="../fichiers-aux-HTML/images/question.gif" alt="Plus d’information sur le pH" id="ancre-ph"/>
      </xsl:with-param>
      <xsl:with-param name="unité">pH</xsl:with-param>
    </xsl:call-template>
  </xsl:template> 
  
  <!--  ===== Affichage du gH idéal de l'eau ===== -->
  <xsl:template match="dureté-dGH">
    <xsl:call-template name="moyMinMaxComm">
      <xsl:with-param name="intitulé">Dureté&#160;:
        <img src="../fichiers-aux-HTML/images/question.gif" alt="Plus d’information sur la dureté" id="ancre-gh"/>
      </xsl:with-param>
      <xsl:with-param name="unité">dGH</xsl:with-param>
    </xsl:call-template>
  </xsl:template> 
  
  <!--  ===== Affichage de l'alimentation du poisson ===== -->
  <xsl:template match="alimentation">
    <dt>Alimentation&#160;:</dt>
    <dd><xsl:apply-templates/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de la description physique du poisson ===== -->
  <xsl:template match="aspect-physique">
    <dt>Aspect physique&#160;:</dt>
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

  <!-- Gabarit général pour traiter les éléments dont le contenu est %moyMinMaxComm; -->
  <xsl:template name="moyMinMaxComm">
    <xsl:param name="intitulé" />
    <xsl:param name="unité" />
    
    <dt><xsl:copy-of select="$intitulé"/></dt>
    <xsl:apply-templates select="min | max | moy">
      <xsl:with-param name="unité" select="$unité" />
    </xsl:apply-templates>
    <xsl:apply-templates select="commentaires" />
  </xsl:template>

  <xsl:template match="min">
    <xsl:param name="unité"/>
    <dd>Minimum&#160;:
      <xsl:call-template name="traiterUnités">
        <xsl:with-param name="unité" select="$unité"/>
      </xsl:call-template>
    </dd>
  </xsl:template>

  <xsl:template match="max">
    <xsl:param name="unité"/>
    <dd>Maximum&#160;:
      <xsl:call-template name="traiterUnités">
        <xsl:with-param name="unité" select="$unité"/>
      </xsl:call-template>
    </dd>
  </xsl:template>

  <xsl:template match="moy">
    <xsl:param name="unité"/>
    <dd>Moyenne&#160;:
      <xsl:call-template name="traiterUnités">
        <xsl:with-param name="unité" select="$unité"/>
      </xsl:call-template>
    </dd>
  </xsl:template>

  <xsl:template name="traiterUnités">
    <xsl:param name="unité"/>
    <xsl:if test="$unité='pH'"><xsl:value-of select="$unité"/><xsl:text> </xsl:text></xsl:if>
    <xsl:choose>
      <xsl:when test="$unité='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unité='°F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
    <xsl:if test="$unité!='pH'"><xsl:text> </xsl:text><xsl:value-of select="$unité"/></xsl:if>
  </xsl:template>

  <xsl:template match="commentaires">
    <dd><xsl:apply-templates/></dd>
  </xsl:template>

  <!--
    =======================================
    TRAITEMENT DES ÉLÉMENTS DU MODULE TEXTE
    =======================================
  -->
  <!--  ===== Traitement des blocs ===== -->
  <xsl:template match="titre">
    <p><strong><xsl:value-of select="."/></strong></p>
  </xsl:template>
  <xsl:template match="para">
    <p><xsl:apply-templates/></p>
  </xsl:template>

  <!--  ===== Traitement des inlines ===== -->
  <xsl:template match="em">
    <em><xsl:apply-templates/></em>
  </xsl:template>

  <xsl:template match="em//em">
<!-- Double emphase (emphase dans une emphase: traitée nativement et correctement par LaTeX, mais
      pas en HTML. -->
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

  <xsl:template match="lien">
    <a href="document.php?document=poissons/{@id}.xml"
		><xsl:value-of select=
			"."
			/></a>
	</xsl:template>

</xsl:stylesheet>
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
								2016-03-08
  ====================================================================
2013-04-22 YMA
Concernant le template match="lien":
Même si on pourrait penser que l'adresse pour aller chercher le titre du document
destination pourrait être "../document.php?document=..." (puisque les URL relatives
dans "document()" sont par rapport à la feuille XSLT elle-même), eh bien non: la récupération
du document doit absolument passer par http, étant donné qu'il sort de la BD, et non du
simple système de fichiers. Donc, il faut utiliser une URL absolue.
("http:../document.php?document=..." ne marche pas non plus; je l'ai essayé.)
2017-04-10 YMA
Simplifié le traitement des liens pour démo en classe: le contenu du <lien> est
maintenant le texte cliquable.
2021-04-17 YMA
Modifié pour produire du HTML5.
-->
