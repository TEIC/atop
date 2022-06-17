<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:rng="http://relaxng.org/ns/structure/1.0">
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:variable name="MRMProsopRef" as="document-node()" select="doc('MRMProsopRef.odd')"/>

    <!--2018-08-08 ebb: This is an XSLT identity transformation designed to combine the mitfordEditable.odd with the MRMProsopRef.odd, to create the complete mitfordODD.odd. 
            Run this over mitfordEditable.odd to pull in elements from MRMProsopRef.odd, and output to mitfordODD.odd
           -->
    <xsl:template match="teiHeader">
        <xsl:copy-of select="$MRMProsopRef//teiHeader"/>
    </xsl:template>
    
<xsl:template match="body">
  <body>  
      <schemaSpec ident="mitfordODD" start="TEI teiCorpus" prefix="tei">
         <xsl:copy-of select="descendant::moduleRef"/>
        <xsl:copy-of select="descendant::constraintSpec"/>
        <xsl:copy-of select="descendant::elementSpec"/>
        <xsl:apply-templates select="$MRMProsopRef//specGrp/*"/>
    </schemaSpec>
  </body>
</xsl:template>
</xsl:stylesheet>
    
    
