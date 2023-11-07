<xsl:transform version="3.0" expand-text="yes"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:atop="http://www.tei-c.org/ns/atop"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
               xmlns:sch="http://purl.oclc.org/dsdl/schematron"
               xmlns:map="http://www.w3.org/2005/xpath-functions/map">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>Experimental Pruned, Localized ODD to RelaxNG transpiler</xd:p>
    </xd:desc>
  </xd:doc>

  <xd:doc>
    <xd:desc>Ignore things that we're not expecting. This might change when
    the PLODD specification is clearer and we have strategies for responding
    to unexpected content.</xd:desc>
  </xd:doc>
  <xsl:mode on-no-match="shallow-skip"/>
  
  
  <xd:doc>
    <xd:desc>A special mode to enable us to process &lt;constraintSpecs> in the 
    specific location we want to.</xd:desc>
  </xd:doc>
  <xsl:mode name="schematron" on-no-match="shallow-copy"/>
  
  <xsl:output indent="yes" method="xml" encoding="UTF-8" normalization-form="NFC"
              exclude-result-prefixes="#all"/>

  <xsl:include href="modules/functions_module.xslt"/>
  <xsl:include href="assemble-relaxng.xslt"/>
  

  <xd:doc>
    <xd:desc><xd:ref name="atop:vMapSchNs"/>: A map of all in-scope namespaces, each with 
    a selected prefix.</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vMapSchNs" as="map(xs:string, xs:string)" select="atop:get-sch-ns-prefix-map(/)"/>


  <xd:doc>
    <xd:desc>The TEI &lt;schemaSpec> becomes the RELAX NG &lt;grammar>.</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" as="element(rng:grammar)">
    <!-- We assume that if there is no @start attribute, the start element is <TEI>. -->
    <xsl:variable name="vStartElementSpecs" as="element(elementSpec)+"
                  select="key('atop:elementSpec', if (@start) then tokenize(@start) else 'TEI', .)"/>
    <rng:grammar datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
      <!--
	  Make sure to keep namespace declarations, because in RELAX
	  NG the namespace specified by the prefix of a QName in the
	  @name attribute takes precedence over the @ns attribute.
      -->
      <xsl:copy-of select="namespace-node()"/>

      <!--
	  Start with an alternation of the @start elements. Note that
	  if there is only 1 @start element we end up with a single
	  <ref> inside a <choice>, which looks kinda weird but is no
	  problem for RELAX NG. (As evidence, `trang` happily converts
	  it to the compact syntax; when you convert back again, the
	  <choice> has been dropped.)
      -->
      <rng:start>
        <rng:choice>
          <xsl:for-each select="$vStartElementSpecs">
            <rng:ref name="{atop:get-element-pattern-name(.)}"/>
          </xsl:for-each>
        </rng:choice>
      </rng:start>

      <!--
	  Generate <define> patterns for <anyElement> descendants
	  separately, as they are more complex.
      -->
      <xsl:apply-templates mode="atop:anyElement">
        <xsl:with-param name="tpDefaultExceptions" as="xs:string*" select="tokenize((@defaultExceptions, 'http://www.tei-c.org/ns/1.0 teix:egXML')[1])" tunnel="yes"/>
      </xsl:apply-templates>
      <!-- Generate the rest of the schema based on the children of this <schemaSpec> -->
      <xsl:apply-templates/>
      
      <!-- Now we output any Schematron required. -->
      <xsl:if test="descendant::constraintSpec[@scheme eq 'schematron']">
        <rng:div>
          <xsl:comment> Schematron rules </xsl:comment>
          
          <!-- Now we build the collection of Schematron namespaces we need. -->
          <xsl:comment><xsl:sequence select="'Namespace declarations (' || map:size($atop:vMapSchNs) div 2 || ')'"/></xsl:comment>
          <xsl:for-each select="map:keys($atop:vMapSchNs)[not(contains(., ':'))]">
            <sch:ns prefix="{.}" uri="{map:get($atop:vMapSchNs, .)}"/>
          </xsl:for-each>
          
          <!-- Is this the right level at which to proceed? -->
          <xsl:apply-templates select="descendant::constraintSpec[@scheme eq 'schematron']" mode="schematron"/>          
        </rng:div>
      </xsl:if>
      
    </rng:grammar>
  </xsl:template>

  <!-- NOTE FOR DM: Is there any reason that this and the following
       two templates could not be combined into one? e.g.: -->
  <!-- DM, 2022-12-07: Having separate templates for macroSpec,
       dataSpec, classSpec[attList] is a scaffold. We can merge them
       once we are convinced that translating to a named pattern is
       the right thing in both cases. See classSpec[atttList]: Turns
       out we don't define a pattern. -->
  <!--<xsl:template match="macroSpec | dataSpec | classSpec[attList]" as="element(rng:define)">
    <rng:define name="{atop:get-macro-pattern-name(.)}">
      <xsl:apply-templates/>
    </rng:define>
  </xsl:template>-->

  <xsl:template match="macroSpec" as="element(rng:define)">
    <rng:define name="{atop:get-macro-pattern-name(.)}">
      <xsl:apply-templates/>
    </rng:define>
  </xsl:template>

  <xsl:template match="dataSpec" as="element(rng:define)">
    <rng:define name="{atop:get-datatype-pattern-name(.)}">
      <xsl:apply-templates/>
    </rng:define>
  </xsl:template>

  <xsl:template match="classSpec[@type eq 'atts']" as="element(rng:define)">
    <rng:define name="{atop:get-class-pattern-name(.)}">
      <xsl:apply-templates/>
    </rng:define>
  </xsl:template>

  <xsl:template match="classSpec" as="empty-sequence()" priority="-10"/>

  <!-- An element specification transpiles to a named RelaxNG pattern
       w/ defining the element. -->
  <xsl:template match="elementSpec" as="element(rng:define)">
    <xsl:variable name="vQName" as="xs:QName" select="atop:get-element-qname(.)"/>
    <xsl:variable name="vContent" as="element()*">
      <xsl:apply-templates select="* except classes"/>
    </xsl:variable>

    <rng:define name="{atop:get-element-pattern-name(.)}">
      <rng:element name="{local-name-from-QName($vQName)}"
                   ns="{namespace-uri-from-QName($vQName)}">
        <xsl:apply-templates select="classes"/>
        <xsl:choose>
          <xsl:when test="empty($vContent)">
            <rng:empty/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:sequence select="$vContent"/>
          </xsl:otherwise>
        </xsl:choose>
      </rng:element>
    </rng:define>
  </xsl:template>

  <xsl:template match="(elementSpec | classSpec[@type eq 'atts'])/classes/memberOf" as="element(rng:ref)?">
    <xsl:variable name="vClassSpec" as="element(classSpec)" select="key('atop:classSpec', @key, ancestor::schemaSpec)"/>
    <xsl:if test="$vClassSpec/@type = 'atts'">
      <rng:ref name="{atop:get-class-pattern-name($vClassSpec)}"/>
    </xsl:if>
  </xsl:template>

  <!-- An attribute list transpiles to the sequence or alternate
       pattern. A fallback template catches unsupported attribute list
       types. -->
  <xsl:template match="attList[empty(@org) or @org eq 'group']" as="element(rng:group)">
    <rng:group>
      <xsl:apply-templates/>
    </rng:group>
  </xsl:template>

  <xsl:template match="attList[@org eq 'choice']" as="element(rng:choice)">
    <rng:choice>
      <xsl:apply-templates/>
    </rng:choice>
  </xsl:template>

  <xsl:template match="attList" priority="-10" as="empty-sequence()">
    <xsl:message terminate="yes">
      <xsl:text>The attribute list type '{@org}' is not supported. This version of only supports the types 'choice' and 'group'.</xsl:text>
    </xsl:message>
  </xsl:template>

  <!-- An attribute specifcation transpiles to an (optional) attribute
       pattern. -->
  <xsl:template match="attDef[empty(@usage) or @usage = ('opt', 'rec')]" as="element(rng:optional)">
    <rng:optional>
      <xsl:next-match/>
    </rng:optional>
  </xsl:template>

  <xsl:template match="attDef" as="element(rng:attribute)">
    <xsl:variable name="vQName" as="xs:QName" select="atop:get-attribute-qname(.)"/>

    <rng:attribute name="{local-name-from-QName($vQName)}"
                   ns="{namespace-uri-from-QName($vQName)}">

      <!--

