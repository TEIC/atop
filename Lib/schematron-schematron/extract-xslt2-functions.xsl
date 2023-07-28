<xsl:transform version="3.0" expand-text="yes"
               exclude-result-prefixes="xs"
               xpath-default-namespace="http://www.w3.org/1999/xhtml"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:template match="/">
    <functions>
      <xsl:apply-templates/>
    </functions>
  </xsl:template>

  <xsl:template match="div[@class = 'proto']">
    <function name="{code[@class = 'function']}" arity="{count(code[@class = 'arg'])}"/>
  </xsl:template>

</xsl:transform>
