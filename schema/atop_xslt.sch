<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <!-- The purpose of this Schematron is to enforce requirements for specific
       coding and documentation practices in the project's XSLT files. -->
    <title>ISO Schematron rules for TEI ATOP XSLT</title>
    
    <!-- Namespaces. -->
    <ns prefix="xd" uri="http://www.oxygenxml.com/ns/doc/xsl"/>
    
    <ns prefix="teif" uri="http://www.tei-c.org/ns/functions"/>
    
    <!-- Global variables. -->
    <let name="docUri" value="document-uri(/)"/>
    
    <let name="atopNamespaceUri" value="'http://www.tei-c.org/ns/atop'"/>
    <let name="atopNamespacePrefix" value="'atop'"/>
    
    <let name="reVarName" value="'^v[A-Z][a-zA-Z0-9]+(_[a-zA-Z0-9_]+)?$'"/>
    
    <let name="reParamName" value="'^t?p[A-Z][a-zA-Z0-9]+(_[a-zA-Z0-9_]+)?$'"/>
    
    <let name="reFunctionName" value="concat('^', $atopNamespacePrefix, ':[a-z][a-z\-]+[a-z]$')"/>
    
    <!-- Constraints -->
    <pattern id="names">
        <title>Coding style rules for names</title>
        <rule abstract="true" id="param-name-re">
            <assert test="matches(tokenize(@name, ':')[last()], $reParamName)" id="assert-param-name-re" role="error">
                ERROR: A <value-of select="name()"/> must have a name matching the regular expression <value-of select="$reParamName"/>. 
            </assert>
        </rule>
        <rule abstract="true" id="variable-name-re">
            <assert test="matches(tokenize(@name, ':')[last()], $reVarName)" id="assert-variable-name-re" role="error">
                ERROR: A <value-of select="name()"/> must have a name matching the regular expression <value-of select="$reVarName"/>. 
            </assert>
        </rule>
        <rule abstract="true" id="global-name">
            <assert test="starts-with(@name, concat($atopNamespacePrefix, ':'))" role="error" id="assert-global-name-prefix">
                ERROR: The name of a global <value-of select="name()"/> must be a xs:QName with the prefix <value-of select="$atopNamespacePrefix"/>. 
            </assert>
            <assert test="namespace-uri-for-prefix(substring-before(@name, ':'), .) = $atopNamespaceUri" role="error" id="assert-global-name-uri">
                ERROR: The name of a global <value-of select="name()"/> must be a xs:QName with the namespace URI <value-of select="$atopNamespaceUri"/>. 
            </assert>
        </rule>
        <rule abstract="true" id="local-name">
            <assert test="not(contains(@name, ':'))" role="error" id="assert-local-name">
                ERROR: The name of a local <value-of select="name()"/> must be a xs:NCName.
            </assert>
        </rule>
        <rule context="/*/xsl:param">
            <extends rule="global-name"/>
            <extends rule="param-name-re"/>           
        </rule>
        <rule context="/*/xsl:variable">
            <extends rule="global-name"/>
            <extends rule="variable-name-re"/>            
        </rule>
        <rule context="xsl:variable">
            <extends rule="local-name"/>
            <extends rule="variable-name-re"/>
        </rule>
        <rule context="xsl:param[boolean(@tunnel) eq true()] | xsl:with-param[boolean(@tunnel) eq true()]">
            <extends rule="local-name"/>
            <extends rule="param-name-re"/>
            <assert test="starts-with(@name, 'tp')" role="error" id="assert-tunnel-param-name">
                ERROR: The name of a tunnel parameter must start with 'tp'.
            </assert>
        </rule>
        <rule context="xsl:param | xsl:with-param">
            <extends rule="local-name"/>
            <extends rule="param-name-re"/>
        </rule>
        <rule context="xsl:function | xsl:template[@name]">
            <extends rule="global-name"/>
            <assert test="matches(tokenize(@name, ':')[last()], $reFunctionName)" role="error" id="assert-function-name-re">
                ERROR: The name of a <value-of select="name()"/> must match the regular expression <value-of select="$reFunctionName"/>.
            </assert>
        </rule>
    </pattern>
    
    <pattern id="things-must-have-as-attribute">
        <rule context="xsl:template | xsl:variable | xsl:with-param | xsl:param | xsl:function">
            <let name="ln" value="local-name(.)"/>
            <let name="name" value="@name"/>
            <assert test="@as">
                ERROR: <value-of select="$name"/> (<value-of select="$ln"/>) missing required @as attribute.
            </assert>
        </rule>
    </pattern>

    <pattern id="no-literal-text">
        <rule context="text()[not(normalize-space(.) = '')]">
            <assert test="parent::xsl:text">
                ERROR: Literal text should always be in an xsl:text
                element or in the @select attribute of xsl:sequence.
            </assert>
        </rule>
    </pattern>
    
    <pattern id="root-children-must-have-documentation">
        <rule context="/*/xsl:*[@name]">
            <let name="name" value="@name"/>
            <assert test="//xd:doc/descendant::xd:ref[@name eq $name]">
                ERROR: Any element which is a child of the root 
                and has a name attribute must have an xd:doc block
                which documents it using xd:ref.
            </assert>
        </rule>
    </pattern>
    
    <pattern id="keep-things-short">
        <rule context="xsl:template | xsl:variable | xsl:with-param | xsl:param | xsl:function">
            <let name="ln" value="local-name(.)"/>
            <let name="componentCount" value="count(descendant::*|descendant::*/@*)"/>
            <assert role="warning" test="$componentCount le 100">
                WARNING: This <value-of select="$ln"/> has <value-of select="$componentCount"/>
                components, so you should consider breaking it up.
            </assert>
        </rule>
    </pattern>
    
</schema>