<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jul 5, 2022</xd:p>
      <xd:p><xd:b>Author:</xd:b> syd</xd:p>
      <xd:p>Routine to read in an ODD file “flattened” by the current Stylesheets
      and try to convert it to a plausible PLODD.</xd:p>
    </xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:param name="lang">the language of the &lt;gloss>es and &lt;desc>s we keep</xd:param>
  </xd:doc>
  <xsl:param name="lang" select="'en'"/>
  
  <xd:doc>
    <xd:desc>the language of the &lt;gloss>es and &lt;desc>s we keep</xd:desc>
  </xd:doc>
  <xsl:variable name="vLang" select="$lang"/>
  
  <xd:doc>
    <xd:desc>Version number of this program</xd:desc>
  </xd:doc>
  <xsl:variable name="vVersion" select="'0.1.2'"/>
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xd:doc>
    <xd:desc>give empty &lt;content> &lt;empty> content</xd:desc>
  </xd:doc>
  <xsl:template match="content[not(child::*)]">
    <content><empty/></content>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Simplify names</xd:desc>
  </xd:doc>
  <xsl:template match="persName|placeName|orgName|surname|forename">
    <name type="{name(.)}">
      <xsl:if test="@type">
        <xsl:attribute name="subtype" select="@type"/>
      </xsl:if>
      <xsl:apply-templates select="@* except ( @type, @subtype )|node()"/>
    </name>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>put &lt;schemaSpec> into &lt;body>, no matter where it was</xd:desc>
  </xd:doc>
  <xsl:template match="body">
    <xsl:copy>
      <xsl:apply-templates select="//schemaSpec"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>make sure &lt;schemaSpec> has an @ns attr</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec">
    <xsl:copy>
      <xsl:attribute name="ns" select="'http://www.tei-c.org/ns/1.0'"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>Generate the PLODD metadata</xd:desc>
  </xd:doc>
  <xsl:template match="teiHeader">
    <xsl:copy>
      <fileDesc>
        <titleStmt>
          <title>PLODD of <xsl:apply-templates select="/*/teiHeader/fileDesc/titleStmt/title"/></title>
          <title type="sub">an automatically generated file</title>
        </titleStmt>
        <publicationStmt>
          <p>This is an unpublished (and unpublishable) intermediate file.</p>
        </publicationStmt>
        <sourceDesc>
          <p>Generated from a source ODD. See &lt;appInfo>.</p>
        </sourceDesc>
      </fileDesc>
      <encodingDesc>
        <appInfo>
          <xsl:apply-templates select="/*/teiHeader/encodingDesc/appInfo/application"/>
          <application ident="{(static-base-uri()=>tokenize('/'))[last()]}" version="{$vVersion}">
            <desc xml:lang="en" xsl:expand-text="yes">Input: {document-uri(.)}</desc>
          </application>
        </appInfo>
      </encodingDesc>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>Ensure there is an appropriate language specification for &lt;gloss>,
      &lt;desc>, and &lt;valDesc>. If the @xml:lang matches the parameter we were
    given, take this one. </xd:desc>
  </xd:doc>
  <xsl:template match="desc|gloss|valDesc">
    <xsl:choose>
      <xsl:when test="@xml:lang eq $vLang">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <xsl:when test="@xml:lang and ( @xml:lang ne $vLang )"/>
      <xsl:when test="not( @xml:lang )
                      and
                      not( ../*[name(.) eq name(current())][ @xml:lang eq $vLang ] )">
        <xsl:copy>
          <xsl:attribute name="xml:lang" select="$vLang"/>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>
      <xd:p>Kill various constructs that PLODDs should not have</xd:p>
      <xd:p>Note that I am less sure of those that occur after the blank line.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template name="nuke" match="
     @source
    |@module
    |@predeclare
    |@validUntil
    |attDef/@mode
    |valList/@mode
    |valItem/@mode
    |constraintSpec/@mode
    |elementSpec/@mode
    |memberOf/@mode
    |classes/@mode
    |classSpec/@mode
    |dataSpec/@mode
    |moduleSpec
    |macroSpec/@type
    |editionStmt
    |notesStmt
    |front
    |back
    |head
    |table
    |remarks
    |exemplum
    |listRef
    |model
    |modelGrp
    |modelSequence
    |outputRendition
    |@xsi:*
    |elementSpec/@rend
    |classSpec/@rend
    |macroSpec/@rend
    |dataSpec/@rend
    |attDef/@rend
    
    |attList[not(child)]
    |@ref
    |equiv
    "/>
  
</xsl:stylesheet>