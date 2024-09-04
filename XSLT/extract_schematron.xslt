<xsl:transform version="3.0" expand-text="yes"
  xpath-default-namespace="http://purl.oclc.org/dsdl/schematron"
               xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:atop="http://www.tei-c.org/ns/atop"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns="http://purl.oclc.org/dsdl/schematron"
               xmlns:tei="http://www.tei-c.org/ns/1.0"
               xmlns:map="http://www.w3.org/2005/xpath-functions/map"
  exclude-result-prefixes="#all">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>This XSLT is passed the URL of a RELAX NG file created by 
      the PLODD transpiler, and extracts the embedded Schematron into 
      a standalone Schematron file. It is configured as a standard transformation
      which outputs a file with the same name as the input RNG but with the 
      .sch extension, in the same folder as the RNG.</xd:p>
      <xd:p>This process is based on assumptions about the structure of 
      the RNG file, and in particular the fact that all Schematron content 
      is grouped at the end of that file.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xd:doc>
    <xd:desc>Output is an XML file.</xd:desc>
  </xd:doc>
  <xsl:output method="xml" encoding="UTF-8" normalization-form="NFC" indent="yes" exclude-result-prefixes="#all"/>
  
  <xd:doc>
    <xd:desc>This may as well be an identity transform.</xd:desc>
  </xd:doc>
  <xsl:mode on-no-match="shallow-copy" exclude-result-prefixes="#all"/>
  
  <xd:doc>
    <xd:desc>The root template does the majority of the work.</xd:desc>
  </xd:doc>
  <xsl:template match="/" as="item()*">
    <xsl:variable name="vOutputFile" as="xs:string" select="replace(base-uri(.), '\.rng$', '.sch')"/>
    <!--<xsl:result-document href="{$vOutputFile}">-->
      <schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding="xslt3"
        xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
        <!-- NOTE: @queryBinding should be configurable in the ODD file, and thence 
             into the RNG file, and into here, but that mechanism is not yet fixed. 
             See https://github.com/TEIC/TEI/issues/2330. -->
        
        <title><xsl:text>Schematron extracted from </xsl:text><xsl:sequence select="tokenize(base-uri(.), '[/\\]')[last()]"/></title>
        <xsl:if test="not(//child::sch:*)">
          <pattern>
            <p><xsl:text>There were no Schematron rules in the processed ODD file.</xsl:text></p>
          </pattern>
        </xsl:if>
        
        <xsl:apply-templates select="//rng:*/child::sch:*"/>
      </schema>
    <!--</xsl:result-document>-->
  </xsl:template>
  
  <xd:doc>
    <xd:desc>This approach is the only one we know which enables nice clean
    Schematron output uncluttered by redundant namespace declarations.</xd:desc>
  </xd:doc>
  <xsl:template match="*" as="element()" exclude-result-prefixes="#all">
    <xsl:element name="{local-name()}" exclude-result-prefixes="#all">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
  </xsl:template>
  
</xsl:transform>
