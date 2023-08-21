<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <sch:title>Verify that a schema specification is self-contained</sch:title>
  <sch:ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
  <sch:ns prefix="atop" uri="http://www.tei-c.org/ns/atop"/>
  <xsl:key name="atop:classSpec" match="tei:classSpec" use="@ident"/>
  <xsl:key name="atop:dataSpec" match="tei:dataSpec" use="@ident"/>
  <xsl:key name="atop:elementSpec" match="tei:elementSpec" use="@ident"/>
  <xsl:key name="atop:macroSpec" match="tei:macroSpec" use="@ident"/>
  <sch:pattern>
    <sch:rule context="tei:schemaSpec">
      <sch:assert test="empty(tei:classRef)">
        A self-contained schema specification does not contain any classRef child elements.
      </sch:assert>
      <sch:assert test="empty(tei:dataRef)">
        A self-contained schema specification does not contain any dataRef child elements.
      </sch:assert>
      <sch:assert test="empty(tei:elementRef)">
        A self-contained schema specification does not contain any elementRef child elements.
      </sch:assert>
      <sch:assert test="empty(tei:macroRef)">
        A self-contained schema specification does not contain any macroRef child elements.
      </sch:assert>
      <sch:assert test="empty(tei:moduleRef)">
        A self-contained schema specification does not contain any moduleRef child elements.
      </sch:assert>
      <sch:assert test="empty(tei:specGrpRef)">
        A self-contained schema specification does not contain any specGrpRef child elements.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern>
    <sch:rule context="tei:classRef">
      <sch:assert test="empty(@source) and key('atop:classSpec', @key, (ancestor::tei:schemaSpec, root())[1])"
                  properties="dangling-reference">
        Every classRef element in a self-contained schema specification must resolve locally.
      </sch:assert>
    </sch:rule>
    <sch:rule context="tei:dataRef[@key]">
      <sch:assert test="empty(@source) and key('atop:dataSpec', @key, (ancestor::tei:schemaSpec, root())[1])"
                  properties="dangling-reference">
        Every dataRef element in a self-contained schema specification must resolve locally.
      </sch:assert>
    </sch:rule>
    <sch:rule context="tei:elementRef">
      <sch:assert test="empty(@source) and key('atop:elementSpec', @key, (ancestor::tei:schemaSpec, root())[1])"
                  properties="dangling-reference">
        Every elementRef element in a self-contained schema specification must resolve locally.
      </sch:assert>
    </sch:rule>
    <sch:rule context="tei:macroRef">
      <sch:assert test="empty(@source) and key('atop:macroSpec', @key, (ancestor::tei:schemaSpec, root())[1])"
                  properties="dangling-reference">
        Every macroRef element in a self-contained schema specification must resolve locally.
      </sch:assert>
    </sch:rule>
    <sch:rule context="tei:attRef">
      <sch:assert test="empty(@source) and key('atop:classSpec', @class, (ancestor::tei:schemaSpec, root())[1])/tei:attList//tei:attDef[@ident = current()/@name]"
                  properties="dangling-reference">
        Every dataRef element in a self-contained schema specification must resolve locally.
      </sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:properties>
    <sch:property id="dangling-reference">
      <xsl:copy-of select="."/>
    </sch:property>
  </sch:properties>
</sch:schema>
