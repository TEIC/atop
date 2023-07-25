<p:declare-step version="3.0" type="atop:validate-schematron" name="main"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:schematron-schematron="tag:dmaus@dmaus.name,2022:Schematron-Schematron"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xvrl="http://www.xproc.org/ns/xvrl">

  <p:documentation>Validate ISO Schematron extracted from the ODD file.</p:documentation>

  <p:import href="../../Lib/schematron-schematron/src/main/resources/content/step.xpl"/>

  <p:input  port="source"/>
  <p:output port="result" pipe="source@main"/>
  <p:output port="report" pipe="result@combine-reports"/>

  <p:validate-with-relax-ng assert-valid="false" name="iso-relaxng">
    <p:with-input port="source" pipe="source@main"/>
    <p:with-input port="schema" href="../../Schemas/schematron.rnc"/>
  </p:validate-with-relax-ng>

  <p:validate-with-schematron assert-valid="false" report-format="xvrl" name="iso-schematron">
    <p:with-input port="source" pipe="source@main"/>
    <p:with-input port="schema" href="../../Schemas/schematron.sch"/>
  </p:validate-with-schematron>

  <schematron-schematron:validate-schematron report-format="svrl" name="schematron-schematron">
    <p:with-input port="source" pipe="source@main"/>
  </schematron-schematron:validate-schematron>

  <p:wrap-sequence wrapper="xvrl:reports" name="combine-reports">
    <p:with-input port="source">
      <p:pipe step="iso-relaxng" port="report"/>
      <p:pipe step="iso-schematron" port="report"/>
      <p:pipe step="schematron-schematron" port="report"/>
    </p:with-input>
  </p:wrap-sequence>

</p:declare-step>
