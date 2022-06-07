<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:date="http://exslt.org/dates-and-times" 
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="date exsl"
    exclude-result-prefixes="xs tei html"
    version="2.0">
    
    <xsl:output method="xhtml" html-version="5.0" encoding="UTF-8" indent="yes" normalization-form="NFC"
        omit-xml-declaration="yes"/>
    
    <xsl:variable name="today" select="format-date(current-date(),'[M01]-[D01]-[Y0001]')"/>
    
    
    <xsl:template match="@*|*|text()|comment()|processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>    
    
    <xsl:template match="html:*">
        <xsl:element name="{local-name()}">
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="html:*/comment()">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <!-- create main html document structure -->
    <xsl:template match="/">
        
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html;"/>
                <meta charset="UTF-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
                    
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous"/>
                <link rel="stylesheet" href="main.css"/>
                            
                <title>
                    <text>DDR im Schmalfilm | </text>
                    <xsl:apply-templates select="tei:TeiHeader//tei:title[@type='main']"/>
                </title>
            </head>
            
            <body data-offset="4em">
                <!-- Navigation -->
                <nav class="navbar navbar-expand-sm bg-dark navbar-dark fixed-top">
                    <a class="navbar-brand" href="#">av Zeitgeschichte</a>
                    <a class="navbar-link text-info" href="#">DDR im Schmalfilm</a>
                    
                    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <!-- Navbar text-->
                    <!-- Sammlungsnavigation -->
                    <div class="collapse navbar-collapse" id="collapsibleNavbar">
                        <ul class="navbar-nav">
                            <li class="nav-item">
                                <a class="nav-link text-warning" href="#">KORREKTURFAHNE</a>
                            </li>
                        </ul>
                    </div>
                </nav>
                
                <main>
                <article>
                <div class="container-xl">
                    <!-- Artikel Header -->
                    <header>
                    <div class="row artikel-header">
                        <div class="col-xs-8 col-sm-6 col-md-5">
                            <xsl:apply-templates select="//tei:docTitle"/>
                        </div>
                        <div class="col-xs-4 col-sm-6 col-md-7 p-0">
                            <img src="https://open-memory-box.de/thumb/480/omb_029-04_480_00-07-27-12.jpg"
                                class="img-fluid float-right"/>
                        </div>
                    </div>
                    
                    <div class="row">
                        
                        <!-- Main content -->
                        <div class="col-md-9 ">
                            <!-- Inhaltsübersicht -->
                            <!-- Steuerungsbutton Inhaltsverzeichnis collapsable -->
                            <button type="button" data-toggle="collapse" data-target="#clipliste"
                                class="btn btn-info btn-block mb-2">
                                Inhaltsübersicht
                            </button>
                            <!-- Inhaltsverzeichnis collapsable #clipliste -->
                            <div class="collapse" id="clipliste">
                                <ul>
                                    <xsl:apply-templates select="//tei:div/tei:head" mode="inhaltsvz"/>
                                </ul>
                            </div>
                            
                            <!-- Autor*in -->
                            <h5>von <xsl:apply-templates select="//tei:docAuthor"/> | <xsl:value-of select="$today"/> </h5>
                            
                        </div>
                    
                    </div>   
                    </header>
                    <div class="row">
                        <div class="col-md-9 ">
                            <xsl:apply-templates select="//tei:body/tei:div" />
                            
                            <!-- Fussnotenbereich  -->
                            <aside>     
                                <div id="fussnoten">
                                    <xsl:if test="tei:TEI/tei:text//tei:note[@type = 'footnote']">
                                        <hr/>
                                        
                                    </xsl:if>
                                    
                                    
                                    <a name="footnotes"/>
                                    <xsl:choose>
                                        <xsl:when test="tei:TEI/tei:text/tei:body/tei:div[@type = 'footnotes']">
                                            <!--  Wenn es einen Fussnotenbereich gibt -->
                                            <xsl:apply-templates
                                                select="tei:TEI/tei:text/tei:body/tei:div[@type = 'footnotes']"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!--  andernfalls notes auswerten -->
                                            <div class="footnote">
                                                <h2>Anmerkungen</h2>
                                                <ul class="footnote">
                                                    <xsl:for-each
                                                        select="tei:TEI/tei:text//tei:note[@place = 'foot']">
                                                        
                                                        <li class="footnote">
                                                            <div class="footnote2">
                                                                <xsl:attribute name="id">
                                                                    <xsl:text>fn</xsl:text>
                                                                    <xsl:number level="any"
                                                                        count="tei:note[@place = 'foot']"/>
                                                                </xsl:attribute>
                                                                <xsl:attribute name="href">
                                                                    <xsl:text>#fna</xsl:text><xsl:number level="any"
                                                                        count="tei:note[@place = 'foot']"/>
                                                                </xsl:attribute>[<a><xsl:attribute name="href">
                                                                    <xsl:text>#fna</xsl:text><xsl:number level="any"
                                                                        count="tei:note[@place = 'foot']"
                                                                    /></xsl:attribute><xsl:number level="any"
                                                                        count="tei:note[@place = 'foot']"/></a>]</div>
                                                            <div class="footnote3">
                                                                <xsl:apply-templates/>
                                                            </div>
                                                        </li>
                                                        <br/>
                                                    </xsl:for-each>
                                                </ul>
                                            </div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </div>
                                <!-- Bibliographie -->
                                <div class="bibliography">
                                    <hr/>
                                    <xsl:apply-templates
                                        select="/tei:TEI/tei:text/tei:body/tei:div/tei:div[@type = 'bibliography']"
                                    />
                                </div>
                            </aside>   
                            
                        </div>
                    </div>
                </div>  
                </article>
                    
                </main>
                
            </body>
        </html>
    </xsl:template>
    
    <!-- how to format Title, Subtitel and Suptitle -->
    <xsl:template match="tei:docTitle">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:titlePart[@type='sup']">
        <h2><xsl:apply-templates/></h2>        
    </xsl:template>
    <xsl:template match="tei:titlePart[@type='main']">
        <h1><xsl:apply-templates/></h1>        
    </xsl:template>
    <xsl:template match="tei:titlePart[@type='sub']">
        <h2><xsl:apply-templates/></h2>        
    </xsl:template>
    
    <!-- how to format section titles in table of content -->
    <xsl:template match="tei:div/tei:head" mode="inhaltsvz">
        <li><b><xsl:value-of select="."/></b></li>
    </xsl:template>
    <xsl:template match="tei:div/tei:div/tei:head" mode="inhaltsvz">
        <li><i><xsl:value-of select="."/></i></li>
    </xsl:template>
    
    <!-- how to show author of article on page -->
    <xsl:template match="tei:docAuthor">
        <xsl:element name="span">
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="following-sibling::tei:docAuthor/following-sibling::tei:docAuthor">
                    <xsl:text>, </xsl:text>
                </xsl:when>
                <xsl:when test="following-sibling::tei:docAuthor">
                    <xsl:text> und </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:element>       
    </xsl:template>
    
    
    <!-- how to handle footnotes in the text -->      
    <xsl:template match="tei:note">
        
        <xsl:param name="caption"/>
        
        <xsl:choose>
            <xsl:when test="parent::tei:div[@type = 'footnotes']">
                <!--   Fussnoten am Text- oder Seitenende -->
                <div class="footnote">
                    <a>
                        <xsl:attribute name="name">
                            <xsl:text>fn</xsl:text>
                            <xsl:value-of select="@n"/>
                        </xsl:attribute>
                        <a>
                            <xsl:attribute name="href">
                                <xsl:text>#fna</xsl:text>
                                <xsl:value-of select="@n"/>
                            </xsl:attribute>
                            <xsl:value-of select="@n"/>
                            
                        </a>
                    </a>
                    <xsl:apply-templates/>
                </div>
            </xsl:when>
            <!--  in Text integriert, nur Verweis , Fussnotenabschnitt mit foreach generiert -->
            <xsl:when test="@place = 'foot'">
                <a>
                    <xsl:attribute name="id">
                        <xsl:text>fna</xsl:text>
                        <xsl:number level="any" count="tei:note[@place = 'foot']"/>
                    </xsl:attribute>
                    <xsl:attribute name="class">
                        <xsl:text>fn</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="href">
                        <xsl:text>#fn</xsl:text>
                        <xsl:number level="any" count="tei:note[@place = 'foot']"/>
                    </xsl:attribute>
                    <xsl:attribute name="title">
                        <xsl:copy-of select="normalize-space(.)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$caption"/>
                    <xsl:text>[</xsl:text>
                    <xsl:number level="any" count="tei:note[@place = 'foot']"/>
                    <xsl:text>]</xsl:text>
                </a>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- How to handle Citation Links to OMB Videoclips -->
    <xsl:template match="tei:figure[@place='column' and @type='omb']">
        <figure>
            <xsl:apply-templates select="tei:media"/>
            <xsl:choose>
                <xsl:when test="child::tei:head and child::tei:trailer">
                    <figcaption>
                        <span class="fighead">
                            <xsl:apply-templates select="tei:head"/>
                            <xsl:text>. </xsl:text>
                        </span>
                        <span class="figtrailer">
                            <xsl:apply-templates select="tei:trailer"/>
                        </span>
                    </figcaption>
                </xsl:when>                
                <xsl:when test="child::tei:head">
                    <figcaption>
                        <xsl:apply-templates select="tei:head"/>
                    </figcaption>
                </xsl:when>
                <xsl:when test="child::tei:trailer">
                    <figcaption>
                        <xsl:apply-templates select="tei:trailer"/>
                    </figcaption>
                </xsl:when>                
            </xsl:choose>
        </figure>
    </xsl:template>
    
    <!-- for the moment do not show omb-scence if inside text paragraphs (only link, see tei:ref) -->
    <xsl:template match="tei:figure[@type='omb' and @place='margin']"/>
    
    <xsl:template match="tei:media[@type='omb']">
        <xsl:element name="video">
            <xsl:attribute name="controls"/>
            <xsl:attribute name="loop"/>
            <xsl:attribute name="preload">auto</xsl:attribute>
            <xsl:attribute name="width">480</xsl:attribute>
            <xsl:element name="source">
                <xsl:attribute name="src">
                    <xsl:value-of select="@url"/>
                    <xsl:text>#t=</xsl:text>
                    <xsl:value-of select="@start"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="@end"/>
                </xsl:attribute>
                <xsl:attribute name="type">video/mp4</xsl:attribute>
           </xsl:element>            
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:ref">
        <xsl:element name="a">
            <xsl:attribute name="href">
                <xsl:value-of select="@target"/>
            </xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- how to handle section titles and trailer elements in the main content -->
    <xsl:template match="tei:div/tei:head">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    
    <xsl:template match="tei:div/tei:div/tei:head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <xsl:template match="tei:figure[@type='omb']/tei:head">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:figure[@type='omb']/tei:trailer">
        <xsl:apply-templates/>
    </xsl:template>
    
</xsl:stylesheet>
