<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="tei teix" version="2.0">

   <!-- import base conversion style -->

   <xsl:import href="../../../html5/tei.xsl"/>
   <xsl:import href="../../../html5/microdata.xsl"/>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

         <p>This software is dual-licensed: 1. Distributed under a Creative Commons
            Attribution-ShareAlike 3.0 Unported License
            http://creativecommons.org/licenses/by-sa/3.0/ 2.
            http://www.opensource.org/licenses/BSD-2-Clause All rights reserved. Redistribution and
            use in source and binary forms, with or without modification, are permitted provided
            that the following conditions are met: * Redistributions of source code must retain the
            above copyright notice, this list of conditions and the following disclaimer. *
            Redistributions in binary form must reproduce the above copyright notice, this list of
            conditions and the following disclaimer in the documentation and/or other materials
            provided with the distribution. This software is provided by the copyright holders and
            contributors "as is" and any express or implied warranties, including, but not limited
            to, the implied warranties of merchantability and fitness for a particular purpose are
            disclaimed. In no event shall the copyright holder or contributors be liable for any
            direct, indirect, incidental, special, exemplary, or consequential damages (including,
            but not limited to, procurement of substitute goods or services; loss of use, data, or
            profits; or business interruption) however caused and on any theory of liability,
            whether in contract, strict liability, or tort (including negligence or otherwise)
            arising in any way out of the use of this software, even if advised of the possibility
            of such damage. </p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id: to.xsl 10466 2012-06-08 18:47:50Z rahtz $</p>
         <p>Copyright: 2008, TEI Consortium</p>
         <p>enhanced and customized for journal rg Rechtsgeschichte Legal History</p>
         <p>by Olaf Berg, Max Planck Institute for European Legal History</p>
         <p> Copyright enhancements: 2013, Olaf Berg and MPI for European Legal History</p>
      </desc>
   </doc>

   <!-- Parameter für Rg setzen -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>Link back from footnotes to reference</desc>
   </doc>
   <xsl:param name="footnoteBackLink">true</xsl:param>


   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="string">
      <desc> Style for formatted bibliography </desc>
   </doc>
   <xsl:param name="biblioStyle"/>


   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="numbering" type="string">
      <desc>How to construct heading numbering in main matter</desc>
   </doc>
   <xsl:param name="numberBodyHeadings">1.1.1.1</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="numbering" type="boolean">
      <desc>Automatically number sections</desc>
   </doc>
   <xsl:param name="numberHeadings">true</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="numbering" type="integer">
      <desc>Depth to which sections should be numbered</desc>
   </doc>
   <xsl:param name="numberHeadingsDepth">9</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="integer">
      <desc>
         <p>The difference between TEI div levels and HTML headings.</p>
         <p>TEI &lt;div&gt;s are implicitly or explicitly numbered from 0 upwards; this offset is
            added to that number to produce an HTML &lt;Hn&gt; element. So a value of 2 here means
            that a &lt;div1&gt; will generate an &lt;h2&gt;</p>
      </desc>
   </doc>
   <xsl:param name="divOffset">2</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="boolean">
      <desc>Include the back matter in the table of contents.</desc>
   </doc>
   <xsl:param name="tocBack">true</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="string">
      <desc>CSS class for TOC entries</desc>
   </doc>
   <xsl:param name="class_toc">toc</xsl:param>




   <!-- Hooks für Rg nutzen  -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="hook">
      <desc>[html] Hook where HTML can be inserted at the start of processing each section</desc>
   </doc>
   <xsl:template name="startDivHook"/>



   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Make a heading, if there some text to display<param name="text">Heading
            title</param>
         <param name="class">CSS class</param>
         <param name="level">Heading level</param>
      </desc>
   </doc>
   <xsl:template name="makeHTMLHeading">
      <xsl:param name="text"/>
      <xsl:param name="class">TESTtitle</xsl:param>
      <xsl:param name="level">1</xsl:param>
      <xsl:if test="not($text='')">
         <xsl:choose>
            <xsl:when test="$level &gt; 6">
               <div class="h{$level}">
                  <xsl:copy-of select="$text"/>
               </div>
            </xsl:when>
            <xsl:otherwise>
               <xsl:element name="h{$level}">
                  <xsl:attribute name="class">
                     <xsl:value-of select="$class"/>
                  </xsl:attribute>
                  <xsl:copy-of select="$text"/>
               </xsl:element>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
   </xsl:template>

   <!-- Templates aus Parameter file für Muster der Überschriftennummerierung -->

   <xsl:template name="numberBodyDiv">
      <xsl:if test="$numberHeadings='true'">
         <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
            format="I.1.A.a" level="multiple"/>
      </xsl:if>
   </xsl:template>
   
