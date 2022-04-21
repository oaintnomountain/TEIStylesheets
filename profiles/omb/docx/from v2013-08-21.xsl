<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
 xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei">

 <xsl:import href="../../../docx/from/docxtotei.xsl"/>
 <!-- This transformation is based on the agora transformation 
  and modified for the forum historiae iuris by Olaf Berg (MPI for European Legal History) 2013
  c 2013 cc-by-sa
  
  main purpose of change:
  - Transform German word-formats like the English ones into valid TEI-XML
  - Allow for footnotes in title, author and heading
  - Allow italic, smallcaps, etc. in title and heading
  - Allow more than one paragraph in footnotes
  - Allow more than one author (each author in one element/ textline)
  - Allow to define through the first paragraph of the manuscript the numbering style of head elements and the section of the article.
  
  Important modifications:
  language: allow also German names for word-formats (word standard formats work out of the box with english, others not).
  docAuthor: allow for more than one author. Each paragraph in word becomes a separete docAuthor element. Set author above titel
  Supertitle: allow for a Supertitle above the maintitle (word-format: Supertitle / Übertitel to titlepart type="sup")
  Quote: aply also for Zitat format
  template P in pass3 - apply for elements inside &lt;text&gt; instead of inside &lt;body&gt;
                      - differentiate numbering for &lt;p&gt; in &lt;note&gt; to avoid same id for different elements
  include and sort abstracts in different languages (English, German, Italian, French, Portugues and Spanish predefined) by word format abstract, abstract-de, abstract-en. abstract-es
  allow for legend in figure and table (table not yet found a TEI compliant way to do so): p[type=legend] slips as last element into figure and table
  Section: If parameter rgRubrikDE or rgRubrikEN has value use this for biblscope[@type='part']. 
           Else check if the first paragraph is p[@rend='Parameter'] and contains a valid parameter for the section title and use this. 
           Otherwise default for @lang=de "Rubrik" and @lang=en "section".
  Numberstyle of head: Check if the first paragraph is p[@rend='Parameter'] and contains a valid parameter for numberingstyle of head. 
           Valid is: roman, arabic, none
           Otherwise use value of param name "headNumberStyle" (default: arabic)
 -->
 
