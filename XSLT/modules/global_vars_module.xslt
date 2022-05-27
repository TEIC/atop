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
            <xd:p>This module contains global variables such as the URIs of 
                resources commonly retrieved or the locations of local files and 
                collections.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc><ref name="atop:vCurrP5subset_uri">vCurrP5subset_uri</ref> is the location of the 
        p5subset.xml file in the current release of P5.</xd:desc>
    </xd:doc>
    <xsl:variable name="atop:vCurrP5subset_uri" as="xs:string" select="'https://tei-c.org/Vault/P5/current/xml/tei/odd/p5subset.xml'"/>
        
    <xd:doc>
        <xd:desc><ref name="atop:vTeiNs">vTeiNs</ref> is the location current TEI namespace.</xd:desc>
    </xd:doc>
    <xsl:variable name="atop:vTeiNs" as="xs:string" select="'http://www.tei-c.org/ns/1.0'"/>


</xsl:stylesheet>