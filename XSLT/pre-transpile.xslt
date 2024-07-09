<xsl:transform version="3.0" expand-text="yes"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:atop="http://www.tei-c.org/ns/atop"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:map="http://www.w3.org/2005/xpath-functions/map"
               xmlns="http://www.tei-c.org/ns/1.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>Preparatory process which handles some infelicities in the incoming
      PLODD prior to the actual transpilation process.</xd:p>
    </xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:desc>This is an identity transform</xd:desc>
  </xd:doc>
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xd:doc>
    <xd:desc>As of 2022-08-17 some ODDs contain empty attLists.</xd:desc>
  </xd:doc>
  <xsl:template as="item()*" match="attList[empty(*)]"/>
  
  <xd:doc>
    <xd:desc>As of 2022-08-17 ODDs that declare attributes from the XML
      namespace 'http://www.w3.org/XML/1998/namespace' use a colonized
      name in @ident rather then a non-colonized name and @ns.</xd:desc>
  </xd:doc>
  <xsl:template as="element(attDef)" match="attDef[starts-with(@ident, 'xml:')][empty(@ns)]">
    <xsl:copy>
      <xsl:sequence select="@* except @ident"/>
      <xsl:attribute name="ident" select="substring-after(@ident, ':')"/>
      <xsl:attribute name="ns" select="'http://www.w3.org/XML/1998/namespace'"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:transform>
