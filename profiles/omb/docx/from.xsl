<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
 xmlns:tei="http://www.tei-c.org/ns/1.0" 
 xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 version="2.0" exclude-result-prefixes="tei w xs">

 <xsl:import href="../../../docx/from/docxtotei.xsl"/>
 <!-- This transformation is based on the agora transformation and the modification 
  for "rg Rechtsgeschichte - Legal History" by Olaf Berg (MPI for European Legal History) 2013.
  it is modified for use at the Leibniz-Center for Contemporary History Potsdam (ZZF) and actualized to work with the current TEI stylesheets v 7.52.0
  c 2022 cc-by-sa Olaf Berg (ZZF-Potsdam)
  
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
  Supertitle: allow for a Supertitle above the maintitle (word-format: Supertitle / Übertitel / Obertitel to titlepart type="sup")
  Quote: aply also for Zitat format
  template P in pass3 - apply for elements inside &lt;text&gt; instead of inside &lt;body&gt;
                      - differentiate numbering for &lt;p&gt; in &lt;note&gt; to avoid same id for different elements
  include and sort abstracts in different languages (English, German, Italian, French, Portugues and Spanish predefined) by word format abstract, abstract-de, abstract-en. abstract-es
  allow for legend in figure and table (table not yet found a TEI compliant way to do so): p[type=legend] slips as last element into figure and table
 
  Use of first paragraph in word-document with formate "parameter" to set some parameters for the document/documentprocessing:
  - OMB-Section: If parameter ombRubrikDE or ombRubrikEN has value use this for biblscope[@type='part']. 
           Else check if the first paragraph is p[@rend='Parameter'] and contains a valid parameter for the section title and use this. 
           Otherwise default for @lang=de "Rubrik" and @lang=en "section".
           note: ombRubrikDE and ombRubrikEN is used for information in teiHeader and as running header for typesetting
  - Numberstyle of head: Check if the first paragraph is p[@rend='Parameter'] and contains a valid parameter for numberingstyle of head. 
           Valid is: roman, arabic, none
           Otherwise use value of param name "headNumberStyle" (default: arabic) (this param is newly introduced in this xsl-file)
           note: this stylesheet only sets for the element <head> the param @rend to roman, arabic or none. 
                 The exact numbering style depends on the processing in the typesetting program or further xsl-transformations
  New support for text underline with dotted line and with doublewavyline in hi element attribute "underdottedline" resp. "doubleunderwavyline"
  Support for non-latin character words in text that need special typefont: 
           Words that are doubleunderlined in word will get packed into an <foreign> element 
          (transforming an <hi @rend="doubleunderlined"> into an <foreign> element with @rend attribute="gentium".
          note: the free opensource gentiumPlus font covers kyrillic and greek letters
          Words that are underdottedlined or doubleunderwavylined will get packed into an <foreign @rend="cjk"> element.
          note: this allow for use of an typefont like cyberCJK or others that cover Chinese, Japanese and Korean letters.
          note2: the use of @type instead of the more accurate @xml:lang is a compromise to avoid long lists of correspondence between language and typeface
                 and to ease work for typesetters who do not neccesarilly know which exact language a word (e.g. name) comes from.
 -->
 
<xsl:param name="headNumberStyle">arabic</xsl:param>
<xsl:param name="ombRubrikEN"/> 
<xsl:param name="ombRubrikDE"/> 
 
 
 <!-- a slightly changed template from textruns.xsl to include doublewavyunderlined textmarks for further processing -->


 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>
   <p>Look at the Word underlying basic formatting.</p>
   <p>We can ignore the run's font change if a) it's not a special para AND the font is the ISO
    default, OR b) the font for the run is the same as its parent paragraph.</p>
   <p>This template is slightly changed from the docx standard docx-stylesheet to detect more
    textstyles like doublewavyunderlined textmarks in order to enable further processing. For the
    OMB Stylesheet we use thes uncommon textstyles to mark text for special elements specific to the
    OMB texts.</p>
  </desc>
 </doc>
 <xsl:template name="basicStyles">
  <xsl:param name="parented">false</xsl:param>
  <xsl:param name="extrarow"  tunnel="yes" as="node()?"/>
  <xsl:param name="extracolumn"   tunnel="yes" as="node()?"/>
  <xsl:variable name="wVal.off" select="('0','false','off')"/>
  <xsl:variable name="styles">
   <xsl:choose>
    <xsl:when test="w:rPr/w:rFonts  and not(w:rPr/w:rFonts/@w:ascii)"/>
    <xsl:when test="w:rPr/w:rFonts/@w:ascii  and matches(parent::w:p/w:pPr/w:pStyle/@w:val,'Special')">
     <s><xsl:text>font-family:</xsl:text>
      <xsl:value-of select="w:rPr/w:rFonts/@w:ascii"/>
     </s>
    </xsl:when>
    <xsl:when test="w:rPr/w:rFonts/@w:ascii='Cambria'"/>
    <xsl:when test="matches(w:rPr/w:rFonts/@w:ascii,'^Times')"/>
    <xsl:when test="w:rPr/w:rFonts/@w:ascii='Calibri'"/>
    <xsl:when test="w:rPr/w:rFonts/@w:ascii='Arial'"/>
    <xsl:when test="w:rPr/w:rFonts/@w:ascii='Verdana'"/>
    <xsl:when test="w:rPr/w:rFonts/@w:ascii =
     parent::w:p/w:pPr/w:rPr/w:rFonts/@w:ascii"/>
    <xsl:when test="not(w:rPr/w:rFonts)"/>
    <xsl:otherwise>
     <s><xsl:text>font-family:</xsl:text>
      <xsl:value-of select="w:rPr/w:rFonts/@w:ascii"/>
     </s>
    </xsl:otherwise>
   </xsl:choose>
   <!-- see also w:ascii="Courier New" w:hAnsi="Courier New" w:cs="Courier New" -->
   <!-- what do we want to do about cs (Complex Scripts), hAnsi (high ANSI), eastAsia etc? -->
   
   <xsl:choose>
    <xsl:when test="w:rPr/w:sz and $preserveFontSizeChanges='true'">
     <s><xsl:text>font-size:</xsl:text>
      <xsl:value-of select="number(w:rPr/w:sz/@w:val) div 2"/>
      <xsl:text>pt</xsl:text>
     </s>
    </xsl:when>
    <xsl:when test="ancestor::w:tc and $extrarow/w:rPr/w:sz">
     <s><xsl:text>font-size:</xsl:text>
      <xsl:value-of select="number($extrarow/w:rPr/w:sz/@w:val) div 2"/>
      <xsl:text>pt</xsl:text>
     </s>
    </xsl:when>
    <xsl:when test="ancestor::w:tc and $extracolumn/w:rPr/w:sz">
     <s><xsl:text>font-size:</xsl:text>
      <xsl:value-of select="number($extracolumn/w:rPr/w:sz/@w:val) div 2"/>
      <xsl:text>pt</xsl:text>
     </s>
    </xsl:when>
   </xsl:choose>
   <xsl:if test="w:rPr/w:position/@w:val and not(w:rPr/w:position/@w:val='0')">
    <s><xsl:text>position:</xsl:text>
     <xsl:value-of select="w:rPr/w:position/@w:val"/>
    </s>
   </xsl:if>
  </xsl:variable>
  
  <!-- right-to-left text -->
  <xsl:variable name="dir" select="tei:onOff(w:rPr/w:rtl) or tei:onOff(parent::w:p/w:pPr/w:rPr/w:rtl)"/>
  
  <xsl:variable name="effects">
   <xsl:call-template name="fromDocxEffectsHook"/>
   <xsl:if test="w:rPr/w:position[number(@w:val)&lt;-2] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:position[number(@w:val)&lt;-2]
    or $extrarow/w:rPr/w:position[number(@w:val)&lt;-2])
    )">
    <n>subscript</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:i[not(@w:val=$wVal.off)] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:i[not(@w:val=$wVal.off)]  or $extrarow/w:rPr/w:i[not(@w:val=$wVal.off)])
    )">
    <n>italic</n>
   </xsl:if>
   
   <xsl:choose>
    <xsl:when test="w:rPr/w:b/@w:val=$wVal.off or
     (ancestor::w:tc 
     and
     ($extracolumn/w:rPr/w:b/@w:val=$wVal.off or $extrarow/w:rPr/w:b/@w:val=$wVal.off)
     )">
     <n>normalweight</n>
    </xsl:when>
    <xsl:when test="w:rPr/w:b[not(@w:val=$wVal.off)] or
     (ancestor::w:tc 
     and
     ($extracolumn/w:rPr/w:b[not(@w:val=$wVal.off)]  or $extrarow/w:rPr/w:b[not(@w:val=$wVal.off)])
     )">
     <n>bold</n>
    </xsl:when>
   </xsl:choose>
   
   <xsl:if test="w:rPr/w:position[number(@w:val)&gt;2] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:position[number(@w:val)&gt;2]
    or $extrarow/w:rPr/w:position[number(@w:val)&gt;2])
    )">
    <n>superscript</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:vertAlign or 
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:vertAlign  or $extrarow/w:rPr/w:vertAlign)
    )">
    <n>
     <xsl:value-of select="w:rPr/w:vertAlign/@w:val"/>
    </n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:strike[not(@w:val=$wVal.off)] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:strike[not(@w:val=$wVal.off)]  or $extrarow/w:rPr/w:strike[not(@w:val=$wVal.off)])
    )">
    
    <n>strikethrough</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:dstrike[not(@w:val=$wVal.off)] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:dstrike[not(@w:val=$wVal.off)]  or $extrarow/w:rPr/w:dstrike[not(@w:val=$wVal.off)])
    )">
    <n>doublestrikethrough</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:u[@w:val='single']">
    <n>underline</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:u[@w:val='wave']">
    <n>wavyunderline</n>
   </xsl:if>
      
   <xsl:if test="w:rPr/w:u[@w:val='wavyDouble']">
    <n>doubleunderwavyline</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:u[@w:val='dotted']">
    <n>underdottedline</n>
   </xsl:if>
   
   
   <xsl:if test="w:rPr/w:u[@w:val='double']">
    <n>doubleunderline</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:smallCaps[not(@w:val=$wVal.off)] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:smallCaps[not(@w:val=$wVal.off)]  or $extrarow/w:rPr/w:smallCaps[not(@w:val=$wVal.off)])
    )">
    <n>smallcaps</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:caps[not(@w:val=$wVal.off)] or
    (ancestor::w:tc 
    and
    ($extracolumn/w:rPr/w:caps[not(@w:val=$wVal.off)]  or $extrarow/w:rPr/w:caps[not(@w:val=$wVal.off)])
    )">
    <n>allcaps</n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:color and
    not(w:rPr/w:color/@w:val='000000' or w:rPr/w:color/@w:val='auto')">
    <n>
     <xsl:text>color(</xsl:text>
     <xsl:value-of select="w:rPr/w:color/@w:val"/>
     <xsl:text>)</xsl:text>
    </n>
   </xsl:if>
   
   <xsl:if test="w:rPr/w:highlight">
    <n>
     <xsl:text>background(</xsl:text>
     <xsl:value-of select="w:rPr/w:highlight/@w:val"/>
     <xsl:text>)</xsl:text>
    </n>
   </xsl:if>
   
  </xsl:variable>
  <xsl:choose>
   <xsl:when test="normalize-space(.)='' and not(w:sym)">
    <xsl:apply-templates/>
   </xsl:when>
   <xsl:when test="$effects/* or ($styles/* and $preserveEffects='true')">
    <xsl:element name="{if ($parented='true') then 'seg' else 'hi'}">
     <xsl:choose>
      <xsl:when test="$effects/*">
       <xsl:attribute name="rend">
        <xsl:value-of select="$effects/*" separator=" "/>
       </xsl:attribute>
      </xsl:when>
     </xsl:choose>
     <xsl:if test="$styles/* and $preserveEffects='true'">
      <xsl:attribute name="style">
       <xsl:value-of select="($styles/*)" separator=";"/>
       <xsl:if test="$dir">direction:rtl;</xsl:if>
      </xsl:attribute>
     </xsl:if>
     <xsl:if test="w:t[@xml:space='preserve']">
      <xsl:attribute name="xml:space">preserve</xsl:attribute>
     </xsl:if>
     <xsl:apply-templates/>
    </xsl:element>
   </xsl:when>
   <xsl:otherwise>
    <xsl:if test="w:t[@xml:space='preserve'] and $parented='true'">
     <xsl:attribute name="xml:space">preserve</xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
   </xsl:otherwise> 
  </xsl:choose>
 </xsl:template>
 
 
  
  
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

 <!-- jiggle around the paragraphs which should be in teiHeader for omb@zzf -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>create teiHeader with paragraphs like suptitel, titel, subtitel and author and create an edition statement </desc>
 </doc>
 <xsl:template match="tei:teiHeader" mode="pass2">
  <teiHeader>
   <fileDesc>
    <titleStmt>
     <title type="short">
      <xsl:value-of select="lower-case(substring(replace(//tei:p[@rend='Title'], '[\s\W]', '-'),1,25))"/>
     </title>
     <xsl:for-each select="//tei:p[@rend='Supertitle' or @rend='Übertitel' or @rend='Obertitel']">
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
      <date>2022</date>
     </edition>
    </editionStmt>
    <publicationStmt>
     <p>
      <idno type="documentnumber">omb-01</idno>
     </p>
    </publicationStmt>
    <seriesStmt>
     <title>DDR im Schmalfilm</title>
     <respStmt>
      <resp>ed. by</resp>
      <name>Olaf Berg (ZZF Potsdam)</name>
     </respStmt> 
     <biblScope unit="issue">version 01</biblScope>
     <biblScope unit="volume">2022</biblScope>
     <xsl:choose>
       <xsl:when test="string-length($ombRubrikDE)+string-length($ombRubrikEN)!=0">
        <biblScope unit="part" xml:lang="de-DE"><xsl:value-of select="$ombRubrikDE"/></biblScope>
        <biblScope unit="part" xml:lang="en-GB"><xsl:value-of select="$ombRubrikEN"/></biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'kuratorisch')">
        <biblScope unit="part" xml:lang="de-DE">Kuratorische Anmerkungen</biblScope>
        <biblScope unit="part" xml:lang="en-GB">curatorial remarks</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'meta')">
        <biblScope unit="part" xml:lang="de-DE">Meta-Analysen</biblScope>
        <biblScope unit="part" xml:lang="en-GB">meta analysis</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'öffentlich')">
        <biblScope unit="part" xml:lang="de-DE">Öffentliches Leben</biblScope>
        <biblScope unit="part" xml:lang="en-GB">public life</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'privat')">
        <biblScope unit="part" xml:lang="de-DE">Privates Leben</biblScope>
        <biblScope unit="part" xml:lang="en-GB">privat life</biblScope>
       </xsl:when>
       <xsl:when test="contains(lower-case(//tei:body//tei:p[1][@rend='Parameter']),'objekte')">
        <biblScope unit="part" xml:lang="de-DE">Tiere und Gegenstände</biblScope>
        <biblScope unit="part" xml:lang="en-GB">animals and things</biblScope>
       </xsl:when>
       <xsl:otherwise>
        <biblScope unit="part" xml:lang="de-DE">Rubrik</biblScope>
        <biblScope unit="part" xml:lang="en-GB">section</biblScope>
       </xsl:otherwise>
      </xsl:choose>
     
     
     <idno type="ISSN">xxxx-xxxx</idno>
     <idno type="eISSN">xxxx-xxxx</idno>
     <idno type="ISBN">978-3-xxx-xxxxx-x</idno>
    </seriesStmt>
    <sourceDesc>
     <p>digital native publication</p>
    </sourceDesc>
   </fileDesc>
  </teiHeader>
 </xsl:template>

 <!-- jiggle around the paragraphs which should be in front -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>create front with paragraphs like suptitel, titel, subtitel, author and abstract and backmatter with bibliographic elements </desc>
 </doc>
 <xsl:template match="tei:text" mode="pass2">
  <text>
   <front>
    <titlePage>
     <docTitle>
      <xsl:for-each select="//tei:p[@rend='Supertitle' or @rend='Übertitel' or @rend='Obertitel']">
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

     <xsl:for-each select="//tei:p[@rend='author' or @rend='Autor']">
      <docAuthor>
       <xsl:apply-templates mode="pass2"/>
      </docAuthor>
     </xsl:for-each>
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
    <xsl:if test="//tei:p[@rend='bibliography' or @rend='Bibliographie']">
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
    </xsl:if>
    <div type="author-info">
     <xsl:for-each select="//tei:p[@rend='cv' or @rend='author-info']">
      <p>
       <xsl:apply-templates mode="pass2"/>
      </p>
     </xsl:for-each>
    </div>
   </back>
  </text>
 </xsl:template>
 
  
 <!-- suppress paragraphs which have been jiggled into front/back -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>suppress paragraphs which have been jiggled into front/back from body of text </desc>
 </doc>
 <xsl:template match="tei:p[@rend='Title']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='author' or @rend='Autor']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='Subtitle']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='Suptitle' or @rend='Übertitel' or @rend='Obertitel']" mode="pass2"/>
 <xsl:template match="tei:p[@rend='cv' or @rend='author-info']" mode="pass2" />
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
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>fix paragraph styles which should be TEI elements: p rend=epigraph to epigraph element </desc>
 </doc>
 <!-- 
  <xsl:template match="tei:p[@rend='epigraph' or @rend='Epigraph']" mode="pass2">
  <epigraph>
   <xsl:copy-of select="."/>
  </epigraph>
 </xsl:template>
  -->
 <xsl:template match="tei:div" mode="pass2">
  <xsl:copy>
   <xsl:for-each-group select="tei:p[@rend='epigraph' or @rend='Epigraph']" group-adjacent="name( )">
    <epigraph>
     <xsl:apply-templates select="current-group()" mode="pass2"/>
    </epigraph>
   </xsl:for-each-group>
   <xsl:apply-templates select="*[not(self::tei:p[@rend='epigraph' or @rend='Epigraph'])]" mode="pass2"/>
  </xsl:copy>
 </xsl:template> 

