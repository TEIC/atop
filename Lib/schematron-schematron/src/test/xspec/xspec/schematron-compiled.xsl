<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="#all"
                version="3.0">
   <!-- the tested stylesheet -->
   <xsl:import href="file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/xspec/schematron-sch-preprocessed.xsl"/>
   <!-- XSpec library modules providing tools -->
   <xsl:include href="file:/home/dmaus/bin/xspec-dev/src/common/runtime-utils.xsl"/>
   <xsl:include href="file:/home/dmaus/bin/xspec-dev/src/schematron/select-node.xsl"/>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}stylesheet-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/xspec/schematron-sch-preprocessed.xsl</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}xspec-uri"
                 as="Q{http://www.w3.org/2001/XMLSchema}anyURI">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:variable>
   <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}is-external"
                 as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                 select="false()"/>
   <xsl:variable name="Q{urn:x-xspec:compile:impl}thread-aware"
                 as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                 select="(system-property('Q{http://www.w3.org/1999/XSL/Transform}product-name') eq 'SAXON') and starts-with(system-property('Q{http://www.w3.org/1999/XSL/Transform}product-version'), 'EE ')"
                 static="yes"/>
   <xsl:variable name="Q{urn:x-xspec:compile:impl}logical-processor-count"
                 as="Q{http://www.w3.org/2001/XMLSchema}integer"
                 use-when="$Q{urn:x-xspec:compile:impl}thread-aware"
                 select="Q{java:java.lang.Runtime}getRuntime() =&gt; Q{java:java.lang.Runtime}availableProcessors()"/>
   <xsl:variable name="Q{urn:x-xspec:compile:impl}thread-count"
                 as="Q{http://www.w3.org/2001/XMLSchema}integer"
                 select="1"
                 use-when="$Q{urn:x-xspec:compile:impl}thread-aware =&gt; not()"/>
   <!-- the main template to run the suite -->
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}main"
                 as="empty-sequence()">
      <xsl:context-item use="absent"/>
      <!-- info message -->
      <xsl:message>
         <xsl:text>Testing with </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-name')"/>
         <xsl:text> </xsl:text>
         <xsl:value-of select="system-property('Q{http://www.w3.org/1999/XSL/Transform}product-version')"/>
      </xsl:message>
      <!-- set up the result document (the report) -->
      <xsl:result-document format="Q{{http://www.jenitennison.com/xslt/xspec}}xml-report-serialization-parameters">
         <xsl:element name="report" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
            <xsl:attribute name="stylesheet" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/xspec/schematron-sch-preprocessed.xsl</xsl:attribute>
            <xsl:attribute name="schematron" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/main/resources/content/schematron.sch</xsl:attribute>
            <xsl:attribute name="date" namespace="" select="current-dateTime()"/>
            <!-- invoke each compiled top-level x:scenario -->
            <xsl:for-each select="1 to 2">
               <xsl:choose>
                  <xsl:when test=". eq 1">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"/>
                  </xsl:when>
                  <xsl:when test=". eq 2">
                     <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:for-each>
         </xsl:element>
      </xsl:result-document>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>XSLT 2.0 query language binding</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>XSLT 2.0 query language binding</xsl:text>
         </xsl:element>
         <xsl:for-each select="1 to 2">
            <xsl:choose>
               <xsl:when test=". eq 1">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1"/>
               </xsl:when>
               <xsl:when test=". eq 2">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..The generate-id() function</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>The generate-id() function</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="xspec:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="select" namespace="">self::document-node()</xsl:attribute>
               <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="context"
                                 namespace=""
                                 select="'', ''"
                                 separator="element[generate-id()]"/>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d57e0-doc"
                       as="document-node()">
            <xsl:document>
               <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="context"
                                 namespace=""
                                 select="'', ''"
                                 separator="element[generate-id()]"/>
               </xsl:element>
            </xsl:document>
         </xsl:variable>
         <xsl:variable xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                       name="Q{urn:x-xspec:compile:impl}context-d57e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d57e0-doc ! ( self::document-node() )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       as="item()*"
                       select="$Q{urn:x-xspec:compile:impl}context-d57e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:apply-templates select="$Q{urn:x-xspec:compile:impl}context-d57e0"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario1-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>not report unknown-function</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e6" select="()"><!--expected result--></xsl:variable>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/xspec}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/xspec}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unknown-function'])"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                             select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unknown-function'])"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="$Q{urn:x-xspec:compile:impl}test-result =&gt; boolean()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">ERROR in xspec:expect ('XSLT 2.0 query language binding The generate-id() function not report unknown-function'): Non-boolean @test must be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>not report unknown-function</xsl:text>
         </xsl:element>
         <xsl:element name="expect-test-wrap" namespace="">
            <xsl:element name="xspec:expect" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="test" namespace="">Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unknown-function'])</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="report-name" select="'result'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e6"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..Namespace prefixes in QNames</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Namespace prefixes in QNames</xsl:text>
         </xsl:element>
         <xsl:for-each select="1 to 2">
            <xsl:choose>
               <xsl:when test=". eq 1">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario1"/>
               </xsl:when>
               <xsl:when test=". eq 2">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario2"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..QName with undeclared prefix</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario2-scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>QName with undeclared prefix</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="xspec:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="select" namespace="">self::document-node()</xsl:attribute>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt2"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@undeclared:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d74e0-doc"
                       as="document-node()">
            <xsl:document>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt2"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@undeclared:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:document>
         </xsl:variable>
         <xsl:variable xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                       name="Q{urn:x-xspec:compile:impl}context-d74e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d74e0-doc ! ( self::document-node() )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       as="item()*"
                       select="$Q{urn:x-xspec:compile:impl}context-d74e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:apply-templates select="$Q{urn:x-xspec:compile:impl}context-d74e0"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario1-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>report unbound-qname-ns</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e13" select="()"><!--expected result--></xsl:variable>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/xspec}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/xspec}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                select="exists(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                             select="exists(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="$Q{urn:x-xspec:compile:impl}test-result =&gt; boolean()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">ERROR in xspec:expect ('XSLT 2.0 query language binding Namespace prefixes in QNames QName with undeclared prefix report unbound-qname-ns'): Non-boolean @test must be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario2-scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>report unbound-qname-ns</xsl:text>
         </xsl:element>
         <xsl:element name="expect-test-wrap" namespace="">
            <xsl:element name="xspec:expect" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="test" namespace="">exists(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="report-name" select="'result'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e13"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..QName with xml: prefix</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario2-scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>QName with xml: prefix</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="xspec:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="select" namespace="">self::document-node()</xsl:attribute>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt2"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@xml:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d89e0-doc"
                       as="document-node()">
            <xsl:document>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt2"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@xml:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:document>
         </xsl:variable>
         <xsl:variable xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                       name="Q{urn:x-xspec:compile:impl}context-d89e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d89e0-doc ! ( self::document-node() )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       as="item()*"
                       select="$Q{urn:x-xspec:compile:impl}context-d89e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:apply-templates select="$Q{urn:x-xspec:compile:impl}context-d89e0"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario1-scenario2-scenario2-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>not report unbound-qname-ns</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e19" select="()"><!--expected result--></xsl:variable>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/xspec}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/xspec}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                             select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="$Q{urn:x-xspec:compile:impl}test-result =&gt; boolean()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">ERROR in xspec:expect ('XSLT 2.0 query language binding Namespace prefixes in QNames QName with xml: prefix not report unbound-qname-ns'): Non-boolean @test must be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario1-scenario2-scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>not report unbound-qname-ns</xsl:text>
         </xsl:element>
         <xsl:element name="expect-test-wrap" namespace="">
            <xsl:element name="xspec:expect" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="test" namespace="">Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="report-name" select="'result'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e19"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>XSLT 3.0 query language binding</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>XSLT 3.0 query language binding</xsl:text>
         </xsl:element>
         <xsl:for-each select="1 to 2">
            <xsl:choose>
               <xsl:when test=". eq 1">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario1"/>
               </xsl:when>
               <xsl:when test=". eq 2">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..The generate-id() function</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>The generate-id() function</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="xspec:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="select" namespace="">self::document-node()</xsl:attribute>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt3"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="element[generate-id()]"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d107e0-doc"
                       as="document-node()">
            <xsl:document>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt3"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="element[generate-id()]"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:document>
         </xsl:variable>
         <xsl:variable xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                       name="Q{urn:x-xspec:compile:impl}context-d107e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d107e0-doc ! ( self::document-node() )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       as="item()*"
                       select="$Q{urn:x-xspec:compile:impl}context-d107e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:apply-templates select="$Q{urn:x-xspec:compile:impl}context-d107e0"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario1-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>not report unknown-function</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e26" select="()"><!--expected result--></xsl:variable>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/xspec}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/xspec}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unknown-function'])"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                             select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unknown-function'])"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="$Q{urn:x-xspec:compile:impl}test-result =&gt; boolean()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">ERROR in xspec:expect ('XSLT 3.0 query language binding The generate-id() function not report unknown-function'): Non-boolean @test must be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>not report unknown-function</xsl:text>
         </xsl:element>
         <xsl:element name="expect-test-wrap" namespace="">
            <xsl:element name="xspec:expect" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="test" namespace="">Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unknown-function'])</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="report-name" select="'result'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e26"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..Namespace prefixes in QNames</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>Namespace prefixes in QNames</xsl:text>
         </xsl:element>
         <xsl:for-each select="1 to 2">
            <xsl:choose>
               <xsl:when test=". eq 1">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario1"/>
               </xsl:when>
               <xsl:when test=". eq 2">
                  <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario2"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:message terminate="yes">ERROR: Unhandled scenario invocation</xsl:message>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..QName with undeclared prefix</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario2-scenario1</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>QName with undeclared prefix</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="xspec:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="select" namespace="">self::document-node()</xsl:attribute>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt3"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@undeclared:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d124e0-doc"
                       as="document-node()">
            <xsl:document>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt3"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@undeclared:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:document>
         </xsl:variable>
         <xsl:variable xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                       name="Q{urn:x-xspec:compile:impl}context-d124e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d124e0-doc ! ( self::document-node() )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       as="item()*"
                       select="$Q{urn:x-xspec:compile:impl}context-d124e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:apply-templates select="$Q{urn:x-xspec:compile:impl}context-d124e0"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario1-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario1-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>report unbound-qname-ns</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e33" select="()"><!--expected result--></xsl:variable>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/xspec}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/xspec}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                select="exists(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                             select="exists(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="$Q{urn:x-xspec:compile:impl}test-result =&gt; boolean()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">ERROR in xspec:expect ('XSLT 3.0 query language binding Namespace prefixes in QNames QName with undeclared prefix report unbound-qname-ns'): Non-boolean @test must be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario2-scenario1-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>report unbound-qname-ns</xsl:text>
         </xsl:element>
         <xsl:element name="expect-test-wrap" namespace="">
            <xsl:element name="xspec:expect" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="test" namespace="">exists(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="report-name" select="'result'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e33"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario2"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}scenario)">
      <xsl:context-item use="absent"/>
      <xsl:message>..QName with xml: prefix</xsl:message>
      <xsl:element name="scenario" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario2-scenario2</xsl:attribute>
         <xsl:attribute name="xspec" namespace="">file:/home/dmaus/projects/schematron/schematron-schematron/src/test/xspec/schematron.xspec</xsl:attribute>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>QName with xml: prefix</xsl:text>
         </xsl:element>
         <xsl:element name="input-wrap" namespace="">
            <xsl:element name="xspec:context" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="select" namespace="">self::document-node()</xsl:attribute>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt3"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@xml:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:element>
         </xsl:element>
         <xsl:variable name="Q{urn:x-xspec:compile:impl}context-d139e0-doc"
                       as="document-node()">
            <xsl:document>
               <xsl:element name="sch:schema" namespace="http://purl.oclc.org/dsdl/schematron">
                  <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                  <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                 xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                 name="queryBinding"
                                 namespace=""
                                 select="'', ''"
                                 separator="xslt3"/>
                  <xsl:element name="sch:pattern" namespace="http://purl.oclc.org/dsdl/schematron">
                     <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                     <xsl:element name="sch:rule" namespace="http://purl.oclc.org/dsdl/schematron">
                        <xsl:namespace name="xspec">http://www.jenitennison.com/xslt/xspec</xsl:namespace>
                        <xsl:attribute xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                       name="context"
                                       namespace=""
                                       select="'', ''"
                                       separator="@xml:lang"/>
                     </xsl:element>
                  </xsl:element>
               </xsl:element>
            </xsl:document>
         </xsl:variable>
         <xsl:variable xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                       xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                       name="Q{urn:x-xspec:compile:impl}context-d139e0"
                       select="$Q{urn:x-xspec:compile:impl}context-d139e0-doc ! ( self::document-node() )"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}context"
                       as="item()*"
                       select="$Q{urn:x-xspec:compile:impl}context-d139e0"/>
         <xsl:variable name="Q{http://www.jenitennison.com/xslt/xspec}result" as="item()*">
            <xsl:apply-templates select="$Q{urn:x-xspec:compile:impl}context-d139e0"/>
         </xsl:variable>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            <xsl:with-param name="report-name" select="'result'"/>
         </xsl:call-template>
         <!-- invoke each compiled x:expect -->
         <xsl:call-template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario2-expect1">
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}context"/>
            <xsl:with-param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                            select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
   <xsl:template name="Q{http://www.jenitennison.com/xslt/xspec}scenario2-scenario2-scenario2-expect1"
                 as="element(Q{http://www.jenitennison.com/xslt/xspec}test)">
      <xsl:context-item use="absent"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}context"
                 as="item()*"
                 required="yes"/>
      <xsl:param name="Q{http://www.jenitennison.com/xslt/xspec}result"
                 as="item()*"
                 required="yes"/>
      <xsl:message>not report unbound-qname-ns</xsl:message>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}expect-d52e39" select="()"><!--expected result--></xsl:variable>
      <!-- wrap $x:result into a document node if possible -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-items" as="item()*">
         <xsl:choose>
            <xsl:when test="exists($Q{http://www.jenitennison.com/xslt/xspec}result) and Q{http://www.jenitennison.com/xslt/xspec}wrappable-sequence($Q{http://www.jenitennison.com/xslt/xspec}result)">
               <xsl:sequence select="Q{http://www.jenitennison.com/xslt/xspec}wrap-nodes($Q{http://www.jenitennison.com/xslt/xspec}result)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence select="$Q{http://www.jenitennison.com/xslt/xspec}result"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <!-- evaluate the predicate with $x:result (or its wrapper document node) as context item if it is a single item; if not, evaluate the predicate without context item -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}test-result" as="item()*">
         <xsl:choose>
            <xsl:when test="count($Q{urn:x-xspec:compile:impl}test-items) eq 1">
               <xsl:for-each select="$Q{urn:x-xspec:compile:impl}test-items">
                  <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                                select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                                version="3"/>
               </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
               <xsl:sequence xmlns:sch="http://purl.oclc.org/dsdl/schematron"
                             xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                             select="Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])"
                             version="3"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="Q{urn:x-xspec:compile:impl}boolean-test"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean"
                    select="$Q{urn:x-xspec:compile:impl}test-result instance of Q{http://www.w3.org/2001/XMLSchema}boolean"/>
      <!-- did the test pass? -->
      <xsl:variable name="Q{urn:x-xspec:compile:impl}successful"
                    as="Q{http://www.w3.org/2001/XMLSchema}boolean">
         <xsl:choose>
            <xsl:when test="$Q{urn:x-xspec:compile:impl}boolean-test">
               <xsl:sequence select="$Q{urn:x-xspec:compile:impl}test-result =&gt; boolean()"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:message terminate="yes">ERROR in xspec:expect ('XSLT 3.0 query language binding Namespace prefixes in QNames QName with xml: prefix not report unbound-qname-ns'): Non-boolean @test must be accompanied by @as, @href, @select, or child node.</xsl:message>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:if test="not($Q{urn:x-xspec:compile:impl}successful)">
         <xsl:message>      FAILED</xsl:message>
      </xsl:if>
      <xsl:element name="test" namespace="http://www.jenitennison.com/xslt/xspec">
         <xsl:attribute name="id" namespace="">scenario2-scenario2-scenario2-expect1</xsl:attribute>
         <xsl:attribute name="successful"
                        namespace=""
                        select="$Q{urn:x-xspec:compile:impl}successful"/>
         <xsl:element name="label" namespace="http://www.jenitennison.com/xslt/xspec">
            <xsl:text>not report unbound-qname-ns</xsl:text>
         </xsl:element>
         <xsl:element name="expect-test-wrap" namespace="">
            <xsl:element name="xspec:expect" namespace="http://www.jenitennison.com/xslt/xspec">
               <xsl:namespace name="sch">http://purl.oclc.org/dsdl/schematron</xsl:namespace>
               <xsl:attribute name="test" namespace="">Q{http://purl.oclc.org/dsdl/svrl}schematron-output[Q{http://purl.oclc.org/dsdl/svrl}fired-rule] and empty(Q{http://purl.oclc.org/dsdl/svrl}schematron-output/Q{http://purl.oclc.org/dsdl/svrl}successful-report[(@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}fired-rule[1]/@id, preceding-sibling::Q{http://purl.oclc.org/dsdl/svrl}active-pattern[1]/@id)[1] = 'unbound-qname-ns'])</xsl:attribute>
            </xsl:element>
         </xsl:element>
         <xsl:if test="not($Q{urn:x-xspec:compile:impl}boolean-test)">
            <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
               <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}test-result"/>
               <xsl:with-param name="report-name" select="'result'"/>
            </xsl:call-template>
         </xsl:if>
         <xsl:call-template name="Q{urn:x-xspec:common:report-sequence}report-sequence">
            <xsl:with-param name="sequence" select="$Q{urn:x-xspec:compile:impl}expect-d52e39"/>
            <xsl:with-param name="report-name" select="'expect'"/>
         </xsl:call-template>
      </xsl:element>
   </xsl:template>
</xsl:stylesheet>
