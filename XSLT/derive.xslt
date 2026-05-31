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
  exclude-result-prefixes="#all"
  expand-text="yes">

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Dec 18, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> ATOP team</xd:p>
      <xd:p>resolve ODD references at schema specification level</xd:p>
      <xd:p>That is, given 2 inputs — a customization ODD provided as
      the input document and a base ODD (which may itself really be a
      derived ODD from a previous step in ODD chain) provided either as
      the <xd:pre>$atop:pSource</xd:pre> parameter or, failing that,
      read from the <xd:pre>schemaSpec/@source</xd:pre> — write out
      the ODD derived from applying the 1st to the 2nd.</xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" indent="yes"/>
  <xsl:include href="modules/functions_module.xslt"/>

  <!-- modes that do not process entire document -->
  <xsl:mode name="atop:mChange" on-no-match="shallow-copy"/>
  
  <!-- preperatory work -->
  <xsl:mode name="atop:mPass01" on-no-match="shallow-copy"><!-- normalize whitespace in attrs --></xsl:mode>
  <xsl:mode name="atop:mPass02" on-no-match="shallow-copy"><!-- expand schemaSpec/*Ref & replace schemaSpec/@source --></xsl:mode>

  <!-- deletion of all but <attDef>s -->
  <xsl:mode name="atop:mPass03" on-no-match="shallow-copy"><!-- element deletion --></xsl:mode>
  <xsl:mode name="atop:mPass04" on-no-match="shallow-copy"><!-- datatype deletion --></xsl:mode>
  <xsl:mode name="atop:mPass05" on-no-match="shallow-copy"><!-- macro deletion --></xsl:mode>
  <xsl:mode name="atop:mPass06" on-no-match="shallow-copy"><!-- class deletion --></xsl:mode>
  <xsl:mode name="atop:mPass07" on-no-match="shallow-copy"><!-- post-deletion clean-up --></xsl:mode>

  <!-- replacement of schema-level components -->
  <xsl:mode name="atop:mPass08" on-no-match="shallow-copy"><!-- replacement --></xsl:mode>

  <!-- change of schema-level components -->
  <xsl:mode name="atop:mPass09" on-no-match="shallow-copy"><!--  --></xsl:mode>

  <xsl:mode name="atop:mPass10" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass11" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass12" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass13" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass14" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass15" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass16" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass17" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass18" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass19" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass20" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass21" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass22" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass23" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass24" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass25" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass26" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass27" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass28" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass29" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass30" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass31" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass32" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass33" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass34" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass35" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass36" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass37" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass38" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass39" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass40" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass41" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass42" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass43" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass44" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass45" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass46" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass47" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass48" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass49" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass50" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass51" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass52" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass53" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass54" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass55" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass56" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass57" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass58" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass59" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass60" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass61" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass62" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass63" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass64" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass65" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass66" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass67" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass68" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass69" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass70" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass71" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass72" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass73" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass74" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass75" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass76" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass77" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass78" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass79" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass80" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass81" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass82" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass83" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass84" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass85" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass86" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass87" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass88" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass89" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass90" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass91" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass92" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass93" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass94" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass95" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass96" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass97" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass98" on-no-match="shallow-copy"></xsl:mode>
  <xsl:mode name="atop:mPass99" on-no-match="shallow-copy"></xsl:mode>

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
  <xsl:param name="atop:pDebugName" select="tokenize( static-base-uri(),'/')[last()]" as="xs:string"/>
  
  <xd:doc>
    <xd:desc>The source, i.e. the base ODD (as an entire document node)</xd:desc>
  </xd:doc>
  <xsl:variable name="atop:vBaseOdd" as="document-node()">
    <xsl:sequence select="document( $atop:pSource )"/>
  </xsl:variable>

  <!--
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      The elements that are members of att.identifiable, and thus have
      @ident, are: <attDef>, <classSpec>, <constraintSpec>,
      <dataSpec>, <elementSpec>, <macroSpec>, <moduleSpec>,
      <paramSpec>, <schemaSpec>, and also <remarks> & <valItem>.

      The elements that are members of att.combinable, and thus have
      @mode, are all the elements mentioned above plus: <defaultVal>,
      <valDesc>, and <valList>; also <classes> [change,replace] &
      <memberOf> [add,delete] have @mode.
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  -->
  
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
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_01.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass01"/>
      </xsl:result-document>
      
      <!-- pass 02: expand ref children of <schemaSpec> -->
      <xsl:variable name="vPass02" as="node()+">
        <xsl:apply-templates select="$vPass01" mode="atop:mPass02"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_02.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass02"/>
      </xsl:result-document>
      
      <!-- pass 03: element specification deletion -->
      <xsl:variable name="vPass03" as="node()+">
        <xsl:apply-templates select="$vPass02" mode="atop:mPass03"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_03.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass03"/>
      </xsl:result-document>

      <!-- pass 04: data specification deletion -->
      <xsl:variable name="vPass04" as="node()+">
        <xsl:apply-templates select="$vPass03" mode="atop:mPass04"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_04.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass04"/>
      </xsl:result-document>

      <!-- pass 05: macro deletion -->
      <xsl:variable name="vPass05" as="node()+">
        <xsl:apply-templates select="$vPass04" mode="atop:mPass05"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_05.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass05"/>
      </xsl:result-document>

      <!-- pass 06: class deletion -->
      <xsl:variable name="vPass06" as="node()+">
        <xsl:apply-templates select="$vPass05" mode="atop:mPass06"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_06.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass06"/>
      </xsl:result-document>

      <!-- pass 07: post-deletion clean-up -->
      <xsl:variable name="vPass07" as="node()+">
        <xsl:apply-templates select="$vPass06" mode="atop:mPass07"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_07.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass07"/>
      </xsl:result-document>

      <!-- pass 08: delete classes being replaced -->
      <xsl:variable name="vPass08" as="node()+">
        <xsl:apply-templates select="$vPass07" mode="atop:mPass08"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_08.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass08"/>
      </xsl:result-document>

      <!-- pass 09: delete datatypes being replaced -->
      <xsl:variable name="vPass09" as="node()+">
        <xsl:apply-templates select="$vPass08" mode="atop:mPass09"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_09.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass09"/>
      </xsl:result-document>

      <!-- pass 10: delete macros being replaced -->
      <xsl:variable name="vPass10" as="node()+">
        <xsl:apply-templates select="$vPass09" mode="atop:mPass10"/>
      </xsl:variable>
      <xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_10.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass10"/>
      </xsl:result-document>

      <!-- pass 11: delete classes being replaced -->
      <xsl:variable name="vPass11" as="node()+">
        <xsl:apply-templates select="$vPass10" mode="atop:mPass11"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_11.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass11"/>
      </xsl:result-document -->

      <!-- pass 12: NOP -->
      <xsl:variable name="vPass12" as="node()+">
        <xsl:apply-templates select="$vPass11" mode="atop:mPass12"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_12.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass12"/>
      </xsl:result-document -->

      <!-- pass 13: NOP -->
      <xsl:variable name="vPass13" as="node()+">
        <xsl:apply-templates select="$vPass12" mode="atop:mPass13"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_13.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass13"/>
      </xsl:result-document -->

      <!-- pass 14: NOP -->
      <xsl:variable name="vPass14" as="node()+">
        <xsl:apply-templates select="$vPass13" mode="atop:mPass14"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_14.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass14"/>
      </xsl:result-document -->

      <!-- pass 15: NOP -->
      <xsl:variable name="vPass15" as="node()+">
        <xsl:apply-templates select="$vPass14" mode="atop:mPass15"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_15.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass15"/>
      </xsl:result-document -->

      <!-- pass 16: NOP -->
      <xsl:variable name="vPass16" as="node()+">
        <xsl:apply-templates select="$vPass15" mode="atop:mPass16"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_16.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass16"/>
      </xsl:result-document -->

      <!-- pass 17: NOP -->
      <xsl:variable name="vPass17" as="node()+">
        <xsl:apply-templates select="$vPass16" mode="atop:mPass17"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_17.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass17"/>
      </xsl:result-document -->

      <!-- pass 18: NOP -->
      <xsl:variable name="vPass18" as="node()+">
        <xsl:apply-templates select="$vPass17" mode="atop:mPass18"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_18.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass18"/>
      </xsl:result-document -->

      <!-- pass 19: NOP -->
      <xsl:variable name="vPass19" as="node()+">
        <xsl:apply-templates select="$vPass18" mode="atop:mPass19"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_19.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass19"/>
      </xsl:result-document -->

      <!-- pass 20: NOP -->
      <xsl:variable name="vPass20" as="node()+">
        <xsl:apply-templates select="$vPass19" mode="atop:mPass20"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_20.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass20"/>
      </xsl:result-document -->

      <!-- pass 21: NOP -->
      <xsl:variable name="vPass21" as="node()+">
        <xsl:apply-templates select="$vPass20" mode="atop:mPass21"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_21.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass21"/>
      </xsl:result-document -->

      <!-- pass 22: NOP -->
      <xsl:variable name="vPass22" as="node()+">
        <xsl:apply-templates select="$vPass21" mode="atop:mPass22"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_22.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass22"/>
      </xsl:result-document -->

      <!-- pass 23: NOP -->
      <xsl:variable name="vPass23" as="node()+">
        <xsl:apply-templates select="$vPass22" mode="atop:mPass23"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_23.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass23"/>
      </xsl:result-document -->

      <!-- pass 24: NOP -->
      <xsl:variable name="vPass24" as="node()+">
        <xsl:apply-templates select="$vPass23" mode="atop:mPass24"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_24.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass24"/>
      </xsl:result-document -->

      <!-- pass 25: NOP -->
      <xsl:variable name="vPass25" as="node()+">
        <xsl:apply-templates select="$vPass24" mode="atop:mPass25"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_25.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass25"/>
      </xsl:result-document -->

      <!-- pass 26: NOP -->
      <xsl:variable name="vPass26" as="node()+">
        <xsl:apply-templates select="$vPass25" mode="atop:mPass26"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_26.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass26"/>
      </xsl:result-document -->

      <!-- pass 27: NOP -->
      <xsl:variable name="vPass27" as="node()+">
        <xsl:apply-templates select="$vPass26" mode="atop:mPass27"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_27.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass27"/>
      </xsl:result-document -->

      <!-- pass 28: NOP -->
      <xsl:variable name="vPass28" as="node()+">
        <xsl:apply-templates select="$vPass27" mode="atop:mPass28"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_28.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass28"/>
      </xsl:result-document -->

      <!-- pass 29: NOP -->
      <xsl:variable name="vPass29" as="node()+">
        <xsl:apply-templates select="$vPass28" mode="atop:mPass29"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_29.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass29"/>
      </xsl:result-document -->

      <!-- pass 30: NOP -->
      <xsl:variable name="vPass30" as="node()+">
        <xsl:apply-templates select="$vPass29" mode="atop:mPass30"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_30.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass30"/>
      </xsl:result-document -->

      <!-- pass 31: NOP -->
      <xsl:variable name="vPass31" as="node()+">
        <xsl:apply-templates select="$vPass30" mode="atop:mPass31"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_31.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass31"/>
      </xsl:result-document -->

      <!-- pass 32: NOP -->
      <xsl:variable name="vPass32" as="node()+">
        <xsl:apply-templates select="$vPass31" mode="atop:mPass32"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_32.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass32"/>
      </xsl:result-document -->

      <!-- pass 33: NOP -->
      <xsl:variable name="vPass33" as="node()+">
        <xsl:apply-templates select="$vPass32" mode="atop:mPass33"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_33.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass33"/>
      </xsl:result-document -->

      <!-- pass 34: NOP -->
      <xsl:variable name="vPass34" as="node()+">
        <xsl:apply-templates select="$vPass33" mode="atop:mPass34"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_34.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass34"/>
      </xsl:result-document -->

      <!-- pass 35: NOP -->
      <xsl:variable name="vPass35" as="node()+">
        <xsl:apply-templates select="$vPass34" mode="atop:mPass35"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_35.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass35"/>
      </xsl:result-document -->

      <!-- pass 36: NOP -->
      <xsl:variable name="vPass36" as="node()+">
        <xsl:apply-templates select="$vPass35" mode="atop:mPass36"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_36.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass36"/>
      </xsl:result-document -->

      <!-- pass 37: NOP -->
      <xsl:variable name="vPass37" as="node()+">
        <xsl:apply-templates select="$vPass36" mode="atop:mPass37"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_37.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass37"/>
      </xsl:result-document -->

      <!-- pass 38: NOP -->
      <xsl:variable name="vPass38" as="node()+">
        <xsl:apply-templates select="$vPass37" mode="atop:mPass38"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_38.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass38"/>
      </xsl:result-document -->

      <!-- pass 39: NOP -->
      <xsl:variable name="vPass39" as="node()+">
        <xsl:apply-templates select="$vPass38" mode="atop:mPass39"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_39.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass39"/>
      </xsl:result-document -->

      <!-- pass 40: NOP -->
      <xsl:variable name="vPass40" as="node()+">
        <xsl:apply-templates select="$vPass39" mode="atop:mPass40"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_40.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass40"/>
      </xsl:result-document -->

      <!-- pass 41: NOP -->
      <xsl:variable name="vPass41" as="node()+">
        <xsl:apply-templates select="$vPass40" mode="atop:mPass41"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_41.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass41"/>
      </xsl:result-document -->

      <!-- pass 42: NOP -->
      <xsl:variable name="vPass42" as="node()+">
        <xsl:apply-templates select="$vPass41" mode="atop:mPass42"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_42.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass42"/>
      </xsl:result-document -->

      <!-- pass 43: NOP -->
      <xsl:variable name="vPass43" as="node()+">
        <xsl:apply-templates select="$vPass42" mode="atop:mPass43"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_43.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass43"/>
      </xsl:result-document -->

      <!-- pass 44: NOP -->
      <xsl:variable name="vPass44" as="node()+">
        <xsl:apply-templates select="$vPass43" mode="atop:mPass44"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_44.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass44"/>
      </xsl:result-document -->

      <!-- pass 45: NOP -->
      <xsl:variable name="vPass45" as="node()+">
        <xsl:apply-templates select="$vPass44" mode="atop:mPass45"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_45.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass45"/>
      </xsl:result-document -->

      <!-- pass 46: NOP -->
      <xsl:variable name="vPass46" as="node()+">
        <xsl:apply-templates select="$vPass45" mode="atop:mPass46"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_46.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass46"/>
      </xsl:result-document -->

      <!-- pass 47: NOP -->
      <xsl:variable name="vPass47" as="node()+">
        <xsl:apply-templates select="$vPass46" mode="atop:mPass47"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_47.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass47"/>
      </xsl:result-document -->

      <!-- pass 48: NOP -->
      <xsl:variable name="vPass48" as="node()+">
        <xsl:apply-templates select="$vPass47" mode="atop:mPass48"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_48.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass48"/>
      </xsl:result-document -->

      <!-- pass 49: NOP -->
      <xsl:variable name="vPass49" as="node()+">
        <xsl:apply-templates select="$vPass48" mode="atop:mPass49"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_49.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass49"/>
      </xsl:result-document -->

      <!-- pass 50: NOP -->
      <xsl:variable name="vPass50" as="node()+">
        <xsl:apply-templates select="$vPass49" mode="atop:mPass50"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_50.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass50"/>
      </xsl:result-document -->

      <!-- pass 51: NOP -->
      <xsl:variable name="vPass51" as="node()+">
        <xsl:apply-templates select="$vPass50" mode="atop:mPass51"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_51.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass51"/>
      </xsl:result-document -->

      <!-- pass 52: NOP -->
      <xsl:variable name="vPass52" as="node()+">
        <xsl:apply-templates select="$vPass51" mode="atop:mPass52"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_52.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass52"/>
      </xsl:result-document -->

      <!-- pass 53: NOP -->
      <xsl:variable name="vPass53" as="node()+">
        <xsl:apply-templates select="$vPass52" mode="atop:mPass53"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_53.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass53"/>
      </xsl:result-document -->

      <!-- pass 54: NOP -->
      <xsl:variable name="vPass54" as="node()+">
        <xsl:apply-templates select="$vPass53" mode="atop:mPass54"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_54.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass54"/>
      </xsl:result-document -->

      <!-- pass 55: NOP -->
      <xsl:variable name="vPass55" as="node()+">
        <xsl:apply-templates select="$vPass54" mode="atop:mPass55"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_55.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass55"/>
      </xsl:result-document -->

      <!-- pass 56: NOP -->
      <xsl:variable name="vPass56" as="node()+">
        <xsl:apply-templates select="$vPass55" mode="atop:mPass56"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_56.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass56"/>
      </xsl:result-document -->

      <!-- pass 57: NOP -->
      <xsl:variable name="vPass57" as="node()+">
        <xsl:apply-templates select="$vPass56" mode="atop:mPass57"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_57.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass57"/>
      </xsl:result-document -->

      <!-- pass 58: NOP -->
      <xsl:variable name="vPass58" as="node()+">
        <xsl:apply-templates select="$vPass57" mode="atop:mPass58"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_58.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass58"/>
      </xsl:result-document -->

      <!-- pass 59: NOP -->
      <xsl:variable name="vPass59" as="node()+">
        <xsl:apply-templates select="$vPass58" mode="atop:mPass59"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_59.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass59"/>
      </xsl:result-document -->

      <!-- pass 60: NOP -->
      <xsl:variable name="vPass60" as="node()+">
        <xsl:apply-templates select="$vPass59" mode="atop:mPass60"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_60.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass60"/>
      </xsl:result-document -->

      <!-- pass 61: NOP -->
      <xsl:variable name="vPass61" as="node()+">
        <xsl:apply-templates select="$vPass60" mode="atop:mPass61"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_61.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass61"/>
      </xsl:result-document -->

      <!-- pass 62: NOP -->
      <xsl:variable name="vPass62" as="node()+">
        <xsl:apply-templates select="$vPass61" mode="atop:mPass62"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_62.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass62"/>
      </xsl:result-document -->

      <!-- pass 63: NOP -->
      <xsl:variable name="vPass63" as="node()+">
        <xsl:apply-templates select="$vPass62" mode="atop:mPass63"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_63.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass63"/>
      </xsl:result-document -->

      <!-- pass 64: NOP -->
      <xsl:variable name="vPass64" as="node()+">
        <xsl:apply-templates select="$vPass63" mode="atop:mPass64"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_64.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass64"/>
      </xsl:result-document -->

      <!-- pass 65: NOP -->
      <xsl:variable name="vPass65" as="node()+">
        <xsl:apply-templates select="$vPass64" mode="atop:mPass65"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_65.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass65"/>
      </xsl:result-document -->

      <!-- pass 66: NOP -->
      <xsl:variable name="vPass66" as="node()+">
        <xsl:apply-templates select="$vPass65" mode="atop:mPass66"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_66.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass66"/>
      </xsl:result-document -->

      <!-- pass 67: NOP -->
      <xsl:variable name="vPass67" as="node()+">
        <xsl:apply-templates select="$vPass66" mode="atop:mPass67"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_67.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass67"/>
      </xsl:result-document -->

      <!-- pass 68: NOP -->
      <xsl:variable name="vPass68" as="node()+">
        <xsl:apply-templates select="$vPass67" mode="atop:mPass68"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_68.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass68"/>
      </xsl:result-document -->

      <!-- pass 69: NOP -->
      <xsl:variable name="vPass69" as="node()+">
        <xsl:apply-templates select="$vPass68" mode="atop:mPass69"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_69.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass69"/>
      </xsl:result-document -->

      <!-- pass 70: NOP -->
      <xsl:variable name="vPass70" as="node()+">
        <xsl:apply-templates select="$vPass69" mode="atop:mPass70"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_70.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass70"/>
      </xsl:result-document -->

      <!-- pass 71: NOP -->
      <xsl:variable name="vPass71" as="node()+">
        <xsl:apply-templates select="$vPass70" mode="atop:mPass71"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_71.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass71"/>
      </xsl:result-document -->

      <!-- pass 72: NOP -->
      <xsl:variable name="vPass72" as="node()+">
        <xsl:apply-templates select="$vPass71" mode="atop:mPass72"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_72.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass72"/>
      </xsl:result-document -->

      <!-- pass 73: NOP -->
      <xsl:variable name="vPass73" as="node()+">
        <xsl:apply-templates select="$vPass72" mode="atop:mPass73"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_73.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass73"/>
      </xsl:result-document -->

      <!-- pass 74: NOP -->
      <xsl:variable name="vPass74" as="node()+">
        <xsl:apply-templates select="$vPass73" mode="atop:mPass74"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_74.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass74"/>
      </xsl:result-document -->

      <!-- pass 75: NOP -->
      <xsl:variable name="vPass75" as="node()+">
        <xsl:apply-templates select="$vPass74" mode="atop:mPass75"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_75.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass75"/>
      </xsl:result-document -->

      <!-- pass 76: NOP -->
      <xsl:variable name="vPass76" as="node()+">
        <xsl:apply-templates select="$vPass75" mode="atop:mPass76"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_76.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass76"/>
      </xsl:result-document -->

      <!-- pass 77: NOP -->
      <xsl:variable name="vPass77" as="node()+">
        <xsl:apply-templates select="$vPass76" mode="atop:mPass77"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_77.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass77"/>
      </xsl:result-document -->

      <!-- pass 78: NOP -->
      <xsl:variable name="vPass78" as="node()+">
        <xsl:apply-templates select="$vPass77" mode="atop:mPass78"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_78.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass78"/>
      </xsl:result-document -->

      <!-- pass 79: NOP -->
      <xsl:variable name="vPass79" as="node()+">
        <xsl:apply-templates select="$vPass78" mode="atop:mPass79"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_79.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass79"/>
      </xsl:result-document -->

      <!-- pass 80: NOP -->
      <xsl:variable name="vPass80" as="node()+">
        <xsl:apply-templates select="$vPass79" mode="atop:mPass80"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_80.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass80"/>
      </xsl:result-document -->

      <!-- pass 81: NOP -->
      <xsl:variable name="vPass81" as="node()+">
        <xsl:apply-templates select="$vPass80" mode="atop:mPass81"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_81.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass81"/>
      </xsl:result-document -->

      <!-- pass 82: NOP -->
      <xsl:variable name="vPass82" as="node()+">
        <xsl:apply-templates select="$vPass81" mode="atop:mPass82"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_82.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass82"/>
      </xsl:result-document -->

      <!-- pass 83: NOP -->
      <xsl:variable name="vPass83" as="node()+">
        <xsl:apply-templates select="$vPass82" mode="atop:mPass83"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_83.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass83"/>
      </xsl:result-document -->

      <!-- pass 84: NOP -->
      <xsl:variable name="vPass84" as="node()+">
        <xsl:apply-templates select="$vPass83" mode="atop:mPass84"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_84.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass84"/>
      </xsl:result-document -->

      <!-- pass 85: NOP -->
      <xsl:variable name="vPass85" as="node()+">
        <xsl:apply-templates select="$vPass84" mode="atop:mPass85"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_85.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass85"/>
      </xsl:result-document -->

      <!-- pass 86: NOP -->
      <xsl:variable name="vPass86" as="node()+">
        <xsl:apply-templates select="$vPass85" mode="atop:mPass86"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_86.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass86"/>
      </xsl:result-document -->

      <!-- pass 87: NOP -->
      <xsl:variable name="vPass87" as="node()+">
        <xsl:apply-templates select="$vPass86" mode="atop:mPass87"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_87.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass87"/>
      </xsl:result-document -->

      <!-- pass 88: NOP -->
      <xsl:variable name="vPass88" as="node()+">
        <xsl:apply-templates select="$vPass87" mode="atop:mPass88"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_88.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass88"/>
      </xsl:result-document -->

      <!-- pass 89: NOP -->
      <xsl:variable name="vPass89" as="node()+">
        <xsl:apply-templates select="$vPass88" mode="atop:mPass89"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_89.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass89"/>
      </xsl:result-document -->

      <!-- pass 90: NOP -->
      <xsl:variable name="vPass90" as="node()+">
        <xsl:apply-templates select="$vPass89" mode="atop:mPass90"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_90.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass90"/>
      </xsl:result-document -->

      <!-- pass 91: NOP -->
      <xsl:variable name="vPass91" as="node()+">
        <xsl:apply-templates select="$vPass90" mode="atop:mPass91"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_91.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass91"/>
      </xsl:result-document -->

      <!-- pass 92: NOP -->
      <xsl:variable name="vPass92" as="node()+">
        <xsl:apply-templates select="$vPass91" mode="atop:mPass92"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_92.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass92"/>
      </xsl:result-document -->

      <!-- pass 93: NOP -->
      <xsl:variable name="vPass93" as="node()+">
        <xsl:apply-templates select="$vPass92" mode="atop:mPass93"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_93.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass93"/>
      </xsl:result-document -->

      <!-- pass 94: NOP -->
      <xsl:variable name="vPass94" as="node()+">
        <xsl:apply-templates select="$vPass93" mode="atop:mPass94"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_94.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass94"/>
      </xsl:result-document -->

      <!-- pass 95: NOP -->
      <xsl:variable name="vPass95" as="node()+">
        <xsl:apply-templates select="$vPass94" mode="atop:mPass95"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_95.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass95"/>
      </xsl:result-document -->

      <!-- pass 96: NOP -->
      <xsl:variable name="vPass96" as="node()+">
        <xsl:apply-templates select="$vPass95" mode="atop:mPass96"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_96.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass96"/>
      </xsl:result-document -->

      <!-- pass 97: NOP -->
      <xsl:variable name="vPass97" as="node()+">
        <xsl:apply-templates select="$vPass96" mode="atop:mPass97"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_97.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass97"/>
      </xsl:result-document -->

      <!-- pass 98: NOP -->
      <xsl:variable name="vPass98" as="node()+">
        <xsl:apply-templates select="$vPass97" mode="atop:mPass98"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_98.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass98"/>
      </xsl:result-document -->

      <!-- pass 99: NOP -->
      <xsl:variable name="vPass99" as="node()+">
        <xsl:apply-templates select="$vPass98" mode="atop:mPass99"/>
      </xsl:variable>
      <!-- xsl:result-document href="/tmp/{$atop:pDebugName}_post-pass_99.xml" use-when="$atop:pDebug">
        <xsl:sequence select="$vPass99"/>
      </xsl:result-document -->

      <!-- output -->
      <xsl:sequence select="$vPass99"/>
    </xsl:copy>
  </xsl:template>

  <!-- ************ pass01, normalize whitespace in attrs ************ -->

  <xd:doc>
    <xd:desc>Having extraneous leading or trailing whitespace can mess
    things up, and we do not want to need to issue normalize-space()
    all over all the time. So just normalize spaces in all attrs ahead
    of time.</xd:desc>
  </xd:doc>
  <xsl:template match="@*" as="attribute()" mode="atop:mPass01">
    <xsl:copy>
      <xsl:sequence select="normalize-space(.)"/>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>The content of <tt>&lt;defaultVal></tt> is basically an attribute value.</xd:desc>
  </xd:doc>
  <xsl:template match="defaultVal" as="element(defaultVal)" mode="atop:mPass01">
    <xsl:copy>
      <xsl:sequence select="normalize-space(.)"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- ************ pass02, resolve top-level references ************ -->

  <xd:doc>
    <xd:desc>
      <xd:p>Replace the value of @source, as our output is no longer
      based on @source, but rather is the combination of the input and
      @source (or the <xd:pre>$atop:pSource</xd:pre>
      parameter).</xd:p>
      <xd:p>This perhaps should be done at pass 01 or the last pass,
      but if we think of the attributes of &lt;schemaSpec> as
      “top-level”, then it belongs here.</xd:p>
    </xd:desc>    
  </xd:doc>
  <xsl:template match="schemaSpec/@source" mode="atop:mPass02" as="attribute(source)">
    <xsl:attribute name="{name(.)}" select="'atop:DERIVED'"/>
  </xsl:template>
  
  <!-- Note: no need to process schemaSpec/specGrpRef, as those will
       already have been resolved by the "assemble" step before this
       routine is called. -->

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
    <xsl:comment expand-text="true"> *** ATOP: *** class specifications from "{$vModule}" in {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//classSpec[ @module eq $vModule ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** ATOP: *** data specifications from "{$vModule}" in {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//dataSpec[ @module eq $vModule ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** ATOP: *** element specifications from "{$vModule}" in {$atop:pSource} *** </xsl:comment>
    <xsl:sequence select="$atop:vBaseOdd//elementSpec[ @module eq $vModule ][ not( @ident = $vExcepts ) ][ not( current()/@include ) or @ident = $vIncludes ]"/>
    <xsl:text>&#x0A;</xsl:text>
    <xsl:comment expand-text="true"> *** ATOP: *** macro specifications from "{$vModule}" in {$atop:pSource} *** </xsl:comment>
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
    <xsl:message select="'debug3s:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpDeleteUs" select="$vDeleteUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>If an elementSpec/@ident matches one of the things-to-be-deleted,
    then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="elementSpec" mode="atop:mPass03" as="node()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:message select="'debug3e:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
    <xsl:choose>
      <xsl:when test="@ident = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: specification for element {@ident} deleted here </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:desc>If an elementRef/@key matches one of the things-to-be-deleted,
    then do not copy it.</xd:desc>
    <xd:param name="tpDeleteUs">list of NCNames of the idents of elements to be deleted</xd:param>
  </xd:doc>
  <xsl:template match="elementRef" mode="atop:mPass03" as="node()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: reference to element {@key} deleted here </xsl:comment>
      </xsl:when>
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
    <xsl:message select="'debug4s:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
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
  <xsl:template match="dataSpec" mode="atop:mPass04" as="node()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:message select="'debug4d:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
    <xsl:choose>
      <xsl:when test="@ident = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: specification of datatype {@ident} deleted here </xsl:comment>
      </xsl:when>
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
    <xsl:choose>
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: reference to {@key} datatype deleted here </xsl:comment>
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
    <xsl:message select="'debug5s:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
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
  <xsl:template match="macroSpec" mode="atop:mPass05" as="node()?">
    <xsl:param name="tpDeleteUs" tunnel="yes" as="xs:string*"/>
    <xsl:message select="'debug5m:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
    <xsl:choose>
      <xsl:when test="@ident = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: specification of macro {@ident} deleted here </xsl:comment>
      </xsl:when>
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
    <xsl:choose>
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: reference to {@key} macro deleted here </xsl:comment>
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
    <xsl:message select="'debug6s:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
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
    <xsl:message select="'debug6c:  '|| atop:common-ident(.)||'  has uid  '||atop:unique-ident(.)" use-when="$atop:pDebug"/>
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
    <xsl:choose>
      <xsl:when test="@key = $tpDeleteUs">
        <xsl:comment expand-text="true"> *** ATOP: reference to {@key} class deleted here </xsl:comment>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ************ pass07, post-deletion clean-up ************ -->

  <xd:doc>
    <xd:desc>If our deletions have left a grouping element
    (&lt;alternate>, &lt;interleave>, or &lt;sequence>) with only 1
    descendant oddDecl or RELAX NG node, commit suicide (but not
    filicide).</xd:desc>
  </xd:doc>
  <xsl:template mode="atop:mPass07" as="item()+"
                match="(alternate|interleave|sequence)[ count( .//( anyElement | classRef | dataRef | elementRef | macroRef | textNode | valList | rng:* ) ) eq 1 ]">
    <xsl:apply-templates select="node()" mode="#current"/>
  </xsl:template>

  <xd:doc>
    <xd:desc>If our deletions have left a grouping element
    (&lt;alternate>, &lt;interleave>, or &lt;sequence> empty (which is
    to say, without any oddDecl or RELAX NG descendants) just kill
    it.</xd:desc>
  </xd:doc>
  <xsl:template match="(alternate|interleave|sequence)[ atop:has-no-content-content(.) ]" mode="atop:mPass07" as="empty-sequence()"/>
  
  <xd:doc>
    <xd:desc>If our deletions have left a &lt;content> empty (same definition as
    above), change its content to emptiness itself.</xd:desc>
  </xd:doc>
  <xsl:template match="content[ atop:has-no-content-content(.) ]" mode="atop:mPass07" as="element(content)">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <empty/>
    </xsl:copy>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If our deletions have left a &lt;datatype> empty (same definition as
      above), change its content to allow whatever.</xd:desc>
  </xd:doc>
  <xsl:template match="datatype[ atop:has-no-content-content(.) ]" mode="atop:mPass07" as="element(datatype)">
    <xsl:copy>
      <xsl:apply-templates select="@*" mode="#current"/>
      <xsl:comment> *** ATOP: cannot use the {@key} datatype, as it has been deleted; allowing any value </xsl:comment>
      <dataRef name="string"/> <!-- cannot use a TEI datatype as it may have been deleted -->
    </xsl:copy>
  </xsl:template>

  <!-- ******** pass08, replacement of schema-level components -->

  <xd:doc>
    <xd:desc>Set up to replace base schema-level specifications (i.e.,
    replacements specified as child of input &lt;schemaSpec>) that
    customization indicates are being replaced.</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="atop:mPass08" as="element(schemaSpec)">
    <xsl:variable name="vReplaceUs" select="child::*[ @mode eq 'replace']!atop:common-ident(.)" as="xs:string*"/>
    <xsl:message select="'debug08vReplaceUs = '||string-join( $vReplaceUs, ', ')" use-when="$atop:pDebug"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpReplaceUs" select="$vReplaceUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>If what a schema-level specification element specifies
      matches one of the things-to-be-replaced, then do not copy
      it.</xd:desc>
    <xd:param name="tpReplaceUs">list of atop:common-ident() values of the elements to be replaced</xd:param>
  </xd:doc>
  <xsl:template match="classSpec | dataSpec | elementSpec | macroSpec" mode="atop:mPass08" as="node()+">
    <xsl:param name="tpReplaceUs" tunnel="yes" as="xs:string*"/>
    <xsl:choose>
      <xsl:when test="atop:common-ident(.) = $tpReplaceUs  and  ( @mode ne 'replace'  or  not( @mode ) )">
        <xsl:message use-when="$atop:pDebug"
            select="'debug08choose1 for a '||name(.)||' of '||@ident||' in '||ancestor-or-self::*[@xml:id][1]/@xml:id||' a:ci()='||atop:common-ident(.)||' and RU='||string-join( $tpReplaceUs, ', ')"/>
        <xsl:text>&#x0A;</xsl:text>
        <xsl:comment> *** ATOP: deleting base version of {@ident} {local-name(.)} here as it has been replaced </xsl:comment>
      </xsl:when>
      <xsl:when test="atop:common-ident(.) = $tpReplaceUs  and  @mode eq 'replace'">
        <xsl:message use-when="$atop:pDebug"
            select="'debug08choose2 for a '||name(.)||' of '||@ident||' in '||ancestor-or-self::*[@xml:id][1]/@xml:id||' a:ci()='||atop:common-ident(.)||' and RU='||string-join( $tpReplaceUs, ', ')"/>
        <xsl:copy>
          <xsl:apply-templates select="@* except @mode" mode="#current"/>
          <xsl:attribute name="mode" select="'add'"/>
          <xsl:text>&#x0A;</xsl:text>
          <xsl:comment> *** ATOP: base version has been deleted, this (the replacement version) is being added </xsl:comment>
          <xsl:apply-templates select="node()" mode="#current"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message use-when="$atop:pDebug"
            select="'debug08choose3 for a '||name(.)||' of '||@ident||' in '||ancestor-or-self::*[@xml:id][1]/@xml:id||' a:ci()='||atop:common-ident(.)||' and RU='||string-join( $tpReplaceUs, ', ')"/>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- ******** pass09, change (i.e., merge) of schema-level components -->

  <xd:doc>
    <xd:desc>Set up to merge a schema-level specifications that
    customization indicates are being merged (i.e., "change"
    specified as child of input &lt;schemaSpec>).</xd:desc>
  </xd:doc>
  <xsl:template match="schemaSpec" mode="atop:mPass09" as="element(schemaSpec)">
    <xsl:variable name="vChangeUs" select="child::*[ @mode eq 'change']!atop:common-ident(.)" as="xs:string*"/>
    <xsl:copy>
      <xsl:apply-templates select="@*|node()" mode="#current">
        <xsl:with-param name="tpChangeUs" select="$vChangeUs" as="xs:string*" tunnel="yes"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

  <xd:doc>
    <xd:desc>If the class that a class specification defines matches
    one of the things-to-be-changed, then merge it with the base
    version of the same thing.</xd:desc>
    <xd:param name="tpChangeUs">list of atop:common-ident() values of the elements to be changed</xd:param>
  </xd:doc>
  <xsl:template match="classSpec" mode="atop:mPass09" as="node()+">
    <xsl:param name="tpChangeUs" tunnel="yes" as="xs:string*"/>
    <xsl:variable name="vMyCommonIdent" select="atop:common-ident(.)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="$vMyCommonIdent = $tpChangeUs  and  ( @mode ne 'change'  or  not( @mode ) )">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:comment> *** ATOP: deleting base version of {@ident} {local-name(.)} here as it has been merged with customization version</xsl:comment>
      </xsl:when>
      <xsl:when test="$vMyCommonIdent = $tpChangeUs  and  @mode eq 'change'">
        <xsl:variable name="vBaseSpec" as="element(classSpec)"
                      select="$atop:vBaseOdd//classSpec[ atop:common-ident(.) eq $vMyCommonIdent ]"/>
        <xsl:copy>
          <xsl:comment> *** ATOP: base version has been deleted, this (the merged or "change"d version) is being added </xsl:comment>
          <!-- DO THE RIGHT THING HERE!! -->
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:desc>If what a datatype specification defines matches one of
    the things-to-be-changed, then merge it with the base version of
    the same thing.</xd:desc>
    <xd:param name="tpChangeUs">list of atop:common-ident() values of the elements to be changed</xd:param>
  </xd:doc>
  <xsl:template match="dataSpec" mode="atop:mPass09" as="node()+">
    <xsl:param name="tpChangeUs" tunnel="yes" as="xs:string*"/>
    <xsl:variable name="vMe" select="." as="element(dataSpec)"/>
    <xsl:variable name="vMyCommonIdent" select="atop:common-ident(.)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="atop:common-ident(.) = $tpChangeUs  and  @mode eq 'change'">
        <xsl:variable name="vBaseSpec" as="element(dataSpec)"
                      select="$atop:vBaseOdd//dataSpec[ atop:common-ident(.) eq $vMyCommonIdent ]"/>
        <xsl:copy>
          <xsl:apply-templates select="$vBaseSpec/@* except @mode" mode="#current"/>
          <xsl:apply-templates select="@* except @mode" mode="#current"/>
          <xsl:comment> *** ATOP: base version has been deleted, this (the merged or "change"d version) is being added </xsl:comment>
          <!--
              Make a list of all the langues used for the <altIdent>s,
              <equiv>s, <gloss>es, and <desc>s inside this
              <dataSpec>.
          -->
          <xsl:variable name="vAllDocLangs" as="xs:language+">
            <xsl:variable name="vAllDocXMLLangs" as="xs:language*">
              <xsl:for-each select="tei:altIdent | tei:equiv | tei:gloss | tei:desc">
                <xsl:sequence select="ancestor-or-self::*[@xml:lang][1]/@xml:lang cast as xs:language"/>
              </xsl:for-each>
            </xsl:variable>
            <xsl:sequence select="distinct-values( ('en' cast as xs:language, $vAllDocXMLLangs ) )"/>
          </xsl:variable>
          <!--
              For each language, take the local <altIdent>, <equiv>,
              <gloss>, or <desc> if there is one, otherwise the base
              version thereof (if there is one).
          -->
          <xsl:for-each select="$vAllDocLangs">
            <xsl:variable name="vThisLang" select=". cast as xs:string" as="xs:string"/>
            <xsl:apply-templates select="( $vMe/tei:altIdent[ lang( $vThisLang ) ], $vBaseSpec/tei:altIdent[ lang( $vThisLang ) ] )[1]" mode="#current"/>
            <xsl:apply-templates select="( $vMe/tei:equiv[    lang( $vThisLang ) ], $vBaseSpec/tei:equiv[    lang( $vThisLang ) ] )[1]" mode="#current"/>
            <xsl:apply-templates select="( $vMe/tei:gloss[    lang( $vThisLang ) ], $vBaseSpec/tei:gloss[    lang( $vThisLang ) ] )[1]" mode="#current"/>
            <xsl:apply-templates select="( $vMe/tei:desc[     lang( $vThisLang ) ], $vBaseSpec/tei:desc[     lang( $vThisLang ) ] )[1]" mode="#current"/>
          </xsl:for-each>
          <!-- There is 0 or 1 <content> element, but if it has a child <valList> we need to think of it differently … -->
          <xsl:message select="'debug09a: ident='
                              ||@ident
                              ||', content='
                              ||exists( tei:content )
                              ||', content/valList='
                              ||exists( tei:content/tei:valList )
                              ||', base/content='
                              ||exists( $vBaseSpec/tei:content )
                              ||', base/content/valList='
                              ||exists(
                              $vBaseSpec/tei:content/tei:valList )"/>
          <xsl:choose>
            <xsl:when test="not( tei:content/tei:valList )  and  not( $vBaseSpec/tei:content/tei:valList )">
              <!-- neither has a <valList> child of <content>, so the customization <content> replaces the base’s -->
              <xsl:apply-templates select="tei:content[ not( tei:valList ) ]" mode="#current"/>
            </xsl:when>
            <xsl:when test="tei:content[ tei:valList ]  and  $vBaseSpec/tei:content[ not( tei:valList ) ]
                            or
                            tei:content[ not( tei:valList ) ]  and  $vBaseSpec/tei:content[ tei:valList ]">
              <!-- one of ’em has a <valList>, but not the other, so combine contents -->
              <content>
                <xsl:apply-templates select="tei:content/* | $vBaseSpec/tei:content/*" mode="#current"/>
              </content>
            </xsl:when>
            <xsl:when test="tei:content[ tei:valList ]  and  $vBaseSpec/tei:content[ tei:valList ]">
              <!-- both of ’em have a <valList> … what to do? -->
              <content>
                <xsl:comment> ATOP, temp: this is NOT supposed to be
                empty, but I am not sure what we are supposed to do
                when both the customization and the base &lt;content>
                each have a child &lt;valList>!</xsl:comment>
                <empty/>
              </content>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes" select="'ATOP: internal logic error in processing dataSpec '||@ident||' in mode change'"/>
            </xsl:otherwise>
          </xsl:choose>

          <!-- The following handles a <valList> *child*, not one that it inside <content> -->
          <xsl:choose>
            <xsl:when test="tei:valList[ @mode eq 'delete']"/>
            <xsl:when test="tei:valList[ @mode eq 'add'  or  not( @mode ) ]">
              <xsl:for-each select="tei:valList"> <!-- to set context node -->
                <xsl:copy>
                  <xsl:apply-templates select="$vBaseSpec/tei:valList/*" mode="#current"/>
                  <xsl:apply-templates select="tei:valList/*" mode="#current"/>
                </xsl:copy>
              </xsl:for-each>
            </xsl:when>
            <xsl:when test="tei:valList[ @mode eq 'replace']">
              <xsl:apply-templates select="tei:valList" mode="#current"/>
            </xsl:when>
            <xsl:when test="tei:valList[ @mode eq 'change']">
              <!-- Conveniently, there can be at most 1 <valList> descendant of <dataSpec> -->
              <xsl:message use-when="$atop:pDebug" select="'debug: call valList change template'"/>
              <xsl:apply-templates select="tei:valList" mode="atop:mChange">
                <xsl:with-param name="pSourceValList" select="$vBaseSpec/tei:valList" as="element(tei:valList)"/>
              </xsl:apply-templates>
            </xsl:when>
          </xsl:choose>
          <xsl:comment> DO THE RIGHT THING for &lt;constraintSpec> (has @mode &amp; @ident) HERE!! </xsl:comment>
          <xsl:comment> DO THE RIGHT THING for &lt;exemplum> (has neither @mode nor @ident) HERE!! </xsl:comment>
          <xsl:comment> DO THE RIGHT THING for &lt;remarks> (has @mode &amp; @ident) HERE!! </xsl:comment>
          <xsl:comment> DO THE RIGHT THING for &lt;listRef> (has neither @mode nor @ident) HERE!! </xsl:comment>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If the element an element specification defines matches
    one of the things-to-be-changed, then merge it with the base
    version of the same thing.</xd:desc>
    <xd:param name="tpChangeUs">list of atop:common-ident() values of the elements to be changed</xd:param>
  </xd:doc>
  <xsl:template match="elementSpec" mode="atop:mPass09" as="node()+">
    <xsl:param name="tpChangeUs" tunnel="yes" as="xs:string*"/>
    <xsl:variable name="vMyCommonIdent" select="atop:common-ident(.)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="atop:common-ident(.) = $tpChangeUs  and  ( @mode ne 'change'  or  not( @mode ) )">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:comment> *** ATOP: deleting base version of {@ident} {local-name(.)} here as it has been merged with customization version</xsl:comment>
      </xsl:when>
      <xsl:when test="atop:common-ident(.) = $tpChangeUs  and  @mode eq 'change'">
        <xsl:variable name="vBaseSpec" as="element(elementSpec)"
                      select="$atop:vBaseOdd//elementSpec[ atop:common-ident(.) eq $vMyCommonIdent ]"/>
        <xsl:copy>
          <xsl:comment> *** ATOP: base version has been deleted, this (the merged or "change"d version) is being added </xsl:comment>
          <!-- DO THE RIGHT THING HERE!! -->
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xd:doc>
    <xd:desc>If the macro a macro specification defines matches one of
    the things-to-be-changed, then merge it with the base version of
    the same thing.</xd:desc>
    <xd:param name="tpChangeUs">list of atop:common-ident() values of the elements to be changed</xd:param>
  </xd:doc>
  <xsl:template match="macroSpec" mode="atop:mPass09" as="node()+">
    <xsl:param name="tpChangeUs" tunnel="yes" as="xs:string*"/>
    <xsl:variable name="vMyCommonIdent" select="atop:common-ident(.)" as="xs:string"/>
    <xsl:choose>
      <xsl:when test="atop:common-ident(.) = $tpChangeUs  and  ( @mode ne 'change'  or  not( @mode ) )">
        <xsl:text>&#x0A;</xsl:text>
        <xsl:comment> *** ATOP: deleting base version of {@ident} {local-name(.)} here as it has been merged with customization version</xsl:comment>
      </xsl:when>
      <xsl:when test="atop:common-ident(.) = $tpChangeUs  and  @mode eq 'change'">
        <xsl:variable name="vBaseSpec" as="element(macroSpec)"
                      select="$atop:vBaseOdd//macroSpec[ atop:common-ident(.) eq $vMyCommonIdent ]"/>
        <xsl:copy>
          <xsl:comment> *** ATOP: base version has been deleted, this (the merged or "change"d version) is being added </xsl:comment>
          <!-- DO THE RIGHT THING HERE!! -->
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:next-match/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xd:doc>
    <xd:desc>Perform the "change" operation on a value list.</xd:desc>
    <xd:param name="pSourceValList">The value list from the source ODD that is the one that
      corresponds to the value list this template matched in the cusotmization ODD</xd:param>
    <xd:return>a &lt;valList> element, hopefully appropriately merged</xd:return>
  </xd:doc>
  <xsl:template mode="atop:mChange" match="tei:valList" as="element(tei:valList)">
    <xsl:param name="pSourceValList" required="yes" as="element(tei:valList)"/>
    <xsl:variable name="vCustomizationValList" select="." as="element(tei:valList)"/>
    <xsl:message use-when="$atop:pDebug" select="'debug: valList-mChange pSourceValList='||normalize-space(string($pSourceValList))||', and vCostomizationValist='||normalize-space(string($vCustomizationValList))||'.'"/>
    <xsl:copy>
      <xsl:apply-templates select="$pSourceValList/@* except @xml:id" mode="#current"/>
      <xsl:apply-templates select="@* except @xml:id" mode="#current"/>
      <!-- I figure @xml:id should NOT be processed, above; are there other attrs that should be skipped? -->
      <!-- Handle <equiv> -->
      <xsl:for-each select="$pSourceValList/equiv">
        <xsl:if test="not( ./@name = $vCustomizationValList/equiv!@name )">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates select="$vCustomizationValList/equiv"/>
      <!-- Handle <altItent> -->
      <xsl:for-each select="$pSourceValList/altIdent">
        <xsl:if test="not( atop:lang(.) = $vCustomizationValList/altIdent!atop:lang(.) )">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates select="$vCustomizationValList/altIdent"/>
      <!-- Handle <gloss> -->
      <xsl:for-each select="$pSourceValList/gloss">
        <xsl:if test="not( atop:lang(.) = $vCustomizationValList/gloss!atop:lang(.) )">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates select="$vCustomizationValList/gloss"/>
      <!-- Handle <desc> -->
      <xsl:for-each select="$pSourceValList/desc">
        <xsl:message use-when="$atop:pDebug"
            select="'debug valList-change: '||atop:lang(.)||' = '||$vCustomizationValList/desc!atop:lang(.)||'?'"/>
        <xsl:if test="not( atop:lang(.) = $vCustomizationValList/desc!atop:lang(.) )">
          <xsl:copy-of select="."/>
        </xsl:if>
      </xsl:for-each>
      <xsl:apply-templates select="$vCustomizationValList/desc"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
