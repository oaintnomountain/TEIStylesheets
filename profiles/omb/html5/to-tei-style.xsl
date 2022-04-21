<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei teix"
    version="2.0">

    <!-- import base conversion style -->

    <xsl:import href="../../../html5/tei.xsl"/>
    <xsl:import href="../../../html5/microdata.xsl"/>

    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

This software is provided by the copyright holders and contributors
"as is" and any express or implied warranties, including, but not
limited to, the implied warranties of merchantability and fitness for
a particular purpose are disclaimed. In no event shall the copyright
holder or contributors be liable for any direct, indirect, incidental,
special, exemplary, or consequential damages (including, but not
limited to, procurement of substitute goods or services; loss of use,
data, or profits; or business interruption) however caused and on any
theory of liability, whether in contract, strict liability, or tort
(including negligence or otherwise) arising in any way out of the use
of this software, even if advised of the possibility of such damage.
</p>
         <p>Author: See AUTHORS</p>
         <p>Id: $Id: to.xsl 10466 2012-06-08 18:47:50Z rahtz $</p>
         <p>Copyright: 2008, TEI Consortium</p>
         <p>enhanced and customized for journal rg Rechtsgeschichte Legal History</p>
         <p>by Olaf Berg, Max Planck Institute for European Legal History</p>
         <p> Copyright enhancements: 2012, Olaf Berg and MPI for European Legal History</p>
      </desc>
   </doc>

<!-- Parameter für Rg setzen -->
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="layout" type="boolean">
      <desc>Link back from footnotes to reference</desc>
      
   </doc>
   <xsl:param name="footnoteBackLink">true</xsl:param>

<!-- Fußnoten als Endnoten und in Marginalspalte -->   

