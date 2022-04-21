<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns="http://www.w3.org/1999/xhtml"
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teix="http://www.tei-c.org/ns/Examples"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   exclude-result-prefixes="tei teix html xs"
   version="2.0">
   
   <!-- import base conversion style -->

  <!--    <xsl:import href="../../../xhtml2/tei.xsl"/> -->
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

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>Number footnotes consecutively</desc>
   </doc>
   <xsl:param name="consecutiveFNs">true</xsl:param>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>[Rg] Max length of footnotes in margin column</desc>
   </doc>
   <xsl:param name="maxLengthFnMargin">250</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="string">
      <desc> Style for formatted bibliography </desc>
   </doc>
   <xsl:param name="biblioStyle"/>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings" type="boolean">
      <desc>Construct a heading 
         for &lt;div&gt; elements with no &lt;head&gt;</desc>
   </doc>
   <xsl:param name="autoHead">false</xsl:param> 
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="numbering" type="string">
      <desc>How to construct heading numbering in main matter</desc>
   </doc>
   <xsl:param name="numberBodyHeadings">1.1.1.1</xsl:param> <!-- scheint wirkungslos im aktuellen tei-xslt -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings" type="string">
      <desc>Character to put after number of
         section header</desc>
   </doc>
   <xsl:param name="numberSpacer">
      <xsl:text> </xsl:text>
   </xsl:param>
   
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
      <desc>Make an automatic table of contents</desc>
   </doc>
   <xsl:param name="autoToc">false</xsl:param>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="toc" type="boolean">
      <desc>Include the back matter in the table of contents.</desc>
   </doc>
   <xsl:param name="tocBack">true</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="CSS" type="string">
      <desc>CSS class for TOC entries</desc>
   </doc>
   <xsl:param name="class_toc">toc</xsl:param>

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="style" type="string">
      <desc>Display of &lt;pb&gt; element.
         Choices are "visible", "active" and "none". 
         New Choice for Rg is "attribute". This will mark the pagebrake with a vertical line 
         and bring the pagenumber before and after the pb as attribute into the tooltip </desc>
   </doc>
   <xsl:param name="pagebreakStyle">attribute</xsl:param>
   
   
   


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
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[parameters][Rg] different numbering depending on @rend attribute in head Element (arabic = "1.1.1.1" roman = "I. 1. A. a)" none, symbol = no numbering)</desc>
   </doc>
   
   <xsl:template name="numberBodyDiv">
      <xsl:if test="$numberHeadings='true'">
         <xsl:choose>
            <xsl:when test="tei:head[@rend='arabic']">
               <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
                  format="1.1.1.1" level="multiple"/>
            </xsl:when>
            <xsl:when test="tei:head[@rend='roman']">
               <xsl:choose>
                  <xsl:when test="parent::tei:body">
                     <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
                        format="I." level="single"/>
                  </xsl:when>
                  <xsl:when test="parent::node()=//tei:body/(tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6)">
                     <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
                        format="1." level="single"/>
                  </xsl:when>
                  <xsl:when test="parent::node()=//tei:body/(tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6)/(tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6)">
                     <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
                        format="A." level="single"/>
                  </xsl:when>
                  <xsl:when test="parent::node()=//tei:body/(tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6)/(tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6)/(tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6)">
                     <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
                        format="a)" level="single"/>
                  </xsl:when>
               </xsl:choose>  
            </xsl:when>
            <xsl:when test="tei:head[@rend='none']"/>
            <xsl:when test="tei:head[@rend='symbol']"/>
         </xsl:choose>
      </xsl:if>
   </xsl:template>
   

   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings" type="string">
      <desc>Punctuation to insert after a section number</desc>
   </doc>
   <xsl:template name="headingNumberSuffix">
      <xsl:choose>
         <xsl:when test="tei:head[@rend='none']">
            <xsl:text></xsl:text>
            <xsl:value-of select="$numberSpacer"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$numberSpacer"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   



   <!-- Abstract in front ignorieren, da das aus der Django-Datenbank generiert wird -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[Rg] ignore the content of abstracts and information on reviewed book in front </desc>
   </doc>
   <xsl:template match="//tei:front/tei:div[@type='abstract']"/>
   <xsl:template match="//tei:front/tei:div[@type='review']"/>
   
   <!-- Den Titel und Untertitel  aus dem front Teil nutzen -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[Rg] Use the Title elements in front. Build Yaml-Grid around it and put Footnotes into Margin and to Endnotes </desc>
   </doc>
   <xsl:template match="//tei:titlePage/tei:docTitle/tei:titlePart">
      <div class="ym-g62 ym-gl">
         <div class="ym-gbox">
            <xsl:choose>
               <xsl:when test="@type='main'">
                  <h2><xsl:apply-templates/></h2>
         </xsl:when>
         <xsl:when test="@type='sub' or 'sup'">
                   <p><b><xsl:apply-templates/></b></p>
         </xsl:when>
               <xsl:otherwise>
                  <p><b>NOT SPECIFIED titlePart</b></p>
                  <p><b><xsl:apply-templates/></b></p>
               </xsl:otherwise>
      </xsl:choose>
      </div>
      </div>
      <div class="ym-g38 ym-gr">
         <div class="ym-gbox">
            <xsl:if test=".//tei:note">
               <xsl:choose>
                  <xsl:when test="parent::tei:note"/>
                  <xsl:otherwise>
                     <xsl:element name="div">
                        <xsl:apply-templates select="tei:note" mode="footandmargin"/>
                     </xsl:element>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:if>
         </div>
      </div>
   </xsl:template>

   <!-- Keinen Footer generieren - no footer needed -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] no footer needed for Rg</desc>
   </doc>
   <xsl:template name="stdfooter"/> 
   



   <!-- Yaml Gerüst um Inhaltsverzeichnis bauen  Build Yaml around TOC -->

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
   

   <!-- Dafür sorgen, dass head in Bibliographie nicht übersehen wird und keines für Epigraph in front generiert wird (mal sehen, ob es klappt) -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="headings"> 
      <desc>[common] How to make a heading for section if there is no
         &lt;head&gt;</desc>
   </doc>
   <xsl:template name="autoMakeHead">
      <xsl:param name="display"/>
      <xsl:choose>
         <xsl:when test="tei:head and $display='full'">
            <xsl:apply-templates select="tei:head" mode="makeheading"/>
         </xsl:when>
         <xsl:when test="tei:head and $display='simple'">
            <xsl:apply-templates select="tei:head" mode="makeheading"/>
         </xsl:when>
         <xsl:when test="tei:head">
            <xsl:apply-templates select="tei:head" mode="plain"/>
         </xsl:when>
         <xsl:when test="tei:front/tei:head">
            <xsl:apply-templates select="tei:front/tei:head" mode="plain"/>
         </xsl:when>
         
         <xsl:when test="@n">
            <xsl:value-of select="@n"/>
         </xsl:when>
         <xsl:when test="@type">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="@type"/>
            <xsl:text>]</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>➤</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template> 

   <!-- head Element in listBibl mit h2 hervorheben -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[html] [core] Process element head</p>
         <p xmlns="http://www.w3.org/1999/xhtml"> headings etc </p>
      </desc>
   </doc>
   <xsl:template match="tei:head">
      <xsl:variable name="parent" select="local-name(..)"/>
      <xsl:choose>
         <xsl:when test="parent::tei:group or parent::tei:body or parent::tei:front or parent::tei:back">
            <h1>
               <xsl:apply-templates/>
            </h1>
         </xsl:when>
         <xsl:when test="parent::tei:listBibl">
            <h2 class="bibliography">
               <xsl:apply-templates/>
            </h2>
         </xsl:when>
         <xsl:when test="parent::tei:argument">
            <div>
               <xsl:call-template name="makeRendition">
                  <xsl:with-param name="default">false</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="not(starts-with($parent,'div'))">
            <xsl:apply-templates/>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   

   <!-- Yaml Gerüst um Überschriften bauen - build Yaml around headings -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc><p>[html] [textstructure] doing the contents of a div </p>
         <p>modification for Rg: insert YAML Grid in Head,</p>
         <p>no &lt;header&gt; Element around head, because it interfere with yaml &lt;header&gt; Element for page header </p>
      </desc>
   </doc>
   
   <xsl:template name="divContents">
      <xsl:param name="Depth"/>
      <xsl:param name="nav">false</xsl:param>
      <xsl:variable name="ident">
         <xsl:apply-templates mode="ident" select="."/>
      </xsl:variable>
      <xsl:variable name="headertext">
         <xsl:call-template name="header">
            <xsl:with-param name="display">full</xsl:with-param>
         </xsl:call-template>
      </xsl:variable>
      
      <xsl:choose>
         <xsl:when test="parent::tei:*/@rend='multicol'"/> <!-- not needed for Rg -->
         <xsl:when test="@rend='multicol'"/> <!-- not needed for Rg -->
         <xsl:when test="@rend='nohead' or $headertext=''">
            <xsl:apply-templates/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:if test="not($Depth = '')">
               <xsl:variable name="Heading">
                  <xsl:element name="{if (number($Depth)+$divOffset &gt;6) then 'div'
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
                     <xsl:call-template name="sectionHeadHook"/>
                     <xsl:copy-of select="$headertext"/>	 
                  </xsl:element>     
               </xsl:variable>
               <!-- wrap with yaml grid and not with &lt;head&gt; element  -->
               <div class="ym-g62 ym-gl">
                  <div class="ym-gbox">
                     <xsl:copy-of select="$Heading"/>
                  </div>
               </div>
               <div class="ym-g38 ym-gr">
                  <div class="ym-gbox"/> 
               </div>
               <xsl:if test="$topNavigationPanel='true' and $nav='true'"/> <!-- not needed for Rg -->
            </xsl:if>
            <xsl:apply-templates/>
            <xsl:if test="$bottomNavigationPanel='true' and $nav='true'"/> <!-- not needed for Rg -->
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>


