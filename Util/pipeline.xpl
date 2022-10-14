<p:declare-step version="3.0"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <p:import href="transpile.xpl"/>

  <p:option name="teiOddSpecification" as="xs:string" required="true"/>

  <p:output port="result" serialization="map{'indent': true()}"/>

  <p:load href="{p:urify($teiOddSpecification)}" content-type="application/tei+xml"/>

  <atop:transpile/>

  <p:validate-with-relax-ng assert-valid="false">
    <p:with-input port="schema" href="../Schemas/relaxng.rnc"/>
  </p:validate-with-relax-ng>

</p:declare-step>
