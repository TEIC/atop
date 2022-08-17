<xsl:transform version="3.0" expand-text="yes"
               xpath-default-namespace="http://www.tei-c.org/ns/1.0"
               xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
               xmlns:atop="http://www.tei-c.org/ns/atop"
               xmlns:rng="http://relaxng.org/ns/structure/1.0"
               xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p>Experimental Purified ODD to RelaxNG transpiler</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:mode on-no-match="shallow-skip"/>

  <xsl:output indent="yes"/>

  <xsl:include href="modules/functions_module.xslt"/>

  <xsl:template match="schemaSpec" as="element(rng:grammar)">
    <rng:grammar datatypeLibrary="http://www.w3.org/2001/XMLSchema-datatypes">
      <rng:start>
        <xsl:for-each select="if (@start) then tokenize(@start, '\s+') else 'TEI'">
          <rng:ref name="{.}"/>
        </xsl:for-each>
      </rng:start>
      <xsl:apply-templates mode="atop:anyElement">
        <xsl:with-param name="tpDefaultExceptions" as="xs:string*" select="tokenize((@defaultExceptions, 'http://www.tei-c.org/ns/1.0 teix:egXML')[1], '\s+')" tunnel="yes"/>
      </xsl:apply-templates>
      <xsl:apply-templates/>
    </rng:grammar>
  </xsl:template>

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

  <xsl:template match="classSpec[attList]" as="element(rng:define)">
    <rng:define name="{atop:get-class-pattern-name(.)}">
      <xsl:apply-templates/>
    </rng:define>
  </xsl:template>

  <!-- An element specification transpiles to a named RelaxNG pattern
       w/ defining the element. -->
  <xsl:template match="elementSpec" as="element(rng:define)">
    <xsl:variable name="vQName" as="xs:QName" select="atop:get-element-qname(.)"/>
    <xsl:variable name="vContent" as="element()*">
      <xsl:apply-templates/>
    </xsl:variable>

    <rng:define name="{atop:get-element-pattern-name(.)}">
      <rng:element name="{local-name-from-QName($vQName)}"
                   ns="{namespace-uri-from-QName($vQName)}">
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

  <!-- An attribute list transpiles to the sequence or alternate
       pattern. A fallback template catches unsupported attribute list
       types. -->
  <xsl:template match="attList[empty(@org) or @org = 'group']" as="element(rng:group)">
    <rng:group>
      <xsl:apply-templates/>
    </rng:group>
  </xsl:template>

  <xsl:template match="attList[@org = 'choice']" as="element(rng:choice)">
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
  <xsl:template match="attDef[empty(@use) or @use = ('opt', 'rec')]" as="element(rng:optional)">
    <rng:optional>
      <xsl:next-match/>
    </rng:optional>
  </xsl:template>

  <xsl:template match="attDef" as="element(rng:attribute)">
    <xsl:variable name="vQName" as="xs:QName" select="atop:get-attribute-qname(.)"/>

    <rng:attribute name="{local-name-from-QName($vQName)}"
                   ns="{namespace-uri-from-QName($vQName)}">

      <!--