<!-- Include Yaml into head -->
   
   <xsl:template name="headHook">
      <meta http-equiv="content-type" content="application/xhtml+xml;charset=utf-8" />
      
      <title></title>
      <meta name="description"
         content="Rg Rechtsgeschichte Legal History - Zeitschrift für Rechtsgeschichte" />
      <meta name="author" content="olaf berg" />
      
      
      <!-- mobile viewport optimisation -->
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      

   </xsl:template>
   
   <xsl:template name="includeCSS">
      <!-- stylesheets -->
      <link rel="stylesheet" href="css/central.css" type="text/css" />
      
   </xsl:template>
   
   <xsl:template name="includeJavascript">
      <!--[if lt IE 9]>
<script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
<![endif]-->
      
      <!--[if lte IE 7]>
  <link rel="stylesheet" href="yaml/core/iehacks.min.css" type="text/css"/>
  <![endif]-->
      
   </xsl:template>


<!-- Rg20 Testbed Part 1 -->
   
   <xsl:template name="bodyHook">
      <header>
         <div class="ym-wrapper">
            <div class="ym-wbox">
               <h1 class="kopfzeile">Rg - <b>Rechtsgeschichte</b> Legal History</h1>
            </div>
         </div>
      </header>
      <nav class="ym-hlist">
         <div class="ym-wrapper">
            <div class="ym-wbox"> 
               <ul>
                  <li>Heft Nr.:</li>
                  <li class="rainbow" id="rainbow1"><a href="#">01</a></li>
                  <li class="rainbow" id="rainbow2"><a href="#">02</a></li>
                  <li class="rainbow" id="rainbow3"><a href="#">03</a></li>
                  <li class="rainbow" id="rainbow4"><a href="#">04</a></li>
                  <li class="rainbow" id="rainbow5"><a href="#">05</a></li>
                  <li class="rainbow" id="rainbow6"><a href="#">06</a></li>
                  <li class="rainbow" id="rainbow7"><a href="#">07</a></li>
                  <li class="rainbow" id="rainbow8"><a href="#">08</a></li>
                  <li class="rainbow" id="rainbow9"><a href="#">09</a></li>
                  <li class="rainbow" id="rainbow10"><a href="#">10</a></li>
                  <li class="rainbow" id="rainbow11"><a href="#">11</a></li>
                  <li class="rainbow" id="rainbow12"><a href="#">12</a></li>
                  <li class="rainbow" id="rainbow13"><a href="#">13</a></li>
                  <li class="rainbow" id="rainbow14"><a href="#">14</a></li>
                  <li class="rainbow" id="rainbow15"><a href="#">15</a></li>
                  <li class="rainbow" id="rainbow16"><a href="#">16</a></li>
                  <li class="rainbow" id="rainbow17"><a href="#">17</a></li>
                  <li class="rainbow" id="rainbow18"><a href="#">18</a></li>
                  <li class="rainbow" id="rainbow19"><a href="#">19</a></li>
                  <li class="rainbow" id="rainbow20"><a href="#">20</a></li>
               </ul>
               <ul class="mpi-navi">
                  <li><a href="#">Start</a></li>
                  <li><a href="#">Impressum</a></li>
                  <li><a href="#">MPIeR</a></li>							
               </ul>
            </div>
         </div> 
      </nav>                     
   </xsl:template>
   
   <!-- Rg Testbed Part 2 Contents of Issue in left column -->
   
   <xsl:template name="startHook">
      <div class="ym-col1">
         <div class="ym-cbox">
            <form class="ym-form">
               <div class="ym-grid">
                  <div class="ym-g50 ym-gl">
                     <div class="ym-gbox ym-fbox-button">
                        <a class="ym-button ym-next" href="#">Autor/in</a>
                        <a class="ym-button ym-next" href="#">Titel</a>
                     </div>
                  </div>
                  <div class="ym-g50 ym-gl">
                     <div class="ym-gbox ym-fbox-text .ym-full">
                        <div class="ym-gbox ym-fbox-text">
                           <input class="ym-searchfield" type="search" placeholder="Suche..." />
                           <input class="ym-searchbutton" type="submit" value="Suchen" />
                        </div>
                     </div>
                  </div>
               </div>
            </form>
            <section class="info box">
               <p> Blättern nach </p>
               <a class="ym-button ym-next" href="#">Autor/in</a>
               <a class="ym-button ym-next" href="#">Titel</a>
            </section>
            <section class="info box">
               <form class="ym-searchform">
                  <input class="ym-searchfield .ym-inline" type="search" placeholder="Suche..." />
                  <input class="ym-searchbutton .ym-inline" type="submit" value="Jetzt suchen" />
               </form>
            </section>
            <section class="issue-content">
               <h2>Inhalt Rg 20</h2>
               <div class="jquery_tabs">
                  <h4>Recherche</h4>
                  <div class="tabbody">
                     <div class="contentblock">
                        <p class="author"> Thomas Duve </p>
                        <p class="titel"> Von der Europäischen Rechtsgeschichte zu einer Rechtsgeschichte Europas in globalhistorischer Perspektive</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Michael Stolleis  </p>
                        <p class="titel"> Transfer normativer Ordnungen - Baumaterial für junge Nationalstaaten. Forschungsbericht über ein Südosteuropa-Projekt </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Georg Rodrigo Bandeira Galindo </p>
                        <p class="titel"> Force Field: On History and Theory of International Law </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Jakob Fortunat Stagl </p>
                        <p class="titel"> The Rule of Law against the Rule of Greed: Edmund Burke against the East India Company </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Michael Sievernich </p>
                        <p class="titel"> Recht und Mission in der frühen Neuzeit. Normative Texte im kirchlichen Leben der Neuen Welt</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Christoph H. F. Meyer  </p>
                        <p class="titel"> <i>Probati auctores.</i> Ursprünge und Funktionen einer wenig beachteten Quelle kanonistischer Tradition und Argumentation</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> José Daniel Cesano </p>
                        <p class="titel">Redes intelectuales y recepción en la cultura jurídico penal de Córdoba (1900-1950) </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Rafael Mrowczynski </p>
                        <p class="titel"> Self-Regulation of Legal Professions in State-Socialism. Poland and Russia Compared </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                  </div>
                  <h4>Fokus</h4>
                  <div class="tabbody">
                     <div class="contentblock">
                        <p class="author"> Alessandro Somma  </p>
                        <p class="titel"> Tradizione giuridica occidentale e modernizzazione lationamericana. Petrolio, democrazia e capitalismo nell'esperienza venezuelana </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Luis M. Lloredo Alix </p>
                        <p class="titel"> Rafael Altamira y Adolfo Posada: Dos
                           aportaciones a la socialización del derecho y su
                           projección en Latinoamérica</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Enrique Brahm García </p>
                        <p class="titel"> Algunos aspectos del proceso de
                           socialización del derecho de propiedad en Chile durante
                           el gobierno del General Carlos Ibañez del Campo
                           (1927-1931)</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Thorsten keiser </p>
                        <p class="titel"> Social conceptions of Property and Labor - Private Law in the aftermath of the Mexican Revolution and European Legal Science</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Mario G. Losano  </p>
                        <p class="titel"> Un modello italiano per l'economia nel Brasile di Getúlio Vargas: la "Carta del Lavoro" del 1927 </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> María Rosario Polotto </p>
                        <p class="titel"> Argumentación jurídica y trasfondo ideológico. Análisis del debate legislativo sobre prórroga de alquileres en Argentina a principios del siglo XX </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                  </div>
                  <h4>Forum</h4>
                  <div class="tabbody">
                     <div class="contentblock">
                        <p class="author"> Benedetta Albani </p>
                        <p class="titel"> Invitation to debate</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Carlo Fantappiè </p>
                        <p class="titel"> La Santa Sede e il Mondo in prospettiva storico-giuridica </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <p> test topic debatte a... </p>
                  </div>
                  <h4>Kritik</h4>
                  <div class="tabbody">
                     <div class="contentblock">
                        <p class="author"> Manlio Bellomo </p>
                        <p class="titel">Much Ado About Nothing. <br/> Uwe Wesel, Geschichte des Rechts in Europa</p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author"> Mario G. Losano </p>
                        <p class="titel"> La circolazione mondiale delle norme giuridiche. <br/> Jean-Louis Halpérin, Profils des modialisations du droit </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <p> test kritik a... </p>
                  </div>
                  <h4>Marginalien</h4>
                  <div class="tabbody">
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <div class="contentblock">
                        <p class="author">  </p>
                        <p class="titel"> </p>
                        <p class="format"> html | pdf | ebook</p>
                     </div>
                     <p> test marginalien a... </p>
                  </div>
               </div>
            </section>
         </div>
      </div>
   </xsl:template>
   
   <!-- Rg Testbed Part 3 -->
   
   <xsl:template match="tei:TEI">
      <xsl:call-template name="teiStartHook"/>
      <xsl:if test="$verbose='true'">
         <xsl:message>TEI HTML creation in single document mode </xsl:message>
      </xsl:if>
      <html>
         <xsl:call-template name="addLangAtt"/>
         <head>
            <xsl:variable name="pagetitle">
               <xsl:call-template name="generateTitle"/>
            </xsl:variable>
            <title>
               <xsl:value-of select="$pagetitle"/>
            </title>
            <xsl:call-template name="headHook"/>
            <xsl:call-template name="metaHTML">
               <xsl:with-param name="title" select="$pagetitle"/>
            </xsl:call-template>
            <xsl:call-template name="includeCSS"/>
            <xsl:call-template name="cssHook"/>
            <xsl:call-template name="includeJavascript"/>
            <xsl:call-template name="javascriptHook"/>
         </head>
         <body class="simple" id="TOP">
            <xsl:call-template name="bodyMicroData"/>
            <xsl:call-template name="bodyJavascriptHook"/>
            <xsl:call-template name="bodyHook"/>
            <xsl:if test="not(tei:text/tei:front/tei:titlePage)">
               <div class="stdheader">
                  <xsl:call-template name="stdheader">
                     <xsl:with-param name="title">
                        <xsl:call-template name="generateTitle"/>
                     </xsl:with-param>
                  </xsl:call-template>
               </div>
            </xsl:if>
            
            <!-- Insert here Yaml Grid Code for main column -->
            <div id="main">
               <div class="ym-column">
                  
            <xsl:call-template name="startHook"/>
            
            <!-- Insert here Yaml Grid Code to wrap simple Body -->
                  <div class="ym-col3">
                     <div class="ym-cbox"> 
                        <section class="ym-grid">
                           
                           <div class="ym-g62 ym-gl">
                              <div class="ym-gbox">
                                 <h1>Titel des Artikels (aus Django Datenbank)</h1>
                                 <h2>Autor des Artikels (aus Django Datenbank)</h2>
                                 <p>Abstract (aus Django Datenbank)</p>
                              </div>
                           </div>
                           <div class="ym-g38 ym-gr">
                              <div class="ym-gbox"> </div>
                           </div>	
                           
            <xsl:call-template name="simpleBody"/>
                        </section>
                     </div>
                  </div>
               </div>
            </div>
            <xsl:call-template name="stdfooter"/>
            <xsl:call-template name="bodyEndHook"/>
         </body>
      </html>
      <xsl:if test="$verbose='true'">
         <xsl:message>TEI HTML: run end hook template teiEndHook</xsl:message>
      </xsl:if>
      <xsl:call-template name="teiEndHook"/>
   </xsl:template>
   


   <!-- Elemente in front (Abstract, Titel) ignorieren, da das aus der Django-Datenbank generiert wird -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>ignore the content of elements in front </desc>
   </doc>
   <xsl:template match="//tei:front"/>

   <!-- Keinen Footer generieren - no footer needed 
   
   <xsl:template name="stdfooter"/> -->
   
   <!-- Yaml Footer generieren -->

   <xsl:template name="stdfooter">
      <footer>
         <div class="ym-wrapper">
            <div class="ym-wbox"> Impressum | Max Planck Institut für Europäische
               Rechtsgeschichte | MPG </div>
         </div>
      </footer>
      
   </xsl:template>

