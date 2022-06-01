<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:atop="http://www.tei-c.org/ns/atop"
    xmlns:teix="http://www.tei-c.org/ns/Examples"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:rng="http://relaxng.org/ns/structure/1.0"
    xmlns:err="http://www.w3.org/2005/xqt-errors"
    exclude-result-prefixes="#all"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> May 18, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
            <xd:p>This module contains XSLT functions which are generally
            useful across multiple transformations in the ATOP repository.
            A corresponding XSpec file provides testing for these functions.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc><ref name="atop:collapse-space">atop:collapse-space</ref>
        takes an xs:string as input and returns a string in which space has been normalized, but
        any leading or trailing space is not stripped, but instead is reduced to a single space.</xd:desc>
        <xd:param name="pIn_string" as="xs:string">The input string.</xd:param>
        <xd:return as="xs:string">The transformed string.</xd:return>
    </xd:doc>
    <xsl:function name="atop:collapse-space" as="xs:string">
        <xsl:param name="pIn_string" as="xs:string"/>
        <xsl:sequence select="replace($pIn_string, '\s+', ' ')"/>
    </xsl:function>

    <xd:doc>
      <xd:desc>
        <xd:p>The attributes @minOccurs and @maxOccurs are (by definition) strings, but they
          are defined as counts (a user should be able to enter minOccurs="02" and get the
          same result as if she had entered minOccurs='2'). We need to be able to do calculations
          on numbers, not strings. So this function takes as parameters the string values of
          @minOccurs and @maxOccurs and returns a sequence of 2 integers representing the integer
          values thereof, with -1 used to indicate "unbounded"</xd:p>
      </xd:desc>
      <xd:param name="pMinOccurs">Minimum number of occurences as a string; typically just @minOccurs.</xd:param>
      <xd:param name="pMaxOccurs">Maximum number of occurences as a string; typically just @maxOccurs.</xd:param>
      <xd:return>A sequence of 2 integers, the minimum number and the maximum number; except that a
      maximum of -1 is used for "unbounded"</xd:return>
    </xd:doc>
    <xsl:function name="atop:min-max-to-int" as="xs:integer+">
      <xsl:param name="pMinOccurs" as="xs:string"/>
      <xsl:param name="pMaxOccurs" as="xs:string"/>
      <!-- get the value of @minOccurs, defaulting to "1" -->
      <xsl:variable name="vMinOccurs" select="( $pMinOccurs, '1')[1]" as="xs:string"/>
      <!-- get the value of @maxOccurs, defaulting to "1" -->
      <xsl:variable name="vMaxOccurs" select="( $pMaxOccurs, '1')[1]" as="xs:string"/>
      <!-- We now have two _string_ representations of the attrs, but -->
      <!-- we need integers. So cast them, converting "unbounded" to  -->
      <!-- a special flag value (-1): -->
      <xsl:variable name="vMin" select="xs:integer( $vMinOccurs )" as="xs:integer"/>
      <xsl:variable name="vMax"                                    as="xs:integer">
        <xsl:choose>
          <xsl:when test="$vMaxOccurs castable as xs:integer">
            <xsl:sequence select="xs:integer( $vMaxOccurs )"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Must be "unbounded". -->
            <xsl:sequence select="-1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:sequence select="( $vMin, $vMax )"/>
    </xsl:function>
  
</xsl:stylesheet>