An attribute specification may contain an attribute list (attList) and
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
        <xsl:when test="valList[empty(@type) or @type = 'open']">
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
        <xsl:when test="valList[@type = ('semi')]">
          <rng:choice>
            <xsl:apply-templates/>
          </rng:choice>
        </xsl:when>
        <xsl:when test="valList[@type = ('closed')]">
          <xsl:apply-templates select="valList"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </rng:attribute>
  </xsl:template>

  <xsl:template match="datatype" as="element(rng:list)">
    <xsl:variable name="vDatatypeContent" as="element()+">
      <xsl:apply-templates/>
    </xsl:variable>

    <rng:list>
      <xsl:call-template name="atop:repeat-content">
        <xsl:with-param name="pContent" as="element()*" select="$vDatatypeContent"/>
        <xsl:with-param name="pMinOccurrence" as="xs:integer?" select="@minOccurs"/>
        <xsl:with-param name="pMaxOccurrence" as="xs:string?" select="@maxOccurs"/>
      </xsl:call-template>
    </rng:list>
  </xsl:template>

  <xsl:template match="valList[empty(@type) or @type = 'open']" as="empty-sequence()"/>

  <xsl:template match="valList[@type = ('closed')]" as="element(rng:choice)">
    <rng:choice>
      <xsl:apply-templates/>
    </rng:choice>
  </xsl:template>

  <xsl:template match="valList[@type = ('semi')]" as="element(rng:value)+">
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
  <xsl:template match="alternate" as="element(rng:choice)">
    <rng:choice>
      <xsl:apply-templates/>
    </rng:choice>
  </xsl:template>

  <xsl:template match="sequence" as="element(rng:group)">
    <rng:group>
      <xsl:apply-templates/>
    </rng:group>
  </xsl:template>

  <xsl:template match="empty" as="element(rng:empty)">
    <rng:empty/>
  </xsl:template>

  <xsl:template match="textNode" as="element(rng:text)">
    <rng:text/>
  </xsl:template>

  <xsl:template match="elementRef" as="element(rng:ref)">
    <xsl:variable name="vElementSpec" as="element(elementSpec)" select="key('atop:elementSpec', @key)"/>
    <xsl:call-template name="atop:repeat-content">
      <xsl:with-param name="pContent" as="element()*">
        <rng:ref name="{atop:get-element-pattern-name($vElementSpec)}"/>
      </xsl:with-param>
      <xsl:with-param name="pMinOccurrence" as="xs:integer?" select="@minOccurs"/>
      <xsl:with-param name="pMaxOccurrence" as="xs:string?" select="@maxOccurs"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="classRef" as="element()+">
    <xsl:variable name="vClassSpec" as="element(classSpec)" select="key('atop:classSpec', @key, ancestor::schemaSpec)"/>
    <!-- Create a reference to all class attribute patterns -->
    <xsl:for-each select="($vClassSpec, key('atop:classMembers', $vClassSpec, ancestor::schemaSpec)[self::classSpec])">
      <xsl:if test="attList">
        <rng:ref name="{atop:get-class-pattern-name(.)}"/>
      </xsl:if>
    </xsl:for-each>

    <!-- Create reference to class members -->
    <!-- TODO: Clarify the relationship between classRef/@expand and classSpec/@generate? -->
    <xsl:variable name="vExpand" as="xs:string" select="(@expand, 'alternation')[1]"/>

    <xsl:element name="{if ($vExpand eq 'alternation') then 'rng:choice' else 'rng:group'}">
      <xsl:for-each select="atop:get-class-members($vClassSpec, ancestor::schemaSpec)">
        <xsl:variable name="vReference" as="element()">
          <xsl:choose>
            <xsl:when test="$vExpand eq 'sequenceRepeatable'">
              <rng:oneOrMore>
                <rng:ref name="{atop:get-element-pattern-name(.)}"/>
              </rng:oneOrMore>
            </xsl:when>
            <xsl:when test="$vExpand eq 'sequenceOptionalRepeatable'">
              <rng:zeroOrMore>
                <rng:ref name="{atop:get-element-pattern-name(.)}"/>
              </rng:zeroOrMore>
            </xsl:when>
            <xsl:otherwise>
              <rng:ref name="{atop:get-element-pattern-name(.)}"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$vExpand = ('sequenceOptional', 'sequenceOptionalRepeatable')">
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

  </xsl:template>

  <!-- anyElement is special. The special mode 'atop:anyElement' creates a
       recursive RelaxNG pattern. We reference this pattern when
       processing. -->
  <xsl:mode name="atop:anyElement" on-no-match="shallow-skip"/>

  <xsl:template match="anyElement" mode="atop:anyElement" as="element(rng:define)">
    <xsl:param name="tpDefaultExceptions" as="xs:string*" tunnel="yes"/>

    <xsl:variable name="vPatternName" as="xs:string" select="generate-id()"/>
    <xsl:variable name="vInScopePrefixes" as="xs:string*" select="in-scope-prefixes(.)"/>

    <rng:define name="{$vPatternName}">
      <rng:element>
        <rng:anyName>
          <xsl:where-populated>
            <rng:except>
              <xsl:for-each select="if (@except) then tokenize(@except, '\s+') else $tpDefaultExceptions">
                <!-- Nota bene: teidata.namespaceOrName is ambiguous! -->
                <xsl:choose>
                  <xsl:when test="(. castable as xs:Name) and contains(., ':') and (substring-before(., ':') = $vInScopePrefixes)">
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

  <xsl:template match="dataRef[@key]" as="element(rng:ref)">
    <xsl:variable name="vDataSpec" as="element(dataSpec)" select="key('atop:dataSpec', @key, ancestor::schemaSpec)"/>
    <rng:ref name="{atop:get-datatype-pattern-name($vDataSpec)}"/>
  </xsl:template>

  <xsl:template match="dataRef[@ref]" as="empty-sequence()">
    <xsl:message terminate="yes">
      <xsl:text>Unsupported datatype specification reference. This version of atop only supports references to XML Schema datatypes (@name) and ODD datatype specifications (@key).</xsl:text>
    </xsl:message>
  </xsl:template>

</xsl:transform>