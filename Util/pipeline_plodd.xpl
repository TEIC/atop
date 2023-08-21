<!-- This pipeline is a custom version of the main pipeline
     intended mainly for testing; it runs only the PLODD-to-output
     stage of the process. -->

<p:declare-step version="3.0"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <p:import href="steps/transpile.xpl"/>
  <p:import href="steps/extract-schematron.xpl"/>

  <p:option name="teiOddSpecification" as="xs:string" required="true"/>

  <p:output port="result" serialization="map{'indent': true()}" pipe="result@validate"/>
  <p:output port="report" serialization="map{'indent': true()}" pipe="report@validate"/>
  <p:output port="schematron" pipe="result@extract-schematron"/>

  <p:load href="{p:urify($teiOddSpecification)}" content-type="application/tei+xml"/>

  <p:validate-with-schematron assert-valid="true">
    <p:with-input port="schema" href="../Schemas/pre-transpile.sch"/>
  </p:validate-with-schematron>

  <atop:transpile/>

  <p:validate-with-relax-ng assert-valid="false" name="validate">
    <p:with-input port="schema" href="../Schemas/relaxng.rnc"/>
  </p:validate-with-relax-ng>

  <atop:extract-schematron name="extract-schematron"/>

</p:declare-step>
