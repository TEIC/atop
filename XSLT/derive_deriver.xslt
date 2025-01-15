<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:XSL="http://www.w3.org/1999/XSL/TransformAlias"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
		xmlns="http://www.tei-c.org/ns/1.0"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:teix="http://www.tei-c.org/ns/Examples"
		xmlns:atop="http://www.tei-c.org/ns/atop"
		xpath-default-namespace="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="#all"
		version="3.0">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Dec 18, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
      <xd:param>STDIN = a customization ODD</xd:param>
      <xd:param>source = the original base ODD referred to by the
      cusomization specified as STDIN</xd:param>
      <xd:param>STDERR = information &amp; debugging messages</xd:param>
      <xd:param>STDOUT = an XSLT program which, when applied to the
      original base ODD, will produce the derived ODD</xd:param>
    </xd:desc>
  </xd:doc>
  
  <xsl:namespace-alias stylesheet-prefix="XSL" result-prefix="xsl"/>
  <xsl:output method="xml" indent="yes"/>
  <xsl:mode name="atop:mPhase1ResolveModuleRefs" on-no-match="shallow-copy"/>
  <xsl:mode name="atop:mPhase2DeriveOdd" on-no-match="shallow-skip"/>
  <xsl:mode name="mCopy" on-no-match="deep-copy"/>
  <xsl:include href="modules/functions_module.xslt"/>
  
  <xd:doc>
    <xd:desc>generate intermediate files in /tmp/ folder iff true</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pDebug" select="true()" as="xs:boolean"/>
  
  <xd:doc>
    <xd:desc>Easier to generate strings with variables, sometimes</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vApos" as="xs:string">&apos;</xsl:variable>

  <xd:doc>
    <xd:desc>The input, i.e. the customization ODD itself</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vInput" select="/" as="document-node()"/>
  
  <xd:doc>
    <xd:desc>The source, i.e. a pointer to the base ODD (as an xs:anyURI)</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vSource" select="atop:resolve-uri( ( //schemaSpec/@source, 'tei:current' cast as xs:anyURI )[1], / )" as="xs:anyURI"/>
  
  <xd:doc>
    <xd:desc>The source, i.e. the base ODD itself</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vBaseOdd" as="document-node()">
    <xsl:sequence select="document( $atop:vSource )"/>
  </xsl:variable>
    
  <xd:doc>
    <xd:desc>name of this XSLT pgm, for debugging</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vMyName" select="tokenize( static-base-uri(),'/')[last()]" as="xs:string"/>

  <xd:doc>
    <xd:desc>name of input file, for debugging</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vInputName" select="tokenize( base-uri(),'/')[last()]" as="xs:string"/>

  <xd:doc>
    <xd:desc>Subroutine for debugging</xd:desc>
    <xd:param name="pMostRecentPass">and indicator of the mode of pass we just finished</xd:param>
    <xd:param name="pDebugOutput">the result of that pass (as a document or element node)</xd:param>
  </xd:doc>
  <xsl:template name="atop:t-maybe-write-debug-file" as="item()*">
    <xsl:param name="pMostRecentPass" as="xs:string"/>
    <xsl:param name="pDebugOutput" as="node()"/>
    <xsl:if test="$atop:pDebug">
      <xsl:variable name="vDebugFilename"
                    select="'/tmp/'
                          ||replace( $atop:vMyName, '\.xslt?', '')
                          ||'_'
                          ||replace( $atop:vInputName, '\..*$', '')
                          ||'_post-pass_'
                          ||$pMostRecentPass" as="xs:string"/>
      <xsl:result-document href="{$vDebugFilename}.xml">
        <xsl:sequence select="$pDebugOutput"/>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>********* main driver template *********</xd:p>
      <xd:p>On initial match of the input document (a customization ODD) set up and
        initiate our micro-pipeline.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template match="/" name="xsl:initial-template" as="item()*">
    <!-- phase 1 — resolve <moduleRef>s -->
    <xsl:variable name="vPhase1ResolvedModuleRefs" as="element(TEI)">
      <xsl:apply-templates mode="atop:mPhase1ResolveModuleRefs"/>
    </xsl:variable>
    <xsl:call-template name="atop:t-maybe-write-debug-file">
      <xsl:with-param name="pMostRecentPass" select="'mPhase1ResolveModuleRefs'" as="xs:string"/>
      <xsl:with-param name="pDebugOutput" select="$vPhase1ResolvedModuleRefs" as="element(TEI)"/>
    </xsl:call-template>
    
    <!-- phase 2 — generate XSLT -->
    <xsl:variable name="vPhase2Deriver" as="element(xsl:transform)">
      <xsl:apply-templates mode="atop:mPhase2DeriveOdd" select="$vPhase1ResolvedModuleRefs"/>
    </xsl:variable>
    <xsl:call-template name="atop:t-maybe-write-debug-file">
      <xsl:with-param name="pMostRecentPass" select="'mPhase2DeriveOdd'" as="xs:string"/>
      <xsl:with-param name="pDebugOutput" select="$vPhase2Deriver" as="element(xsl:transform)"/>
    </xsl:call-template>

    <!-- phase 4 — apply XSLT -->
    <xsl:variable name="vTransformationMap" as="map(*)">
      <xsl:map>
        <xsl:map-entry key="'stylesheet-node'" select="$vPhase2Deriver"/>
        <xsl:map-entry key="'source-node'" select="$atop:vBaseOdd"/>
      </xsl:map>
    </xsl:variable>
    <xsl:sequence select="transform($vTransformationMap)?output"/>

  </xsl:template>

  <xd:doc>
    <xd:desc>******** mode phase 1 = resolve moduleRefs ********</xd:desc>
  </xd:doc>
  <xd:doc>
    <xd:desc>When we hit a &lt;moduleRef> in the customization ODD, replace it
    with the specifications of the base ODD that are in that module (as adjusted
    by its @include or @except attribute)</xd:desc>
  </xd:doc>
  <xsl:template mode="atop:mPhase1ResolveModuleRefs" match="schemaSpec/moduleRef" as="item()+">
    <xsl:variable name="vModule" select="normalize-space( @key )" as="xs:string"/>
    <xsl:variable name="vIncludes" select="tokenize( @include )" as="xs:string*"/>
    <xsl:variable name="vExcepts" select="tokenize( @except )" as="xs:string*"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** class specifications in {$vModule} from {$atop:vSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//classSpec[ @module eq $vModule ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** data specifications in {$vModule} from {$atop:vSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//dataSpec[ @module eq $vModule ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** element specifications in {$vModule} from {$atop:vSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//elementSpec[ @module eq $vModule ][ not( @ident = $vExcepts ) ][ not( current()/@include ) or @ident = $vIncludes ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** macro specifications in {$vModule} from {$atop:vSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//macroSpec[ @module eq $vModule ]"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>********* phase 2 = generate customizer transformation ********</xd:desc>
  </xd:doc>
  
  <xd:doc>
    <xd:desc>On match of &lt;TEI>, generate outer shell of XSLT transformation</xd:desc>
  </xd:doc>
  <xsl:template mode="atop:mPhase2DeriveOdd" match="TEI" as="element(xsl:transform)">
    <XSL:transform version="3.0"
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns="http://www.tei-c.org/ns/1.0"
      xmlns:tei="http://www.tei-c.org/ns/1.0"
      xmlns:teix="http://www.tei-c.org/ns/Examples"
      xmlns:atop="http://www.tei-c.org/ns/atop"
      xpath-default-namespace="http://www.tei-c.org/ns/1.0"
      >
      <xsl:call-template name="atop:t-health-warning"/>
      <XSL:output method="xml" indent="yes"/>
      <XSL:mode on-no-match="shallow-copy"/>
      <XSL:mode name="mCopy" on-no-match="deep-copy" xmlns:atop="http://www.tei-c.org/ns/atop"/>
      <XSL:template match="/">
        <XSL:call-template name="derived-health-warning"/>
        <XSL:apply-templates select="*"/>
      </XSL:template>
      <xsl:apply-templates mode="#current"/>
    </XSL:transform>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>On match of &lt;teiHeader> generate useful metadata for output</xd:desc>
  </xd:doc>
  <xsl:template mode="atop:mPhase2DeriveOdd" match="teiHeader" as="item()+">
    <XSL:template name="derived-health-warning">
      <xsl:element name="xsl:variable">
        <xsl:attribute name="name" select="'timestamp'"/>
        <xsl:attribute name="select" select='"&apos;"||current-dateTime()||"&apos;"'/>
      </xsl:element>
      <xsl:element name="xsl:variable">
        <xsl:attribute name="name" select="'customizationODD'"/>
        <xsl:attribute name="select" select='"&apos;"||base-uri()||"&apos;"'/>
      </xsl:element>
      <xsl:element name="xsl:variable">
        <xsl:attribute name="name" select="'source'"/>
        <xsl:attribute name="select" select='"&apos;"||($atop:vInput//schemaSpec/@source, "tei:current")[1]||"&apos;"'/>
      </xsl:element>
      <xsl:element name="xsl:variable">
        <xsl:attribute name="name" select="'processor'"/>
        <xsl:attribute name="select" select='"&apos;"||static-base-uri()||"&apos;"'/>
      </xsl:element>
      <xsl:element name="xsl:variable">
        <xsl:attribute name="name" select="'schemaName'"/>
        <XSL:sequence select="if (//schemaSpec/@xml:id | //schemaSpec/@ident) then '/'||( //schemaSpec/@ident, //schemaSpec/@xml:id )[1] else ''"/>
      </xsl:element>
      <xsl:element name="xsl:variable">
        <xsl:attribute name="name" select="'title'"/>
        <XSL:sequence select="normalize-space( /*/teiHeader/fileDesc/titleStmt/title[1] )||$schemaName"/>
      </xsl:element>
      <XSL:comment>
        <xsl:text>&#x0A;</xsl:text>
        <XSL:text>&#x0A;* This is the derived ODD file “</XSL:text>
        <XSL:value-of select="$title"/>
        <xsl:text>” generated </xsl:text>
        <XSL:value-of select="current-dateTime()"/>
        <xsl:text>&#x0A;</xsl:text>
        <XSL:text>&#x0A;* with input </XSL:text>
        <XSL:value-of select="$customizationODD"/>
        <xsl:text>&#x0A;</xsl:text>
        <XSL:text>&#x0A;* by </XSL:text>
        <XSL:value-of select="static-base-uri()"/>
        <xsl:text>&#x0A;</xsl:text>
        <XSL:text>&#x0A;* itself generated</XSL:text>
        <XSL:value-of select="$timestamp"/>
        <xsl:text>&#x0A;</xsl:text>
        <XSL:text>&#x0A;* by </XSL:text>
        <XSL:value-of select="$processor"/>
        <xsl:text>&#x0A;&#xA0;</xsl:text>
      </XSL:comment>
    </XSL:template>
    <!-- (at least for now) no further processing of anything <teiHeader>-related. -->
    <XSL:template match="teiHeader//node()"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>When we hit an added specification in the input document, just copy it over</xd:desc>
  </xd:doc>
  <xsl:template mode="atop:mPhase2DeriveOdd" as="element(xsl:template)"
    match="(classSpec|dataSpec|elementSpec|macroSpec)[@mode eq 'add' or not(@mode)]">
    <xsl:variable name="vMatcher" as="xs:string+">
      <xsl:sequence select="name(.)"/>
      <xsl:for-each select="@*">
        <xsl:text>[@</xsl:text>
        <xsl:sequence select="name(.)"/>
        <xsl:text> eq '</xsl:text>
        <xsl:sequence select="."/>
        <xsl:text>']</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <XSL:template match="{string-join($vMatcher)}">
      <XSL:copy>
        <XSL:apply-templates select="@*|node()" mode="mCopy" xmlns:atop="http://www.tei-c.org/ns/atop"/>
      </XSL:copy>
    </XSL:template>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Place a warning in the XSLT we generate so that if &amp; when it is
    serialized, folks are warned it is a temporary file.</xd:desc>
  </xd:doc>
  <xsl:template name="atop:t-health-warning" as="item()+">
    <xsl:text>&#x0A;</xsl:text>
      <xsl:comment> *** This is a derived XSLT program, DO NOT EDIT! *** </xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment> * To make changes modify <xsl:sequence select="base-uri()"/> and </xsl:comment>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment> * re-run <xsl:sequence select="static-base-uri()"/> on it. </xsl:comment>
  </xsl:template>

</xsl:stylesheet>
