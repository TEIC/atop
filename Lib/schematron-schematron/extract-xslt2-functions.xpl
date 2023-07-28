<p:declare-step version="3.0"
                xmlns:c="http://www.w3.org/ns/xproc-step"
                xmlns:p="http://www.w3.org/ns/xproc"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">

  <p:output port="result"/>

  <p:load href="https://www.w3.org/TR/xslt20/index.html" content-type="text/html"/>

  <p:xslt>
    <p:with-input port="stylesheet" href="extract-xslt2-functions.xsl"/>
  </p:xslt>
  
</p:declare-step>
