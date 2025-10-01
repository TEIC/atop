<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
      <xd:p>resolve ODD references at schema specification level</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="modules/functions_module.xslt"/>
  <xsl:mode name="atop:mPass01" on-no-match="shallow-copy"><!-- normalize whitespace in attrs --></xsl:mode>
  <xsl:mode name="atop:mPass02" on-no-match="shallow-copy"><!-- moduleRef expansion --></xsl:mode>
  
  <xd:doc>
    <xd:desc>The source, i.e. a pointer to the base ODD (as an xs:anyURI)</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vSource" select="atop:resolve-uri( ( //schemaSpec/@source, 'tei:current' cast as xs:anyURI )[1], / )" as="xs:anyURI"/>
  
  <xd:doc>
    <xd:desc>The source, i.e. the base ODD (as an entire document node)</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vBaseOdd" as="document-node()">
    <xsl:sequence select="document( $atop:vSource )"/>
  </xsl:variable>
    
  <xd:doc>
    <xd:desc>Match the input document (a customization ODD), process it with a
    micropipeline, and write out the result of the last stage in the pipeline.</xd:desc>
  </xd:doc>
  <xsl:template match="/" name="xsl:initial-template" as="document-node()">
    <xsl:copy>
      <xsl:variable name="vPass01" as="node()+">
        <xsl:apply-templates mode="atop:mPass01"/>
      </xsl:variable>
      <xsl:variable name="vPass02" as="node()+">
        <xsl:apply-templates mode="atop:mPass02"/>
      </xsl:variable>
      <xsl:sequence select="$vPass02"/>
    </xsl:copy>
  </xsl:template>


  <xd:doc>
    <xd:desc>Having extraneous leading or trailing whitespace can mess things up, and we do not
    want to need to issue normalize-space() all over all the time. So just normalize spaces in
    all attrs ahead of time.</xd:desc>
  </xd:doc>
  <xsl:template match="@*" as="attribute()" mode="atop:mPass01">
    <xsl:copy>
      <xsl:sequence select="normalize-space(.)"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>When we hit a &lt;moduleRef> in the customization ODD, replace it
    with the specifications of the base ODD that are in that module (as adjusted
    by its @include or @except attribute)</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec/moduleRef" as="item()+" mode="atop:mPass02">
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
  
</xsl:stylesheet>
