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
        <xd:desc><ref name="atop:norm-space-preserve-outer">atop:norm-space-preserve-outer</ref>
        takes an xs:string as input and returns a string in which space has been normalized, but
        any leading or trailing space is not stripped, but instead is reduced to a single space.</xd:desc>
        <xd:param name="pIn_string" as="xs:string">The input string.</xd:param>
        <xd:return as="xs:string">The transformed string.</xd:return>
    </xd:doc>
    <xsl:function name="atop:norm-space-preserve-outer" as="xs:string">
        <xsl:param name="pIn_string" as="xs:string"/>
        <xsl:sequence select="replace($pIn_string, '\s+', ' ')"/>
    </xsl:function>
</xsl:stylesheet>