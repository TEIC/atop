<xsl:transform version="3.0" expand-text="yes"
               xpath-default-namespace="http://www.w3.org/xpath-functions/spec/namespace"
               exclude-result-prefixes="xs"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:template match="functions">
    <functions>
      <xsl:apply-templates/>
    </functions>
  </xsl:template>

  <xsl:template match="function/signatures/proto">
    <function name="{@name}" arity="{count(arg)}"/>
  </xsl:template>

</xsl:transform>
