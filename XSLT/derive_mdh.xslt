<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:atop="http://www.tei-c.org/ns/atop"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  expand-text="yes"
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
      applies to every mode. The mCollection mode is where we interrogate the 
      moduleRefs in the customization and pull in all the starting points from
      the base ODD.
    </xd:desc>
  </xd:doc>
  <xsl:mode name="atop:mCollection" on-no-match="shallow-copy"/>
  
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
  
  <xd:doc>
    <xd:desc>A map of all spec elements from their idents to their module.
    So if a module is not included for a specific ident, then the item
    itself can be discarded.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vMapSpecIdentsToModuleIdents" as="map(xs:string, xs:string)">
    <xsl:map>
      <xsl:for-each select="$atop:vBaseOdd//*[@module and @ident]">
        <xsl:map-entry key="xs:string(@ident)" select="xs:string(@module)"/>
      </xsl:for-each>
    </xsl:map>
  </xsl:variable>
  
  <xd:doc>
    <xd:desc>A list of all elementSpecs which should be included, based on
      moduleRef/@include and moduleRef/@exclude.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vElementIdentsToInclude" as="xs:string*">
    <xsl:for-each select="$atop:vCustOdd//moduleRef">
      <xsl:variable name="vModuleRef" as="element(moduleRef)" select="."/>
      <xsl:variable name="vElementIdents" as="xs:string*" select="$atop:vBaseOdd//elementSpec[@module = $vModuleRef/@key]/xs:string(@ident)"/>
      <xsl:variable name="vIncludes" as="xs:string*" select="if ($vModuleRef/@include) then tokenize(normalize-space($vModuleRef/@include), '\s+') else ()"/>
      <xsl:variable name="vExcepts" as="xs:string*" select="if ($vModuleRef/@except) then tokenize(normalize-space($vModuleRef/@except), '\s+') else ()"/>
      <xsl:sequence select="$vElementIdents[(not($vIncludes) and not($vExcepts)) or (. = $vIncludes) or (not($vIncludes) and not(. = $vExcepts))]"/>
    </xsl:for-each>
  </xsl:variable>
  
  <xd:doc>
    <xd:desc>A sequence of all the moduleRef/@key attributes so we can
    easily check when a *Spec element needs to be included.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vModuleIdentsToInclude" as="xs:string*" select="$atop:vCustOdd//moduleRef/xs:string(@key)"/>
  
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
  <xsl:template match="/" as="item()*">
    
    <xsl:variable name="vInputSpecs" as="element(schemaSpec)">
      <xsl:choose>
        <xsl:when test="$atop:vBaseOdd/descendant::schemaSpec">
          <xsl:copy-of select="$atop:vBaseOdd/descendant::schemaSpec"/>
        </xsl:when>
        <xsl:otherwise>
          <schemaSpec>
            <xsl:sequence select="$atop:vBaseOdd/descendant::node()[ends-with(local-name(.), 'Spec')]"/>
          </schemaSpec>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <!-- Phase 1: pull in what is required based on moduleRefs. -->
    
    <xsl:variable name="vCollectionDone" as="node()*">
      <xsl:apply-templates select="$vInputSpecs" mode="atop:mCollection">
        <!--<xsl:with-param name="tpModuleRefs" as="element(moduleRef)*" select="$atop:vCustOdd//moduleRef" tunnel="yes"/>-->
      </xsl:apply-templates>
    </xsl:variable>
    
    <!-- Phase 2: Deletions. -->
    <xsl:variable name="vDeletionsDone" as="node()*">
      <xsl:apply-templates select="$vCollectionDone" mode="atop:mDeletion"/>
    </xsl:variable>
    
    <!-- Phase 3: Additions. -->
    <xsl:variable name="vAdditionsDone" as="node()*">
      <xsl:apply-templates select="$vDeletionsDone" mode="atop:mAddition"/>
    </xsl:variable>
    
    <!-- Phase 4: Replacements. -->
    <xsl:variable name="vReplacementsDone" as="node()*">
      <xsl:apply-templates select="$vAdditionsDone" mode="atop:mReplacement"/>
    </xsl:variable>
    
    <!-- Phase 5: Sanity checks. -->
    
    <!-- Phase 6: Output. -->
    <xsl:result-document href="{$atop:pOutputPath}">
      <xsl:sequence select="$vReplacementsDone"/>
    </xsl:result-document>
  </xsl:template>
  
  <!-- Template(s) in the atop:mCollection mode. -->
  <xd:doc>
    <xd:desc>We match moduleSpecs to check whether they should be included
      or not, based on the moduleRefs.</xd:desc>
    <xd:param name="tpModuleRefs" as="element(moduleRef)*" tunnel="yes">The moduleRef elements from the customization ODD.</xd:param>
  </xd:doc>
  <xsl:template match="moduleSpec" as="element(moduleSpec)?" mode="atop:mCollection">
    <xsl:param name="tpModuleRefs" as="element(moduleRef)*" tunnel="yes"/>
    <xsl:if test="@ident = ($tpModuleRefs/@key)">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>We match elementSpecs to check whether they should be included
    or not, based on the moduleRefs.</xd:desc>
  </xd:doc>
  <xsl:template match="elementSpec[not(xs:string(@ident) = $atop:vElementIdentsToInclude)]" as="item()" mode="atop:mCollection">
    <xsl:comment>elementSpec with @ident={@ident} omitted.</xsl:comment>
  </xsl:template> 
  
  <xd:doc>
    <xd:desc>Any classSpec that has a module attribute matching the 
    ident of one of the included moduleRefs gets included; otherwise
    they're deleted.</xd:desc>
  </xd:doc>
  <xsl:template match="classSpec[not(xs:string(@module) = $atop:vModuleIdentsToInclude)]" as="item()" mode="atop:mCollection">
    <xsl:comment>classSpec with @ident={@ident} omitted.</xsl:comment>
  </xsl:template>
    
  <!-- Template(s) in the atop:mDeletion mode. -->
  <xd:doc>
    <xd:desc>A template matching anything that needs to be deleted.</xd:desc>
  </xd:doc>
  <!--<xsl:template match="node()[atop:unique-ident(.) = $atop:vDeletions]" mode="atop:mDeletion"/>-->
  
</xsl:stylesheet>
