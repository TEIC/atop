<xsl:transform version="3.0" expand-text="yes"
               default-mode="atop:rngCombine"
               xmlns:atop="http://www.tei-c.org/ns/atop"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode name="atop:rngCombine" on-no-match="shallow-copy"/>

  <xsl:template match="rng:grammar" as="element()">
    <xsl:param name="pIsInclusion" as="xs:boolean" select="false()"/>
    <xsl:element name="rng:{if ($pIsInclusion) then 'div' else 'grammar'}">
      <xsl:sequence select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:element>
  </xsl:template>

  <!-- The externalRef pattern is a reference to an external
       schema. It has the same effect as replacing the externalRef
       pattern with the external schema, which is treated as a
       pattern. -->
  <xsl:template match="rng:externalRef">
    <xsl:comment>BEGIN {resolve-uri(@href, base-uri(@href))}</xsl:comment>
    <xsl:apply-templates select="doc(resolve-uri(@href, base-uri(@href)))"/>
    <xsl:comment>END {resolve-uri(@href, base-uri(@href))}</xsl:comment>
  </xsl:template>

  <!-- The include pattern includes a grammar and merges its
       definitions with the definitions of the current grammar. The
       definitions of the included grammar may be redefined and
       overridden by the definitions embedded in the include
       pattern. Note that a schema must contain an explicit grammar
       definition in order to be included. -->
  <xsl:template match="rng:include">
    <xsl:variable name="vInclusion" as="document-node(element())">
      <xsl:apply-templates select="doc(resolve-uri(@href, base-uri(@href)))">
        <xsl:with-param name="pIsInclusion" as="xs:boolean" select="true()"/>
        <xsl:with-param name="tpSkipPattern" tunnel="yes" as="xs:string*" select=".//rng:define/@name ! string()"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:comment>BEGIN {resolve-uri(@href, base-uri(@href))}</xsl:comment>
    <xsl:sequence select="$vInclusion"/>
    <xsl:comment>END {resolve-uri(@href, base-uri(@href))}</xsl:comment>
    <xsl:sequence select="*"/>
    <xsl:apply-templates select="node()">
      <xsl:with-param name="tpSkipPattern" tunnel="yes" as="xs:string*" select=".//rng:define/@name ! string()"/>
      <xsl:with-param name="tpSkipStart" tunnel="yes" as="xs:boolean" select="exists(.//rng:start)"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="rng:define" as="element(rng:define)?">
    <xsl:param name="tpSkipPattern" tunnel="yes" as="xs:string*"/>
    <xsl:if test="not(@name = $tpSkipPattern)">
      <xsl:sequence select="."/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="rng:start" as="element(rng:start)?">
    <xsl:param name="tpSkipStart" tunnel="yes" as="xs:boolean" select="false()"/>
    <xsl:if test="not($tpSkipStart)">
      <xsl:sequence select="."/>
    </xsl:if>
  </xsl:template>

</xsl:transform>
