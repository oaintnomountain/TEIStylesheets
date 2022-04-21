<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
   xmlns:tei="http://www.tei-c.org/ns/1.0"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   exclude-result-prefixes="tei"
   version="2.0">
   xmlns:tei="http://www.tei-c.org/ns/1.0"
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




   <!-- Fußnoten als Endnoten und in Marginalspalte - make footnotes to endnotes AND notes in the margin per paragraph -->

   <!-- Fußnoten für Marginalspalte pro Absatz sammeln - collect notes per paragraph -->

   <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
      <desc>Process element p</desc>
   </doc>
   <xsl:template match="tei:p">
      <xsl:variable name="wrapperElement" select="tei:is-DivOrP(.)"/>
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
   </xsl:template>
   

   
</xsl:stylesheet>
