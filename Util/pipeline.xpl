<p:declare-step version="3.0"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <p:import href="steps/legacy-odd2odd.xpl"/>
  <p:import href="steps/transpile.xpl"/>
  <p:import href="steps/prune.xpl"/>

  <p:option name="teiOddSpecification" as="xs:string" required="true"/>

  <p:output port="result" serialization="map{'indent': true()}" pipe="result@validate"/>
  <p:output port="report" serialization="map{'indent': true()}" pipe="report@validate"/>

  <p:load href="{p:urify($teiOddSpecification)}" content-type="application/tei+xml"/>

  <atop:legacy-odd2odd/>
  <atop:prune/>
  <atop:transpile/>

  <p:validate-with-relax-ng assert-valid="false" name="validate">
    <p:with-input port="schema" href="../Schemas/relaxng.rnc"/>
  </p:validate-with-relax-ng>

</p:declare-step>
