<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt3"
            xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <sch:ns prefix="fn" uri="tag:dmaus@dmaus.name,2022:Schematron-Schematron"/>
  <sch:ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>

  <sch:let name="queryBinding" value="'xslt2'"/>

  <sch:phase id="embedded">
    <sch:active pattern="embedded"/>
  </sch:phase>

  <xsl:include href="functions.xsl"/>

  <sch:pattern id="embedded">
    <sch:rule context="sch:rule/@context | sch:assert/@test | sch:report/@test | sch:value-of/@select | sch:let/@value | sch:name/@path | sch:pattern/@documents | xsl:copy-of/@select">
      <sch:let name="queryBinding" value="lower-case((ancestor::sch:schema/@queryBinding, $queryBinding, 'xslt')[1])"/>
      <sch:let name="result" value="fn:validate-xpath(., $queryBinding)"/>
      <sch:let name="invalid-fn" value="fn:find-invalid-functions(fn:get-xpath-functions($result, $queryBinding), $queryBinding)"/>
      <sch:report test="$result[self::ERROR]" id="syntax-error">
        <sch:value-of select="$result[self::ERROR]"/>
      </sch:report>
      <sch:report test="exists($invalid-fn)" role="WARNING" id="unknown-function">
        The XPath expression may contain one or more unknown function: <sch:value-of select="fn:pretty-print-function($invalid-fn)"/>.
      </sch:report>
    </sch:rule>
  </sch:pattern>

  <sch:pattern>
    <sch:rule context="sch:rule/@context | sch:assert/@test | sch:report/@test | sch:value-of/@select | sch:let/@value | sch:name/@path | sch:pattern/@documents | xsl:copy-of/@select">
      <sch:let name="schema" value="ancestor::sch:schema"/>
      <sch:let name="queryBinding" value="lower-case((ancestor::sch:schema/@queryBinding, $queryBinding, 'xslt')[1])"/>
      <sch:let name="result" value="fn:validate-xpath(., $queryBinding)"/>
      <sch:let name="bound-ns" value="($schema/sch:ns/@prefix, 'xml')"/>
      <sch:let name="unbound-ns" value="fn:get-qname-prefixes($result)[not(. = $bound-ns)]"/>
      <sch:report test="exists($unbound-ns)" role="WARNING" id="unbound-qname-ns">
        The XPath expression may contain one or more unbound namespace prefixes: <sch:value-of select="$unbound-ns"/>.
      </sch:report>
    </sch:rule>
  </sch:pattern>

</sch:schema>