<!-- Wie Fußnoten nummeriert werden (anpassen an Rg Standard aus Satz in UltraXML) -->
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] How to label a note - adapted to numbering schema of rg: @n only used when @rend='symbol' notes should have @place="foot" in Rg context</desc>
   </doc>
   <xsl:template name="noteN">
      <xsl:choose>
         <xsl:when test="@n and @rend='symbol'">
            <xsl:value-of select="@n"/>
         </xsl:when>
         <xsl:when test="not(@place) and $consecutiveFNs='true'"> <!-- this should also not be needed for Rg, since footnotes should have @place="foot" -->
            <xsl:number count="tei:note[not(@place) and not(@rend='symbol')]" level="any"/> 
         </xsl:when>
         <xsl:when test="not(@place)"/> <!-- not needed for Rg -->
         <xsl:when test="@place='end'"/> <!-- not needed for Rg -->
         <xsl:otherwise>
            <xsl:choose>
               <xsl:when test="$consecutiveFNs = 'true'">
                  <xsl:number count="tei:note[(@place='foot' or @place='bottom') and not(@rend='symbol')]" level="any"/>
               </xsl:when>
               <xsl:otherwise/> <!-- not needed for Rg -->
           </xsl:choose>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>  
   


   <!-- Fußnoten als Endnoten und in Marginalspalte - make footnotes to endnotes AND notes in the margin per paragraph -->

   <!-- Fußnoten für Marginalspalte pro Absatz sammeln - collect notes per paragraph -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>Process element p.</p>
         <p>Adapted for Rg building a yaml-css framework grid aroung paragraph</p>
         <p>and collect footnotes per paragraph in margin column</p> 
      </desc>
   </doc>
   <xsl:template match="tei:p">
      <xsl:variable name="wrapperElement" select="tei:is-DivOrP(.)"/>
      
      <xsl:choose>
         <xsl:when test="parent::tei:note or parent::tei:figure"> <!-- wenn p in Anmerkung oder Grafikbeschreibung, dann kein yaml-Gerüst - no yaml-grid when p in note or figure element -->
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
         </xsl:when>
         
         <xsl:otherwise>
            <!-- gerüst um Absatz linke Spalte  built yaml around left column (text) -->
            <div class="ym-g62 ym-gl">
               <div class="ym-gbox">
                  <xsl:choose>
                     <xsl:when test="$filePerPage='true'"/> <!-- not needed in rg -->
                     <xsl:when test="$generateDivFromP='true' or teix:egXML"/> <!-- not needed in rg -->
                     
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
                  <!-- gerüst um Absatz linke Spalte - yaml around left text column -->
               </div>
            </div>
            <!-- ab hier werden die Fußnoten für die Marginalspalte je Absatz gesammelt - collect notes for margin column -->
            <div class="ym-g38 ym-gr">
               <div class="ym-gbox">
                  <xsl:if test=".//tei:note">
                     <xsl:choose>
                        <xsl:when test="parent::tei:note"/>
                        <xsl:otherwise>
                           <xsl:element name="div">
                              <xsl:apply-templates select="tei:note" mode="footandmargin"/>
                           </xsl:element>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:if>
               </div>
            </div>
         </xsl:otherwise>
      </xsl:choose>
      
      
   </xsl:template>
   

   
   <!-- dieses Template soll die Fußnoten nochmal in die Marginalspalte doppeln - double notes into margin column -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Collect footnotes into margin on per paragraph base but keep them as endnotes as well. 
         If footnotes too long, cut them and link to endnote
         $maxLengthFnMargin parameter (Rg specific) = controls from which length (characters) marignnote will be cut
      </desc>
   </doc>
   
   <xsl:template match="tei:note" mode="footandmargin">
      <xsl:variable name="identifier">
         <xsl:call-template name="noteID"/>
      </xsl:variable>
      <div class="margnote">
         <span class="margnoteLabel">
            <a class="notelink" title="go to endnote" href="#{$identifier}">
               <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
                  <xsl:call-template name="noteN"/>
               </xsl:element>
               <xsl:if test="following-sibling::node()[1][self::tei:note]">
                  <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
                     <xsl:text>,</xsl:text>
                  </xsl:element>
               </xsl:if>   
            </a>
         </span>
         <xsl:variable name="note-text">
            <xsl:apply-templates mode="plain"/>
         </xsl:variable>
         <xsl:choose>
            <!-- string-length controls from which point long notes will be cut in margin column -->
            <xsl:when test="string-length($note-text) &gt; $maxLengthFnMargin">
               <xsl:value-of select="substring($note-text,1,$maxLengthFnMargin)"/>
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

   <!-- Zu Endnoten gewordene Fussnoten mit YAML Grid versehen - build yaml around footnotes -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] Rg specific: build yaml-grid around footnotes</desc>
   </doc>
   <xsl:template name="printNotes">
      <xsl:if test="count(key('NOTES',1)) or ($autoEndNotes='true' and count(key('ALLNOTES',1)))">
         <xsl:choose>
            <xsl:when test="$footnoteFile='true'"/> <!-- Entfällt, da für Rg nicht relevant - not relevant for rg -->
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
                     <div class="ym-g100 ym-gl">
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
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[xhtlm] [core]Process element note - for rg modified: 
         - span instead of div for noteBody
         - linkreturn also around noteLabel
      </desc>
   </doc>
   <xsl:template name="makeaNote">
      <xsl:variable name="identifier">
         <xsl:call-template name="noteID"/>
      </xsl:variable>
      <xsl:if test="$verbose='true'">
         <xsl:message>Make note <xsl:value-of select="$identifier"/></xsl:message>
      </xsl:if>
      <div class="note">
         <xsl:call-template name="makeAnchor">
            <xsl:with-param name="name" select="$identifier"/>
         </xsl:call-template>
         <span class="noteLabel">
            <a class="link_return" title="Go back to text" href="#{concat($identifier,'_return')}">
            <xsl:call-template name="noteN"/>
            <xsl:if test="matches(@n,'[0-9]')">
               <xsl:text>.</xsl:text>
            </xsl:if>
            </a>
            <xsl:text> </xsl:text>
         </span>
         <span class="noteBody">
            <xsl:apply-templates/>
         </span>
         <xsl:if test="$footnoteBackLink= 'true'">
            <xsl:text> </xsl:text>
            <a class="link_return" title="Go back to text" href="#{concat($identifier,'_return')}">↵</a>
         </xsl:if>
      </div>
   </xsl:template>
   
   <!-- Auflistungen im Text mit yaml-grid versehen -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[xhtml][core] [rg]Process element list</p>
         <p>
            <p>Rg specific: build yaml-grid around list elements in text. The template builds the grid and calls the original template renamed to "makeList" </p>
            <p>Than it collects the notes in the (item) elements of the list for the margin notes. </p>
            <p>No &lt;note&gt; element directly in the &lt;list&gt; element is processed! Otherwise the order of notes might be distorted (direct childs of list before item childs) </p>
         </p>
      </desc>
   </doc>
   
   <xsl:template match="tei:list">
      <xsl:choose>
         <xsl:when test="parent::tei:p"> <!-- Achtung: Fn werden nicht in Marginalspalte geschrieben wenn list in p eingebettet - Fn won't make it into the margin when list embedded in p-->
            <xsl:call-template name="makeList"/>
         </xsl:when>
         <xsl:otherwise>
            <div class="ym-g62 ym-gl">
               <div class="ym-gbox">
                  <xsl:call-template name="makeList"/>
               </div>                                    
            </div>
            <div class="ym-g38 ym-gr">
               <div class="ym-gbox"> 
                  <xsl:for-each select=".//*">
                     <xsl:choose>
                        <xsl:when test="parent::tei:note"/>
                        <xsl:otherwise>
                           <xsl:apply-templates select="tei:note" mode="footandmargin"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:for-each>
               </div>
            </div>
         </xsl:otherwise>
      </xsl:choose>
      
   </xsl:template>
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[xhtml][core] [rg] Process element list</p>
         <p>
            <p>This is the original template for the element &lt;list&gt; transfered into a named template that is called by the new template for &lt;list&gt; that builds the Rg specific yaml-grid around the list</p>
            <p xmlns="http://www.w3.org/1999/xhtml">Lists. Depending on the value of the 'type' attribute, various HTML
               lists are generated: <dl><dt>bibl</dt><dd>Items are processed in mode 'bibl'</dd><dt>catalogue</dt><dd>A gloss list is created, inside a paragraph</dd><dt>gloss</dt><dd>A gloss list is created, expecting alternate label and item
                  elements</dd><dt>glosstable</dt><dd>Label and item pairs are laid out in a two-column table</dd><dt>inline</dt><dd>A comma-separate inline list</dd><dt>runin</dt><dd>An inline list with bullets between items</dd><dt>unordered</dt><dd>A simple unordered list</dd><dt>ordered</dt><dd>A simple ordered list</dd><dt>valList</dt><dd>(Identical to glosstable)</dd></dl>
            </p>
         </p>
      </desc>
   </doc>
   <xsl:template name="makeList">
      <xsl:if test="tei:head">
         <xsl:element name="{if (not(tei:is-inline(.))) then 'div' else 'span' }">
            <xsl:attribute name="class">listhead</xsl:attribute>
            <xsl:apply-templates select="tei:head"/>
         </xsl:element>
      </xsl:if>
      <xsl:choose>
         <xsl:when test="@type='catalogue'">
            <p>
               <dl>
                  <xsl:call-template name="makeRendition">
                     <xsl:with-param name="default">false</xsl:with-param>
                  </xsl:call-template>
                  <xsl:for-each select="tei:item">
                     <p/>
                     <xsl:apply-templates mode="gloss" select="."/>
                  </xsl:for-each>
               </dl>
            </p>
         </xsl:when>
         <xsl:when test="@type='gloss' and @rend='multicol'">
            <xsl:variable name="nitems">
               <xsl:value-of select="count(tei:item)div 2"/>
            </xsl:variable>
            <p>
               <table>
                  <xsl:call-template name="makeRendition">
                     <xsl:with-param name="default">false</xsl:with-param>
                  </xsl:call-template>
                  <tr>
                     <td style="vertical-align:top;">
                        <dl>
                           <xsl:apply-templates mode="gloss" select="tei:item[position()&lt;=$nitems ]"/>
                        </dl>
                     </td>
                     <td style="vertical-align:top;">
                        <dl>
                           <xsl:apply-templates mode="gloss" select="tei:item[position() &gt;$nitems]"/>
                        </dl>
                     </td>
                  </tr>
               </table>
            </p>
         </xsl:when>
         <xsl:when test="@type='gloss' or  tei:label">
            <dl>
               <xsl:call-template name="makeRendition">
                  <xsl:with-param name="default">false</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates mode="gloss" select="tei:item"/>
            </dl>
         </xsl:when>
         <xsl:when test="@type='glosstable' or @type='valList'">
            <table>
               <xsl:call-template name="makeRendition">
                  <xsl:with-param name="default">false</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates mode="glosstable" select="tei:item"/>
            </table>
         </xsl:when>
         <xsl:when test="@type='inline' or ancestor::tei:head or parent::tei:label">
            <!--<xsl:if test="not(tei:item)">None</xsl:if>-->
            <xsl:apply-templates mode="inline" select="tei:item"/>
         </xsl:when>
         <xsl:when test="@type='runin'">
            <p>
               <xsl:apply-templates mode="runin" select="tei:item"/>
            </p>
         </xsl:when>
         <xsl:when test="@type='unordered' or @type='simple'">
            <ul>
               <xsl:call-template name="makeRendition">
                  <xsl:with-param name="default">false</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates select="tei:item"/>
            </ul>
         </xsl:when>
         <xsl:when test="@type='bibl'">
            <xsl:apply-templates mode="bibl" select="tei:item"/>
         </xsl:when>
         <xsl:when test="starts-with(@type,'ordered')">
            <ol>
               <xsl:call-template name="makeRendition">
                  <xsl:with-param name="default">false</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="starts-with(@type,'ordered:')">
                  <xsl:attribute name="start">
                     <xsl:value-of select="substring-after(@type,':')"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:apply-templates select="tei:item"/>
            </ol>
         </xsl:when>
         <xsl:otherwise>
            <ul>
               <xsl:call-template name="makeRendition">
                  <xsl:with-param name="default">false</xsl:with-param>
               </xsl:call-template>
               <xsl:apply-templates select="tei:item"/>
            </ul>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   

   <!-- Bibliographie mit YAML Grid und ohne nummern (ul statt ol) sonderangaben für mla style raus - bibliography without numbers -->
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element listBibl</desc>
   </doc>
   <xsl:template match="tei:listBibl">
      <xsl:choose>
         <xsl:when test="tei:biblStruct and $biblioStyle='mla'"/> <!-- not needed for Rg -->
         <xsl:when test="tei:biblStruct"/> <!-- not needed for Rg -->
         <xsl:when test="tei:msDesc"/> <!-- not needed for Rg -->
         
         <xsl:otherwise>
            <div class="ym-g100 ym-gl">
               <div class="ym-gbox">
                  <xsl:if test="tei:head">
                     <xsl:apply-templates select="tei:head"/>
                  </xsl:if>
                  <ul class="listBibl">
                     <xsl:for-each select="*[not(local-name(.)='head' or local-name(.)='pb')]">
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
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   

