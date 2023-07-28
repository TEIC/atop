<p:declare-step version="3.0" type="schematron-schematron:validate-schematron"
                xmlns:schematron-schematron="tag:dmaus@dmaus.name,2022:Schematron-Schematron"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <p:input  port="source"/>
  <p:output port="result" pipe="result@validate"/>
  <p:output port="report" pipe="report@validate"/>

  <p:option name="report-format" as="xs:string" select="'svrl'"/>

  <p:validate-with-schematron assert-valid="false" report-format="{$report-format}" name="validate">
    <p:with-input port="schema" href="schematron.sch"/>
  </p:validate-with-schematron>

</p:declare-step>