<!-- Yaml Scripte am Ende von body einbinden -->
   
   <xsl:template name="bodyEndHook">
      <script src="lib/jquery-1.7.1.min.js" type="text/javascript"> </script>
      <script src="yaml/add-ons/accessible-tabs/jquery.tabs.js" type="text/javascript"> </script>
      <script type="text/javascript">  
         $(document).ready(function(){
         $('.jquery_tabs').accessibleTabs();
         });
      </script>
      
   </xsl:template>


   <!-- Yaml Gerüst um Inhaltsverzeichnis bauen  -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] [textstructure] build a simple page - modified to integrate yaml</desc>
   </doc>

   <xsl:template name="simpleBody">
      <xsl:choose>
         <!-- This options are not used -->
         <xsl:when test="tei:text/tei:group">
            <xsl:apply-templates select="tei:text/tei:group"/>
         </xsl:when>
         <xsl:when test="$filePerPage='true'"/>
         
         <!-- here starts the relevant part -->
         <xsl:otherwise>
            <!-- front matter -->
            <xsl:apply-templates select="tei:text/tei:front"/>
            <xsl:if
               test="$autoToc='true' and (descendant::tei:div or descendant::tei:div1) and not(descendant::tei:divGen[@type='toc'])">

               <!-- Hier wird das YAML Grid um das Inhaltsverzeichnis eingefügt - wraping the TOC with YAML Grid code -->
               <div class="ym-g62 ym-gl">
                  <div class="ym-gbox">

                     <h2>
                        <xsl:call-template name="i18n">
                           <xsl:with-param name="word">tocWords</xsl:with-param>
                        </xsl:call-template>
                     </h2>
                     <xsl:call-template name="mainTOC"/>

                  </div>
               </div>
               <div class="ym-g38 ym-gr">
                  <div class="ym-gbox"> </div>
               </div>

            </xsl:if>
            <!-- main text -->
            <xsl:apply-templates select="tei:text/tei:body"/>
         </xsl:otherwise>
      </xsl:choose>
      <!-- back matter -->
      <xsl:apply-templates select="tei:text/tei:back"/>
      <xsl:call-template name="printNotes"/>
   </xsl:template>



   <!-- Yaml Gerüst um Head bauen -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] doing the contents of a div - insert YAML Grid in Head </desc>
   </doc>

   <xsl:template name="divContents">
      <xsl:param name="Depth"/>
      <xsl:param name="nav">false</xsl:param>
      <xsl:variable name="ident">
         <xsl:apply-templates mode="ident" select="."/>
      </xsl:variable>

      <xsl:choose>
         <xsl:when test="parent::tei:*/@rend='multicol'">
            <td style="vertical-align:top;">
               <xsl:if test="not($Depth = '')">
                  <xsl:element name="h{$Depth + $divOffset}">
                     <xsl:for-each select="tei:head[1]">
                        <xsl:call-template name="makeRendition">
                           <xsl:with-param name="default">false</xsl:with-param>
                        </xsl:call-template>
                     </xsl:for-each>
                     <xsl:if test="@xml:id">
                        <xsl:call-template name="makeAnchor">
                           <xsl:with-param name="name">
                              <xsl:value-of select="@xml:id"/>
                           </xsl:with-param>
                        </xsl:call-template>
                     </xsl:if>
                     <xsl:call-template name="header">
                        <xsl:with-param name="display">full</xsl:with-param>
                     </xsl:call-template>
                     <xsl:call-template name="sectionHeadHook"/>
                  </xsl:element>
               </xsl:if>
               <xsl:apply-templates/>
            </td>
         </xsl:when>
         <xsl:when test="@rend='multicol'">
            <xsl:apply-templates select="*[not(local-name(.)='div')]"/>
            <table>
               <tr>
                  <xsl:apply-templates select="tei:div"/>
               </tr>
            </table>
         </xsl:when>
         <xsl:when test="@rend='nohead'">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="not($Depth = '')">
               <xsl:variable name="Heading">
                  <xsl:element
                     name="{if (number($Depth)+$divOffset &gt;6) then 'div'
                     else concat('h',number($Depth) +
                     $divOffset)}">
                     <xsl:choose>
                        <xsl:when test="@rend">
                           <xsl:call-template name="makeRendition"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:for-each select="tei:head[1]">
                              <xsl:call-template name="makeRendition">
                                 <xsl:with-param name="default">
                                    <xsl:choose>
                                       <xsl:when test="number($Depth)&gt;5">
                                          <xsl:text>div</xsl:text>
                                          <xsl:value-of select="$Depth"/>
                                       </xsl:when>
                                       <xsl:otherwise>false</xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:for-each>
                        </xsl:otherwise>
                     </xsl:choose>
                     <xsl:call-template name="header">
                        <xsl:with-param name="display">full</xsl:with-param>
                     </xsl:call-template>
                     <xsl:call-template name="sectionHeadHook"/>
                  </xsl:element>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$outputTarget='html5'">
                     <header>
                        <!-- Hier wird das YAML Grid eingefügt Achtung: So nicht geeignet für Fußnotenmarginalspalte in Überschrift -->
                        <div class="ym-g62 ym-gl">
                           <div class="ym-gbox">
                              <xsl:copy-of select="$Heading"/>
                           </div>
                        </div>
                        <div class="ym-g38 ym-gr">
                           <div class="ym-gbox"> </div>
                        </div>
                     </header>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:copy-of select="$Heading"/>
                  </xsl:otherwise>
               </xsl:choose>

               <xsl:if test="$topNavigationPanel='true' and
                  $nav='true'">
                  <xsl:element
                     name="{if ($outputTarget='html5') then 'nav'
                     else 'div'}">
                     <xsl:call-template name="xrefpanel">
                        <xsl:with-param name="homepage" select="concat($masterFile,$standardSuffix)"/>
                        <xsl:with-param name="mode" select="local-name(.)"/>
                     </xsl:call-template>
                  </xsl:element>
               </xsl:if>
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="$bottomNavigationPanel='true' and
               $nav='true'">
               <xsl:element
                  name="{if ($outputTarget='html5') then 'nav' else
                  'div'}">
                  <xsl:call-template name="xrefpanel">
                     <xsl:with-param name="homepage" select="concat($masterFile,$standardSuffix)"/>
                     <xsl:with-param name="mode" select="local-name(.)"/>
                  </xsl:call-template>
               </xsl:element>
            </xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>




   <!-- Fußnoten als Endnoten und in Marginalspalte -->

   <!-- Fußnoten für Marginalspalte pro Absatz sammeln -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element p</desc>
   </doc>
   <xsl:template match="tei:p">
      <xsl:variable name="wrapperElement" select="tei:is-DivOrP(.)"/>
      <!-- gerüst um Absatz linke Spalte -->
      <div class="ym-g62 ym-gl">
         <div class="ym-gbox">
            <!-- ab hier TEI xsl wie gehabt -->
            <xsl:choose>
               <xsl:when test="$filePerPage='true'">
                  <xsl:for-each-group select="node()" group-starting-with="tei:pb">
                     <xsl:choose>
                        <xsl:when test="self::tei:pb">
                           <xsl:apply-templates select="."/>
                           <xsl:element name="{$wrapperElement}">
                              <xsl:for-each select="..">
                                 <xsl:call-template name="makeRendition">
                                    <xsl:with-param name="default">false</xsl:with-param>
                                 </xsl:call-template>
                                 <xsl:attribute name="id">
                                    <xsl:choose>
                                       <xsl:when test="@xml:id">
                                          <xsl:value-of select="@xml:id"/>
                                          <xsl:text>continued</xsl:text>
                                       </xsl:when>
                                       <xsl:otherwise>
                                          <xsl:text>false</xsl:text>
                                       </xsl:otherwise>
                                    </xsl:choose>
                                 </xsl:attribute>
                              </xsl:for-each>
                              <xsl:apply-templates select="current-group() except ."/>
                           </xsl:element>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:element name="{$wrapperElement}">
                              <xsl:for-each select="..">
                                 <xsl:call-template name="makeRendition">
                                    <xsl:with-param name="default">false</xsl:with-param>
                                 </xsl:call-template>
                              </xsl:for-each>
                              <xsl:apply-templates select="current-group()"/>
                           </xsl:element>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each-group>
               </xsl:when>
               <xsl:when test="$generateDivFromP='true' or teix:egXML">
                  <div>
                     <xsl:call-template name="makeRendition">
                        <xsl:with-param name="default">p</xsl:with-param>
                     </xsl:call-template>
                     <xsl:choose>
                        <xsl:when test="@xml:id">
                           <xsl:call-template name="makeAnchor">
                              <xsl:with-param name="name">
                                 <xsl:value-of select="@xml:id"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="$generateParagraphIDs='true'">
                           <xsl:call-template name="makeAnchor">
                              <xsl:with-param name="name">
                                 <xsl:value-of select="generate-id()"/>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:when>
                     </xsl:choose>
                     <xsl:if test="$numberParagraphs='true'">
                        <xsl:call-template name="numberParagraph"/>
                     </xsl:if>
                     <xsl:apply-templates/>
                  </div>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="CLASS">
                     <freddy>
                        <xsl:call-template name="makeRendition">
                           <xsl:with-param name="default">false</xsl:with-param>
                        </xsl:call-template>
                     </freddy>
                  </xsl:variable>
                  <xsl:variable name="ID">
                     <freddy>
                        <xsl:choose>
                           <xsl:when test="@xml:id">
                              <xsl:call-template name="makeAnchor">
                                 <xsl:with-param name="name">
                                    <xsl:value-of select="@xml:id"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:when>
                           <xsl:when test="$generateParagraphIDs='true'">
                              <xsl:call-template name="makeAnchor">
                                 <xsl:with-param name="name">
                                    <xsl:value-of select="generate-id()"/>
                                 </xsl:with-param>
                              </xsl:call-template>
                           </xsl:when>
                        </xsl:choose>
                     </freddy>
                  </xsl:variable>
                  <xsl:variable name="pContent">
                     <xsl:if test="$numberParagraphs='true'">
                        <xsl:call-template name="numberParagraph"/>
                     </xsl:if>
                     <xsl:apply-templates/>
                  </xsl:variable>
                  <xsl:for-each-group select="$pContent/node()"
                     group-adjacent="if (self::html:ol or
               self::html:ul or
               self::html:dl or
               self::html:pre or
               self::html:figure or
               self::html:blockquote or
               self::html:div) then 1
               else 2">
                     <xsl:choose>
                        <xsl:when test="current-grouping-key()=1">
                           <xsl:copy-of select="current-group()"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <p>
                              <xsl:copy-of select="$CLASS/html:freddy/@*"/>
                              <xsl:if test="position()=1">
                                 <xsl:copy-of select="$ID/html:freddy/@*"/>
                              </xsl:if>
                              <xsl:copy-of select="current-group()"/>
                           </p>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each-group>
               </xsl:otherwise>
            </xsl:choose>
            <!-- gerüst um Absatz linke Spalte -->
         </div>
      </div>
      <!-- ab hier werden die Fußnoten für die Marginalspalte je Absatz gesammelt -->
      <div class="ym-g38 ym-gr">
         <div class="ym-gbox">
            <xsl:if test=".//tei:note">
               <xsl:choose>
                  <xsl:when test="parent::tei:note"/>
                  <xsl:otherwise>

                     <xsl:element name="div">
                        <!--test
                        <div class="margnote" >
                           <p>
                              <xsl:text>Neues Element für Absatzsammlung</xsl:text>
                           </p>
                        </div>