<!-- transform paragraph styled as "Legend" into tei trailer element -->
 <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
  <xd:desc> transform paragraph with style "Legende" or "tabletrailer / Tabellenlegende" into tei element "trailer". 
   Trailer will be positioned within tabele/figure element in pass 2 </xd:desc>
 </xd:doc>
 <xsl:template match="tei:p[@rend='Legende' or @rend='tabletrailer' or @rend='Tabellenlegende']" mode="pass1hi">
  <xsl:element name="trailer">
   <xsl:apply-templates mode="pass1hi"/>
  </xsl:element>
 </xsl:template>

 <!-- transform paragraph styled as "tabelhead" into tei caption element -->
 <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
  <xd:desc> transform paragraph with style "tabelhead" or "Tabellenüberschrift" into tei element "caption". 
   Caption will be positioned within tabele/figure element as head in pass 2 </xd:desc>
 </xd:doc>
 <xsl:template match="tei:p[@rend='Tabellenüberschrift' or @rend='tablehead']" mode="pass1hi">
  <xsl:element name="CAPTION">
   <xsl:apply-templates mode="pass1hi"/>
  </xsl:element>
 </xsl:template>
 
<!-- create OMB video element in column between paragraphs -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>create video reference as TEI element for video sequences taken from the OMB that are set between text-paragraphs. 
   Use information from ms word paragraph styled as "Videoblock" with OMB clip information in squared brackets. 
   p rend=Videoblock to tei:media in tei:figure Include Legend into figure element</desc>
 </doc>
 
 <xsl:template match="tei:p[@rend='Videoblock' or @rend='videoblock']" mode="pass2">
  <xsl:analyze-string select="." regex="\[{{1,2}}[Bb]ox:? ?(\d+)[, ]+[Rr]olle:? ?(\d+),? *([Ss]tart:? ?\d[\d\.:\- ]+\d)?[, ]*([Ss]top:? ?\d[\d\.:\- ]+\d)?[, ]*(#.+?)?\]{{1,2}}">
   
   <xsl:matching-substring>
    <!-- extract variable values from analyzed string. We have to do it her because in xslt variables are only aviable to childs and siblings -->
    <xsl:variable name="box">
     <xsl:choose>
      <xsl:when test="matches(regex-group(1),'\d{3}')">
       <xsl:value-of select="regex-group(1)"/>
      </xsl:when>
      <xsl:when test="matches(regex-group(1),'\d\d')">
       <xsl:value-of select="concat('0', regex-group(1))"/>
      </xsl:when>
      <xsl:when test="matches(regex-group(1),'\d')">
       <xsl:value-of select="concat('00', regex-group(1))"/>
      </xsl:when>
     </xsl:choose>
    </xsl:variable>
    <xsl:variable name="roll">
     <xsl:choose>
      <xsl:when test="matches(regex-group(2),'\d\d')">
       <xsl:value-of select="regex-group(2)"/>
      </xsl:when>
      <xsl:when test="matches(regex-group(2),'\d')">
       <xsl:value-of select="concat('0', regex-group(2))"/>
      </xsl:when>
     </xsl:choose>
    </xsl:variable>
    <xsl:variable name="start">
     <xsl:if test="regex-group(3)">
      <xsl:choose>
       <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
        <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})','$1h$2m$3s$4')"/>
       </xsl:when>
       <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
        <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2}).*','00h$1m$2s$3')"/>
       </xsl:when>
       <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{1,2})[:\.\-](\d{2})')">
        <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{1,2})[:\.\-](\d{2}).*','00h$1m$2s00')"/>
       </xsl:when>
      </xsl:choose>
     </xsl:if>
    </xsl:variable>
    <xsl:variable name="end">
     <xsl:if test="regex-group(4)">
      <xsl:choose>
       <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
        <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})','$1h$2m$3s$4')"/>
       </xsl:when>
       <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
        <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2}).*','00h$1m$2s$3')"/>
       </xsl:when>
       <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{1,2})[:\.\-](\d{2})')">
        <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{1,2})[:\.\-](\d{2}).*','00h$1m$2s00')"/>
       </xsl:when>
      </xsl:choose>
     </xsl:if>
    </xsl:variable>
    <xsl:variable name="trailer">
     <xsl:if test="matches(regex-group(3),'^#.+')">
      <xsl:value-of select="replace(regex-group(3),'#(.+)','$1')"/>
     </xsl:if>
     <xsl:if test="matches(regex-group(4),'^#.+')">
      <xsl:value-of select="replace(regex-group(5),'#(.+)','$1')"/>
     </xsl:if>
     <xsl:if test="matches(regex-group(5),'^#.+')">
      <xsl:value-of select="replace(regex-group(5),'#(.+)','$1')"/>
     </xsl:if>
    </xsl:variable>
    
    <figure place="column" type="omb">
     <xsl:element name="head">
      <xsl:value-of select="concat('Sequenz aus OMB Box ',$box,' Rolle ', $roll)"/>
     </xsl:element>
     <xsl:element name="media">
      <xsl:attribute name="type">omb</xsl:attribute>
      <xsl:attribute name="mimeType">video/mp4</xsl:attribute>
      <xsl:attribute name="url">
       <xsl:value-of select="concat('https://open-memory-box.de/stream/watermark/480/omb_', $box,'-', $roll,'_480_wm.mp4')"/>
      </xsl:attribute>
      <xsl:if test="$start != ''">
       <xsl:attribute name="start">
        <xsl:text>tc:</xsl:text>
        <xsl:value-of select="$start"/>
       </xsl:attribute>
      </xsl:if>
      <xsl:if test="$end != ''">
       <xsl:attribute name="end">
        <xsl:text>tc:</xsl:text>
        <xsl:value-of select="$end"/>
       </xsl:attribute>
      </xsl:if>        
     </xsl:element>
     <xsl:if test="$trailer != ''">
      <xsl:element name="trailer">
       <xsl:value-of select="$trailer"/>
      </xsl:element>
     </xsl:if>
    </figure>
   </xsl:matching-substring>
   <xsl:non-matching-substring/>
  </xsl:analyze-string>    
 </xsl:template>
 
 
 <!-- create OMB video reference and element inline in p -->
 <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
  <xd:desc> create OMB video-reference for OMB sequences within text paragraphs (inline)
   the template matches only the text node of tei:p so that the element structure of p is preserved </xd:desc>
 </xd:doc>
 <xsl:template match="tei:p//text()" mode="pass2">
  
  <!-- handle inline notation like OMB link path  DOES NOT WORK
  <xsl:if test=".,'\[\d\d\d\-\d\d/\d\d\-\d\d\-\d\d\-\d\d\]'">
   <xsl:analyze-string select="." regex="\[((\d\d\d)\-(\d\d)/(\d\d)\-(\d\d)\-(\d\d)\-(\d\d))\]">
    <xsl:matching-substring>
     <xsl:element name="ref">
      <xsl:attribute name="target">
       <xsl:value-of select="concat('http://open-memory-box.de/roll/',regex-group(1))"/>
      </xsl:attribute>
      <xsl:value-of select="concat('(OMB Box', regex-group(2), ' Rolle ', regex-group(3), ')')"/>
     </xsl:element>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
     <xsl:copy-of select="."/>
    </xsl:non-matching-substring>
   </xsl:analyze-string>    
  </xsl:if>
   -->

  
  <!-- handle notation as stated in author information -->
  <xsl:choose>
   <xsl:when test=".,'\[ ?[Bb]ox:?.+?\]'">
    <xsl:analyze-string select="." regex="\[{{1,2}} ?[Bb]ox:? ?(\d+)[, ]+[Rr]olle:? ?(\d+),? *([Ss]tart:? ?\d[\d\.:\- ]+\d)?[, ]*([Ss]top:? ?\d[\d\.:\- ]+\d)?[, ]*(#.+?)?\]{{1,2}}">

     <xsl:matching-substring>
      <!-- extract variable values from analyzed string. We have to do it her because in xslt variables are only aviable to childs and siblings -->
      <xsl:variable name="box">
       <xsl:choose>
        <xsl:when test="matches(regex-group(1),'\d{3}')">
         <xsl:value-of select="regex-group(1)"/>
        </xsl:when>
        <xsl:when test="matches(regex-group(1),'\d\d')">
         <xsl:value-of select="concat('0', regex-group(1))"/>
        </xsl:when>
        <xsl:when test="matches(regex-group(1),'\d')">
         <xsl:value-of select="concat('00', regex-group(1))"/>
        </xsl:when>
       </xsl:choose>
      </xsl:variable>
      <xsl:variable name="roll">
       <xsl:choose>
        <xsl:when test="matches(regex-group(2),'0\d\d')">
         <xsl:value-of select="substring(regex-group(2),2)" />
        </xsl:when>
        <xsl:when test="matches(regex-group(2),'\d\d')">
         <xsl:value-of select="regex-group(2)"/>
        </xsl:when>
        <xsl:when test="matches(regex-group(2),'\d')">
         <xsl:value-of select="concat('0', regex-group(2))"/>
        </xsl:when>
       </xsl:choose>
      </xsl:variable>
      <xsl:variable name="start">
       <xsl:if test="regex-group(3)">
        <xsl:choose>
         <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})','$1h$2m$3s$4')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2}).*','00h$1m$2s$3')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{1})[:\.\-](\d{1,2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{1})[:\.\-](\d{1,2})[:\.\-](\d{2}).*','00h0$1m$2s$3')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{1,2})[:\.\-](\d{2}).*','00h$1m$2s00')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(3),'[Ss]tart:? ?(\d{1})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(3),'[Ss]tart:? ?(\d{1})[:\.\-](\d{2}).*','00h0$1m$2s00')"/>
         </xsl:when>
        </xsl:choose>
       </xsl:if>
      </xsl:variable>
      <xsl:variable name="end">
       <xsl:if test="regex-group(4)">
        <xsl:choose>
         <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})[:\.\-](\d{2})','$1h$2m$3s$4')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})[:\.\-](\d{2}).*','00h$1m$2s$3')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{1})[:\.\-](\d{1,2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{1})[:\.](\d{1,2})[:\.](\d{2}).*','00h0$1m$2s$3')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{2})[:\.\-](\d{2}).*','00h$1m$2s00')"/>
         </xsl:when>
         <xsl:when test="matches(regex-group(4),'[Ss]top:? ?(\d{1})[:\.\-](\d{2})')">
          <xsl:value-of select="replace(regex-group(4),'[Ss]top:? ?(\d{1})[:\.\-](\d{2}).*','00h0$1m$2s00')"/>
         </xsl:when>
        </xsl:choose>
       </xsl:if>
      </xsl:variable>
      <xsl:variable name="trailer">
       <xsl:if test="matches(regex-group(3),'^#.+')">
        <xsl:value-of select="replace(regex-group(3),'#(.+)','$1')"/>
       </xsl:if>
       <xsl:if test="matches(regex-group(4),'^#.+')">
        <xsl:value-of select="replace(regex-group(5),'#(.+)','$1')"/>
       </xsl:if>
       <xsl:if test="matches(regex-group(5),'^#.+')">
        <xsl:value-of select="replace(regex-group(5),'#(.+)','$1')"/>
       </xsl:if>
      </xsl:variable>
      
      <xsl:element name="ref">
       <xsl:attribute name="target">
        <xsl:choose>
         <xsl:when test="$start != ''">
          <xsl:value-of select="concat('http://open-memory-box.de/roll/',$box,'-',$roll,'/',replace($start,'(\d+)h(\d+)m(\d+)s(\d+)','$1-$2-$3-$4'))"/>
         </xsl:when>
         <xsl:otherwise>
          <xsl:value-of select="concat('http://open-memory-box.de/roll/',$box,'-',$roll,'/00-00-00-00')"/>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:attribute>
       <xsl:value-of select="concat('(OMB Box ',$box,' Rolle ',$roll)"/>
       <xsl:if test="$trailer != ''">
        <xsl:value-of select="concat('; ',$trailer)"/>
       </xsl:if>
       <xsl:text>)</xsl:text>
      </xsl:element>      
      <figure place="margin" type="omb">
       <xsl:element name="head">
        <xsl:value-of select="concat('Sequenz aus OMB Box ',$box,' Rolle ', $roll)"/>
       </xsl:element>
       <xsl:element name="media">
        <xsl:attribute name="mimeType">video/mp4</xsl:attribute>
        <xsl:attribute name="url">
         <xsl:value-of select="concat('https://open-memory-box.de/stream/watermark/480/omb_', $box,'-', $roll,'_480_wm.mp4')"/>
        </xsl:attribute>
        <xsl:if test="$start != ''">
         <xsl:attribute name="start">
          <xsl:text>tc:</xsl:text>
          <xsl:value-of select="$start"/>
         </xsl:attribute>
        </xsl:if>
        <xsl:if test="$end != ''">
         <xsl:attribute name="end">
          <xsl:text>tc:</xsl:text>
          <xsl:value-of select="$end"/>
         </xsl:attribute>
        </xsl:if>        
       </xsl:element>
       <xsl:if test="$trailer != ''">
        <xsl:element name="trailer">
         <xsl:value-of select="$trailer"/>
        </xsl:element>
       </xsl:if>
      </figure>
     </xsl:matching-substring>
     <xsl:non-matching-substring>
      <xsl:copy-of select="."/>
     </xsl:non-matching-substring>
    </xsl:analyze-string>  
   </xsl:when>
   
   <xsl:otherwise>
    <xsl:apply-templates mode="pass2"/>
   </xsl:otherwise>
  </xsl:choose>
  
 </xsl:template>
 
 

 <!-- include Legend in table/grafik -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc> &lt;CAPTION&gt; belongs to nearest figure or table, Legend as well. Put Caption above, and
   Legend under figure or table</desc>
 </doc> 
 
 <xsl:template match="tei:table|tei:figure" mode="pass2">
  <xsl:copy>
   <xsl:apply-templates select="@*" mode="pass2"/>
   <xsl:if test="preceding-sibling::*[1][self::tei:p[@rend='Tabellenüberschrift' or @rend='tablehead']]">
    <xsl:element name="head">
     <xsl:apply-templates select="preceding-sibling::*[1][self::tei:p[@rend='Tabellenüberschrift' or @rend='tablehead']][1]" mode='pass2'/>
     <!--   <xsl:copy-of select="preceding-sibling::*[1][self::tei:p[@rend='Tabellenüberschrift' or @rend='tablehead'][1]/node()]"/> --> 
    </xsl:element>
   </xsl:if>
   <xsl:if test="preceding-sibling::*[1][self::tei:CAPTION]">
    <xsl:element name="head">
     <xsl:apply-templates select="preceding-sibling::*[1][self::tei:CAPTION]/*" mode="pass2"/>
    </xsl:element>   
   </xsl:if>
   <xsl:if test="following-sibling::*[1][self::tei:CAPTION]">
    <xsl:apply-templates select="following-sibling::*[1][self::tei:CAPTION]/*" mode="pass2"/>
   </xsl:if>
   <xsl:apply-templates mode="pass2"/>
   <xsl:if test="following-sibling::*[1][self::tei:CAPTION] and following-sibling::*[self::tei:trailer]">
    <xsl:copy-of select="following-sibling::*[2][self::tei:trailer[1]]"/>
   </xsl:if>
   <xsl:if test="following-sibling::*[1][self::tei:trailer]">
    <xsl:copy-of select="following-sibling::*[1][self::tei:trailer[1]]"/>
   </xsl:if>
  </xsl:copy>
 </xsl:template>

 <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
  <xd:desc>
   Suppress tei:CAPTION from textrun because it is fiddled into the tabel/figure element as head
  </xd:desc>
 </xd:doc>
 <xsl:template match="tei:CAPTION" mode="pass2"/>
 <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
  <xd:desc>
   Suppress tei:trailer from normal textblock because it is fiddled into table/figure element as head
  </xd:desc>
 </xd:doc>
 <xsl:template match="tei:div/tei:trailer" mode="pass2"/>
 

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



 <!-- and here's what we do in pass 3 -->

 
 <!-- fix other styles which should be TEI elements -->
 <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
  <desc>fix paragraph styles which should be TEI elements:</desc>
 </doc>
 
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
 
 <xsl:template match="tei:hi[@rend='doubleunderline']" mode="pass3">
  <foreign rend="gentium">
   <xsl:apply-templates mode="pass3"/>
  </foreign>
 </xsl:template>

 <xsl:template match="tei:hi[@rend='doubleunderwavyline' or @rend='underdottedline']" mode="pass3">
  <foreign rend="cjk">
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

