<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:date="http://exslt.org/dates-and-times"
    xmlns:exsl="http://exslt.org/common" extension-element-prefixes="date exsl"
    exclude-result-prefixes="xs tei html" version="2.0">

    <xsl:output method="xhtml" html-version="5.0" encoding="UTF-8" indent="yes"
        normalization-form="NFC" omit-xml-declaration="yes"/>
    
<!-- declaration of global variables -->
    <xsl:variable name="today" select="format-date(current-date(), '[D01]. [MNn] [Y0001]')"/>
    <xsl:variable name="title">
        <xsl:text>DDR im Schmalfilm | </xsl:text>
        <xsl:value-of select="replace(//tei:teiHeader//tei:title[@type = 'main'], '[\s\W]+',' ')"/>
    </xsl:variable>
    <xsl:variable name="domain">https://ddr-im-schmalfilm.de</xsl:variable>
    <xsl:variable name="articlelink">
        <xsl:value-of select="$domain"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="//tei:teiHeader//tei:title[@type = 'short']"/>
    </xsl:variable>
    <xsl:variable name="abstract">
        <xsl:value-of select="replace(//tei:front/tei:div[@type = 'abstract'], '[\s\W]+',' ')"/>
    </xsl:variable>
    <xsl:variable name="description">
        <xsl:text>Wissenschaftlicher Essay zu Szenen aus privaten DDR-Schmalfilmen. </xsl:text>
        <xsl:value-of select="replace(//tei:front//tei:div[@type = 'abstract'], '[\s\W]+',' ')"/>
    </xsl:variable>

