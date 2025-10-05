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
      <xd:p><xd:b>Created:</xd:b> 2025-10-05.</xd:p>
      <xd:p><xd:b>Author:</xd:b> ATOP task force</xd:p>
      <xd:p>One of several approaches to ODD derivation (applying 
      a customization to a base ODD). This transformation is applied to itself
      as the source file, and loads the resources it needs from parameters
      documented below.</xd:p>
    </xd:desc>
    <xd:param name="atop:pBaseOddPath">The path to the fully-derived base ODD.</xd:param>
    <xd:param name="atop:pCustOddPath">The path to the customization ODD to be applied to it.</xd:param>
    <xd:param name="atop:pOutputPath">The path where we save the resulting derived ODD.</xd:param>
  </xd:doc>
  
  <xd:doc>
    <xd:desc>We use the global functions module.</xd:desc>
  </xd:doc>
  <xsl:include href="modules/functions_module.xslt"/>
  
  <xd:doc>
    <xd:desc>XML in, XML out.</xd:desc>
  </xd:doc>
  <xsl:output method="xml" indent="yes" encoding="UTF-8" normalization-form="NFC"/>
  
  <xd:doc>
    <xd:desc>Default processing is to copy myself and continue processing; this 
      applies to every mode.</xd:desc>
  </xd:doc>
  <xsl:mode name="atop:mDeletion" on-no-match="shallow-copy"/>
  <xd:doc>
    <xd:desc>Default processing is to copy myself and continue processing; this 
      applies to every mode.</xd:desc>
  </xd:doc>
  <xsl:mode name="atop:mAddition" on-no-match="shallow-copy"/>
  <xd:doc>
    <xd:desc>Default processing is to copy myself and continue processing; this 
      applies to every mode.</xd:desc>
  </xd:doc>
  <xsl:mode name="atop:mReplacement" on-no-match="shallow-copy"/>
  <xd:doc>
    <xd:desc>Default processing is to copy myself and continue processing; this 
      applies to every mode.</xd:desc>
  </xd:doc>
  <xsl:mode name="atop:mSanityCheck" on-no-match="shallow-copy"/>
  
  <xd:doc>
    <xd:desc>The path to the fully-derived base ODD against which we will
    apply the customization.</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pBaseOddPath" as="xs:string"/>
  
  <xd:doc>
    <xd:desc>The path to the customization that will be applied to it.</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pCustOddPath" as="xs:string"/>
  
  <xd:doc>
    <xd:desc>The path to output the resulting derived ODD.</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pOutputPath" as="xs:string"/>
  
  <xd:doc>
    <xd:desc>The file loaded from the base ODD path.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vBaseOdd" as="document-node()" select="doc($atop:pBaseOddPath)"/>
  
  <xd:doc>
    <xd:desc>The file loaded from the customization ODD path.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vCustOdd" as="document-node()" select="doc($atop:pCustOddPath)"/>
  
  <!-- Here beginneth a collection of useful maps and string-sequences, created 
       from the customization file, such that templates in any of the phases of 
       the process may match against string sequence or the map:keys from the 
       relevant sequence or map. So for example, an element in the base ODD which 
       matches against the atop:vDeletions string sequence may be deleted in Phase 
       1, while any element or attribute that matches against the map:keys for 
       the atop:vMapReplacements map would be replaced by the value found in that
       map. -->
  
  <!-- For unique identifiers, we use our atop:unique-ident() function for now. -->
  <xd:doc>
    <xd:desc>List of unique idents for items to be deleted.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vDeletions" as="xs:string*" 
    select="for $i in $atop:vCustOdd/descendant::node()[@mode='delete'] return atop:unique-ident($i)"/>
  
  <xd:doc>
    <xd:desc>A map of unique idents to the things from the customization that will replace them.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vMapReplacements" as="map(xs:string, node())">
    <xsl:map>
      <xsl:for-each select="$atop:vCustOdd/descendant::node()[@mode='replace']">
        <xsl:map-entry key="atop:unique-ident(.)" select="."/>
      </xsl:for-each>
    </xsl:map>
  </xsl:variable>
  
  <xd:doc>
    <xd:desc>The root template kicks off the transformation.</xd:desc>
  </xd:doc>
  <xsl:template match="/">
    <!-- Phase 1: Deletions. -->
    
    <!-- Phase 2: Additions. -->
    
    <!-- Phase 3: Replacements. -->
    
    <!-- Phase 4: Sanity checks. -->
    
    <!-- Phase 5: Output. -->
  </xsl:template>
  
</xsl:stylesheet>
