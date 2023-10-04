<p:declare-step version="3.0" type="atop:legacy-odd2odd"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source"/>
  <p:output port="result"/>

  <p:xslt parameters="map{'defaultSource': resolve-uri('../../Tests/resources/p5subset.xml', static-base-uri())}">
    <p:with-input port="stylesheet" href="../../XSLT/legacy-odd2odd.xsl"/>
  </p:xslt>

  <p:group>
    <p:documentation>
      As of 2022-08-17 the odds/odd2odd.xsl of the current ODD
      processor removes specification items but does *not* remove
      references to those items.
    </p:documentation>
    <p:output port="result"/>
    <p:xslt>
      <p:with-input port="stylesheet">
        <p:inline>
          <xsl:transform version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                         xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <xsl:mode on-no-match="shallow-copy"/>
            <xsl:key name="specItem" match="classSpec | dataSpec | elementSpec | macroSpec" use="@ident"/>
            <xsl:template match="classRef | dataRef[@key] | elementRef | macroRef | memberOf">
              <xsl:if test="key('specItem', @key)">
                <xsl:copy>
                  <xsl:apply-templates select="@* | node()"/>
                </xsl:copy>
              </xsl:if>
            </xsl:template>
          </xsl:transform>
        </p:inline>
      </p:with-input>
    </p:xslt>

    <p:xslt>
      <p:with-input port="stylesheet">
        <p:inline>
          <xsl:transform version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                         xpath-default-namespace="http://www.tei-c.org/ns/1.0">
            <xsl:mode on-no-match="shallow-copy"/>

            <xsl:template match="(alternate | sequence)[empty(.//(anyElement | classRef | dataRef | elementRef | empty | macroRef | textNode))]"/>

          </xsl:transform>
        </p:inline>
      </p:with-input>
    </p:xslt>
  </p:group>

</p:declare-step>