<!-- general fallback templates -->
    <xsl:template match="@* | * | text() | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
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

        <html class="no-js" lang="de">
            <head>
                <!-- <meta http-equiv="Content-Type" content="text/html;"/> -->
                <meta http-equiv="x-ua-compatible" content="ie=edge"/>
                <meta name="viewport"
                    content="width=device-width, initial-scale=1.0, shrink-to-fit=no"/>
                <meta name="format-detection" content="telephone=no"/>
                <meta name="description">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$description"/>
                    </xsl:attribute>
                </meta>
                <meta property="og:title">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$title"/>
                    </xsl:attribute>
                </meta>
                <meta property="og:description">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$description"/>
                    </xsl:attribute>
                </meta>
                <!-- Im TEI definierter short-titel als ID. Besser über SSG generieren? -->
                <meta property="og:url">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$articlelink"/>
                    </xsl:attribute>
                </meta>
                <meta property="og:image" content="files/icons/share.jpg"/>
                <meta property="og:site_name" content="Die DDR im Schmalfilm"/>
                <meta property="og:type" content="website"/>
                <meta name="twitter:card" content="summary_large_image"/>
                <meta name="twitter:title">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$title"/>
                    </xsl:attribute>
                </meta>
                <meta name="twitter:description">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$description"/>
                    </xsl:attribute>
                </meta>
                <meta name="twitter:image" content="files/icons/share.jpg"/>
                <meta name="twitter:domain">
                    <xsl:attribute name="content">
                        <xsl:value-of select="$domain"/>
                    </xsl:attribute>
                </meta>
                <link rel="manifest" href="site.webmanifest"/>
                <link rel="apple-touch-icon" sizes="180x180" href="files/icons/apple-touch-icon.png"/>
                <link rel="icon" type="image/png" sizes="32x32"
                    href="files/icons/favicon-32x32.png"/>
                <link rel="icon" type="image/png" sizes="16x16"
                    href="files/icons/favicon-16x16.png"/>
                <link rel="mask-icon" href="files/icons/safari-pinned-tab.svg"/>
                <link rel="shortcut icon" href="files/icons/favicon.ico"/>
                <meta name="msapplication-TileColor" content="#ffffff"/>
                <meta name="msapplication-config" content="files/icons/browserconfig.xml"/>
                <meta name="theme-color" content="#059bbb"/>
                <link rel="canonical">
                    <xsl:attribute name="href">
                        <xsl:value-of select="$articlelink"/>
                    </xsl:attribute>
                </link>
                <link rel="stylesheet" href="files/system/css/style.css"/>
                <!-- <link rel="stylesheet" href="files/system/css/page.css"/>  --> 

                <title>
                    <xsl:value-of select="$title"/>
                </title>
            </head>

            <body class="top essay">
                <div class="wrap animsition">
                    <header class="header">
                        <div class="center clearfix logo_top">
                            <a href="./" title="back to start" class="fadelink logo">Die DDR im Schmalfilm</a>
                            <button class="hamburger hamburger--collapse" type="button" aria-label="Menu" aria-controls="navigation">
                                <span class="hamburger-box">
                                    <span class="hamburger-inner">&#160;</span>
                                </span>
                            </button>
                        </div>
                        <div class="navigation clearfix">
                            <div class="overflowbox">
                                <nav class="menu essays" id="navigation">
                                    <ul class="nav level_1 clearfix">

                                        <!-- hier muss dann nur der aktive Punkt beim li die Klasse bekommen -->

                                        <li>
                                            <a href="die-filmfamilie" title="Die Filmfamilie"
                                                class="fadelink">Die Filmfamilie. Transnationale
                                                Bilder von Gemeinschaft, Geschlecht und Generation
                                                in DDR-Schmalfilmen</a>
                                        </li>
                                        <li>
                                            <a href="soziale-ungleichheit-und-hierarchien"
                                                title="Soziale Ungleichheit und Hierarchien durch die Linse der Privatheit. Eine Spurensuche in den Filmen der Open Memory Box"
                                                class="fadelink">Soziale Ungleichheit und
                                                Hierarchien durch die Linse der Privatheit. Eine
                                                Spurensuche in den Filmen der Open Memory Box</a>
                                        </li>
                                        <li>
                                            <a href="medienkonsum"
                                                title="Medienkonsum: Zeitung, Radio, Fernsehen"
                                                class="fadelink">Medienkonsum: Zeitung, Radio,
                                                Fernsehen</a>
                                        </li>
                                        <li>
                                            <a href="gemeinschaft-und-geselligkeit"
                                                title="Gemeinschaft und Geselligkeit"
                                                class="fadelink">Gemeinschaft und Geselligkeit</a>
                                        </li>
                                        <li>
                                            <a href="kleidung-und-mode" title="Kleidung und Mode in der DDR" class="fadelink">Kleidung und Mode in der DDR</a>
                                        </li>
                                        <li>
                                            <a href="visuelle-spuren-des-westens"
                                                title="Visuelle Spuren des Westens auf DDR-Schmalfilmen"
                                                class="fadelink">Visuelle Spuren des Westens auf
                                                DDR-Schmalfilmen</a>
                                        </li>
                                        <li class="active">
                                            <a href="die-grenze-filmen" title="Die Grenze filmen"
                                                class="fadelink">Die Grenze filmen</a>
                                        </li>
                                        <li>
                                            <a href="home-movies-heimat-and-tourism"
                                                title="Home Movies, Heimat, and Tourism in the German Democratic Republic"
                                                class="fadelink">Home Movies, Heimat, and Tourism in
                                                the German Democratic Republic</a>
                                        </li>
                                        <li>
                                            <a href="familiaere-stadtbilder" 
                                                title="Familiäre STADTBILDER. Zwischen Hintergrundrauschen und Postkartenmotiven" 
                                                class="fadelink">Familiäre STADTBILDER. Zwischen Hintergrundrauschen und Postkartenmotiven</a>
                                        </li>
                                        <li>
                                            <a href="heiraten" title="Heiraten" class="fadelink"
                                                >Heiraten</a>
                                        </li>
                                        <li>
                                            <a href="stein-auf-stein"
                                                title="Stein auf Stein. Filme von Hausbau und Heimwerker*innen"
                                                class="fadelink">Stein auf Stein. Filme von Hausbau
                                                und Heimwerker*innen</a>
                                        </li>
                                       <li>
                                            <a href="und-immer-wieder-flamingos"
                                                title="Und immer wieder Flamingos...: Der Zoo zwischen Privatheit, Aneignung und sozialistischer Inszenierung"
                                                class="fadelink">Und immer wieder Flamingos...: Der
                                                Zoo zwischen Privatheit, Aneignung und
                                                sozialistischer Inszenierung</a>
                                        </li>
                                        <li>
                                            <a href="von-huehnern-und-schweinen"
                                                title="Von Hühnern und Schweinen" class="fadelink"
                                                >Von Hühnern und Schweinen</a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </header>
                    <main>
                        <div class="top_image">
                            <div class="inside">
                                <!-- responsive image -->
                                <!-- wenn die Bilder stehen, generiere ich dann die verschiedenen Größen -->
                                <picture>
                                    <source srcset="files/images/fullwidth/grenze-500.jpg"
                                        media="(max-width:500px)"/>
                                    <source srcset="files/images/fullwidth/grenze-1000.jpg"
                                        media="(min-width:501px) and (max-width:1024px)"/>
                                    <source srcset="files/images/fullwidth/grenze.jpg"
                                        media="(min-width:1025px)"/>
                                    <img src="files/images/fullwidth/grenze.jpg" width="1500" height="800"
                                        alt="Die DDR im Schmalfilm Bild"/>
                                </picture>
                                
                                <div class="headline">
                                    <div class="center">
                                        <!-- Titel im Bild -->
                                        <xsl:apply-templates select="//tei:docTitle" mode="inImage"/>
                                    </div>
                                </div>
                                <a href="javascript:void(0);" onclick="scroller('.content');"
                                    class="scroll_next transit">
                                    <img src="files/system/images/down.png" width="48" height="48"
                                        alt="Down"/>
                                </a>
                            </div>
                        </div>
                        <div class="center">
                            <article>
                                <div class="article_headline">
                                    <xsl:apply-templates select="//tei:docTitle"/>
                                </div>

                                <div class="clearfix">
                                    <!-- Anfang clearfix wegen float -->

                                    <div class="author_content">
                                        <!-- Anfang Autor, Datum und Inhalt -->

                                        <div class="author check fade_in">
                                            <h5>von <a href="#autor_in" class="autorin_link"
                                                onclick="scroller('#autor_in');"><xsl:apply-templates select="//tei:docAuthor"/></a></h5>
                                            <p class="date no_style"><xsl:value-of select="$today"/></p>
                                        </div>
                                        
                                        <!-- Wenn es keine Zwischenüberschriften gibt, wird kein Inhaltsverzeichnis angelegt -->
                                        <xsl:if test="descendant::tei:body/tei:div/tei:head">
                                            <div class="inhalt check fade_in">
                                                <button type="button" data-toggle="collapse"
                                                    data-target="#clipliste" class="transit"
                                                    >Inhaltsübersicht</button>
                                                <div class="collapse" id="clipliste">
                                                    <ul>
                                                        <xsl:for-each select="//tei:body//tei:div/tei:head">
                                                            <li>
                                                                <xsl:element name="a">
                                                                    <xsl:attribute name="href">javascript:void(0);</xsl:attribute>
                                                                    <xsl:attribute name="onclick">
                                                                        <xsl:text>scroller100('#</xsl:text>
                                                                        <xsl:value-of select="@xml:id"/>
                                                                        <xsl:text>');</xsl:text>
                                                                    </xsl:attribute>
                                                                    <xsl:if test="parent::tei:div[parent::tei:div]">
                                                                        <xsl:attribute name="class">
                                                                            <xsl:text>inhalt-level2</xsl:text>                                                                        
                                                                        </xsl:attribute>
                                                                    </xsl:if>
                                                                    <xsl:value-of select="." />
                                                               </xsl:element>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </div>
                                            </div>
                                        </xsl:if>
                                        
                                        <!-- wenn es kein Abstract gibt, wird auch kein Button dafür angezeigt -->
                                        <xsl:if test="descendant::tei:front/tei:div[@type='abstract']">
                                            <div class="abstract">
                                                <button type="button" data-toggle="collapse" data-target="#abstract" class="transit">Abstract</button>
                                                <div id="abstract">
                                                    <xsl:apply-templates select="//tei:front/tei:div[@type='abstract']/tei:p"/> 
                                                </div>
                                            </div>
                                        </xsl:if>
                                    </div>
                                    <!-- Ende Autor, Datum und Inhalt -->

                                    <!-- AB HIER DANN DER EIGENTLICHE INHALT -->

                                    <div class="content">
                                        <!-- Anfang content -->

                                        <div class="text">
                                            <!-- Text mit h2, h3, p und video -->
                                            <xsl:apply-templates select="//tei:body/tei:div" />
                                        </div>
                                        <!-- Ende Text -->
                                        
                                        <!-- Backmatter --> 
                                        <aside>
                                            <!-- Fußnoten, Anmerkungen, Bibliographie, Autor*in -->
                                            <xsl:if test="//tei:text//tei:note[@place ='foot']">
                                                <div id="fussnoten" class="footnote">
                                                    <hr/>
                                                    <h4>Anmerkungen</h4>
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
                                                                    <a>
                                                                        <xsl:attribute name="href">
                                                                            <xsl:text>#fna</xsl:text>
                                                                            <xsl:number level="any"
                                                                                count="tei:note[@place = 'foot']"/>
                                                                        </xsl:attribute>
                                                                        <xsl:number level="any"
                                                                            count="tei:note[@place = 'foot']"/>
                                                                    </a>
                                                                </div>
                                                                <div class="footnote3">
                                                                    <xsl:apply-templates/>
                                                                </div>
                                                            </li>
                                                        </xsl:for-each>
                                                    </ul>
                                                </div>
                                            </xsl:if>

                                            <!-- Bibliographie -->                                           
                                                <xsl:apply-templates select="//tei:back/tei:div[@type = 'bibliography']"/>
                                            
                                            <!-- Autor*innenhinweis -->                                            
                                                <xsl:apply-templates select="//tei:back/tei:div[@type = 'author-info']"/>
                                            
                                        </aside>
                                    </div>
                                    <!-- Ende content -->
                                    <a href="./#alle_texte" class="home_link transit">&#160; alle
                                        Beiträge</a>
                                </div>
                                <!-- Ende clearfix  -->
                            </article>
                        </div>

                    </main>
                    <a href="javascript:void(0);" onclick="scroller('.top');"
                        class="scroll_top transit">
                        <img src="files/system/images/up.png" width="48" height="48" alt="Up"/>
                    </a>
                    <footer>
                        <div class="verbund">
                            <div class="center">
                                <p>Ein Verbundprojekt von: LMU München, FU Berlin und ZZF Potsdam.
                                    Gefördert vom BMBF.</p>
                                <div class="logos">
                                    <img src="files/system/images/logos/LMU.png" width="360"
                                        height="171"
                                        alt="Logo Ludwig-Maximilians-Universität München"
                                        class="lmu"/>
                                    <img src="files/system/images/logos/fu.png" width="300"
                                        height="82" alt="Logo Freie Universität Berlin" class="fu"/>
                                    <img src="files/system/images/logos/zzf.svg" width="300"
                                        height="197"
                                        alt="Logo Leibniz-Zentrum für Zeithistorische Forschung Potsdam"
                                        class="zzf"/>
                                    <img src="files/system/images/logos/BMBF.svg" width="284"
                                        height="202"
                                        alt="Logo Bundesministerium für Bildung und Forschung"
                                        class="bmbf"/>
                                </div>
                            </div>
                        </div>
                        <div class="legal">
                            <div class="center clearfix">
                                <nav>
                                    <ul>
                                        <li>
                                            <a href="impressum" title="Impressum" class="fadelink"
                                                >Impressum</a>
                                        </li>
                                        <li>
                                            <a href="datenschutz" title="Datenschutz"
                                                class="fadelink">Datenschutz</a>
                                        </li>
                                    </ul>
                                </nav>
                                <div class="copy">© 2022 Forschungsverbund „Das mediale Erbe der
                                    DDR. Akteure, Aneignung, Tradierung“</div>
                            </div>
                        </div>
                    </footer>
                </div>
                <div class="nav_trans transit"/>

                <script src="files/system/js/main.js" />
                    
                <script>
                    // onscroll fadeIn und mehr
                    $('body').delegate('.check', 'inview', function(event, visible) {
                    if (visible) { $(this).addClass('show'); } 
                    else $(this).removeClass('show');
                    });	
                    $('p,h1,h2,h3,figure').addClass('check fade_in');
                    <xsl:text>// fussnoten</xsl:text>	
                    $("a.fn").click(function () { var ziel = $(this).attr('href'); scroller(ziel); return false; });
                    $(".footnote2 a").click(function () { var ziel = $(this).attr('href'); scroller100(ziel); return false; });
                    <xsl:text>// inhalt</xsl:text>
                    $(".inhalt button").click(function () { $('#clipliste').slideToggle(); $(this).toggleClass("active"); });
                    $(".abstract button").click(function () { $('#abstract').slideToggle(); $(this).toggleClass("active"); });
                    <xsl:text>// headline animation</xsl:text>
                    var headline_bottom = $(".headline").position().top;
                    $(window).scroll(function(e){ 
                    var scrolled = $(window).scrollTop();
                    if (scrolled > 2) { $('.headline').css('top', headline_bottom+(scrolled * 0.15) + 'px'); }						
                    });                    
                    // index remove sticky
                    <xsl:comment>if (windowHeight &lt; 600) { $('.author_content').css( "position", "relative" );} </xsl:comment>
                </script>
            </body>
        </html>
    </xsl:template>
    
    <!-- how to format tei elements in (body) text -->
    <xsl:template match="tei:body/tei:div">
        
            <xsl:apply-templates/>
        
    </xsl:template>
    
    <xsl:template match="tei:body//tei:div/tei:div">
        
            <xsl:apply-templates/>
        
    </xsl:template>
    
    <xsl:template match="tei:p">
        <xsl:element name="p">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@xml:id"/>
                </xsl:attribute>                
            </xsl:if>
            <!-- speziell für p in author info -->
            <xsl:if test="parent::tei:div[@type='author-info']">
                <xsl:attribute name="class">
                    <xsl:text>no_style</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
       
    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend = 'italic'">
                <i><xsl:apply-templates/></i>
            </xsl:when>
            <xsl:when test="@rend = 'bold'">
                <b><xsl:apply-templates/></b>
            </xsl:when>
            <xsl:when test="@rend = 'Fußnotenanker'">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:seg">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:epigraph">
        <div class="epigraph">
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!-- how to format Title, Subtitel and Suptitle -->
    <xsl:template match="tei:docTitle">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="tei:titlePart[@type = 'sup']">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    <xsl:template match="tei:titlePart[@type = 'main']">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <xsl:template match="tei:titlePart[@type = 'sub']">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>
    
    <!-- how to format title in teaser image -->
    <xsl:template match="tei:docTitle" mode="inImage">
        <p class="headline2 no_style check fade_in">
            <xsl:apply-templates mode="inImage"/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:titlePart[@type='main']" mode="inImage">
        <span class="maintitle">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    <xsl:template match="tei:titlePart[@type='sub']" mode="inImage">
        <span class="subtitle">
            <xsl:apply-templates />
        </span>
    </xsl:template>
    

    <!-- how to format section titles in table of content -->
    <xsl:template match="tei:div/tei:head" mode="inhaltsvz">
        <li>
            <b>
                <xsl:value-of select="."/>
            </b>
        </li>
    </xsl:template>
    <xsl:template match="tei:div/tei:div/tei:head" mode="inhaltsvz">
        <li>
            <i>
                <xsl:value-of select="."/>
            </i>
        </li>
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
    
    <!-- how to show information about the author in backmatter -->
    <!-- see also if clause in template for tei:p -->
    <xsl:template match="tei:div[@type='author-info']">
        <div id="autor_in">
            <h4>
                <xsl:text>Über </xsl:text>
                <xsl:value-of select="//tei:front//tei:docAuthor"/>
            </h4>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- how to show bibliography in backmatter -->
    <xsl:template match="tei:div[@type='bibliography']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="//tei:div[@type='bibliography']/tei:listBibl">
        <div class="bibliography">
            <xsl:apply-templates select="tei:head"/>
            <ul>
                <xsl:apply-templates select="tei:bibl"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="//tei:listBibl/tei:head">
        <h4>
            <xsl:apply-templates/>
        </h4>
    </xsl:template>
    
    <xsl:template match="//tei:listBibl/tei:bibl">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="//tei:bibl/tei:title">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    
    <!-- how to format abstract -->
    <xsl:template match="//tei:div[@type='abstract']/tei:p">
        <p class="no_style">
            <xsl:apply-templates/>
        </p>
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
    <xsl:template match="tei:figure[@place = 'column' and @type = 'omb']">
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
    <xsl:template match="tei:figure[@type = 'omb' and @place = 'margin']"/>

    <!-- process head and trailier in tei:figure so that inline formats like bold and italic be preserved -->
    <xsl:template match="tei:figure[@type = 'omb']/tei:head">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:figure[@type = 'omb']/tei:trailer">
        <xsl:apply-templates/>
    </xsl:template>
    

    <xsl:template match="tei:media[@type = 'omb']">
        <xsl:variable name="poster">
            <xsl:value-of select="replace(@url, '.+omb_(.+)_480_wm\.mp4', 'files/images/videothumbs/omb$1_')"/>
            <xsl:value-of select="substring(@start,4)"/>
            <xsl:text>.jpg</xsl:text>
        </xsl:variable>
        <xsl:element name="video">
            <xsl:attribute name="controls"/>
            <xsl:attribute name="loop"/>
            <xsl:attribute name="preload">none</xsl:attribute>
            <xsl:attribute name="height">480</xsl:attribute>
            <xsl:attribute name="width">640</xsl:attribute>
            <xsl:attribute name="poster">
                <xsl:value-of select="$poster"/>
            </xsl:attribute>
            <xsl:element name="source">
                <xsl:attribute name="src">
                    <xsl:value-of select="@url"/>
                    <xsl:text>#t=</xsl:text>
                    <xsl:value-of select="replace(@start, 'tc:(\d\d)h(\d\d)m(\d\d)s(\d\d)', '$1:$2:$3.$4')"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="replace(@end, 'tc:(\d\d)h(\d\d)m(\d\d)s(\d\d)', '$1:$2:$3.$4')"/>
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
        <xsl:element name="h2">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tei:div/tei:div/tei:head">
        <xsl:element name="h3">
            <xsl:attribute name="id">
                <xsl:value-of select="@xml:id"/>
            </xsl:attribute>            
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <!-- how to handle graphic elements (basic handling, path need to be completed manually)-->
    <xsl:template match="tei:graphic">
        <picture>
            <xsl:element name="source">
                <xsl:attribute name="srcset">
                    <xsl:value-of select="replace(@url,'media/image(.*)(\..*)','files/images/fullwidth/xxx-abb$1-500$2')"/>
                </xsl:attribute>
                <xsl:attribute name="media">(max-width:500px)</xsl:attribute>
            </xsl:element>
            <xsl:element name="source">
                <xsl:attribute name="srcset">
                    <xsl:value-of select="replace(@url,'media/image(.*)(\..*)','files/images/fullwidth/xxx-abb$1$2')"/>
                </xsl:attribute>
                <xsl:attribute name="media">(min-width:501px)</xsl:attribute>
            </xsl:element>
            <xsl:element name="img">
                <xsl:attribute name="src">
                    <xsl:value-of select="replace(@url,'media/image(.*)','files/images/fullwidth/xxx-abb$1')"/>
                </xsl:attribute>
                <xsl:attribute name="alt">
                    <xsl:value-of select="tei:desc"/>
                </xsl:attribute>
            </xsl:element>
        </picture>
    </xsl:template>
    

</xsl:stylesheet>
