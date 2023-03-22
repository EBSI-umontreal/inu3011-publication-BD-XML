<?xml version="1.0" encoding="iso-8859-1"?>
<!--
  =====================================================================
  Auteurs: Arnaud d'Alayer et Marilou Bourque
  Dernière modification:	2006-04-04
  
  BLT6132 - Documents structurés
  ====================================================================
-->
<xsl:stylesheet
  version="1.0"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  extension-element-prefixes="">
  
  <!-- Précision sur la sortie désirée :
    - La sortie sera valide XHTML 1.0 Strict et contiendra l'entête XML
    - La sortie sera indentée
    - La sortie sera encodée en UTF-16 (à cause de MSXML)
    - le namespace par défaut sera celui de HTML, sans préfixer les éléments -->
  <xsl:output
    method="xml" 
    version="1.0" 
    indent="yes" 
    encoding="iso-8859-1" 
    omit-xml-declaration="no" 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
  
  <!--
    ========
    FICHE
    ========
  -->
  <xsl:template match="/">
    <html lang="fr-ca" xml:lang="fr-ca">
      <head>
        <meta http-equiv="Content-type" content="text/html; iso-8859-1"/>
        <title><xsl:value-of select="poisson/noms/nom-scientifique"/></title>
        <link rel="stylesheet" type="text/css" href="css/demo_poissons.css"/>
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
      
      <!-- L'image à insérer sera toujours la première de la collection. -->
      
      <!-- Insérer le cadre des noms et de la famille -->
      <div id="nom">
        <h2>Noms</h2>
        <dl>
          <xsl:apply-templates select="noms"/>
          <xsl:apply-templates select="famille"/>
        </dl>
      </div>
      
      <!-- Insérer le cadre sur la description sommaire du poisson. -->
      <div id="info-desc">
        <h2>Information descriptive</h2>
        <dl>
          <xsl:apply-templates select="descripteur"/>
          <xsl:apply-templates select="origines"/>
          <xsl:apply-templates select="zone-vie"/>
          <xsl:apply-templates select="longévité"/>
          <xsl:apply-templates select="taille"/>
        </dl>
      </div>
      
      <!--
        Insérer le cadre sur la qualité de l'eau.
        Toutes ces informations étant facultatives, on génère le cadre html dans le template de l'élément qualité-eau.
      -->
      <xsl:apply-templates select="qualité-eau"/>
      
      <!--
        Insérer le cadre sur des informations détaillées sur le poisson.
        Toutes ces informations étant facultatives, on génère le cadre html dans un template infolong.
      -->
      <xsl:call-template name="infolong"/>
    </div>
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
  <xsl:template match="descripteur">
    <dt>Descripteur&#160;:</dt>
    <dd><xsl:value-of select="nom-descripteur"/><xsl:text> </xsl:text>(<xsl:value-of select="première-description"/>)</dd>
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
  <xsl:template match="longévité">
    <dt>Espérance de vie&#160;:</dt>
    <xsl:apply-templates/>
  </xsl:template> 
  
  <!--  ===== Affichage de la taille ===== -->
  <xsl:template match="taille">
    <!-- Si c'est une description de la taille sans distinction du sexe, on affiche un intitulé sans mention du sexe. -->
    <xsl:if test="not(mâle | femelle)">
      <dt>Taille&#160;:</dt>
    </xsl:if>
    <xsl:apply-templates>
      <xsl:with-param name="unité">cm</xsl:with-param>
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
      <h2>Qualité de l'eau</h2>
      <dl>
        <xsl:apply-templates select="température"/>
        <xsl:apply-templates select="ph"/>
        <xsl:apply-templates select="dureté"/>
      </dl>
    </div>
  </xsl:template> 
  
  <!--  ===== Affichage de la température de l'eau ===== -->
  <xsl:template match="température">
    <dt>Température&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité">°C</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
  <!--  ===== Affichage du pH idéal de l'eau ===== -->
  <xsl:template match="ph">
    <dt>PH&#160;: <img src="../template-html/images/question.gif" alt="Plus d'information sur le pH" id="ancre-ph"/></dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité">pH</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template> 
  
  <!--  ===== Affichage du pH idéal de l'eau ===== -->
  <xsl:template match="dureté">
    <dt>Dureté&#160;: <img src="../template-html/images/question.gif" alt="Plus d'information sur la dureté" id="ancre-gh"/></dt>
    <xsl:apply-templates>
      <xsl:with-param name="unité">°d GH</xsl:with-param>
    </xsl:apply-templates>
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
    <dd>Minimun&#160;: <xsl:value-of select="."/><xsl:text> </xsl:text><xsl:value-of select="$unité"/></dd>
  </xsl:template>
  <xsl:template match="max">
    <xsl:param name="unité"/>
    <dd>Maximun&#160;: <xsl:value-of select="."/><xsl:text> </xsl:text><xsl:value-of select="$unité"/></dd>
  </xsl:template>
  <xsl:template match="moy">
    <xsl:param name="unité"/>
    <dd>Moyenne&#160;: <xsl:value-of select="."/><xsl:text> </xsl:text><xsl:value-of select="$unité"/></dd>
  </xsl:template>
  <xsl:template match="commentaires">
    <dd><xsl:apply-templates/></dd>
  </xsl:template>
  
  <!-- Cas spécifique pour la longévité : on veut ajouter un s à 'an' si cette période est suppérieure à 1 an. -->
  <xsl:template match="longévité/min">
    <dd>Minimun&#160;:
      <xsl:call-template name="affiche-âge">
        <xsl:with-param name="âge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <xsl:template match="longévité/max">
    <dd>Maximun&#160;:
      <xsl:call-template name="affiche-âge">
        <xsl:with-param name="âge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <xsl:template match="longévité/moy">
    <dd>Moyen&#160;:
      <xsl:call-template name="affiche-âge">
        <xsl:with-param name="âge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <!-- Pour obtenir la longévité en nombre entier, il faut enlever les caractères P et Y du format xsd:duration -->
  <xsl:template name="affiche-âge">
    <xsl:param name="âge"/>
    <xsl:variable name="âge-calculé" select="number(substring-before(substring-after($âge, 'P'), 'Y'))"/>
    <xsl:value-of select="$âge-calculé"/>
    <xsl:choose>
      <xsl:when test="$âge-calculé>1"> ans</xsl:when>
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
  
  <xsl:template match="img">
    <img src="{@src}" alt="{@alt}"/>
  </xsl:template>
</xsl:stylesheet>
