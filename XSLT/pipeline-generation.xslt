<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns:atop="http://www.tei-c.org/ns/atop"
    xmlns:teix="http://www.tei-c.org/ns/Examples" xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:rng="http://relaxng.org/ns/structure/1.0" xmlns:err="http://www.w3.org/2005/xqt-errors"
    exclude-result-prefixes="#all" version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> March 5, 2025</xd:p>
            <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
            <xd:p>Generation of the build file that would process a given ODD (handling
                chaining).</xd:p>
            <xd:param>STDIN = a customization ODD</xd:param>
            <xd:param>STDOUT = a build file named buildProcessingPipeline.xml to be run so as to process the customization ODD</xd:param>
        </xd:desc>
    </xd:doc>

    <xsl:include href="modules/functions_module.xslt"/>

    <xsl:output method="xml" indent="true"/>

    <xd:doc>
        <xd:desc>Creation of an ant build file... </xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:variable name="vDirectory" as="xs:anyURI" select="replace(base-uri(.), '^(.*)/.+',
            '$1') => xs:anyURI()"/>
        <xsl:variable name="vBaseOddUri" select="xs:anyURI($vDirectory || '/base-odd.xml')"/>
        <xsl:variable name="vChainedOdds" select="(reverse(atop:chaining(.)), .)"/>
        <xsl:result-document href="../buildProcessingPipeline.xml">
            <project name="odd-processing" basedir="." default="transpile">
                <description>This is the ant build file that process a given ODD. </description>
                <import file="buildGlobals.xml"/>
                <xsl:choose>
                    <xsl:when test="atop:is-base-odd(.) eq true()">
                        <xsl:sequence select="atop:post-derivation-pipeline(., 1, 1)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:for-each select="1 to count($vChainedOdds)">
                            <xsl:variable name="vSourceOdd" select="if (current() eq 2) then $vBaseOddUri else document-uri($vChainedOdds[current() - 1])"/>
                                <xsl:choose>
                                    <xsl:when test="atop:is-base-odd($vChainedOdds[current()]) eq true()">
                                        <xsl:result-document href="{$vBaseOddUri}">
                                            <xsl:sequence select="$vChainedOdds[current()]"/>
                                        </xsl:result-document>                           
                                    </xsl:when>                                    
                                    <xsl:when test="current() ne count($vChainedOdds)">
                                        <xsl:sequence select="
                                            atop:pre-transpile-pipeline($vChainedOdds[current()], current(), count($vChainedOdds), $vSourceOdd)"
                                        />
                                    </xsl:when>                                     
                                    <xsl:otherwise>
                                        <xsl:sequence select="
                                            atop:pre-transpile-pipeline($vChainedOdds[current()], current(), count($vChainedOdds), $vSourceOdd),
                                            atop:post-derivation-pipeline($vChainedOdds[current()], current(), count($vChainedOdds))"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>                        
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </project>
        </xsl:result-document>

    </xsl:template>
</xsl:stylesheet>