<xsl:param name="headNumberStyle">arabic</xsl:param>
<xsl:param name="rgRubrikEN"/> 
<xsl:param name="rgRubrikDE"/> 

 <!-- 1 : here's what we do in pass2 -->

 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>set up a pass3 </desc>
 </doc>

 <xsl:template match="tei:TEI" mode="pass2">
  <xsl:variable name="Doctext">
   <xsl:copy>
    <xsl:apply-templates mode="pass2"/>
   </xsl:copy>
  </xsl:variable>
  <xsl:apply-templates select="$Doctext" mode="pass3"/>
 </xsl:template>

 <!-- jiggle around the paragraphs which should be in teiHeader for rg -->
 <xsl:template match="tei:teiHeader" mode="pass2">
  <teiHeader>
   <fileDesc>
    <titleStmt>
     <xsl:for-each select="//tei:p[@rend='Supertitle' or @rend='Übertitel']">
      <title type="sup">
       <xsl:apply-templates mode="pass2"/>
      </title>
     </xsl:for-each>
     <xsl:for-each select="//tei:p[@rend='Title']">
      <title type="main">
       <xsl:apply-templates mode="pass2"/>
      </title>
     </xsl:for-each>
     <xsl:for-each select="//tei:p[@rend='Subtitle']">
      <title type="sub">
       <xsl:apply-templates mode="pass2"/>
      </title>
     </xsl:for-each>
     <xsl:for-each select="//tei:p[@rend='author' or @rend='Autor']">
      <author>
       <xsl:apply-templates mode="pass2"/>
      </author>
     </xsl:for-each>
    </titleStmt>
    
    <editionStmt>
     <edition>
      <date>2013</date>
     </edition>
    </editionStmt>
    <publicationStmt>
     <idno type="documentnumber">rg21</idno>
    </publicationStmt>
    <seriesStmt>
     <title>Rg</title>
     <biblScope type="issue">21</biblScope>
     <biblScope type="vol">2013</biblScope>
 
      <xsl:choose>
       <xsl:when test="string-length($rgRubrikDE)+string-length($rgRubrikEN)!=0">
        <biblScope type="part" xml:lang="de-DE"><xsl:value-of select="$rgRubrikDE"/></biblScope>
        <biblScope type="part" xml:lang="en-GB"><xsl:value-of select="$rgRubrikEN"/></biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'fokus')">
        <biblScope type="part" xml:lang="de-DE">Fokus</biblScope>
        <biblScope type="part" xml:lang="en-GB">focus</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'recherche')">
        <biblScope type="part" xml:lang="de-DE">Recherche</biblScope>
        <biblScope type="part" xml:lang="en-GB">research</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'forum')">
        <biblScope type="part" xml:lang="de-DE">Forum</biblScope>
        <biblScope type="part" xml:lang="en-GB">forum</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'debatte')">
        <biblScope type="part" xml:lang="de-DE">Debatte</biblScope>
        <biblScope type="part" xml:lang="en-GB">debate</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'kritik')">
        <biblScope type="part" xml:lang="de-DE">Kritik</biblScope>
        <biblScope type="part" xml:lang="en-GB">critique</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'marginalien')">
        <biblScope type="part" xml:lang="de-DE">Marginalien</biblScope>
        <biblScope type="part" xml:lang="en-GB">marginalia</biblScope>
       </xsl:when>
       <xsl:otherwise>
        <biblScope type="part" xml:lang="de-DE">Rubrik</biblScope>
        <biblScope type="part" xml:lang="en-GB">section</biblScope>
       </xsl:otherwise>
      </xsl:choose>
     
     
     <idno type="ISSN">1619-4993</idno>
     <idno type="eISSN">2195-9617</idno>
     <idno type="ISBN">978-3-465-04171-9</idno>
    </seriesStmt>
    <sourceDesc>
     <p>digital native</p>
    </sourceDesc>
   </fileDesc>
  </teiHeader>
 </xsl:template>

 <!-- jiggle around the paragraphs which should be in front -->
 <xsl:template match="tei:text" mode="pass2">
  <text>
   <front>
    <titlePage>
     <xsl:for-each select="//tei:p[@rend='author' or @rend='Autor']">
      <docAuthor>
       <xsl:apply-templates mode="pass2"/>
      </docAuthor>
     </xsl:for-each>
     <docTitle>
      <xsl:for-each select="//tei:p[@rend='Supertitle' or @rend='Übertitel']">
       <titlePart type="sup">
        <xsl:apply-templates mode="pass2"/>
       </titlePart>
      </xsl:for-each>

      <xsl:for-each select="//tei:p[@rend='Title']">
       <titlePart type="main">
        <xsl:apply-templates mode="pass2"/>
       </titlePart>
      </xsl:for-each>

      <xsl:for-each select="//tei:p[@rend='Subtitle']">
       <titlePart type="sub">
        <xsl:apply-templates mode="pass2"/>
       </titlePart>
      </xsl:for-each>
     </docTitle>
    </titlePage>
    <div type="abstract">
     <xsl:for-each select="//tei:p[@rend='abstract']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
    <div type="abstract" xml:lang="de">
     <xsl:for-each select="//tei:p[@rend='abstract-de']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
    <div type="abstract" xml:lang="es">
     <xsl:for-each select="//tei:p[@rend='abstract-es']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
    <div type="abstract" xml:lang="pt">
     <xsl:for-each select="//tei:p[@rend='abstract-pt']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
    <div type="abstract" xml:lang="it">
     <xsl:for-each select="//tei:p[@rend='abstract-it']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
    <div type="abstract" xml:lang="fr">
     <xsl:for-each select="//tei:p[@rend='abstract-fr']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
    <div type="abstract" xml:lang="en">
     <xsl:for-each select="//tei:p[@rend='abstract-en']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
   </front>
   <body>
    <xsl:apply-templates mode="pass2" select="tei:body/*"/>
   </body>
   <back>
    <div type="bibliography">
     <listBibl>
      <head rend="none">Bibliography</head>
      <xsl:for-each select="//tei:p[@rend='bibliography' or @rend='Bibliographie']">
       <bibl>
        <xsl:apply-templates mode="pass2"/>
       </bibl>
      </xsl:for-each>
     </listBibl>
    </div>
   </back>
  </text>
 </xsl:template>
 
 <!-- get numbering style for head elements from special paragraph format in word document and set variable acordingly
 <xsl:template match="p[@rend='nummerierungsstil']" mode="pass2">
 
  <xsl:value-of select="."/>
 </xsl:template>
  -->
 
 <!-- suppress paragraphs which have been jiggled into front/back -->
 <xsl:template match="tei:p[@rend='Title']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='author' or @rend='Autor']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='Subtitle']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='Suptitle' or @rend='Übertitel']" mode="pass2"/>
 <xsl:template
  match="tei:p[@rend='abstract' or @rend='abstract-de' or @rend='abstract-en' 
  or @rend='abstract-es' or @rend='abstract-pt' or @rend='abstract-it' or @rend='abstract-fr']"
  mode="pass2"/>
 <xsl:template match="tei:p[@rend='bibliography' or @rend='Bibliographie']" mode="pass2"/>
 <!-- suppress empty head elements -->
 <xsl:template match="tei:head" mode="pass3">
  <xsl:if test="string-length(.)!=0">
   <xsl:copy-of select="."/>
  </xsl:if>
 </xsl:template>
 <!-- suppress empty abstract elements -->
 <xsl:template match="tei:div[@type='abstract']" mode="pass3">
  <xsl:if test="string-length(.)!=0">
   <xsl:copy-of select="."/>
  </xsl:if>
 </xsl:template>

 <!-- fix paragraph styles which should be TEI elements -->
 <xsl:template match="tei:p[@rend='epigraph' or @rend='Epigraph']" mode="pass2">
  <epigraph>
   <xsl:copy-of select="."/>
  </epigraph>
 </xsl:template>

