<p:declare-step version="3.0" type="atop:extract-schematron"
                xmlns:atop="http://www.tei-c.org/ns/atop"
                xmlns:p="http://www.w3.org/ns/xproc">

  <p:input  port="source"/>
  <p:output port="result"/>

  <p:xslt>
    <p:with-input port="stylesheet">
      <p:document content-type="application/xsl+xml" href="../../XSLT/extract-schematron.xslt"/>
    </p:with-input>
  </p:xslt>
  
</p:declare-step>
