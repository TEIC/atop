<xsl:transform version="3.0" expand-text="yes"
               exclude-result-prefixes="xs"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:template match="spec">
    <functions>
      <xsl:apply-templates/>
    </functions>
  </xsl:template>

  <xsl:template match="example[@role = 'signature']/proto" as="element(function)">
    <function name="{@name}" arity="{count(arg)}"/>
  </xsl:template>

</xsl:transform>