An attribute specification may contain a value list (valList) and
a datatype specification (datatype), one of either, or none.

The current processor works as follows:

If the attDef contains a valList[@type = 'open'], we use the datatype
specification and list the members of the value list in an annotation.

If the attDef contains a valList[@type = 'semi'], the content model is
a choice between the datatype and the members of the value list.

If the attDef contains a valList[@type = 'closed'], the datatype is
ignored and the members of the value list are provided.

      -->
      <xsl:choose>
        <xsl:when test="valList[empty(@type) or @type eq 'open']">
          <a:documentation>
            <xsl:variable name="vSampleValues" as="xs:string*">
              <xsl:for-each select="valList/valItem">
                <xsl:text>{position()}] {@ident}</xsl:text>
              </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="$vSampleValues"/>
          </a:documentation>
          <xsl:apply-templates select="datatype"/>
        </xsl:when>
        <xsl:when test="valList[@type eq 'semi']">
          <rng:choice>
            <xsl:apply-templates/>
          </rng:choice>
        </xsl:when>
        <xsl:when test="valList[@type eq 'closed']">
          <xsl:apply-templates select="valList"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </rng:attribute>
  </xsl:template>

  <xsl:template match="datatype" as="element()">
    <xsl:variable name="vDatatypeContent" as="element()+">
      <xsl:apply-templates/>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$vDatatypeContent/self::rng:text">
        <xsl:sequence select="$vDatatypeContent"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="vDatatypeContentRepeat" as="element()+">
          <xsl:call-template name="atop:repeat-content">
            <xsl:with-param name="pContent" as="element()*" select="$vDatatypeContent"/>
            <xsl:with-param name="pMinOccurrence" as="xs:integer?" select="@minOccurs"/>
            <xsl:with-param name="pMaxOccurrence" as="xs:string?" select="@maxOccurs"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="count($vDatatypeContentRepeat) eq 1">
            <xsl:sequence select="$vDatatypeContentRepeat"/>
          </xsl:when>
          <xsl:otherwise>
            <rng:list>
              <xsl:sequence select="$vDatatypeContentRepeat"/>
            </rng:list>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="valList[empty(@type) or @type = 'open']" as="empty-sequence()"/>

  <xsl:template match="valList[@type eq 'closed']" as="element(rng:choice)">
    <rng:choice>
      <xsl:apply-templates/>
    </rng:choice>
  </xsl:template>

  <xsl:template match="valList[@type eq 'semi']" as="element(rng:value)+">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="valList" priority="-10" as="empty-sequence()">
    <xsl:message terminate="yes">
      <xsl:text>The value list type '{@type}' is not supported. This version of atop only supports the types 'open', 'semi', and 'closed'.</xsl:text>
    </xsl:message>
  </xsl:template>

  <xsl:template match="valItem" as="element(rng:value)">
    <rng:value>
      <xsl:text>{@ident}</xsl:text>
    </rng:value>
  </xsl:template>

  <!-- Process members of model.contentPart -->
  <xsl:template match="sequence | interleave | alternate" as="element()*">
    <xsl:variable name="vRngOutputElementName" as="xs:NCName">
      <xsl:choose>
        <xsl:when test="self::alternate">choice</xsl:when>
        <xsl:when test="self::sequence[ not( @preserveOrder eq 'false') ]">group</xsl:when>
        <xsl:otherwise>interleave</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="atop:repeat-content">
      <xsl:with-param name="pContent" as="element()">
        <xsl:element name="{$vRngOutputElementName}" namespace="http://relaxng.org/ns/structure/1.0">
          <xsl:apply-templates/>
        </xsl:element>
      </xsl:with-param>
      <xsl:with-param name="pMinOccurrence" as="xs:integer?" select="@minOccurs"/>
      <xsl:with-param name="pMaxOccurrence" as="xs:string?" select="@maxOccurs"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="empty" as="element(rng:empty)">
    <rng:empty/>
  </xsl:template>

  <xsl:template match="textNode" as="element(rng:text)">
    <rng:text/>
  </xsl:template>

  <xsl:template match="elementRef" as="element()+">
    <xsl:variable name="vElementSpec" as="element(elementSpec)" select="key('atop:elementSpec', @key)"/>
    <xsl:call-template name="atop:repeat-content">
      <xsl:with-param name="pContent" as="element()*">
        <rng:ref name="{atop:get-element-pattern-name($vElementSpec)}"/>
      </xsl:with-param>
      <xsl:with-param name="pMinOccurrence" as="xs:integer?" select="@minOccurs"/>
      <xsl:with-param name="pMaxOccurrence" as="xs:string?" select="@maxOccurs"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="classRef" as="element()*">
    <xsl:variable name="vClassSpec" as="element(classSpec)*" select="key('atop:classSpec', @key, ancestor::schemaSpec)"/>

    <xsl:if test="empty($vClassSpec)">
      <xsl:message terminate="yes">
        <xsl:text>Unable to resolve class reference. There is no class '{@key}' in the current schema {ancestor::schemaSpec/@ident}.</xsl:text>
      </xsl:message>
    </xsl:if>

    <xsl:if test="count($vClassSpec) > 1">
      <xsl:message terminate="yes">
        <xsl:text>Unable to resolve class reference. There is more then one class '{@key}' in the current schema {ancestor::schemaSpec/@ident}.</xsl:text>
      </xsl:message>
    </xsl:if>

    <!-- This chunk of code (that deals with @generate) should be
         removed as soon as TEI has deprecated and removed that
         attribute. (See https://github.com/TEIC/TEI/issues/2369.)
         — Syd, 2023-09-20 -->
    <!-- Create reference to class members -->
    <xsl:variable name="vExpand" as="xs:string" select="(@expand, 'alternation')[1]"/>
    <xsl:if test="exists(tokenize($vClassSpec/@generate))">
      <xsl:if test="not($vExpand = tokenize($vClassSpec/@generate))">
        <xsl:message terminate="yes">
          <xsl:text>ERROR: Cannot expand members of the class '{@key}' as '{$vExpand}' because the class only allows </xsl:text>
          <xsl:value-of select='for $token in tokenize($vClassSpec/@generate) return concat("&apos;", $token, "&apos;")'/>
        </xsl:message>
      </xsl:if>
    </xsl:if>

    <xsl:variable name="vAllClassMembers" as="element(elementSpec)*" select="atop:get-class-members($vClassSpec, ancestor::schemaSpec, ())"/>
    <xsl:variable name="vClassMembers" as="element(elementSpec)*">
      <xsl:choose>
        <xsl:when test="@except">
          <xsl:variable name="vExcept" as="xs:string*" select="tokenize(@except)"/>
          <xsl:if test="$vExcept[not(. = $vAllClassMembers/@ident)]">
            <xsl:message terminate="yes">
              <xsl:text>ERROR: The elements </xsl:text>
              <xsl:value-of select="$vExcept[not(. = $vAllClassMembers/@ident)]"/>
              <xsl:text> should be excluded but are not members of the class '{@key}'.</xsl:text>
            </xsl:message>
          </xsl:if>
          <xsl:sequence select="$vAllClassMembers[not(@ident = $vExcept)]"/>
        </xsl:when>
        <xsl:when test="@include">
          <xsl:variable name="vInclude" as="xs:string*" select="tokenize(@include)"/>
          <xsl:if test="$vInclude[not(. = $vAllClassMembers/@ident)]">
            <xsl:message terminate="yes">
              <xsl:text>ERROR: The elements </xsl:text>
              <xsl:value-of select="$vInclude[not(. = $vAllClassMembers/@ident)]"/>
              <xsl:text> should be included but are not members of the class '{@key}'.</xsl:text>
            </xsl:message>
          </xsl:if>
          <xsl:sequence select="$vAllClassMembers[@ident = $vInclude]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:sequence select="$vAllClassMembers"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:if test="exists($vClassMembers)">

      <xsl:variable name="vContent" as="element()">
        <xsl:element name="{if ($vExpand eq 'alternation') then 'rng:choice' else 'rng:group'}">

          <xsl:for-each select="$vClassMembers">
            <xsl:variable name="vReference" as="element()">
              <xsl:choose>
                <xsl:when test="$vExpand eq 'sequenceRepeatable'">
                  <rng:oneOrMore>
                    <rng:ref name="{atop:get-element-pattern-name(.)}"/>
                  </rng:oneOrMore>
                </xsl:when>
                <xsl:when test="$vExpand eq 'sequenceOptionalRepeatable'">
                  <rng:zeroOrMore>
                    <rng:ref name="{atop:get-pattern-name(.)}"/>
                  </rng:zeroOrMore>
                </xsl:when>
                <xsl:otherwise>
                  <rng:ref name="{atop:get-element-pattern-name(.)}"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>

            <xsl:choose>
              <xsl:when test="$vExpand = ('sequenceOptional')">
                <rng:optional>
                  <xsl:sequence select="$vReference"/>
                </rng:optional>
              </xsl:when>
              <xsl:otherwise>
                <xsl:sequence select="$vReference"/>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:for-each>
        </xsl:element>
      </xsl:variable>

      <xsl:call-template name="atop:repeat-content">
        <xsl:with-param name="pContent" as="element()*" select="$vContent"/>
        <xsl:with-param name="pMinOccurrence" as="xs:integer?" select="@minOccurs"/>
        <xsl:with-param name="pMaxOccurrence" as="xs:string?" select="@maxOccurs"/>
      </xsl:call-template>

    </xsl:if>

  </xsl:template>

  <xd:doc>
    <xd:desc>
      <xd:p>The tei:anyElement content model item is special as it creates a recursive RelaxNG pattern.</xd:p>
    </xd:desc>
  </xd:doc>
  <xsl:mode name="atop:anyElement" on-no-match="shallow-skip"/>

  <xd:doc>
    <xd:desc></xd:desc>
    <xd:param name="tpDefaultExceptions" as="xs:string" tunnel="yes">A list of namespaces and/or prefixed
    element names to be excluded by default from anyName in the schema; this is taken from
    schemaSpec/@defaultExceptions.</xd:param>
  </xd:doc>
  <xsl:template match="anyElement" mode="atop:anyElement" as="element(rng:define)">
    <xsl:param name="tpDefaultExceptions" as="xs:string*" tunnel="yes"/>

    <xsl:variable name="vPatternName" as="xs:string" select="generate-id()"/>
    <xsl:variable name="vExceptions" as="xs:string*" select="if (@except) then tokenize(@except, '\s+') else $tpDefaultExceptions"/>
    <xsl:variable name="vScope" as="element(anyElement)" select="."/>

    <rng:define name="{$vPatternName}">
      <rng:element>
        <xsl:choose>
          <xsl:when test="@require">
            <rng:choice>
              <xsl:for-each select="tokenize(@require)">
                <xsl:variable name="vNamespaceUri" as="xs:string" select="."/>
                <rng:nsName ns="{$vNamespaceUri}">
                  <xsl:where-populated>
                    <rng:exclude>
                      <xsl:for-each select="$vExceptions[atop:namespace-or-name-is-name(., $vScope)]">
                        <xsl:if test="$vNamespaceUri eq namespace-uri-for-prefix(substring-before(., ':'), $vScope)">
                          <rng:name><xsl:sequence select="."/></rng:name>
                        </xsl:if>
                      </xsl:for-each>
                    </rng:exclude>
                  </xsl:where-populated>
                </rng:nsName>
              </xsl:for-each>
            </rng:choice>
          </xsl:when>
          <xsl:otherwise>
            <rng:anyName>
              <xsl:where-populated>
                <rng:except>
                  <xsl:for-each select="$vExceptions">
                    <xsl:choose>
                      <xsl:when test="atop:namespace-or-name-is-name(., $vScope)">
                        <rng:name>
                          <xsl:text>{.}</xsl:text>
                        </rng:name>
                      </xsl:when>
                      <xsl:otherwise>
                        <rng:nsName ns="{.}"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:for-each>
                </rng:except>
              </xsl:where-populated>
            </rng:anyName>
          </xsl:otherwise>
        </xsl:choose>
        <rng:zeroOrMore>
          <rng:attribute>
            <rng:anyName/>
          </rng:attribute>
        </rng:zeroOrMore>
        <rng:zeroOrMore>
          <rng:choice>
            <rng:text/>
            <rng:ref name="{$vPatternName}"/>
          </rng:choice>
        </rng:zeroOrMore>
      </rng:element>
    </rng:define>

  </xsl:template>

  <xsl:template match="anyElement" as="element(rng:ref)">
    <rng:ref name="{generate-id()}"/>
  </xsl:template>

  <xsl:template match="macroRef" as="element(rng:ref)">
    <xsl:variable name="vMacroSpec" as="element(macroSpec)" select="key('atop:macroSpec', @key, ancestor::schemaSpec)"/>
    <rng:ref name="{atop:get-macro-pattern-name($vMacroSpec)}"/>
  </xsl:template>

  <xsl:template match="dataRef[@name]" as="element(rng:data)">
    <rng:data type="{@name}">
      <xsl:if test="@restriction">
        <rng:param name="pattern">
          <xsl:text>{@restriction}</xsl:text>
        </rng:param>
      </xsl:if>
      <xsl:apply-templates/>
    </rng:data>
  </xsl:template>

  <xsl:template match="dataFacet" as="element(rng:param)">
    <rng:param name="{@name}">
      <xsl:text>{@value}</xsl:text>
    </rng:param>
  </xsl:template>

  <xsl:template match="dataRef[@key]" as="element()">
    <xsl:variable name="vDataSpec" as="element(dataSpec)" select="key('atop:dataSpec', @key, ancestor::schemaSpec)"/>
    <xsl:apply-templates select="$vDataSpec/*"/>
  </xsl:template>

  <xsl:template match="dataRef" priority="-10" as="empty-sequence()">
    <xsl:message terminate="yes">
      <xsl:text>Unsupported datatype specification reference. This version of atop only supports references to XML Schema datatypes (@name) and ODD datatype specifications (@key).</xsl:text>
    </xsl:message>
  </xsl:template>

  <xsl:template match="rng:define/@name | rng:ref/@name" as="attribute(name)">
    <xsl:param name="tpNamePrefix" tunnel="yes" as="xs:string?"/>
    <xsl:attribute name="name" select="concat($tpNamePrefix, .)"/>
  </xsl:template>

  <xsl:template match="rng:*" as="element()">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="moduleRef[@url]/content" as="element(content)">
    <xsl:variable name="vInclusion" as="node()">
      <xsl:apply-templates mode="atop:rngCombine" select="doc(../@url)"/>
    </xsl:variable>
    <xsl:copy>
      <xsl:sequence select="@*"/>
      <xsl:apply-templates select="$vInclusion">
        <xsl:with-param name="tpPrefix" as="xs:string" select="../@prefix"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="node()"/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>By default we suppress the processing of constraintSpec where it appears
    in the schemaSpec; instead we collect all constraintSpecs and process them 
    into a single div at the end of the RNG schema.</xd:desc>
  </xd:doc>
  <xsl:template match="constraintSpec" as="item()*"/>
  
  <xd:doc>
    <xd:desc>When we do process constraintSpecs all together, we start in 
    a distinct mode, but then revert to the default mode. Each constraintSpec
    gets an rng:div of its own, to group documentation with it.</xd:desc>
  </xd:doc>
  <xsl:template match="constraintSpec" as="item()*" mode="schematron">
    <rng:div>
      <xsl:if test="not(child::desc)">
        <a:documentation xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0">
          <xsl:sequence select="@ident"/>
        </a:documentation>
      </xsl:if>
      <xsl:apply-templates mode="schematron"/>
    </rng:div>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a constraintSpec has a desc, we should output it as an 
    annotation in the RNG.</xd:desc>
  </xd:doc>
  <xsl:template match="constraintSpec/desc" as="element(a:documentation)" mode="schematron">
    <a:documentation xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0">
      <xsl:sequence select="parent::constraintSpec/@ident || ': '"/>
      <xsl:sequence select="xs:string(.)"/>
    </a:documentation>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>We check the contents of the constraint element, and output any 
      complete sch:patterns, then we wrap any sch:rules in sch:patterns,
      then finally we create sch:pattern and sch:rule elements to contain 
      any lower-level Schematron elements.</xd:desc>
  </xd:doc>
  <xsl:template match="constraint" as="element()*" mode="schematron">
    <!-- First we output any complete Schematron components. -->
    <xsl:for-each select="child::*[self::sch:pattern or self::sch:ns]">
      <xsl:apply-templates mode="#current"/>
    </xsl:for-each>
    <!-- Next, we wrap any rule children in patterns. -->
    <xsl:for-each select="child::sch:rule">
      <sch:pattern>
        <xsl:apply-templates select="." mode="#current"/>
      </sch:pattern>
    </xsl:for-each>
    <!-- Finally, we create pattern/rule containers for any lower-level elements. -->
    <xsl:if test="child::sch:*[not(self::sch:pattern or self::sch:ns or self::sch:rule)]">
      <sch:pattern>
        <sch:rule context="{atop:get-schematron-context(., atop:get-sch-ns-prefix-map(/))}">
          <xsl:apply-templates select="child::sch:*[not(self::sch:pattern or self::sch:ns or self::sch:rule)]" mode="#current"/>
        </sch:rule>
      </sch:pattern>
    </xsl:if>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>An explicit rule which lacks a context must get one.</xd:desc>
  </xd:doc>
  <xsl:template match="sch:rule[not(@context)]" as="element(sch:rule)" mode="schematron">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:attribute name="context" select="atop:get-schematron-context(., atop:get-sch-ns-prefix-map(/))"/>
      <xsl:apply-templates mode="schematron"/>
    </xsl:copy>
  </xsl:template>
  
</xsl:transform>
