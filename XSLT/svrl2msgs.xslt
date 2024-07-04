<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:atop="http://www.tei-c.org/ns/atop"
  exclude-result-prefixes="#all"
  version="3.0">
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>svrl2msgs.xslt — a program to convert SVRL to plain text error messages.</xd:p>
      <xd:p>© 2020 TEI Consortium. Some rights reserved.</xd:p>
      <xd:p>
        <xd:b>input:</xd:b> an SVRL file, presumably the output of testing the ATOP-generated Schematron
        against a known valid or invalid file.
      </xd:p>
      <xd:p>
        <xd:b>output:</xd:b> the error messages in a predictable flat file format for comparing
      </xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:output indent="yes" item-separator="&#x0A;" method="text"/>
  
  <xd:doc>
    <xd:desc>If set to true(), the atop:pShowLocation parameter causes the
      location of the error, as indicated in the SVRL, to be prepended to the
      error message. (Separated from the message by a colon-space.)
    </xd:desc>
  </xd:doc>
  <xsl:param name="atop:pShowLocation" select="false()" as="xs:boolean"/>

  <xd:doc>
    <xd:desc>Initial template: match document root, but process only &lt;svrl:text> elements.</xd:desc>
  </xd:doc>
  <xsl:template match="/" name="xsl:initial-template" as="item()*">
    <xsl:apply-templates select="//svrl:text">
      <xsl:sort/>
    </xsl:apply-templates>
    <xsl:text>&#x0A;</xsl:text>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>When we hit an &lt;svrl:text> we presume it is an error message (which
      is usually the case), and spit out just the message, preceded by the location
      iff requested via the parameter to the stylesheet.</xd:desc>
  </xd:doc>
  <xsl:template match="svrl:text" as="xs:string">
    <xsl:variable name="vLocation" as="xs:string" select="if ($atop:pShowLocation)
                                                          then ../@location||': '
                                                          else ''"/>
    <xsl:sequence select="normalize-space( $vLocation|| . )"/>
  </xsl:template>

</xsl:stylesheet>