<!--  does not work for rg style in ultraXml. See pass3 template match p
  <xsl:template match="tei:p[@rend='Quote' or @rend='Zitat']" mode="pass2">
   <p rend="quotation">
    <xsl:apply-templates mode="pass2"/>
   </p>
 </xsl:template>  -->

 <!-- include Legend in table/grafik -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc> &lt;CAPTION&gt; belongs to nearest figure or table, Legend as well. Put Caption above, and
   Legend under figure</desc>
 </doc>
 <xsl:template match="tei:CAPTION" mode="pass2"/>
 
 <xsl:template match="tei:table|tei:figure" mode="pass2">
  <xsl:copy>
   <xsl:apply-templates select="@*" mode="pass2"/>
   <xsl:if test="following-sibling::*[1][self::tei:CAPTION]">
    <xsl:apply-templates select="following-sibling::*[1][self::tei:CAPTION]/*" mode="pass2"/>
   </xsl:if>
   <xsl:apply-templates mode="pass2"/>
   <xsl:if test="self::tei:figure and following-sibling::*[self::tei:p[@rend='Legende']]">
    <xsl:apply-templates select="following-sibling::*[2][self::tei:p[@rend='Legende'][1]]"
     mode="pass2"/>
   </xsl:if>
  </xsl:copy>
 </xsl:template>


 <!-- only needed to change id and kill n attribute and handle endnotes like footnotes
  <xsl:template match="tei:note" mode="pass2">
  <xsl:element name="note">
   <xsl:attribute name="xml:id">
    <xsl:text>N</xsl:text>
    <xsl:number level="any"/>
   </xsl:attribute>
     <xsl:apply-templates mode="pass2" />
  </xsl:element>
 </xsl:template> -->



 <!-- (2) and here's what do in pass 3 -->

 <!-- copy everything that is not specifed further on -->



 <!-- fix up the default header
 <xsl:template match="tei:encodingDesc" mode="pass3"/>
 <xsl:template match="tei:titleStmt/tei:author" mode="pass3">
  <xsl:choose>
   <xsl:when test="tei:surname and tei:name">
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:otherwise>
    <author>
     <name>
      <xsl:value-of select="substring-before(.,' ')"/>
     </name>
     <surname>
      <xsl:value-of select="substring-after(.,' ')"/>
     </surname>
    </author>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>
  -->

 <!-- filter out special paragraph styles to maintain @rend attribute ERROR: italic text will be doubled 
 <xsl:template match="tei:p[@rend='Legende']" mode="pass3">
  <p rend="figure-legend">
   <xsl:copy-of select="descendant::node()"/>
  </p>
 </xsl:template> -->


 <!-- fix other styles which should be TEI elements -->
 <xsl:template match="tei:hi[@rend='Quote']" mode="pass3">
  <quote>
   <xsl:apply-templates mode="pass3"/>
  </quote>
 </xsl:template>

 <xsl:template match="tei:hi[@rend='foreign']" mode="pass3">
  <foreign>
   <xsl:apply-templates mode="pass3"/>
  </foreign>
 </xsl:template>

 <xsl:template match="tei:hi[@rend='Article_Title_Char']" mode="pass3">
  <title level="a">
   <xsl:apply-templates mode="pass3"/>
  </title>
 </xsl:template>

 <xsl:template match="tei:hi[@rend='Date_Pub']" mode="pass3">
  <date>
   <xsl:apply-templates mode="pass3"/>
  </date>
 </xsl:template>

 <xsl:template match="tei:bibl/tei:hi[@rend='italic']" mode="pass3">
  <title>
   <xsl:apply-templates mode="pass3"/>
  </title>
 </xsl:template>

