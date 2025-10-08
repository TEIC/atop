<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:rng="http://relaxng.org/ns/structure/1.0"
  xmlns:teix="http://www.tei-c.org/ns/Examples"
  xmlns:atop="http://www.tei-c.org/ns/atop"
  xpath-default-namespace="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="#all">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Dec 18, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
      <xd:p>resolve ODD references at schema specification level</xd:p>
      <xd:p>That is, given 2 inputs — a customization ODD provided as
      the input document and a base ODD (which may itself really be a
      derived ODD from a previous step in ODD chain) provided either as
      the <xd:pre>$atop:pSource</xd:pre> parameter or, failing that,
      read from the <xd:pre>schemaSpec/@source</xd:pre> — write the
      ODD derived from applying the 1st to the 2nd as output.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="modules/functions_module.xslt"/>
  <xsl:mode name="atop:mPass01" on-no-match="shallow-copy"><!-- normalize whitespace in attrs --></xsl:mode>
  <xsl:mode name="atop:mPass02" on-no-match="shallow-copy"><!-- schemaSpec/*Ref expansion --></xsl:mode>
  <xsl:mode name="atop:mPass03" on-no-match="shallow-copy"><!-- element deletion --></xsl:mode>
  <xsl:mode name="atop:mPass04" on-no-match="shallow-copy"><!-- datatype deletion --></xsl:mode>
  <xsl:mode name="atop:mPass05" on-no-match="shallow-copy"><!-- macro deletion --></xsl:mode>
  <xsl:mode name="atop:mPass06" on-no-match="shallow-copy"><!-- class deletion --></xsl:mode>
  <xsl:mode name="atop:mPass07" on-no-match="shallow-copy"><!-- post-deletion clean-up --></xsl:mode>

  <xd:doc>
    <xd:desc>Debug flag: generate output (to /tmp/) for each pass iff true.</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pDebug" select="true()" as="xs:boolean" static="yes"/>
  
  <xd:doc>
    <xd:desc>The source, i.e. a pointer to the base ODD (as an
    xs:anyURI). In general, it will be provided as a parameter by the
    calling pipeline. But if not, try reading it from the
    schemaSpec/@source.</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pSource" select="atop:resolve-uri( ( //schemaSpec/@source, 'tei:current' cast as xs:anyURI )[1], / )" as="xs:anyURI"/>
  
  <xd:doc>
    <xd:desc>Name of current program for use in building debugging output filenames</xd:desc>
  </xd:doc>
  <xsl:param name="atop:pDebugName" select="tokenize(static-base-uri(),'/')[last()]" as="xs:string"/>
  
  <xd:doc>
    <xd:desc>The source, i.e. the base ODD (as an entire document node)</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vBaseOdd" as="document-node()">
    <xsl:sequence select="document( $atop:pSource )"/>
  </xsl:variable>
    
  <xd:doc>
    <xd:desc>Match the input document (a customization ODD), process it with a
    micropipeline, and write out the result of the last stage in the pipeline.</xd:desc>
  </xd:doc>
  <xsl:template match="/" name="xsl:initial-template" as="document-node()">
    <xsl:copy>
      <!-- pass 01: attribute normalization -->
      <xsl:variable name="vPass01" as="node()+">
        <xsl:apply-templates mode="atop:mPass01"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_01" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass01"/>
      </xsl:result-document>
      <!-- pass 02: expand ref children of <schemaSpec> -->
      <xsl:variable name="vPass02" as="node()+">
        <xsl:apply-templates select="$vPass01" mode="atop:mPass02"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_02" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass02"/>
      </xsl:result-document>
      <!-- pass 03: element specification deletion -->
      <xsl:variable name="vPass03" as="node()+">
        <xsl:apply-templates select="$vPass02" mode="atop:mPass03"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_03" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass03"/>
      </xsl:result-document>
      <!-- pass 04: data specification deletion -->
      <xsl:variable name="vPass04" as="node()+">
        <xsl:apply-templates select="$vPass03" mode="atop:mPass04"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_04" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass04"/>
      </xsl:result-document>
      <!-- pass 05: macro deletion -->
      <xsl:variable name="vPass05" as="node()+">
        <xsl:apply-templates select="$vPass04" mode="atop:mPass05"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_05" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass05"/>
      </xsl:result-document>
      <!-- pass 06: class deletion -->
      <xsl:variable name="vPass06" as="node()+">
        <xsl:apply-templates select="$vPass05" mode="atop:mPass06"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_06" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass06"/>
      </xsl:result-document>
      <!-- pass 07: post-deletion clean-up -->
      <xsl:variable name="vPass07" as="node()+">
        <xsl:apply-templates select="$vPass06" mode="atop:mPass07"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_07" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass07"/>
      </xsl:result-document>
      <!-- output -->
      <xsl:sequence select="$vPass07"/>
    </xsl:copy>
  </xsl:template>

  <!-- ************ pass01, normalize whitespace in attrs ************ -->

  <xd:doc>
    <xd:desc>Having extraneous leading or trailing whitespace can mess things up, and we do not
    want to need to issue normalize-space() all over all the time. So just normalize spaces in
    all attrs ahead of time.</xd:desc>
  </xd:doc>
  <xsl:template match="@*" as="attribute()" mode="atop:mPass01">
    <xsl:copy>
      <xsl:sequence select="normalize-space(.)"/>
    </xsl:copy>
  </xsl:template>

  <!-- ************ pass02, resolve top-level references ************ -->
  
  <xd:doc>
    <xd:desc>When we hit a &lt;moduleRef> in the customization ODD, replace it
    with the specifications of the base ODD that are in that module (as adjusted
    by its @include or @except attribute)</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec/moduleRef" mode="atop:mPass02" as="item()+">
    <xsl:variable name="vModule" select="normalize-space( @key )" as="xs:string"/>
    <xsl:variable name="vIncludes" select="tokenize( @include )" as="xs:string*"/>
    <xsl:variable name="vExcepts" select="tokenize( @except )" as="xs:string*"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** class specifications in {$vModule} from {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//classSpec[ @module eq $vModule ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** data specifications in {$vModule} from {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//dataSpec[ @module eq $vModule ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** element specifications in {$vModule} from {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//elementSpec[ @module eq $vModule ][ not( @ident = $vExcepts ) ][ not( current()/@include ) or @ident = $vIncludes ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** macro specifications in {$vModule} from {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//macroSpec[ @module eq $vModule ]"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>When we hit an element reference directly within the schema
      specification of the customization ODD, replace it with the specification
      from the base ODD</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec/elementRef" mode="atop:mPass02" as="node()?">
    <xsl:sequence select="$atop:vBaseOdd//elementSpec[ @ident eq current()/@key ]"/>
  </xsl:template>
    
  <xd:doc>
    <xd:desc>When we hit an data reference directly within the schema
      specification of the customization ODD, replace it with the specification
      from the base ODD</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec/dataRef" mode="atop:mPass02" as="node()?">
    <xsl:sequence select="$atop:vBaseOdd//dataSpec[ @ident eq current()/@key ]"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>When we hit an macro reference directly within the schema
      specification of the customization ODD, replace it with the specification
      from the base ODD</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec/macroRef" mode="atop:mPass02" as="node()?">
    <xsl:sequence select="$atop:vBaseOdd//macroSpec[ @ident eq current()/@key ]"/>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>When we hit an class reference directly within the schema
      specification of the customization ODD, replace it with the specification
      from the base ODD</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec/classRef" mode="atop:mPass02" as="node()?">
    <xsl:sequence select="$atop:vBaseOdd//classSpec[ @ident eq current()/@key ]"/>
  </xsl:template>

  <!-- ************ pass03, element deletions ************ -->
  
  <xd:doc>
    <xd:desc>Remove elements that customization indicates should be removed. This means:
    * removing both the elementSpec that has mode=delete, and the base elementSpec for same element;
    * removing any references to it.</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="atop:mPass03" as="element(schemaSpec)">
    <xsl:variable name="vDeleteUs" select=".//elementSpec[@mode eq 'delete']/@ident" as="xs:string*"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpDeleteUs" select="$vDeleteUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>If an elementSpec/@ident or elementRef/@key matches one of the things-to-be-deleted,
    then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="elementSpec|elementRef" mode="atop:mPass03" as="element()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="( @ident, @key ) = $tpDeleteUs"/>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ************ pass04, datatype deletions ************ -->
  
  <xd:doc>
    <xd:desc>Remove datatypes that customization indicates should be removed. This means:
      * removing both the dataSpec that has mode=delete, and the base dataSpec for same datatype;
      * removing any references to it.</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="atop:mPass04" as="element(schemaSpec)">
    <xsl:variable name="vDeleteUs" select=".//dataSpec[@mode eq 'delete']/@ident" as="xs:string*"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpDeleteUs" select="$vDeleteUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a dataSpec/@ident matches one of the things-to-be-deleted,
      then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="dataSpec" mode="atop:mPass04" as="element()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="@ident = $tpDeleteUs"/>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a dataRef/@key matches one of the things-to-be-deleted,
    then do not copy it, but rather warn user there is likely to be a
    problem here.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="dataRef" mode="atop:mPass04" as="node()">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose expand-text="yes">
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment> reference to {@key} datatype deleted here </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ************ pass05, macro deletions ************ -->
  
  <xd:doc>
    <xd:desc>Remove macros that customization indicates should be removed. This means:
      * removing both the macroSpec that has mode=delete, and the base macroSpec for same macro;
      * removing any references to it.</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="atop:mPass05" as="element(schemaSpec)">
    <xsl:variable name="vDeleteUs" select=".//macroSpec[@mode eq 'delete']/@ident" as="xs:string*"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpDeleteUs" select="$vDeleteUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a macroSpec/@ident matches one of the things-to-be-deleted,
      then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="macroSpec" mode="atop:mPass05" as="element()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="@ident = $tpDeleteUs"/>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a macroRef/@key matches one of the things-to-be-deleted,
      then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="macroRef" mode="atop:mPass05" as="node()">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose expand-text="yes">
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment> reference to {@key} macro deleted here </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ************ pass06, class deletions ************ -->

  <xd:doc>
    <xd:desc>Remove classses that customization indicates should be removed. This means:
      * removing both the classSpec that has mode=delete, and the base classSpec for same class;
      * removing any references to it.</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="atop:mPass06" as="element(schemaSpec)">
    <xsl:variable name="vDeleteUs" select=".//classSpec[@mode eq 'delete']/@ident" as="xs:string*"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpDeleteUs" select="$vDeleteUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a classSpec/@ident matches one of the things-to-be-deleted,
      then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="classSpec" mode="atop:mPass06" as="element()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="@ident = $tpDeleteUs"/>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If a memberOf/@key or classRef/@key matches one of the things-to-be-deleted,
      then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="(classRef|memberOf)" mode="atop:mPass06" as="node()">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose expand-text="yes">
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment> reference to {@key} class deleted here </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ************ pass07, post-deletion clean-up ************ -->
  
  <xd:doc>
    <xd:desc>If our deletions have left an &lt;alternate>, &lt;interleave>,
      or &lt;sequence> empty (which is to say, without any oddDecl or RELAX NG
      descendants) just kill it.</xd:desc>
  </xd:doc>
  <xsl:template match="(alternate|interleave|sequence)[ atop:has-no-content-content(.) ]" mode="atop:mPass07"/>
  
  <xd:doc>
    <xd:desc>If our deletions have left a &lt;content> empty (same definition as
    above), change its content to emptiness itself.</xd:desc>
  </xd:doc>
  <xsl:template match="content[ atop:has-no-content-content(.) ]" mode="atop:mPass07" as="element(content)">
    <xsl:copy>
      <empty/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If our deletions have left a &lt;datatype> empty (same definition as
      above), change its content to allow whatever.</xd:desc>
  </xd:doc>
  <xsl:template match="datatype[ atop:has-no-content-content(.) ]" mode="atop:mPass07" as="element(datatype)">
    <xsl:copy>
      <dataRef name="string"/> <!-- cannot use a TEI datatype as it may have been deleted -->
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