<!-- Fußnoten für Marginalspalte pro Absatz sammeln -->
   
   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element p</desc>
   </doc>
   <xsl:template match="tei:p">
      <xsl:variable name="wrapperElement">
         <xsl:choose>
            <xsl:when test="$outputTarget='html5'">p</xsl:when>
            <xsl:when test="parent::tei:figure and (tei:q/tei:l or tei:figure or parent::tei:figure/parent::tei:div)">div</xsl:when>
            <xsl:when test="parent::tei:figure">span</xsl:when>
            <xsl:when test="parent::tei:head or    parent::tei:q/parent::tei:head or    parent::tei:note[@place='margin']/parent::tei:head">span</xsl:when>
            <xsl:when test="ancestor::tei:notesStmt">div</xsl:when>
            <xsl:when test="tei:table">div</xsl:when>
            <xsl:when test="parent::tei:note[not(@place or @rend)]">span</xsl:when>
            <xsl:when test="$outputTarget='epub' or $outputTarget='epub3'">div</xsl:when>
            <xsl:when test="tei:eg">div</xsl:when>
            <xsl:when test="tei:figure">div</xsl:when>
            <xsl:when test="tei:floatingText">div</xsl:when>
            <xsl:when test="tei:l">div</xsl:when>
            <xsl:when test="tei:list">div</xsl:when>
            <xsl:when test="tei:moduleSpec">div</xsl:when>
            <xsl:when test="tei:note[@place='display']">div</xsl:when>
            <xsl:when test="tei:note[@place='margin']">div</xsl:when>
            <xsl:when test="tei:note[tei:q]">div</xsl:when>
            <xsl:when test="tei:q/tei:figure">div</xsl:when>
            <xsl:when test="tei:q/tei:list">div</xsl:when>
            <xsl:when test="tei:q[@rend='display']">div</xsl:when>
            <xsl:when test="tei:q[@rend='inline' and tei:note/@place]">div</xsl:when>
            <xsl:when test="tei:q[tei:l]">div</xsl:when>
            <xsl:when test="tei:q[tei:lg]">div</xsl:when>
            <xsl:when test="tei:q[tei:p]">div</xsl:when>
            <xsl:when test="tei:q[tei:sp]">div</xsl:when>
            <xsl:when test="tei:q[tei:floatingText]">div</xsl:when>
            <xsl:when test="tei:quote">div</xsl:when>
            <xsl:when test="tei:specGrp">div</xsl:when>
            <xsl:when test="tei:specGrpRef">div</xsl:when>
            <xsl:when test="tei:specList">div</xsl:when>
            <xsl:when test="tei:table">div</xsl:when>
            <xsl:when test="teix:egXML">div</xsl:when>
            <xsl:when test="ancestor::tei:floatingText">div</xsl:when>
            <xsl:when test="ancestor::tei:closer">div</xsl:when>
            <xsl:when test="parent::tei:p">div</xsl:when>
            <xsl:when test="parent::tei:q">div</xsl:when>
            <xsl:when test="parent::tei:note">div</xsl:when>
            <xsl:when test="parent::tei:remarks">div</xsl:when>
            <xsl:otherwise>
               <xsl:text>p</xsl:text>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$filePerPage='true'">
            <xsl:for-each-group select="node()" group-starting-with="tei:pb">
               <xsl:choose>
                  <xsl:when test="self::tei:pb">
                     <xsl:apply-templates select="."/>
                     <xsl:element name="{$wrapperElement}">
                        <xsl:for-each select="..">
                           <xsl:call-template name="rendToClass">
                              <xsl:with-param name="id">
                                 <xsl:choose>
                                    <xsl:when test="@xml:id">
                                       <xsl:value-of select="@xml:id"/>
                                       <xsl:text>continued</xsl:text>
                                    </xsl:when>
                                    <xsl:otherwise>
                                       <xsl:text>false</xsl:text>
                                    </xsl:otherwise>
                                 </xsl:choose>
                              </xsl:with-param>
                           </xsl:call-template>
                        </xsl:for-each>
                        <xsl:apply-templates select="current-group() except ."/>
                     </xsl:element>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:element name="{$wrapperElement}">
                        <xsl:for-each select="..">
                           <xsl:call-template name="rendToClass"/>
                        </xsl:for-each>
                        <xsl:apply-templates select="current-group()"/>
                     </xsl:element>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each-group>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="{$wrapperElement}">
               <xsl:call-template name="rendToClass">
                  <xsl:with-param name="default">
                     <xsl:if test="not($wrapperElement ='p')">
                        <xsl:text>p</xsl:text>
                     </xsl:if>
                  </xsl:with-param>
               </xsl:call-template>
               <xsl:if test="$numberParagraphs='true'">
                  <xsl:call-template name="numberParagraph"/>
               </xsl:if>
               <xsl:apply-templates/>
            </xsl:element>
         </xsl:otherwise>
      </xsl:choose>
      <!-- ab hier werden die Fußnoten für die Marginalspalte je Absatz gesammelt -->
      <xsl:if test=".//tei:note">
         <xsl:choose>
            <xsl:when test="parent::tei:note"/>
            <xsl:otherwise>
               <xsl:element name="div">
                  <div class="margnote" >
                     <p>
                        <xsl:text>Neues Element für Absatzsammlung</xsl:text>
                     </p>
                  </div>
                  <xsl:apply-templates select="tei:note" mode="footandmargin"/>
               </xsl:element> 
            </xsl:otherwise>
         </xsl:choose>
      </xsl:if>
      
      
      
      
      
   </xsl:template>
   
   