<!-- create rend Attribut for head -->
 <xsl:template match="tei:head[not(@rend)]" mode="pass3">
  <xsl:choose>
   <xsl:when test="ancestor::tei:figure or ancestor::tei:table">
    <xsl:element name="head">
     <xsl:attribute name="rend">
      <xsl:text>none</xsl:text>
     </xsl:attribute>
     <xsl:apply-templates mode="pass3"/>
    </xsl:element>
   </xsl:when>
   <xsl:when test="string-length(.)=0"/>
   <xsl:otherwise>
    <xsl:element name="head">
     <xsl:attribute name="rend">
      <xsl:choose>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'roman')">
        <xsl:text>roman</xsl:text>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'arabic')">
        <xsl:text>arabic</xsl:text>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'none')">
        <xsl:text>none</xsl:text>
       </xsl:when>
       <xsl:otherwise>
        <xsl:value-of select="$headNumberStyle"/>
       </xsl:otherwise>
      </xsl:choose>
     </xsl:attribute>
     <xsl:apply-templates mode="pass3"/>
    </xsl:element>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- now some word artefacts we want to suppress -->

 <xsl:template match="tei:hi[@rend='footnote_reference']" mode="pass3">
  <xsl:apply-templates mode="pass3"/>
 </xsl:template>

 <xsl:template match="tei:hi[@rend='FootnoteReference']" mode="pass3">
  <xsl:apply-templates mode="pass3"/>
 </xsl:template>

 <xsl:template match="tei:p[@rend='Parameter']" mode="pass3"/>
 
 <!--
 <xsl:template match="tei:seg" mode="pass3">
  <xsl:value-of select="."/>
 </xsl:template>
