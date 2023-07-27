<xsl:transform version="3.0" expand-text="yes"
               xmlns:fn="tag:dmaus@dmaus.name,2022:Schematron-Schematron"
               xmlns:xpath20="tag:dmaus@dmaus.name,2022:Schematron-Schematron:XPath20"
               xmlns:xpath31="tag:dmaus@dmaus.name,2022:Schematron-Schematron:XPath31"
               xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:include href="xpath20.xslt"/>
  <xsl:include href="xpath31.xslt"/>

  <xsl:key name="fn:qname-by-context" match="QName[empty(*)]"
           use="(ancestor::VarName, ancestor::NameTest, ancestor::FunctionCall)[1] => local-name()"/>
  <xsl:key name="fn:qname-by-context" match="QName[empty(*)]"
           use="'#ALL'"/>

  <xsl:function name="fn:get-qname-prefixes" as="xs:string*">
    <xsl:param name="parsedExpr" as="element()"/>
    <xsl:for-each-group select="key('fn:qname-by-context', '#ALL', $parsedExpr)[contains(., ':')]" group-by="string(.)">
      <xsl:value-of select="substring-before(., ':')"/>
    </xsl:for-each-group>
  </xsl:function>

  <xsl:function name="fn:validate-xpath" as="item()*">
    <xsl:param name="exprAttr" as="attribute()"/>
    <xsl:param name="queryBinding" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$queryBinding eq 'xslt2'">
        <xsl:sequence select="xpath20:parse-XPath($exprAttr)"/>
      </xsl:when>
      <xsl:when test="$queryBinding eq 'xslt3'">
        <xsl:sequence select="xpath31:parse-XPath($exprAttr)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">Unsupported query language binding: <xsl:value-of select="$queryBinding"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>

  <xsl:function name="fn:get-xpath-functions" as="element(function)*">
    <xsl:param name="parsedExpr" as="element()"/>
    <xsl:param name="queryBinding" as="xs:string"/>

    <xsl:choose>
      <xsl:when test="$queryBinding eq 'xslt2'">
        <xsl:for-each-group select="$parsedExpr//FunctionCall" group-by="string(FunctionName/QName)">
          <xsl:sort select="current-grouping-key()"/>
          <xsl:if test="not(contains(current-grouping-key(), ':'))">
            <function name="{current-grouping-key()}"/>
          </xsl:if>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:when test="$queryBinding eq 'xslt3'">
        <xsl:for-each-group select="$parsedExpr//FunctionCall" composite="yes" group-by="(string(FunctionEQName/FunctionName/QName), count(ArgumentList/Argument))">
          <xsl:sort select="current-grouping-key()[1]"/>
          <xsl:if test="not(contains(current-grouping-key()[1], ':'))">
            <function name="{current-grouping-key()[1]}" arity="{current-grouping-key()[2]}"/>
          </xsl:if>
        </xsl:for-each-group>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">Unsupported query language binding: <xsl:value-of select="$queryBinding"/></xsl:message>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:function>

  <xsl:function name="fn:find-invalid-functions" as="element(function)*">
    <xsl:param name="exprFunctions" as="element(function)*"/>
    <xsl:param name="queryBinding" as="xs:string"/>

    <xsl:variable name="functions" as="element(function)*">
      <xsl:choose>
        <xsl:when test="$queryBinding eq 'xslt2'">
          <xsl:sequence select="doc('xpath20-functions-and-operators.xml')/functions/function"/>
          <xsl:sequence select="doc('xslt2-functions.xml')/functions/function"/>
        </xsl:when>
        <xsl:when test="$queryBinding eq 'xslt3'">
          <xsl:sequence select="doc('xpath31-functions-and-operators.xml')/functions/function"/>
          <xsl:sequence select="doc('xslt3-functions.xml')/functions/function"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">Unsupported query language binding: <xsl:value-of select="$queryBinding"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:choose>
      <xsl:when test="$queryBinding eq 'xslt2'">
        <xsl:sequence select="$exprFunctions except $exprFunctions[@name = $functions/@name]"/>
      </xsl:when>
      <xsl:when test="$queryBinding eq 'xslt3'">
        <xsl:sequence select="$exprFunctions except $exprFunctions[fn:pretty-print-function(.) = fn:pretty-print-function($functions)]"/>
      </xsl:when>
    </xsl:choose>

  </xsl:function>

  <xsl:function name="fn:pretty-print-function" as="xs:string*">
    <xsl:param name="function" as="element(function)*"/>
    <xsl:for-each select="$function">
      <xsl:value-of select="if (@arity) then concat(@name, '#', @arity) else @name"/>
    </xsl:for-each>
  </xsl:function>

</xsl:transform>
