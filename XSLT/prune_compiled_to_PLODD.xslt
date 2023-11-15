<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:atop="http://www.tei-c.org/ns/atop"
  xmlns:sch="http://purl.oclc.org/dsdl/schematron"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  version="3.0">

  <xd:doc>
    <xd:desc>Version number of this program</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vVersion" select="'0.1.5'" as="xs:string"/>
  
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Jul 5, 2022</xd:p>
      <xd:p><xd:b>Author:</xd:b> syd</xd:p>
      <xd:p>Routine to read in an ODD file “flattened” by the current Stylesheets
      and try to convert it to a plausible PLODD.</xd:p>
    </xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:desc>the language of the &lt;gloss>es and &lt;desc>s we keep</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pLang" select="'en'" as="xs:string"/>
  
  <xsl:output method="xml" indent="yes" encoding="UTF-8" normalization-form="NFC"
              exclude-result-prefixes="#all"/>
  <xsl:mode on-no-match="shallow-copy"/>
  
  <xd:doc>
    <xd:desc>give empty &lt;content> &lt;empty> content</xd:desc>
  </xd:doc>
  <xsl:template match="content[ not(child::*) ]" as="element(content)">
    <content><empty/></content>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>give multi-child &lt;content> one child</xd:desc>
    <xd:desc>That is, a &lt;content> that has more than 1 child should
    instead have its content wrapped in a &lt;sequence> (or maybe
    &lt;rng:group>) which is (now) its only 1 child.</xd:desc>
  </xd:doc>
  <xsl:template match="content[ count(child::*) > 1 ]" as="element(content)">
    <content>
      <xsl:choose>
        <xsl:when test="child::rng:*">
          <rng:group>
            <xsl:apply-templates select="node()"/>
          </rng:group>
        </xsl:when>
        <xsl:when test="child::tei:*">
          <sequence>
            <xsl:apply-templates select="node()"/>
          </sequence>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message select="'What the heck do you have in this &lt;content>? (To answer myself, you have: '||string-join( child::*/name(), ', ')||'!'"/>
          <xsl:apply-templates select="node()"/>
        </xsl:otherwise>
      </xsl:choose>
    </content>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Simplify names</xd:desc>
  </xd:doc>
  <xsl:template match="persName|placeName|orgName|surname|forename" as="element(name)">
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
  <xsl:template match="body" as="element(body)">
    <xsl:copy>
      <xsl:apply-templates select="//schemaSpec"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>make sure &lt;schemaSpec> has an @ns attr</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" as="element(schemaSpec)">
    <xsl:copy>
      <xsl:attribute name="ns" select="'http://www.tei-c.org/ns/1.0'"/>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>Strip leading and trailing whitespace from ODD identifiers</xd:desc>
  </xd:doc>
  <xsl:template match="@ident" as="attribute(ident)">
    <xsl:attribute name="ident" select="normalize-space(.)"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>Generate the PLODD metadata</xd:desc>
  </xd:doc>
  <xsl:template match="teiHeader" as="element(teiHeader)">
    <xsl:copy>
      <fileDesc>
        <titleStmt>
          <title>
            <xsl:text>PLODD of </xsl:text>
            <xsl:apply-templates select="/*/teiHeader/fileDesc/titleStmt/title"/>
          </title>
          <title type="sub"><xsl:text>an automatically generated file</xsl:text></title>
        </titleStmt>
        <publicationStmt>
          <p><xsl:text>This is an unpublished (and unpublishable) intermediate file.</xsl:text></p>
        </publicationStmt>
        <sourceDesc>
          <p><xsl:text>Generated from a source ODD. See &lt;appInfo>.</xsl:text></p>
        </sourceDesc>
      </fileDesc>
      <encodingDesc>
        <appInfo>
          <xsl:apply-templates select="/*/teiHeader/encodingDesc/appInfo/application"/>
          <application ident="{(static-base-uri()=>tokenize('/'))[last()]}" version="{$atop:vVersion}">
            <desc xml:lang="en">
              <xsl:sequence select="'Input: '||document-uri(.)"/>
            </desc>
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
  <xsl:template match="desc|gloss|valDesc" as="element()?">
    <xsl:choose>
      <!-- Currently unsolved: what if there are multiple siblings without @xml:lang, or 
        with the same (target or en) @xml:lang? -->
      <!-- If this one is in the target language, just use it. -->
      <xsl:when test="@xml:lang eq $atop:pLang">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <!-- If this one has no @xml:lang, and there isn't a sibling in the target language, use it. -->
      <xsl:when test="not(@xml:lang) and not(../*[name(.) eq name(current())][@xml:lang = $atop:pLang])">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <!-- If this one is @xml:lang="en", and there isn't a sibling in the target language or without @xml:lang, use it. -->
      <xsl:when test="@xml:lang='en' and not(../*[name(.) eq name(current())][@xml:lang = $atop:pLang or not(@xml:lang)])">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
      <!-- If this is the first element in the set, and there is no other usable element
        (i.e. no element with target lang, no lang, or en), then use this. -->
      <xsl:when test="not(preceding-sibling::node()[name(.) eq name(current())]) and not(../*[name(.) eq name(current())][@xml:lang = ('en', $atop:pLang) or not(@xml:lang)])">
        <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:desc>Expand module references that point to external
    schemas. Module references that do not point to external schemas
    should already have been resolved at this point. Thus in a PLODD
    the only <gi>moduleRef</gi>s should have a <att>url</att> of
    <val>.</val> and single child <gi>content</gi> that has PureODD or
    RELAX NG (or both). The use of the value <val>.</val> for
    <att>url</att> is not strictly necessary, but ATOP uses it to
    signify that the content is here and now, and no longer
    external.</xd:desc>
  </xd:doc>
  <xsl:template match="moduleRef[@url]" as="element(moduleRef)">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <!-- Use a value of ‘.’ on @url to signify that the content is here and now, not external. -->
      <xsl:attribute name="url" select="'.'"/>
      <content>
        <xsl:apply-templates select="content/@*"/>
        <xsl:apply-templates select="content/*"/>
        <xsl:if test="doc-available( @url )">
          <xsl:copy-of select="doc(@url)"/>
        </xsl:if>
      </content>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>Kill various constructs that PLODDs should not have</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:template as="item()*" name="atop:nuke" match="
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
    |macroSpec/@mode
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
    |*[@type eq 'deprecationInfo']
    |elementSpec/@rend
    |classSpec/@rend
    |macroSpec/@rend
    |dataSpec/@rend
    |attDef/@rend
    |content/@rend
    |schemaSpec/desc
    |paramList
    |attList[not(*)]
    |@ref
    |equiv
    "/>

</xsl:stylesheet>
