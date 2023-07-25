<p:declare-step version="3.0" type="atop:validate-schematron" name="main"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:schematron-schematron="tag:dmaus@dmaus.name,2022:Schematron-Schematron"
                xmlns:schxslt="https://doi.org/10.5281/zenodo.1495494"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xvrl="http://www.xproc.org/ns/xvrl">

  <p:documentation>
    Validates the Schematron extracted from the ODD specification. The
    schematron is returned unchanged on the report output port. If the
    Schematron is not valid, a non-empty sequence of XVRL and SVRL
    validation reports flows to the result output port.
  </p:documentation>

  <p:import href="../../Lib/schxslt/xproc/3.0/validate-with-schematron.xpl">
    <p:documentation>
      As of 2023-07-25 Morgana XProc III does not support Schematron
      validation with the XSLT 3.0 query language binding, required by
      the Schematron Schematron schema. We thus use the native XProc
      3.0 validation step provided by SchXslt.
    </p:documentation>
  </p:import>

  <p:input  port="source"/>
  <p:output port="result" pipe="source@main"/>
  <p:output port="report" pipe="result@combine-reports" sequence="true"/>

  <p:declare-step type="atop:validate-with-relaxng-internal" name="main">
    <p:documentation>
      Validates the document appearing on the source port with the
      schema appearing on the schema port. Returns an empty sequence
      if the document is valid, a XVRL error report otherwise.
    </p:documentation>

    <p:input  port="source"/>
    <p:input  port="schema"/>
    <p:output port="result" pipe="result@check-report" sequence="true"/>

    <p:validate-with-relax-ng assert-valid="false" name="validate">
      <p:with-input port="source" pipe="source@main"/>
      <p:with-input port="schema" pipe="schema@main"/>
    </p:validate-with-relax-ng>

    <p:choose name="check-report">
      <p:with-input pipe="report@validate"/>
      <p:when test="exists(/xvrl:report/xvrl:detection[@severity = ('fatal-error', 'error', 'warning')])">
        <p:output port="result"/>
        <p:identity>
          <p:with-input port="source" pipe="report@validate"/>
        </p:identity>
      </p:when>
    </p:choose>

  </p:declare-step>

  <p:declare-step type="atop:validate-with-schematron-internal" name="main">
    <p:documentation>
      Validates the document appearing on the source port with the
      schema appearing on the schema port. Returns an empty sequence
      if the document is valid, a SVRL error report otherwise.
    </p:documentation>

    <p:input  port="source"/>
    <p:input  port="schema"/>
    <p:output port="result" pipe="result@check-report" sequence="true"/>

    <schxslt:validate-with-schematron name="validate">
      <p:with-input port="source" pipe="source@main"/>
      <p:with-input port="schema" pipe="schema@main"/>
    </schxslt:validate-with-schematron>

    <p:choose name="check-report">
      <p:with-input pipe="report@validate"/>
      <p:when test="exists(/svrl:schematron-output/svrl:failed-assert) or exists(/svrl:schematron-output/svrl:successful-report)">
        <p:output port="result"/>
        <p:identity>
          <p:with-input port="source" pipe="report@validate"/>
        </p:identity>
      </p:when>
    </p:choose>

  </p:declare-step>

  <atop:validate-with-relaxng-internal name="validate-iso-relaxng">
    <p:with-input port="source" pipe="source@main"/>
    <p:with-input port="schema" href="../../Schemas/schematron.rnc"/>
  </atop:validate-with-relaxng-internal>

  <atop:validate-with-schematron-internal name="validate-iso-schematron">
    <p:with-input port="source" pipe="source@main"/>
    <p:with-input port="schema" href="../../Schemas/schematron.sch"/>
  </atop:validate-with-schematron-internal>

  <atop:validate-with-schematron-internal name="validate-schematron-schematron">
    <p:with-input port="source" pipe="source@main"/>
    <p:with-input port="schema" href="../../Lib/schematron-schematron/src/main/resources/content/schematron.sch"/>
  </atop:validate-with-schematron-internal>

  <p:identity name="combine-reports">
    <p:with-input port="source">
      <p:pipe port="result" step="validate-iso-relaxng"/>
      <p:pipe port="result" step="validate-iso-schematron"/>
      <p:pipe port="result" step="validate-schematron-schematron"/>
    </p:with-input>
  </p:identity>

</p:declare-step>
