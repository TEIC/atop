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
      <xd:p><xd:b>Created on:</xd:b> May 18, 2022</xd:p>
      <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
      <xd:p>This module contains XSLT functions which are generally useful across multiple
        transformations in the ATOP repository. A corresponding XSpec file provides testing for
        these functions.</xd:p>
    </xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:desc><xd:ref name="atop:dataSpec"/>, <xd:ref name="atop:classSpec"/>,
      <xd:ref name="atop:elementSpec"/>, <xd:ref name="atop:macroSpec"/>, 
      and <xd:ref name="atop:attDef"/> are
      handy keys for accessing elements by their idents.</xd:desc>
  </xd:doc>
  <xsl:key name="atop:dataSpec" match="dataSpec" use="@ident"/>
  <xsl:key name="atop:classSpec" match="classSpec" use="@ident"/>
  <xsl:key name="atop:elementSpec" match="elementSpec" use="@ident"/>
  <xsl:key name="atop:macroSpec" match="macroSpec" use="@ident"/>
  <xsl:key name="atop:attDef" match="classSpec/attList/attDef" use="ancestor::classSpec/@ident || '_' || @ident"/>

  <xd:doc>
    <xd:desc><xd:ref name="atop:classMembers"/> is a key for accessing elementSpecs and classSpecs
    by the idents of the classes they are direct members of.</xd:desc>
  </xd:doc>
  <xsl:key name="atop:classMembers" match="elementSpec[classes/memberOf] | classSpec[classes/memberOf]" use="classes/memberOf/@key"/>

  <xd:doc>
    <xd:desc><xd:ref name="atop:prefixDef"/> is a key to prefixDef elements by their idents.</xd:desc>
  </xd:doc>
  <xsl:key name="atop:prefixDef" match="prefixDef" use="@ident"/>

  <xd:doc>
    <xd:desc><ref name="atop:vUriSchemeRegex"/>: a regular expression for matching the prefixes
    of Private Uri Schemes.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vUriSchemeRegex" as="xs:string">^[a-z][a-z0-9+\-.]*:</xsl:variable>

  <xd:doc>
    <xd:desc><ref name="atop:collapse-space">atop:collapse-space</ref> takes an xs:string as input
      and returns a string in which space has been normalized, but any leading or trailing space is
      not stripped, but instead is reduced to a single space.</xd:desc>
    <xd:param name="pIn_string" as="xs:string">The input string.</xd:param>
    <xd:return as="xs:string">The transformed string.</xd:return>
  </xd:doc>
  <xsl:function name="atop:collapse-space" as="xs:string">
    <xsl:param name="pIn_string" as="xs:string"/>
    <xsl:sequence select="replace($pIn_string, '\s+', ' ')"/>
  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:unique-ident"/>:
      Given a specification element, return a unique identifier for the construct that
    element defines. This is <xd:i>not</xd:i> just the @ident, because severel different kinds
    of construct might have the same @ident (e.g., &lt;ref> vs @ref), and because several
    of the same kind of construct might have the same @ident with different namespaces (i.e.,
    @ns attributes).</xd:desc>
    <xd:param name="pSpec">A single &lt;attDef>, &lt;schemaSpec>, &lt;elementSpec>, &lt;classSpec>,
      &lt;macroSpec>, or &lt;dataSpec> element.</xd:param>
  </xd:doc>
  <xsl:function name="atop:unique-ident" as="xs:string">
    <xsl:param name="pSpec" as="element()"/>
    <xsl:if test="not( $pSpec/self::tei:*[ancestor-or-self::*/@ident] )">
      <xsl:message terminate="yes" select="'FATAL error: attempt to get unique identifier of an unidentified element.'" error-code="atop:error-noIdentInScope"/>
    </xsl:if>
    <xsl:variable name="vAncestorsIdentified" as="xs:string*">
      <xsl:for-each select="$pSpec/ancestor-or-self::*[@ident]">
        <xsl:value-of select="local-name(.)||','||@ns||','||@ident"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="string-join( $vAncestorsIdentified, ';')"/>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p><xd:ref name="atop:min-max-to-int"/>:
        The attributes @minOccurs and @maxOccurs are (by definition) strings, but they are
        defined as counts (a user should be able to enter minOccurs="02" and get the same result as
        if she had entered minOccurs='2'). We need to be able to do calculations on numbers, not
        strings. So this function takes as parameters the string values of @minOccurs and @maxOccurs
        and returns a sequence of 2 integers representing the integer values thereof, with -1 used
        to indicate "unbounded"</xd:p>
    </xd:desc>
    <xd:param name="pMinOccurs">Minimum number of occurences as a string; typically just
      @minOccurs.</xd:param>
    <xd:param name="pMaxOccurs">Maximum number of occurences as a string; typically just
      @maxOccurs.</xd:param>
    <xd:return>A sequence of 2 integers, the minimum number and the maximum number; except that a
      maximum of -1 is used for "unbounded"</xd:return>
  </xd:doc>
  <xsl:function name="atop:min-max-to-int" as="xs:integer+">
    <xsl:param name="pMinOccurs" as="xs:string"/>
    <xsl:param name="pMaxOccurs" as="xs:string"/>
    <!-- get the value of @minOccurs, defaulting to "1" -->
    <xsl:variable name="vMinOccurs" select="($pMinOccurs, '1')[1]" as="xs:string"/>
    <!-- get the value of @maxOccurs, defaulting to "1" -->
    <xsl:variable name="vMaxOccurs" select="($pMaxOccurs, '1')[1]" as="xs:string"/>
    <!-- We now have two _string_ representations of the attrs, but -->
    <!-- we need integers. So cast them, converting "unbounded" to  -->
    <!-- a special flag value (-1): -->
    <xsl:variable name="vMin" select="xs:integer($vMinOccurs)" as="xs:integer"/>
    <xsl:variable name="vMax" as="xs:integer">
      <xsl:choose>
        <xsl:when test="$vMaxOccurs castable as xs:integer">
          <xsl:sequence select="xs:integer($vMaxOccurs)"/>
        </xsl:when>
        <xsl:otherwise>
          <!-- Must be "unbounded". -->
          <xsl:sequence select="-1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="($vMin, $vMax)"/>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p><xd:ref name="atop:get-element-qname"/>:
        Given an element specification, return QName of specified element.</xd:p>
      <xd:p>The name part of the QName is taken from the first altIdent child element if present, the @ident attribute otherwise.</xd:p>
      <xd:p>The namespace URI is taken from the @ns attribute of the element specification or the containing schema specification if present. It defaults to the TEI namespace URI otherwise.</xd:p>
    </xd:desc>
    <xd:param name="pElementSpec">Element specification</xd:param>
    <xd:return>QName of specified element</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-element-qname" as="xs:QName">
    <xsl:param name="pElementSpec" as="element(elementSpec)"/>

    <xsl:variable name="vName" as="xs:string" select="($pElementSpec/altIdent[1], $pElementSpec/@ident)[1]"/>
    <xsl:variable name="vUri" as="xs:string" select="($pElementSpec/@ns, $pElementSpec/ancestor::schemaSpec[1]/@ns, 'http://www.tei-c.org/ns/1.0')[1]"/>

    <xsl:sequence select="QName($vUri, $vName)"/>

  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p><xd:ref name="atop:get-attribute-qname"/>:
        Given an attribute specification, return QName of specified attribute.</xd:p>
      <xd:p>The name part of the QName is taken from the first altIdent child element if present, the @ident attribute otherwise.</xd:p>
      <xd:p>The namespace URI is taken from the @ns attribute of the attribute specification if present. It defaults to the no-namespace empty string otherwise.</xd:p>
    </xd:desc>
    <xd:param name="pAttDef">Attribute specification</xd:param>
    <xd:return>QName of specified attribute</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-attribute-qname" as="xs:QName">
    <xsl:param name="pAttDef" as="element(attDef)"/>

    <xsl:variable name="vName" as="xs:string" select="($pAttDef/altIdent[1], $pAttDef/@ident)[1]"/>
    <xsl:variable name="vUri" as="xs:string" select="($pAttDef/@ns, '')[1]"/>

    <xsl:sequence select="QName($vUri, $vName)"/>

  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:get-element-pattern-name"/>: Construct a viable pattern
    name for a RNG element definition by concatenating the schemaSpec's prefix attribute,
    the elementSpec's own prefix, and the elementSpec's ident.</xd:desc>
    <xd:param name="pElementSpec">The elementSpec element for which a pattern name is required.</xd:param>
    <xd:return>A string value suitable for a pattern name.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-element-pattern-name" as="xs:string">
    <xsl:param name="pElementSpec" as="element(elementSpec)"/>
    <xsl:value-of select="concat($pElementSpec/ancestor::schemaSpec[1]/@prefix, $pElementSpec/@prefix, $pElementSpec/@ident)"/>
  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:get-class-pattern-name"/>: Construct a viable pattern
      name for an RNG pattern created from a TEI class by concatenating the schemaSpec's
      prefix attribute, the classSpec's own prefix, and the classSpec's ident.</xd:desc>
    <xd:param name="pClassSpec">The classSpec element for which a pattern name is required.</xd:param>
    <xd:return>A string value suitable for a pattern name.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-class-pattern-name" as="xs:string">
    <xsl:param name="pClassSpec" as="element(classSpec)"/>
    <xsl:value-of select="concat($pClassSpec/ancestor::schemaSpec[1]/@prefix, $pClassSpec/@prefix, $pClassSpec/@ident)"/>
  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:get-macro-pattern-name"/>: Construct a viable pattern
      name for an RNG pattern created from a TEI macro by concatenating the schemaSpec's
      prefix attribute, the macroSpec's own prefix, and the classSpec's ident.</xd:desc>
    <xd:param name="pMacroSpec">The macroSpec element for which a pattern name is required.</xd:param>
    <xd:return>A string value suitable for a pattern name.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-macro-pattern-name" as="xs:string">
    <xsl:param name="pMacroSpec" as="element(macroSpec)"/>
    <xsl:value-of select="concat($pMacroSpec/ancestor::schemaSpec[1]/@prefix, $pMacroSpec/@prefix, $pMacroSpec/@ident)"/>
  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:get-datatype-pattern-name"/>: Construct a viable pattern
      name for an RNG pattern created from a TEI dataSpec element. Currently this simply
    uses the dataSpec's own @ident attribute.</xd:desc>
    <xd:param name="pDataSpec">The dataSpec element for which a pattern name is required.</xd:param>
    <xd:return>A string value suitable for a pattern name.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-datatype-pattern-name" as="xs:string">
    <xsl:param name="pDataSpec" as="element(dataSpec)"/>
    <xsl:value-of select="$pDataSpec/@ident"/>
  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:get-pattern-name"/>: Construct a viable pattern
      name for an RNG pattern created from a TEI classSpec, dataSpec, elementSpec, or macroSpec element. Delegates to <xd:ref name="atop:get-class-pattern-name"/>, <xd:ref name="atop:get-datatype-pattern-name"/>, <xd:ref name="atop:get-element-pattern-name"/>, or <xd:ref name="atop:get-macro-pattern-name"/> respectively.</xd:desc>
    <xd:param name="pSpec">The dataSpec element for which a pattern name is required.</xd:param>
    <xd:return>A string value suitable for a pattern name.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-pattern-name" as="xs:string">
    <xsl:param name="pSpec" as="element()"/>
    <xsl:choose>
      <xsl:when test="$pSpec instance of element(elementSpec)">
        <xsl:value-of select="atop:get-element-pattern-name($pSpec)"/>
      </xsl:when>
      <xsl:when test="$pSpec instance of element(classSpec)">
        <xsl:value-of select="atop:get-class-pattern-name($pSpec)"/>
      </xsl:when>
      <xsl:when test="$pSpec instance of element(dataSpec)">
        <xsl:value-of select="atop:get-datatype-pattern-name($pSpec)"/>
      </xsl:when>
      <xsl:when test="$pSpec instance of element(macroSpec)">
        <xsl:value-of select="atop:get-macro-pattern-name($pSpec)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Unsupport specification element: {serialize($pSpec)}</xsl:text>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:get-class-members"/>: Return a list of elementSpec and classSpec
    elements which are members of the parameter class.</xd:desc>
    <xd:param name="pClassSpec">The classSpec whose member elementSpecs are required.</xd:param>
    <xd:param name="pSchemaSpec">The schemaSpec containing the parameter classSpec.</xd:param>
    <xd:param name="pClassSpecSeen">A list of zero or more classSpecs which have already been retrieved,
    used to check for circularity issues.</xd:param>
    <xd:return>A sequence of zero or more elementSpecs elements.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-class-members" as="element(elementSpec)*">
    <xsl:param name="pClassSpec" as="element(classSpec)"/>
    <xsl:param name="pSchemaSpec" as="element(schemaSpec)"/>
    <xsl:param name="pClassSpecSeen" as="element(classSpec)*"/>

    <xsl:for-each select="key('atop:classMembers', $pClassSpec/@ident, $pSchemaSpec)">
      <xsl:choose>
        <xsl:when test=". instance of element(classSpec)">
          <xsl:if test=". = $pClassSpecSeen">
            <xsl:message terminate="yes">
              <xsl:text>ERROR: Circular class reference.</xsl:text>
              <xsl:value-of select="$pClassSpecSeen/@ident"/>
            </xsl:message>
          </xsl:if>
          <xsl:sequence select="atop:get-class-members(., $pSchemaSpec, (., $pClassSpecSeen))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </xsl:function>

  <xd:doc>
    <xd:desc>
      <xd:p><xd:ref name="atop:repeat-content"/>:
        Given element content, an optional minimum, and an optional maximum occurrence,
        return a corresponding RelaxNG pattern.</xd:p>
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

  <xd:doc>
    <xd:desc>
      <xd:p><xd:ref name="atop:resolve-uri"/>:
        Given a URI and an optional context node, convert the URI to
        a fully-qualified URI if needed. URIs using the tei: prefix and conforming to
      TEI version patterns are treated as special, and resolved to point to
      the appropriate p5subset.xml. Other prefixes are resolved using any in-scope
      tei prefixDef elements.</xd:p>
    </xd:desc>
    <xd:param name="pUri">The private URI string</xd:param>
    <xd:param name="pContext">The context node</xd:param>
    <xd:return>A fully-qualified URI, if the process succeeds, or the original
    string if it isn't possible to resolve the URI with the resources available.</xd:return>
  </xd:doc>
  <xsl:function name="atop:resolve-uri" as="xs:anyURI">
    <xsl:param name="pUri" as="xs:anyURI"/>
    <xsl:param name="pContext" as="node()?"/>
    <xsl:variable name="vNode" as="node()"><duck/></xsl:variable>
    <xsl:variable name="vContext" as="node()" select="if (empty($pContext)) then $vNode else $pContext"/>
    <xsl:choose>
      <xsl:when test="starts-with($pUri, 'tei:')">
        <xsl:if test="not(matches($pUri, '^tei:(current|[0-9]+\.[0-9]+\.[0-9])$'))">
          <xsl:message terminate="yes" expand-text="yes"
		       error-code="atop:error-invalidOrMalformedURI">Invalid or malformed private URI using the "tei:" scheme: '{$pUri}'</xsl:message>
        </xsl:if>
        <xsl:sequence select="xs:anyURI( 'https://www.tei-c.org/Vault/P5/'
			               || substring-after($pUri, ':')
				       || '/xml/tei/odd/p5subset.xml')"/>
      </xsl:when>
      <xsl:when test="matches($pUri, $atop:vUriSchemeRegex) and $pContext">
        <xsl:variable name="vPrefix" as="xs:string" select="substring-before($pUri, ':')"/>
        <xsl:variable name="vPath" as="xs:string" select="substring-after($pUri, ':')"/>
        <xsl:variable name="vDef" as="element(prefixDef)?" select="key('atop:prefixDef', $vPrefix, $pContext)"/>
        <xsl:choose>
          <xsl:when test="empty($vDef)">
            <xsl:sequence select="$pUri"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="vUri" as="xs:anyURI" select="replace($vPath, $vDef/@matchPattern, $vDef/@replacementPattern) => xs:anyURI()"/>
            <xsl:sequence select="atop:resolve-uri($vUri, $vContext)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="resolve-uri( $pUri, base-uri( $vContext ) ) cast as xs:anyURI"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:namespace-or-name-is-name"/>: Given a string value which may
      be a namespace or a name, along with a context node, determine whether it is a name
      using one of the in-scope prefixes.</xd:desc>
    <xd:param name="pValue">The string value to be tested.</xd:param>
    <xd:param name="pContext">The context node for in-scope prefixes.</xd:param>
    <xd:return>True if it's a name, or false.</xd:return>
  </xd:doc>
  <xsl:function name="atop:namespace-or-name-is-name" as="xs:boolean">
    <xsl:param name="pValue" as="xs:string"/>
    <xsl:param name="pContext" as="node()"/>

    <xsl:choose>
      <xsl:when test="($pValue castable as xs:Name) and contains($pValue, ':') and (substring-before($pValue, ':') = in-scope-prefixes($pContext))">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xd:doc>
    <xd:desc><xd:ref name="atop:namespace-or-name-is-namespace-uri"/>: Given a string value which may
      be a namespace or a name, along with a context node, determine whether it is a namespace and
      not a name.</xd:desc>
    <xd:param name="pValue">The string value to be tested.</xd:param>
    <xd:param name="pContext">The context node for in-scope prefixes.</xd:param>
    <xd:return>True if it's a namespace and not a name, or false.</xd:return>
  </xd:doc>
  <xsl:function name="atop:namespace-or-name-is-namespace-uri" as="xs:boolean">
    <xsl:param name="pValue" as="xs:string"/>
    <xsl:param name="pContext" as="node()"/>

    <xsl:choose>
      <xsl:when test="($pValue castable as xs:anyURI) and not(atop:namespace-or-name-is-name($pValue, $pContext))">
        <xsl:sequence select="true()"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="false()"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>
  
  
  <!-- NOTE: Questions for the ATOP team: Should we care about namespace declarations 
       using sch:ns elements? -->
  <xd:doc>
    <xd:desc><xd:ref name="atop:get-nearest-ns"/>: Gets the namespace-uri which is closest in 
    the hierarchy for a tagdocs element. This function gets to work on a number of assumptions
    because it will be called on elements from a PLODD file, not a file earlier in the
    process.</xd:desc>
    <xd:param name="pEl" as="element()">The PLODD file element for which we need to derive 
      the namespace.</xd:param>
    <xd:return as="xs:string">The nearest namespace, if any is defined; otherwise, 
      the defaults, which are the empty string (for attDefs) or the TEI namespace 
      (for other contexts).</xd:return>
  </xd:doc>
  <!-- NOTE: The new constraintDecl element which may appear should be 
       handled here. -->
  <xsl:function name="atop:get-nearest-ns" as="xs:string">
    <xsl:param name="pEl" as="element()"/>
    <xsl:variable name="vScopeEl" as="element()" select="$pEl/ancestor-or-self::*[self::attDef or self::elementSpec or self::schemaSpec][1]"/>
    <xsl:choose>
      <xsl:when test="$vScopeEl/self::attDef">
        <xsl:sequence select="if ($vScopeEl/@ns) then $vScopeEl/@ns else ''"/>
      </xsl:when>
      <xsl:when test="$vScopeEl/@ns"><xsl:sequence select="$vScopeEl/@ns"/></xsl:when>
      <xsl:when test="$vScopeEl/ancestor::*[@ns]"><xsl:sequence select="$vScopeEl/ancestor::*[@ns][1]/@ns"/></xsl:when>
      <xsl:otherwise>
        <!-- NOTE: we should use one of the global variables, but for testing the 
             XSpec only knows about the functions module. Needs discussion. -->
        <xsl:sequence select="'http://www.tei-c.org/ns/1.0'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc>
    <xd:desc><xd:ref name="atop:get-schematron-context"/>: Given a context (which is a Schematron
      fragment, inside a constraint element, but lacking @context), derive XPath to serve 
      as the @context value in a fully-realized Schematron rule. This is heavily based on 
      SB's code in extract-isosch.xsl.
    </xd:desc>
    <xd:param name="pContext" as="element()">The highest-level Schematron element for 
    which a context needs to be derived.</xd:param>
    <xd:param name="pMapSchNs" as="map(xs:string, xs:string)">A map in which every prefix and namespace is a key to its
      corresponding namespace or prefix.</xd:param>
    <xd:return>A string value suitable for use as @context on a Schematron rule.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-schematron-context" as="xs:string">
    <xsl:param name="pContext" as="element()"/>
    <xsl:param name="pMapSchNs" as="map(xs:string, xs:string)"/>
    <xsl:choose>
      <xsl:when test="$pContext/ancestor::attDef[ancestor::elementSpec]">
        <xsl:variable name="vElName" as="xs:string" select="$pContext/ancestor::elementSpec/@ident"/>
        <xsl:variable name="vElNs" as="xs:string" select="atop:get-nearest-ns($pContext/ancestor::elementSpec)"/>
        <xsl:variable name="vElPrefix" as="xs:string" select="if (map:contains($pMapSchNs, $vElNs)) then map:get($pMapSchNs, $vElNs) || ':' else 'tei:'"/>
        <xsl:variable name="vAttName" as="xs:string" select="$pContext/ancestor::attDef[1]/@ident"/>
        <xsl:variable name="vAttNs" as="xs:string" select="atop:get-nearest-ns($pContext/ancestor::attDef[1])"/>
        <xsl:variable name="vAttPrefix" as="xs:string" select="if (map:contains($pMapSchNs, $vAttNs)) then map:get($pMapSchNs, $vAttNs) || ':' else ''"/>
        <xsl:sequence select="$vElPrefix || $vElName || '/@' || $vAttPrefix || $vAttName"/>
      </xsl:when>
      <xsl:when test="$pContext/ancestor::elementSpec">
        <xsl:variable name="vElName" as="xs:string" select="$pContext/ancestor::elementSpec/@ident"/>
        <xsl:variable name="vElNs" as="xs:string" select="atop:get-nearest-ns($pContext/ancestor::elementSpec)"/>
        <xsl:variable name="vElPrefix" as="xs:string" select="if (map:contains($pMapSchNs, $vElNs)) then map:get($pMapSchNs, $vElNs) || ':' else 'tei:'"/>
        <xsl:sequence select="$vElPrefix || $vElName"/>
      </xsl:when>
      <xsl:when test="$pContext/ancestor::classSpec">
        <xsl:message terminate="yes" expand-text="yes" error-code="atop:error-invalidSchematronContext">Schematron rule with content {xs:string($pContext)} is located in a classSpec, so it is impossible to derive a working context for it. Please supply @context.</xsl:message>
      </xsl:when>
      <xsl:when test="$pContext/ancestor::macroSpec">
        <xsl:message terminate="yes" expand-text="yes" error-code="atop:error-invalidSchematronContext">Schematron rule with content {xs:string($pContext)} is located in a macroSpec, so it is impossible to derive a working context for it. Please supply @context.</xsl:message>
      </xsl:when>
      <xsl:when test="$pContext/ancestor::schemaSpec">
        <xsl:sequence select="'/'"/>
      </xsl:when>
    </xsl:choose>
  </xsl:function>
  
  <xd:doc>
    <xd:desc><xd:ref name="atop:get-sch-ns-prefix-map"/>: Given a context (which is typically 
    an XML document such as a PLODD file), construct a two-way map whereby every declared 
    Schematron namespace is a key to a single prefix for that namespace, and every distinct 
    prefix is a key to its matching namespace. This enables us to quickly look up the correct
    ns for any prefix, or prefix for any ns, when processing Schematron fragments, and 
    also to generate a collection of ns elements covering all the Schematron in the document.</xd:desc>
    <xd:param name="pContext" as="node()">The context to process, which may be a complete document.</xd:param>
    <xd:return as="map(xs:string, xs:string)">A map in which every prefix and namespace is a key to its
    corresponding namespace or prefix.</xd:return>
  </xd:doc>
  <xsl:function name="atop:get-sch-ns-prefix-map" as="map(xs:string, xs:string)" new-each-time="no">
    <xsl:param name="pContext" as="node()"/>
    <xsl:variable name="vExplicitNs" as="element(sch:ns)*" select="$pContext/descendant::sch:ns"/>
    <!-- Code thanks to @dmaus. -->
    <xsl:variable name="vNamespaces" as="element(sch:ns)*">
      <xsl:iterate select="$pContext/descendant::sch:*">
        <xsl:param name="pNs" as="element(sch:ns)*" select="$vExplicitNs"/>
        <xsl:on-completion select="$pNs"/>
        <xsl:variable name="vCurrent" as="element()" select="."/>
        <xsl:next-iteration>
          <xsl:with-param name="pNs" as="element(sch:ns)*">
            <xsl:sequence select="$pNs"/>
            <xsl:for-each select="in-scope-prefixes($vCurrent)[not(. = ('', 'xml'))]">
              <xsl:choose>
                <xsl:when test="empty($pNs[@prefix eq current()])">
                  <sch:ns prefix="{.}" uri="{namespace-uri-for-prefix(., $vCurrent)}"/>
                </xsl:when>
                <!-- We only warn when a prefix is used for two different namespaces; we discard all but the first. -->
                <xsl:when test="$pNs[@prefix eq current()]/@uri ne namespace-uri-for-prefix(., $vCurrent)">
                  <xsl:message expand-text="yes">WARNING: Ambiguous in-scope namespace declaration for prefix {.}</xsl:message>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </xsl:with-param>
        </xsl:next-iteration>
      </xsl:iterate>
      <!-- We also need any declarations in @ns attributes, which won't necessarily have discoverable prefixes. -->
      <xsl:for-each select="$pContext/descendant::*[@ns]">
        <sch:ns prefix="{generate-id(.)}" uri="{@ns}"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:map>
      <xsl:for-each select="distinct-values($vNamespaces/@uri)">
        <xsl:variable name="vCurrNs" as="xs:string" select="."/>
        <xsl:message select="$vCurrNs"/>
        <xsl:variable name="vCurrNs" as="element(sch:ns)" select="$vNamespaces[@uri=$vCurrNs][1]"/>
        <xsl:map-entry key="xs:string($vCurrNs/@prefix)" select="xs:string($vCurrNs/@uri)"/>
        <xsl:map-entry key="xs:string($vCurrNs/@uri)" select="xs:string($vCurrNs/@prefix)"/>
      </xsl:for-each>
    </xsl:map>
  </xsl:function>  
  
  
  <xd:doc>
    <xd:desc>This function is called when a *Ref element points to no spec element or more than 
      one spec element; it fails the build with an appropriate error.</xd:desc>
    <xd:param name="pSpecCount" as="xs:integer">The number of spec elements found (0 or > 1)</xd:param>
    <xd:param name="pSpecIdent" as="xs:string">The ident of the target spec element</xd:param> 
    <xd:param name="pSpecType" as="xs:string">The type (element name) of the target spec element</xd:param>
  </xd:doc>
  <xsl:function name="atop:bad-spec-pointer" as="item()*">
    <xsl:param name="pSpecCount" as="xs:integer"/>
    <xsl:param name="pSpecIdent" as="xs:string"/> 
    <xsl:param name="pSpecType" as="xs:string"/>
    <xsl:if test="$pSpecCount lt 1">
      <xsl:message terminate="yes">
        <xsl:text>Unable to resolve class reference. There is no {$pSpecType} class '{$pSpecIdent}' in the current schema.</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:if test="$pSpecCount > 1">
      <xsl:message terminate="yes">
        <xsl:text>Unable to resolve class reference. There is more then one {$pSpecType} '{$pSpecIdent}' in the current schema.</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:function>
  
</xsl:stylesheet>
