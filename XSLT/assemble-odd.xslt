<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:atop="http://www.tei-c.org/ns/atop"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xd:doc>
    <xd:desc>Version number of this program</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vVersion" select="'0.0.1'" as="xs:string"/>
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created:</xd:b> 2024-08-22.</xd:p>
      <xd:p><xd:b>Author:</xd:b> ATOP task force</xd:p>
      <xd:p>Routine to read in an ODD (whether a customization ODD or
      a base ODD, although will likely not have much work to do on the
      latter) and writes out the same with external references
      resolved.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8" normalization-form="NFC"/>
  
  <xd:doc>
    <xd:desc>Default processing is to copy myself and continue processing …</xd:desc>
  </xd:doc>
  <xsl:mode on-no-match="shallow-copy" name="atop:slurpInnards"/>
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xd:doc>
    <xd:desc>Expand module references that point to external
      schemas. The use of the value <val>.</val> for
      <att>url</att> is not strictly necessary, but ATOP uses it to
      signify that the content is here and now, and no longer
      external.</xd:desc>
  </xd:doc>
  <xsl:template match="moduleRef[@url]" as="element(moduleRef)">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- Use a value of ‘.’ (U+002E) on @url to signify that the content is here and now, not external. -->
      <xsl:attribute name="url" select="'.'"/>
      <content>
        <xsl:apply-templates select="content/@*"/>
        <xsl:apply-templates select="content/*"/>
        <xsl:if test="doc-available( @url )">
          <xsl:comment select="'========= from '||normalize-space(@url)||' ========='"/>
          <xsl:copy-of select="doc(@url)"/>
        </xsl:if>
      </content>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Read in a <gi>*Ref</gi> that points to an external source,
    replace it with the correpsonding <gi>*Spec</gi>s from that source.</xd:desc>
  </xd:doc>
  <xsl:template match="(classRef|dataRef|elementRef|macroRef|moduleRef)
                       [ parent::schemaSpec | parent::specGrp ]
                       [ @source ]" as="node()">
    <xsl:variable name="vKey" select="normalize-space(@key)" as="xs:string"/>
    <xsl:variable name="vSource" select="normalize-space(@source)" as="xs:string"/>
    <xsl:variable name="vSpecName" select="replace( local-name(.), 'Ref$','Spec') => xs:NCName()" as="xs:NCName"/>
    <xsl:variable name="vSourceDoc" select="document( atop:source-to-url( $vSource ) )" as="document-node()"/>
    <xsl:message select="'debug: I seek '||$vSpecName||'[ @ident eq '||$vKey||' ] in '||atop:source-to-url( $vSource )"/>
    <xsl:variable name="vSpecToSlurpIn" as="element()*">
      <xsl:evaluate context-item="$vSourceDoc" xpath="'//'||$vSpecName||'[ @ident eq &quot;'||$vKey||'&quot; ]'"/>
    </xsl:variable>
    <xsl:message select="'debug: I have '
      ||count($vSpecToSlurpIn)
      ||' to slurp in, name(s): '
      ||$vSpecToSlurpIn!name() => string-join(', ')"/>
    <xsl:apply-templates select="$vSpecToSlurpIn" mode="atop:slurp"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>process the <gi>*Spec</gi> from source (as opposed to the input).
    At the moment, proccessing is just copying it over, except that the @mode
    of the outermost element copied from the source is set to "replace".</xd:desc>
  </xd:doc>
  <xsl:template match="*" mode="atop:slurp" as="element()">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="atop:slurpInnards"/>
      <xsl:if test="@mode eq 'add' or not( @mode )">
        <xsl:attribute name="mode" select="'replace'"/>
      </xsl:if>
      <xsl:apply-templates select="node()" mode="atop:slurpInnards"/>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>DUMMY function — real version will be in XSLT/modules/functions_module.xslt soon</xd:desc>
    <xd:param name="pSource"/>
  </xd:doc>
  <xsl:function name="atop:source-to-url" as="xs:anyURI" visibility="public">
    <xsl:param name="pSource" as="xs:string"/>
    <xsl:sequence select="'https://tei-c.org/Vault/P5/2.0.0/xml/tei/odd/p5subset.xml' cast as xs:anyURI"/>
  </xsl:function>
  
</xsl:stylesheet>
