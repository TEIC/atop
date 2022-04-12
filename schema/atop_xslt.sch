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
    
    <let name="reVarName" value="'^v[A-Z][a-zA-Z0-9]+(_[a-zA-Z0-9_]+)?$'"/>
    
    <let name="reParamName" value="'^t?p[A-Z][a-zA-Z0-9]+(_[a-zA-Z0-9_]+)?$'"/>
    
    <let name="reFunctionName" value="'^teif:[a-z][a-z\-]+[a-z]$'"/>
    
    <!-- Constraints -->
    
    <pattern id="things-must-have-as-attribute">
        <rule context="xsl:template | xsl:variable | xsl:with-param | xsl:param | xsl:function">
            <let name="ln" value="local-name(.)"/>
            <let name="name" value="@name"/>
            <assert test="@as">
                ERROR: <value-of select="$name"/> (<value-of select="$ln"/>) missing required @as attribute.
            </assert>
        </rule>
    </pattern>
    
    <pattern id="variable-names">
        <rule context="xsl:variable">
            <let name="name" value="@name"/>
            <assert test="matches(@name, $reVarName)">
                ERROR: <value-of select="$name"/> must have a name
                matching the regular expression <value-of select="$reVarName"/>. 
            </assert>
        </rule>
    </pattern>
    
    <pattern id="param-names">
        <rule context="xsl:param | xsl:with-param">
            <let name="name" value="@name"/>
            <assert test="matches(@name, $reParamName)">
                ERROR: <value-of select="$name"/> must have a name
                matching the regular expression <value-of select="$reParamName"/>. 
            </assert>
        </rule>
    </pattern>
    
    <pattern id="tunneled-param-names">
        <rule context="xsl:param[@tunnel] | xsl:with-param[@tunnel]">
            <let name="name" value="@name"/>
            <assert test="starts-with(@name, 'tp')">
                ERROR: <value-of select="$name"/> must have a name starting with 'tp'. 
            </assert>
        </rule>
    </pattern>
    
    <pattern id="function-names">
        <rule context="xsl:function">
            <let name="name" value="@name"/>
            <assert test="matches(@name, $reFunctionName)">
                ERROR: <value-of select="$name"/> must have a name
                matching the regular expression <value-of select="$reFunctionName"/>. 
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
    
    <pattern id="xslt-filename-extension">
        <rule context="/">
            <assert test="ends-with($docUri, '.xslt')" role="error">
                ERROR: An XSL Stylesheet must use the file extension '.xslt'.
            </assert>
        </rule>
    </pattern>
    
</schema>