<!-- Fußnote doppeln zur Marginalspalte   
   
   <xsl:template match="tei:note">
      <xsl:variable name="identifier">
         <xsl:call-template name="noteID"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="@place='none'"/>
         <xsl:when test="ancestor::tei:listBibl or ancestor::tei:biblFull         or ancestor::tei:biblStruct">
            <xsl:text> [</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
         </xsl:when>
         <xsl:when test="@place='foot' or @place='bottom' or @place='end' or $autoEndNotes='true'">
            <xsl:call-template name="footandmargin">
               <xsl:with-param name="identifier" select="$identifier"/>
            </xsl:call-template>
            
            <xsl:element name="{if (parent::tei:head or parent::tei:hi)  then 'span'           else if (parent::tei:l) then 'span'           else if (parent::tei:bibl/parent::tei:head) then 'span'           else if (parent::tei:stage/parent::tei:q) then 'span'           else if  (parent::tei:body or *[not(tei:is-inline(.))]) then 'div' else 'span' }">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="concat($identifier,'_return')"/>
               </xsl:call-template>
               <xsl:variable name="note-title">
                  <xsl:variable name="note-text">
                     <xsl:apply-templates mode="plain"/>
                  </xsl:variable>
                  <xsl:value-of select="substring($note-text,1,500)"/>
                  <xsl:if test="string-length($note-text) &gt; 500">
                     <xsl:text>…</xsl:text>
                  </xsl:if>
               </xsl:variable>
               <xsl:choose>
                  <xsl:when test="$footnoteFile='true'">
                     <a class="notelink" title="{normalize-space($note-title)}" href="{$masterFile}-notes.html#{$identifier}">
                        <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
                           <xsl:call-template name="noteN"/>
                        </xsl:element>
                     </a>
                     <xsl:if test="following-sibling::node()[1][self::tei:note]">
                        <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
                           <xsl:text>,</xsl:text>
                        </xsl:element>
                     </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>
                     <a class="notelink" title="{normalize-space($note-title)}" href="#{$identifier}">
                        <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">				  
                           <xsl:call-template name="noteN"/>
                        </xsl:element>
                     </a>
                     <xsl:if test="following-sibling::node()[1][self::tei:note]">
                        <xsl:element name="{if (@rend='nosup') then 'span' else 'sup'}">
                           <xsl:text>,</xsl:text>
                        </xsl:element>
                     </xsl:if>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:element>
         </xsl:when>
         <xsl:when test="parent::tei:head and @place='margin'">
            <span class="margnote">
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:when test="parent::tei:head">
            <xsl:text> [</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]</xsl:text>
         </xsl:when>
         <xsl:when test="@type='footnote'">
            <div class="note">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <span class="noteNumber">
                  <xsl:number/>
               </span>
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="(@place='display' or tei:q)          and (parent::tei:div or parent::tei:p or parent::tei:body)">
            <div class="note">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <span class="noteLabel">
                  <xsl:choose>
                     <xsl:when test="@n">
                        <xsl:value-of select="@n"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:call-template name="i18n">
                           <xsl:with-param name="word">Note</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>: </xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </span>
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="@place='display'">
            <blockquote>
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <xsl:call-template name="rendToClass"/>
               <xsl:choose>
                  <xsl:when test="$outputTarget='html5'">
                     <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:when test="tei:q">
                     <xsl:apply-templates/>
                  </xsl:when>
                  <xsl:otherwise>
                     <p>
                        <xsl:apply-templates/>
                     </p>
                  </xsl:otherwise>
               </xsl:choose>
            </blockquote>
         </xsl:when>
         <xsl:when test="@place='margin' and parent::tei:hi and not(*)">
            <span class="margnote">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:when test="@place='margin' and (tei:p or tei:list or
            tei:table or tei:lg or *[not(tei:is-inline(.))])">
            <div class="margnote">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <xsl:apply-templates/>
            </div>
         </xsl:when>
         <xsl:when test="@place='margin'">
            <span class="margnote">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <xsl:apply-templates/>
            </span>
         </xsl:when>
         <xsl:when test="@place='inline' or (parent::tei:p or parent::tei:hi or parent::tei:head)">
            <span class="note">
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <xsl:text> [</xsl:text>
               <xsl:apply-templates/>
               <xsl:text>]</xsl:text>
            </span>
         </xsl:when>
         <xsl:otherwise>
            <div>
               <xsl:call-template name="makeAnchor">
                  <xsl:with-param name="name" select="$identifier"/>
               </xsl:call-template>
               <xsl:attribute name="class">
                  <xsl:text>note </xsl:text>
                  <xsl:value-of select="@type"/>
               </xsl:attribute>
               <span class="noteLabel">
                  <xsl:choose>
                     <xsl:when test="@n">
                        <xsl:value-of select="@n"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:call-template name="i18n">
                           <xsl:with-param name="word">Note</xsl:with-param>
                        </xsl:call-template>
                        <xsl:text>: </xsl:text>
                     </xsl:otherwise>
                  </xsl:choose>
               </span>
               <xsl:apply-templates/>
            </div>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template> --> 

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
   
</xsl:stylesheet>
