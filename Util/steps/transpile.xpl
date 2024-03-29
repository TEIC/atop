<p:declare-step version="3.0" type="atop:transpile"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:tei="http://www.tei-c.org/ns/1.0">

  <p:documentation>Run the transpiler for the corresponding ODD and validate the result as valid RelaxNG.</p:documentation>

  <p:output port="result" serialization="map{'indent': true()}"/>
  <p:input  port="source"/>

  <p:delete match="tei:attList[empty(*)]">
    <p:documentation>
      As of 2022-08-17 some ODDs contain empty attLists.
    </p:documentation>
  </p:delete>

  <p:xslt>
    <p:documentation>
      As of 2022-08-17 ODDs that declare attributes from the XML
      namespace 'http://www.w3.org/XML/1998/namespace' use a colonized
      name in @ident rather then a non-colonized name and @ns.
    </p:documentation>
    <p:with-input port="stylesheet">
      <p:inline>
        <xsl:transform version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                       xpath-default-namespace="http://www.tei-c.org/ns/1.0">
          <xsl:mode on-no-match="shallow-copy"/>
          <xsl:template match="attDef[starts-with(@ident, 'xml:')][empty(@ns)]">
            <xsl:copy>
              <xsl:sequence select="@* except @ident"/>
              <xsl:attribute name="ident" select="substring-after(@ident, ':')"/>
              <xsl:attribute name="ns" select="'http://www.w3.org/XML/1998/namespace'"/>
              <xsl:apply-templates select="node()"/>
            </xsl:copy>
          </xsl:template>
        </xsl:transform>
      </p:inline>
    </p:with-input>
  </p:xslt>

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document content-type="application/xml" href="../../XSLT/transpile.xslt"/>
    </p:with-input>
  </p:xslt>

</p:declare-step>