<!-- Seitenumbruch anzeigen -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[xhtml2] [Rg] Process element pb</p>
         <p>Mark pagebreak in text visible depending on parameter $pagebreakStyle. </p>
         <p>"attribute"= mark with vertical line and put page numbers on tooltip. no mark in bibl</p>
         <p>"visible" = page number before | after in squarebrakets</p>
         <p>Build yaml grid around pagenumber when pb outside a paragraph (i.e. direct parent a div)</p>
      </desc>
   </doc>
   <xsl:template match="tei:pb">
      <xsl:choose>
         <xsl:when test="$filePerPage='true'"/> <!-- not needed for rg -->
         <xsl:when test="@facs and not(@rend='none')"/> <!-- not needed for rg -->
         <xsl:when test="$pagebreakStyle='active'"/> <!-- not needed for rg -->
         
         <xsl:when test="$pagebreakStyle='visible' and (parent::tei:body or parent::tei:front or parent::tei:back or parent::tei:group)">
            <div class="ym-g62 ym-gl">
               <div class="ym-gbox">
                  <div class="pagebreak">
               <xsl:call-template name="makeAnchor"/>
               <xsl:text> [</xsl:text>
               <xsl:call-template name="i18n">
                  <xsl:with-param name="word">page</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@n">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="(@n)-1"/>
                  <xsl:text> | </xsl:text>
                  <xsl:value-of select="@n" />
               </xsl:if>
               <xsl:text>] </xsl:text>
            </div>
               </div>
            </div>
            <div class="ym-g38 ym-gr">
               <div class="ym-gbox"/>
            </div>
         </xsl:when>
         <xsl:when test="$pagebreakStyle='visible' and (parent::tei:div)">
            <div class="ym-g62 ym-gl">
               <div class="ym-gbox">
                  <span class="pagebreak">
                     <xsl:call-template name="makeAnchor"/>
                     <xsl:text> [</xsl:text>
                     <xsl:call-template name="i18n">
                        <xsl:with-param name="word">page</xsl:with-param>
                     </xsl:call-template>
                     <xsl:if test="@n">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="(@n)-1"/>
                        <xsl:text> | </xsl:text>
                        <xsl:value-of select="@n" />
                     </xsl:if>
                     <xsl:text>] </xsl:text>
                  </span>
               </div>
            </div>
            <div class="ym-g38 ym-gr">
               <div class="ym-gbox"/>
            </div>
         </xsl:when>
         <xsl:when test="$pagebreakStyle='visible'">
            <span class="pagebreak">
               <xsl:call-template name="makeAnchor"/>
               <xsl:text> [</xsl:text>
               <xsl:call-template name="i18n">
                  <xsl:with-param name="word">page</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@n">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="(@n)-1"/>
                  <xsl:text> | </xsl:text>
                  <xsl:value-of select="@n" />
               </xsl:if>
               <xsl:text>] </xsl:text>
            </span>
         </xsl:when>
         <xsl:when test="$pagebreakStyle='attribute' and (parent::tei:listBibl or parent::tei:bibl)"/> <!-- show no pb in bibliograpy -->
         <xsl:when test="$pagebreakStyle='attribute' and (parent::tei:body or parent::tei:front or parent::tei:back or parent::tei:group)">
            <xsl:variable name="pagenumber">
               <xsl:call-template name="i18n">
                  <xsl:with-param name="word">page</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@n">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="(@n)-1"/>
                  <xsl:text> | </xsl:text>
                  <xsl:value-of select="@n" />
               </xsl:if>
            </xsl:variable>
            <div class="pagebreak" title="{$pagenumber}">
               <xsl:call-template name="makeAnchor"/> <!-- gibt dem ganzen eine id, nicht nötig für rg -->
               <xsl:text>|</xsl:text>
            </div>
         </xsl:when>
         <xsl:when test="$pagebreakStyle='attribute'">
            <xsl:variable name="pagenumber">
               <xsl:call-template name="i18n">
                  <xsl:with-param name="word">page</xsl:with-param>
               </xsl:call-template>
               <xsl:if test="@n">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="(@n)-1"/>
                  <xsl:text> | </xsl:text>
                  <xsl:value-of select="@n" />
               </xsl:if>
            </xsl:variable>
            <span class="pagebreak" title="{$pagenumber}">
               <xsl:call-template name="makeAnchor"/> <!-- gibt dem ganzen eine id, nicht nötig für rg -->
               <xsl:text>|</xsl:text>
            </span>
         </xsl:when>
      </xsl:choose>
   </xsl:template>
   
   <!-- Bilder in html einbinden  -->

