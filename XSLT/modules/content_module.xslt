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
            <xd:p><xd:b>Created on:</xd:b> June 15, 2022</xd:p>
            <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
            <xd:p>This module contains processing which converts TEI content 
                elements into their RELAX NG output.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Given element content, an optional minimum, and an optional maximum occurrence, return a corresponding RelaxNG pattern.</xd:p>
        </xd:desc>
        <xd:param name="pContent">Element content</xd:param>
        <xd:param name="pMinOccurrence">Minimum occurrence, defaults to 1.</xd:param>
        <xd:param name="pMaxOccurrence">Maximum occurrence, defaults to 1.</xd:param>
        <xd:return>RelaxNG pattern</xd:return>
    </xd:doc>
    <xsl:template name="atop:repeat-content" as="element()*">
        <xsl:param name="pContent" as="element()*"/>
        <xsl:param name="pMinOccurrence" as="xs:integer?"/>
        <xsl:param name="pMaxOccurrence" as="xs:string?"/>
        <xsl:if test="exists($pContent)">
            <xsl:variable name="vMinOccurrence" as="xs:integer" select="($pMinOccurrence, 1)[1]"/>
            <xsl:variable name="vMaxOccurrence" as="xs:string" select="($pMaxOccurrence, '1')[1]"/>
            <xsl:for-each select="1 to $vMinOccurrence">
                <xsl:sequence select="$pContent"/>
            </xsl:for-each>
            <xsl:choose>
                <xsl:when test="$pMaxOccurrence eq 'unbounded'">
                    <rng:zeroOrMore>
                        <xsl:sequence select="$pContent"/>
                    </rng:zeroOrMore>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="($vMinOccurrence + 1) to xs:integer($vMaxOccurrence)">
                        <rng:optional>
                            <xsl:sequence select="$pContent"/>
                        </rng:optional>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
