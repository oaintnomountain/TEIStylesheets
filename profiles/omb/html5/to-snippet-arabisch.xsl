<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="tei teix" version="2.0">

   <!-- import base conversion style -->

      <xsl:import href="../../../xhtml2/tei.xsl"/> 
   <!--   <xsl:import href="../../../html5/tei.xsl"/>
   <xsl:import href="../../../html5/microdata.xsl"/> -->

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
   <xsl:param name="numberBodyHeadings">1.1.1.1</xsl:param> <!-- scheint wirkungslos im aktuellen tei-xslt -->

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
         Choices are "visible", "active" and "none".</desc>
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

   <xsl:template name="numberBodyDiv">
      <xsl:if test="$numberHeadings='true'">
         <xsl:number count="tei:div|tei:div1|tei:div2|tei:div3|tei:div4|tei:div5|tei:div6"
            format="1.1.1.1" level="multiple"/>
      </xsl:if>
   </xsl:template>
   




   <!-- Elemente in front (Abstract, Titel) ignorieren, da das aus der Django-Datenbank generiert wird -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>ignore the content of elements in front </desc>
   </doc>
   <xsl:template match="//tei:front"/>

   <!-- Keinen Footer generieren - no footer needed -->
   
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



   <!-- Yaml Gerüst um Überschriften bauen - build Yaml around headings -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] doing the contents of a div - modification to tei: insert YAML Grid in Head </desc>
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
                     <!-- Hier wird das YAML Grid eingefügt Achtung: So nicht geeignet für Fußnotenmarginalspalte in Überschrift (nur wenn xhtml nötig) -->
                     <div class="ym-g62 ym-gl">
                        <div class="ym-gbox">
                           <xsl:copy-of select="$Heading"/>
                        </div>
                     </div>
                     <div class="ym-g38 ym-gr">
                        <div class="ym-gbox"> </div>
                     </div>
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




   <!-- Fußnoten als Endnoten und in Marginalspalte - make footnotes to endnotes AND notes in the margin per paragraph -->

   <!-- Fußnoten für Marginalspalte pro Absatz sammeln - collect notes per paragraph -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element p</desc>
   </doc>
   <xsl:template match="tei:p">
      <xsl:variable name="wrapperElement" select="tei:is-DivOrP(.)"/>
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


   <!-- dieses Template soll die Fußnoten nochmal in die Marginalspalte doppeln - double notes into margin column -->

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
            <!-- string-length controls from which point long notes will be cut in margin column -->
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

   <!-- Zu Endnoten gewordene Fussnoten mit YAML Grid versehen - build yaml around footnotes -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>[html] </desc>
   </doc>
   <xsl:template name="printNotes">
      <xsl:if test="count(key('NOTES',1)) or ($autoEndNotes='true' and count(key('ALLNOTES',1)))">
         <xsl:choose>
            <xsl:when test="$footnoteFile='true'">
               <!-- Entfällt, da für Rg nicht relevant - not relevant for rg -->
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

   <!-- Bibliographie mit YAML Grid und ohne nummern (ul statt ol) sonderangabe nfür mla style raus - bibliography without numbers -->

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

<!-- Seitenumbruch anzeigen -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>
         <p>[xhtml2] Process element pb</p>
         <p>Do nothing</p>
      </desc>
   </doc>
   <xsl:template match="tei:pb" >
   </xsl:template>
   
   
</xsl:stylesheet>
