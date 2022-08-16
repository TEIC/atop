<p:declare-step version="3.0" type="atop:transpile"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:documentation>Run the transpiler for the corresponding ODD and validate the result as valid RelaxNG.</p:documentation>

  <p:output port="result" serialization="map{'indent': true()}"/>

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document content-type="application/xml" href="../XSLT/transpile.xslt"/>
    </p:with-input>
    <p:with-input port="source">
      <p:document content-type="application/xml" href="../Tests/resources/in_vitro_ODDS/transpile.odd"/>
    </p:with-input>
  </p:xslt>

  <p:validate-with-relax-ng>
    <p:with-input port="schema" href="../Schemas/relaxng.rnc"/>
  </p:validate-with-relax-ng>

</p:declare-step>