-->
                        <xsl:apply-templates select="tei:note" mode="footandmargin"/>
                     </xsl:element>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </div>
      </div>
   </xsl:template>


   <!-- dieses Template soll die Fußnoten nochmal in die Marginalspalte doppeln -->

   <xsl:template name="footandmargin">
      <xsl:param name="identifier"/>
      <div class="margnote">
         <xsl:call-template name="makeAnchor">
            <xsl:with-param name="name" select="concat($identifier,'_margin')"/>
         </xsl:call-template>
         <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
            <xsl:call-template name="noteN"/>
         </xsl:element>
         <xsl:if test="following-sibling::node()[1][self::tei:note]">
            <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
               <xsl:text>,</xsl:text>
            </xsl:element>
         </xsl:if>
         <xsl:variable name="note-text">
            <xsl:apply-templates mode="plain"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="string-length($note-text) &gt; 200">
               <xsl:value-of select="substring($note-text,1,200)"/>
               <a class="notelink" title="more... go to endnote" href="#{$identifier}">
                  <xsl:text>… [more]</xsl:text>
               </a>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates/>
            </xsl:otherwise>
         </xsl:choose>
      </div>
   </xsl:template>

   <xsl:template match="tei:note" mode="footandmargin">
      <xsl:variable name="identifier">
         <xsl:call-template name="noteID"/>
      </xsl:variable>
      <div class="margnote">
         <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
            <xsl:call-template name="noteN"/>
         </xsl:element>
         <xsl:if test="following-sibling::node()[1][self::tei:note]">
            <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
               <xsl:text>,</xsl:text>
            </xsl:element>
         </xsl:if>
         <xsl:variable name="note-text">
            <xsl:apply-templates mode="plain"/>
         </xsl:variable>
         <xsl:choose>
            <xsl:when test="string-length($note-text) &gt; 200">
               <xsl:value-of select="substring($note-text,1,200)"/>
               <a class="notelink" title="more... go to endnote" href="#{$identifier}">
                  <xsl:text>… [more]</xsl:text>
               </a>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates/>
            </xsl:otherwise>
         </xsl:choose>
      </div>
   </xsl:template>

   <!-- Zu Endnoten gewordene Fussnoten mit YAML Grid versehen -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="printNotes">
      <xsl:if test="count(key('NOTES',1)) or ($autoEndNotes='true' and count(key('ALLNOTES',1)))">
         <xsl:choose>
            <xsl:when test="$footnoteFile='true'">
               <!-- Entfällt, da für Rg nicht relevant -->
            </xsl:when>
            <xsl:otherwise>

               <xsl:variable name="me">
                  <xsl:apply-templates select="." mode="ident"/>
               </xsl:variable>
               <xsl:variable name="NOTES">
                  <xsl:choose>
                     <xsl:when test="self::tei:TEI">
                        <xsl:choose>
                           <xsl:when test="$autoEndNotes='true'">
                              <xsl:apply-templates mode="printallnotes" select="key('ALLNOTES',1)"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates mode="printallnotes" select="key('NOTES',1)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:when>
                     <xsl:when test="parent::tei:group and tei:group"> </xsl:when>
                     <xsl:otherwise>
                        <xsl:apply-templates mode="printnotes" select=".//tei:note">
                           <xsl:with-param name="whence" select="$me"/>
                        </xsl:apply-templates>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:variable>
               <xsl:for-each select="$NOTES">
                  <xsl:if test="html:div">
                     <div class="ym-g62 ym-gl">
                        <div class="ym-gbox">

                           <div class="notes">
                              <div class="noteHeading">
                                 <xsl:call-template name="i18n">
                                    <xsl:with-param name="word">noteHeading</xsl:with-param>
                                 </xsl:call-template>
                              </div>
                              <xsl:copy-of select="*"/>
                           </div>
                        </div>
                     </div>
                     <div class="ym-g38 ym-gr">
                        <div class="ym-gbox"/>
                     </div>

                  </xsl:if>
               </xsl:for-each>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
      <xsl:if test="ancestor-or-self::tei:TEI/tei:text/descendant::tei:app">
         <div class="notes">
            <div class="noteHeading">
               <xsl:call-template name="i18n">
                  <xsl:with-param name="word">noteHeading</xsl:with-param>
               </xsl:call-template>
            </div>
            <xsl:apply-templates mode="printnotes" select="descendant::tei:app"/>
         </div>
      </xsl:if>
   </xsl:template>

   <!-- Bibliographie mit YAML Grid und ohne nummern (ul statt ol) sonderangabe nfür mla style raus -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element listBibl</desc>
   </doc>
   <xsl:template match="tei:listBibl">
      <xsl:choose>
         <xsl:when test="tei:biblStruct">
            <ul class="listBibl">
               <xsl:for-each select="tei:biblStruct">
                  <xsl:sort
                     select="lower-case((tei:*/tei:author/tei:surname|tei:*[1]/tei:author/tei:orgName|tei:*[1]/tei:author/tei:name|tei:*[1]/tei:author|tei:*[1]/tei:editor/tei:surname|tei:*[1]/tei:editor/tei:name|tei:*[1]/tei:editor|tei:*[1]/tei:title[1])[1])"/>
                  <xsl:sort select="tei:monogr/tei:imprint/tei:date"/>
                  <li>
                     <xsl:call-template name="makeAnchor"/>
                     <xsl:apply-templates select="."/>
                  </li>
               </xsl:for-each>
            </ul>
         </xsl:when>
         <xsl:otherwise>
            <div class="ym-g62 ym-gl">
               <div class="ym-gbox">
                  <ul class="listBibl">
                     <xsl:for-each select="tei:bibl|tei:biblItem">
                        <li>
                           <xsl:call-template name="makeAnchor">
                              <xsl:with-param name="name">
                                 <xsl:apply-templates mode="ident" select="."/>
                              </xsl:with-param>
                           </xsl:call-template>
                           <xsl:apply-templates select="."/>
                        </li>
                     </xsl:for-each>
                  </ul>
               </div>
            </div>
            <div class="ym-g38 ym-gr">
               <div class="ym-gbox"/>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


</xsl:stylesheet>