<!-- create rend Attribut for head including numbering as appropriate -->
 <xsl:template match="tei:head[not(@rend)]" mode="pass3">
  <xsl:choose>
   <xsl:when test="ancestor::tei:figure or ancestor::tei:table">
    <xsl:element name="head">
     <xsl:attribute name="rend">
      <xsl:text>none</xsl:text>
     </xsl:attribute>
     <xsl:attribute name="xml:id">
      <xsl:text>fig</xsl:text>
      <xsl:number from="tei:body" count="tei:head[ancestor::tei:figure or ancestor::tei:table]" level="any"/>
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
     <xsl:attribute name="xml:id">
      <xsl:text>hd</xsl:text>
      <xsl:number from="tei:body" count="tei:head[ancestor::tei:div]" level="any"/>
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

<!-- kill notes and noteanchor in teiHeader -->
 <xsl:template match="tei:teiHeader//tei:note" mode="pass3" />
 
 <xsl:template match="tei:teiHeader//tei:hi[@rend='Fußnotenanker']" mode="pass3" />
 

 <!-- and copy everything else -->
 <xsl:template match="@*|comment()|processing-instruction()|text()" mode="pass3">
  <xsl:copy-of select="."/>
 </xsl:template>
 <xsl:template match="*" mode="pass3">
  <xsl:copy>
   <xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="pass3"/>
  </xsl:copy>
 </xsl:template>


</xsl:stylesheet>
