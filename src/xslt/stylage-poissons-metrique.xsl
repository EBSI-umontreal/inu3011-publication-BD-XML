<?xml version="1.0" encoding="iso-8859-1"?>
<!--
  =====================================================================
  INU3011 - Documents structur�s
  Auteurs: Arnaud d'Alayer et Marilou Bourque
  Cr�ation:						2006-04-04
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

  <xsl:param name="syst�me" select="'m�trique'" />
  <!--  <xsl:param name="syst�me" select="'anglais'" />-->
  <xsl:param name="nomBD" select="'BD'" />
  <xsl:param name="appURI" select="'sysFich'" />
  
  <!-- Pr�cision sur la sortie d�sir�e :
    - La sortie sera valide XHTML 1.0 Strict et contiendra l'ent�te XML
    - La sortie sera indent�e
    - La sortie sera encod�e en UTF-8
    - le namespace par d�faut sera celui de HTML, sans pr�fixer les �l�ments -->
  <xsl:output
    method="xml" 
    version="1.0" 
    indent="yes" 
    encoding="UTF-8" 
    omit-xml-declaration="no" 
    doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>
  
  <!-- Importation du fichier contenant les popups d'informations -->

<!--	YMA 2012-02-16 M�me si le pr�fixe html r�f�re au namespace par d�faut, on doit
		l'utiliser explicitement dans l'instruction ci-dessous, sinon, aucun �l�ment
		n'est rep�ch�... -->

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
        <meta name="DC.Date" content="{m�tadonn�es/date-dern-modif}" />
        <xsl:for-each select="m�tadonn�es/cr�ateur">
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
      <!-- Ins�rer le cadre des noms et de la famille -->
      <div id="nom">
        <h2>Noms</h2>
        <dl>
          <xsl:apply-templates select="noms"/>
          <xsl:apply-templates select="famille"/>
        </dl>
      </div>
      <div class="clearer">&#160;</div>
      
      <!-- Ins�rer le cadre sur la description sommaire du poisson. -->
      <div id="info-desc">
        <h2>Information descriptive</h2>
        <dl>
          <xsl:apply-templates select="premi�re-description"/>
          <xsl:apply-templates select="origines"/>
          <xsl:apply-templates select="zone-vie"/>
          <xsl:apply-templates select="long�vit�-ans"/>
          <xsl:apply-templates select="taille-cm"/>
        </dl>
      </div>
      
      <!--
        Ins�rer le cadre sur la qualit� de l'eau.
        Toutes ces informations �tant facultatives, on g�n�re le cadre html dans le template de l'�l�ment qualit�-eau.
      -->
      <xsl:apply-templates select="qualit�-eau"/>
      <div class="clearer">&#160;</div>
      
      <!--
        Ins�rer le cadre sur des informations d�taill�es sur le poisson.
        Toutes ces informations �tant facultatives, on g�n�re le cadre html dans un template infolong.
      -->
      <xsl:call-template name="infolong"/>    
    </div>
  </xsl:template>
      
  <!--  ===== Affichage des information d�taill�es sur le poisson ===== -->
  <xsl:template name="infolong">
    <!-- On affiche le bloc seulement s'il y a au moins un champ pr�sent -->
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
    <!-- Afficher l'intitul� et les noms communs s'ils existent. -->
    <xsl:if test="nom-commun">
      <dt>Nom(s) commun(s)&#160;:</dt>
      <!-- Les noms communs sont tri�s par langue et ensuite par ordre alphab�tique -->
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
  <xsl:template match="premi�re-description">
    <dt>Descripteur&#160;:</dt>
    <dd><xsl:value-of select="nom-du-descripteur"/><xsl:text> </xsl:text>(<xsl:value-of
      select="ann�e"/>)</dd>
  </xsl:template>
  
  <!--  ===== Affichage de l'origine ===== -->
  <xsl:template match="origines">
    <dt>Origine&#160;:</dt>
    <!-- Les origines seront affich�es dans l'ordre alphab�tique. -->
    <xsl:apply-templates select="origine">
      <xsl:sort select="."/>
    </xsl:apply-templates>
    <xsl:apply-templates select="commentaires"/>
  </xsl:template> 

  <!-- Il n'y a pas de distinction � l'affichage entre les entr�es provenant du th�saurus ou de la saisie libre. -->
  <xsl:template match="origine">
    <dd><xsl:value-of select="."/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de la zone de vie ===== -->
  <xsl:template match="zone-vie">
    <dt>Zone de vie&#160;:</dt>
    <dd><xsl:value-of select="."/></dd>
  </xsl:template> 
  
  <!--  ===== Affichage de l'esp�rance de vie ===== -->
  <xsl:template match="long�vit�-ans">
    <dt>Esp�rance de vie&#160;:</dt>
    <xsl:apply-templates/>
  </xsl:template> 

  <!--  ===== Affichage de la taille ===== -->
  <xsl:template match="taille-cm">
    <!-- Si c'est une description de la taille sans distinction du sexe, on affiche un intitul� sans mention du sexe. -->
    <xsl:if test="not(m�le | femelle)">
      <dt>Taille&#160;:</dt>
    </xsl:if>
    <xsl:apply-templates>
      <xsl:with-param name="unit�"><xsl:choose>
        <xsl:when test="$syst�me='m�trique'">cm</xsl:when>
        <xsl:otherwise>po</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

    <!-- Description de la taille avec distinction du sexe -->
  <xsl:template match="m�le">
    <xsl:param name="unit�"/>
    <dt>Taille du m�le&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unit�" select="$unit�"/>
    </xsl:apply-templates>
  </xsl:template>
  <xsl:template match="femelle">
    <xsl:param name="unit�"/>
    <dt>Taille de la femelle&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unit�" select="$unit�"/>
    </xsl:apply-templates>
  </xsl:template>

  <!--  ===== Affichage des informations concernant la qualit� de l'eau ===== -->
  <xsl:template match="qualit�-eau">
    <div id="info-eau">
      <h2>Qualit� de l&#8217;eau</h2>
      <dl>
        <xsl:apply-templates select="temp�rature-C"/>
        <xsl:apply-templates select="ph"/>
        <xsl:apply-templates select="duret�"/>
      </dl>

      <!-- Ajout des informations pour les popups -->
      <xsl:copy-of select="$popups"/>
    </div>
  </xsl:template>
  
    <!--  ===== Affichage de la temp�rature de l'eau ===== -->
  <xsl:template match="temp�rature-C">
    <dt>Temp�rature&#160;:</dt>
    <xsl:apply-templates>
      <xsl:with-param name="unit�"><xsl:choose>
        <xsl:when test="$syst�me='m�trique'">�C</xsl:when>
        <xsl:otherwise>�F</xsl:otherwise>
      </xsl:choose></xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>
  
  <!--  ===== Affichage du pH id�al de l'eau ===== -->
  <xsl:template match="ph">
    <dt>pH&#160;: <img src="../xslt/template-html/images/question.gif" alt="Plus d'information sur le pH" id="ancre-ph"/></dt>
    <xsl:apply-templates>
      <xsl:with-param name="unit�">pH</xsl:with-param>
    </xsl:apply-templates>
  </xsl:template> 
  
  <!--  ===== Affichage du pH id�al de l'eau ===== -->
  <xsl:template match="duret�">
    <dt>Duret�&#160;: <img src="../xslt/template-html/images/question.gif" alt="Plus d'information sur la duret�" id="ancre-gh"/></dt>
    <xsl:apply-templates>
      <xsl:with-param name="unit�">�d GH</xsl:with-param>
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
  
  <!--  ===== Affichage de la diff�rence entre le m�le et la femelle ===== -->
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
    TRAITEMENT DES �L�MENTS DE TYPE MIN-MAX-MOY-COMMENTAIRES
    ========================================================
  -->
  <!-- Cas g�n�ral -->
  <xsl:template match="min">
    <xsl:param name="unit�"/>
    <dd>Minimum&#160;: <xsl:choose>
      <xsl:when test="$unit�='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unit�='�F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose><xsl:text> </xsl:text><xsl:value-of select="$unit�"/></dd>
  </xsl:template>
  <xsl:template match="max">
    <xsl:param name="unit�"/>
    <dd>Maximum&#160;: <xsl:choose>
      <xsl:when test="$unit�='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unit�='�F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose><xsl:text> </xsl:text><xsl:value-of select="$unit�"/></dd>
  </xsl:template>
  <xsl:template match="moy">
    <xsl:param name="unit�"/>
    <dd>Moyenne&#160;: <xsl:choose>
      <xsl:when test="$unit�='po'"><xsl:value-of select="format-number(. div 2.54, '#.##')"/></xsl:when>
      <xsl:when test="$unit�='�F'"><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose><xsl:text> </xsl:text><xsl:value-of select="$unit�"/></dd>
  </xsl:template>
  <xsl:template match="commentaires">
    <dd><xsl:apply-templates/></dd>
  </xsl:template>
  
  <!-- Cas sp�cifique pour la long�vit� : on veut ajouter un s � 'an' si la valeur est sup�rieure � 1 an. -->
  <xsl:template match="long�vit�-ans/min">
    <dd>Minimum&#160;:
      <xsl:call-template name="affiche-�ge">
        <xsl:with-param name="�ge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <xsl:template match="long�vit�-ans/max">
    <dd>Maximum&#160;:
      <xsl:call-template name="affiche-�ge">
        <xsl:with-param name="�ge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <xsl:template match="long�vit�-ans/moy">
    <dd>Moyen&#160;:
      <xsl:call-template name="affiche-�ge">
        <xsl:with-param name="�ge" select="."/>
      </xsl:call-template>
    </dd>
  </xsl:template>
  <!-- Pour obtenir la long�vit� en nombre entier -->
  <xsl:template name="affiche-�ge">
    <xsl:param name="�ge"/>
    <xsl:variable name="�ge-calcul�" select="number($�ge)"/>
    <xsl:value-of select="$�ge-calcul�"/>
    <xsl:choose>
      <xsl:when test="$�ge-calcul�&gt;1"> ans</xsl:when>
      <xsl:otherwise> an</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!--
    =======================================
    TRAITEMENT DES �L�MENTS DU MODULE TEXTE
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
  <xsl:template match="temp�-C">
	<xsl:choose>
      <xsl:when test="$syst�me!='m�trique'"
	  ><xsl:value-of select="format-number(32 + . * 9 div 5, '#.##')"/>&#160;�F</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/>&#160;�C</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="long-cm">
    <xsl:choose>
      <xsl:when test="$syst�me!='m�trique'"
        ><xsl:value-of select="format-number(. div 2.54, '#.##')"/>&#160;po</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/>&#160;cm</xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="vol-litres">
    <xsl:choose>
      <xsl:when test="$syst�me!='m�trique'"
        ><xsl:value-of select="format-number(. div 4.54609, '#.##')"/>&#160;gallons imp�riaux</xsl:when>
      <xsl:otherwise><xsl:value-of select="."/>&#160;litres</xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- 2013-04-22 YMA
	 2014-04-14 YMA chang� p0699101 pour marcoux
M�me si on pourrait penser que l'adresse pour aller chercher le titre du document
destination pourrait �tre "../document.php?document=..." (puisque les URL relatives
dans "document()" sont par rapport � la feuille elle-m�me), eh bien non: la r�cup�ration
du document doit absolument passer par http, �tant donn� qu'il sort de la BD, et non du
simple syst�me de fichiers. Donc, il faut utiliser une URL absolue.
("http:../document.php?document=..." ne marche pas non plus; je l'ai essay�.)
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