-->


 <xsl:template match="tei:p" mode="pass3">
  <xsl:if test="ancestor::tei:text">
   <xsl:element name="p">
    <xsl:attribute name="xml:id">
     <xsl:choose>
      <xsl:when test="ancestor::tei:note">
       <xsl:text>n</xsl:text>
       <xsl:number count="tei:note" level="any"/>
       <xsl:text>p</xsl:text>
       <xsl:number level="single"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text>p</xsl:text>
       <xsl:number from="tei:body" count="tei:p[not(ancestor::tei:note)]" level="any"/>
      </xsl:otherwise>
     </xsl:choose>
    </xsl:attribute>
    <xsl:if test=".[@rend='noindent']">
     <xsl:attribute name="rend">
      <xsl:text>noindent</xsl:text>
     </xsl:attribute>
    </xsl:if>
    <xsl:if test=".[@rend='Kasten'or @rend='box']">
     <xsl:attribute name="rend">
      <xsl:text>box</xsl:text>
     </xsl:attribute>
    </xsl:if>
    <xsl:if test=".[@rend='Quote'or @rend='Zitat']">
     <xsl:attribute name="rend">
      <xsl:text>quotation</xsl:text>
     </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="pass3"/>
   </xsl:element>
  </xsl:if>
  <xsl:if test="ancestor::tei:teiHeader">
   <p>
    <xsl:value-of select="."/>
   </p>
  </xsl:if>
 </xsl:template>
 
 <xsl:template match="tei:p[@rend='Legende']" mode="pass3">
  <xsl:choose>
   <xsl:when test="ancestor::tei:figure|ancestor::tei:table">
    <p rend='Legende'>
     <xsl:apply-templates mode="pass3"/>
    </p>
   </xsl:when>
   <xsl:when test="preceding-sibling::*[1][self::tei:table]">
    <p rend='Legende'>
     <xsl:apply-templates mode="pass3"/>
    </p>
   </xsl:when>
   <xsl:otherwise/>
  </xsl:choose>
 </xsl:template> 
 
 
 <xsl:template match="tei:hi[matches(@rend,'color')]" mode="pass3"/>

 <!-- contexta magic references -->

 <xsl:template match="tei:hi[@rend='reference']" mode="pass3">
  <xsl:variable name="magicString">
   <xsl:value-of select="substring-before(substring-after(., '&lt;'),'&gt;')"/>
  </xsl:variable>

  <xsl:variable name="parentN">
   <!-- maybe needs to be adapted to counting from text and p in note -->
   <xsl:choose>
    <xsl:when test="ancestor::tei:note">
     <xsl:text>#n</xsl:text>
     <xsl:number from="tei:body" count="tei:note" level="any"/>
    </xsl:when>
    <xsl:otherwise>
     <xsl:text>#p</xsl:text>
     <xsl:number from="tei:body" count="tei:p[not(ancestor::tei:note)]" level="any"/>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

  <xsl:element name="ref">
   <xsl:attribute name="cRef">
    <xsl:value-of select="$magicString"/>
   </xsl:attribute>
   <xsl:attribute name="corresp">
    <xsl:value-of select="$parentN"/>
   </xsl:attribute>
   <xsl:apply-templates mode="pass3"/>
  </xsl:element>
 </xsl:template>

 <xsl:template match="tei:hi[@rend='reference']/tei:seg" mode="pass3">
  <hi rend="{@rend}">
   <xsl:value-of select="."/>
  </hi>
 </xsl:template>


 <xsl:template match="tei:hi[@rend='reference']/text()" mode="pass3">
  <xsl:value-of select='substring-before(.,"&lt;")'/>
  <xsl:if test="not(contains(.,'&lt;'))">
   <xsl:value-of select="."/>
  </xsl:if>
  <xsl:value-of select='substring-after(.,"&gt;")'/>
 </xsl:template>


 <!-- now some attribute values we want to kill -->
 <xsl:template match="@rend[.='Body Text First Indent']" mode="pass3"/>
 <xsl:template match="@rend[.='Body Text']" mode="pass3"/>
 <xsl:template match="tei:p[@rend='FootnoteText']" mode="pass3">
  <xsl:apply-templates mode="pass3"/>
 </xsl:template>

<!-- kill notes in teiHeader -->
 <xsl:template match="tei:teiHeader//tei:note" mode="pass3" />

 <!-- and copy everything else -->
 <xsl:template match="@*|comment()|processing-instruction()|text()" mode="pass3">
  <xsl:copy-of select="."/>
 </xsl:template>
 <xsl:template match="*" mode="pass3">
  <xsl:copy>
   <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
  </xsl:copy>
 </xsl:template>



 <!-- <xsl:template match="/">        <xsl:variable name="pass0">         <xsl:apply-templates mode="pass0"/>       </xsl:variable>        <xsl:variable name="pass1">         <xsl:for-each select="$pass0"> 	 <xsl:apply-templates mode="pass3"/>         </xsl:for-each>       </xsl:variable>		        <xsl:apply-templates select="$pass1" mode="pass2"/>              <xsl:call-template name="fromDocxFinalHook"/>     </xsl:template>  -->
</xsl:stylesheet>