<!-- nicht gebraucht, da figure schon in p und der baut yaml-grid drumrum
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[xhtml] [figures]Process element figure  build yaml-grid around figure for Rg </desc>
   </doc>
   <xsl:template match="tei:figure">
      <div class="ym-g62 ym-gl">
         <div class="ym-gbox">
            <xsl:choose>
               <xsl:when test="ancestor::tei:head or @rend='inline' or @place='inline'">
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:when test="parent::tei:ref">
                  <xsl:apply-templates/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:element name="{if ($outputTarget='html5') then 'figure'  else 'div'}">
                     <xsl:call-template name="makeRendition">
                        <xsl:with-param name="auto">figure</xsl:with-param>
                     </xsl:call-template>
                     <xsl:if test="@xml:id">
                        <xsl:attribute name="id">
                           <xsl:value-of select="@xml:id"/>
                        </xsl:attribute>
                     </xsl:if>
                     <xsl:call-template name="figureHook"/>
                     <xsl:apply-templates/>
                  </xsl:element>
               </xsl:otherwise>
            </xsl:choose>  
         </div>
      </div>
      <div class="ym-g38 ym-gl">
         <div class="ym-gbox"/>
      </div>
   </xsl:template>
 -->
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html][figure] display graphic file put content from &lt;p @rend='figure-license'gt; into "alt" of picture </desc>
   </doc>
   <xsl:template name="showGraphic">
      <xsl:variable name="File">
         <xsl:choose>
            <xsl:when test="self::tei:binaryObject"/>
            <xsl:when test="@url">
               <xsl:sequence select="tei:resolveURI(.,@url)"/>
               <xsl:if test="not(contains(@url,'.'))">
                  <xsl:value-of select="$graphicsSuffix"/>
               </xsl:if>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">Cannot work out how to do a graphic, needs a URL</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Alt">
         <xsl:choose>
            <xsl:when test="tei:desc">
               <xsl:for-each select="tei:desc">
                  <xsl:apply-templates mode="plain"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:when test="tei:figDesc">
               <xsl:for-each select="tei:figDesc">
                  <xsl:apply-templates mode="plain"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:when test="tei:head">
               <xsl:value-of select="tei:head/text()"/>
            </xsl:when>
            <xsl:when test="parent::tei:figure/tei:figDesc">
               <xsl:for-each select="parent::tei:figure/tei:figDesc">
                  <xsl:apply-templates mode="plain"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:when test="parent::tei:figure/tei:head">
               <xsl:value-of select="parent::tei:figure/tei:head/text()"/>
            </xsl:when>
            <xsl:when test="parent::tei:figure/tei:p[@rend='figure-license']">
               <xsl:for-each select="parent::tei:figure/tei:p[@rend='figure-license']">
                  <xsl:apply-templates mode="plain"/>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$showFigures='true'">
            <xsl:choose>
               <xsl:when test="@type='thumbnail'"/>
               <xsl:when test="starts-with(@mimeType, 'video')">
                  <video src="{$graphicsPrefix}{$File}"
                     controls="controls">
                     <xsl:if test="../tei:graphic[@type='thumbnail']">
                        <xsl:attribute name="poster">
                           <xsl:value-of select="../tei:graphic[@type='thumbnail']/@url"/>
                        </xsl:attribute>
                     </xsl:if>
                  </video>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:variable name="sizes">
                     <xsl:if test="@width">
                        <xsl:text> width:</xsl:text>
                        <xsl:value-of select="@width"/>
                        <xsl:text>;</xsl:text>
                     </xsl:if>
                     <xsl:if test="@height">
                        <xsl:text> height:</xsl:text>
                        <xsl:value-of select="@height"/>
                        <xsl:text>;</xsl:text>
                     </xsl:if>
                  </xsl:variable>
                  <xsl:variable name="i">
                     <img>
                        <xsl:attribute name="src">
                           <xsl:choose>
                              <xsl:when test="self::tei:binaryObject">
                                 <xsl:text>data:</xsl:text>
                                 <xsl:value-of select="@mimetype"/>
                                 <xsl:variable name="enc" select="if (@encoding) then @encoding else 'base64'"/>
                                 <xsl:text>;</xsl:text>
                                 <xsl:value-of select="$enc"/>
                                 <xsl:text>,</xsl:text>
                                 <xsl:copy-of select="text()"/>
                              </xsl:when>
                              <xsl:otherwise>
                                 <xsl:value-of
                                    select="concat($graphicsPrefix,$File)"/>
                              </xsl:otherwise>
                           </xsl:choose>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                           <xsl:value-of select="$Alt"/>
                        </xsl:attribute>
                        <xsl:call-template name="imgHook"/>
                        <xsl:if test="@xml:id">
                           <xsl:attribute name="id">
                              <xsl:value-of select="@xml:id"/>
                           </xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="makeRendition"/>
                     </img>
                  </xsl:variable>
                  <xsl:for-each select="$i/*">
                     <xsl:copy>
                        <xsl:copy-of select="@*[not(name()='style')]"/>
                        <xsl:choose>
                           <xsl:when test="$sizes=''">
                              <xsl:copy-of select="@style"/>
                           </xsl:when>
                           <xsl:when test="not(@style)">
                              <xsl:attribute name="style" select="$sizes"/>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:attribute name="style"
                                 select="concat(@style,';' ,$sizes)"/>
                           </xsl:otherwise>
                        </xsl:choose>
                     </xsl:copy>
                  </xsl:for-each>
               </xsl:otherwise>
            </xsl:choose>	  
         </xsl:when>
         <xsl:otherwise>
            <div class="altfigure">
               <xsl:sequence select="tei:i18n('figureWord')"/>
               <xsl:text> </xsl:text>
               <xsl:for-each select="self::tei:figure|parent::tei:figure">
                  <xsl:number count="tei:figure[tei:head]" level="any"/>
               </xsl:for-each>
               <xsl:text> </xsl:text>
               <xsl:value-of select="$File"/>
               <xsl:text> [</xsl:text>
               <xsl:value-of select="$Alt"/>
               <xsl:text>] </xsl:text>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <!-- externe Links in neuem Fenster/Tab öffnen - open external links in new window/tab -->
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[common] create external link. For Rg added: attribute target="_blank" to open link in new window/tab <param name="ptr">ptr</param>
         <param name="dest">dest</param>
         <param name="class">class</param>
      </desc>
   </doc>
   <xsl:template name="makeExternalLink">
      <xsl:param name="ptr" as="xs:boolean"  select="false()"/>
      <xsl:param name="dest"/>
      <xsl:param name="class">link_<xsl:value-of select="local-name(.)"/>
      </xsl:param>
      <xsl:element name="{$linkElement}" namespace="{$linkElementNamespace}">
         <xsl:if test="(self::tei:ptr or self::tei:ref) and @xml:id">
            <xsl:attribute name="id" select="@xml:id"/>
         </xsl:if>
         <xsl:call-template name="makeRendition">
            <xsl:with-param name="default" select="$class"/>
         </xsl:call-template>
         <xsl:if test="@type and not($outputTarget='epub3' or $outputTarget='html5')">
            <xsl:attribute name="type">
               <xsl:value-of select="@type"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:attribute name="{$linkAttribute}" namespace="{$linkAttributeNamespace}">
            <xsl:sequence select="$dest"/>
            <xsl:if test="contains(@from,'id (')">
               <xsl:text>#</xsl:text>
               <xsl:value-of select="substring(@from,5,string-length(normalize-space(@from))-1)"/>
            </xsl:if>
         </xsl:attribute>
         <xsl:attribute name="target">_blank</xsl:attribute> <!-- open link in new window/tab -->
         <xsl:choose>
            <xsl:when test="@n">
               <xsl:attribute name="title">
                  <xsl:value-of select="@n"/>
               </xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <xsl:call-template name="xrefHook"/>
         <xsl:choose>
            <xsl:when test="$dest=''">??</xsl:when>
            <xsl:when test="$ptr">
               <xsl:element name="{$urlMarkup}" namespace="{$linkElementNamespace}">
                  <xsl:choose>
                     <xsl:when test="starts-with($dest,'mailto:')">
                        <xsl:value-of select="substring-after($dest,'mailto:')"/>
                     </xsl:when>
                     <xsl:when test="starts-with($dest,'file:')">
                        <xsl:value-of select="substring-after($dest,'file:')"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="$dest"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:element>
            </xsl:when>
            <xsl:otherwise>
               <xsl:apply-templates/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:element>
   </xsl:template>
   
   
</xsl:stylesheet>
