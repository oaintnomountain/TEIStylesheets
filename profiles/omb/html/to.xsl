<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html"
    version="2.0">
    <!-- import base conversion style -->

    <xsl:import href="../../../html/html.xsl"/>

  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet" type="stylesheet">
      <desc>

         <p>This software is dual-licensed:

1. Distributed under a Creative Commons Attribution-ShareAlike 3.0
Unported License http://creativecommons.org/licenses/by-sa/3.0/ 

2. http://www.opensource.org/licenses/BSD-2-Clause
		


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
         
         <p>Copyright: 2013, TEI Consortium</p>
<p>
  This is a modified version of the TEI Stylesheets default profile.
  It is adapted to the needs of the OMB@ZZF project at the
  Leibniz Center for Contemporary History Potsdam.
  The project is part of the BMBF funded research consortium "Das mediale Erbe der DDR".
</p>
        <p>Modifications by Olaf Berg. Copyright: 2020, Olaf Berg (ZZF)</p>
      </desc>
   </doc>

  <xsl:output method="xhtml" html-version="5.0" encoding="UTF-8" indent="yes" normalization-form="NFC"
    omit-xml-declaration="yes"/>
    
    <xsl:template match="html:*">
      <xsl:element name="{local-name()}">
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates/>
      </xsl:element>
    </xsl:template>
    
    <xsl:template match="html:*/comment()">
      <xsl:copy-of select="."/>
    </xsl:template>

  <xsl:template match="tei:div[@type='frontispiece']">
      <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:div[@type='illustration']">
      <xsl:apply-templates/>
  </xsl:template>
  
  <!-- Here starts my modification of TEI Stylesheets templates for OMB@ZZF -->
  
  <xsl:param name="doclang">de</xsl:param>
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl" class="numbering">
    <desc>[common] How to number sections in main matter</desc>
  </doc>
  <xsl:template name="numberBodyDiv">
    <xsl:if test="$numberHeadings='true'">
      <xsl:number count="tei:div[child::tei:head[@rend!='none']]" level="multiple"/>
    </xsl:if>
  </xsl:template>
    
  
  <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
    <desc>[html] display graphic file</desc>
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
          <xsl:message>Found binaryObject without @url.</xsl:message>
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
      </xsl:choose>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$showFigures='true'">
        <xsl:choose>
          <xsl:when test="@type='thumbnail'"/>
          <xsl:when test="starts-with(@mimeType, 'video')">
            <video src="{$graphicsPrefix}{$File}"
              controls="controls"
              loop="loop"
              muted="muted"
              preload="auto"
              width="480"
              >
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
                      <xsl:variable name="mime" select="if (@mimeType) then @mimeType else 'image/*'"/>
                      <xsl:variable name="enc" select="if (@encoding) then @encoding else 'base64'"/>
                      <xsl:value-of select="concat('data:', $mime, ';', $enc, ',', normalize-space(text()))"/>
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
  

</xsl:stylesheet>
