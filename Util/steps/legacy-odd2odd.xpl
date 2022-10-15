<p:declare-step version="3.0" type="atop:legacy-odd2odd"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source"/>
  <p:output port="result"/>

  <p:xslt parameters="map{'defaultSource': resolve-uri('../../Tests/resources/p5subset.xml', static-base-uri())}">
    <p:with-input port="stylesheet" href="../../XSLT/legacy-odd2odd.xsl"/>
  </p:xslt>

</p:declare-step>
                
