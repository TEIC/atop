<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:rng="http://relaxng.org/ns/structure/1.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:variable name="mitfordEditable" as="document-node()" select="doc('mitfordEditable.odd')"/>
    <xsl:template match="/">
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_odds.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"</xsl:processing-instruction>
        <xsl:processing-instruction name="xml-model">href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_odds.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"
        </xsl:processing-instruction>
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"
            xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:rng="http://relaxng.org/ns/structure/1.0" xml:lang="en">
            <!--2018-08-08 ebb: Run this XSLT over the current Digital Mitford Site Index file stored at http://digitalmitford.org/si.xml (you can open its URL in oXygen). 
            This will update the values of @ref and @corresp attributes approved for use in the project.-->
            <teiHeader>
                <fileDesc>
                    <xsl:copy-of select="$mitfordEditable//titleStmt"/>
                    <editionStmt xml:id="edition"><edition>Generated on <xsl:value-of select="current-dateTime()"/> from updates to the <xsl:apply-templates select="descendant::teiHeader//editionStmt/edition"/></edition>
                    </editionStmt>
                    <xsl:copy-of select="$mitfordEditable//publicationStmt"/>
                    <xsl:copy-of select="$mitfordEditable//seriesStmt"/>
                    <xsl:copy-of select="$mitfordEditable//sourceDesc"/>
                </fileDesc>
                <xsl:copy-of select="$mitfordEditable//revisionDesc"/>
            </teiHeader>
            <text>
                <body>
                    <schemaSpec ident="mrmProsop" start="TEI teiCorpus" prefix="tei">
                        <specGrp xml:id="prosop">
                            <elementSpec ident="persName" module="namesdates" mode="change">
                            <attList>
                                <attDef ident="ref" mode="replace" usage="rec">
                                    <datatype><dataRef name="string"/></datatype>
                                 <valList type="semi">   
                                     <xsl:apply-templates select="descendant::text//listPerson//@xml:id"/>
                                 </valList>
                                </attDef>
                            </attList>    
                            </elementSpec>
                            <elementSpec ident="orgName" module="namesdates" mode="change">
                                <attList>
                                    <attDef ident="ref" mode="replace" usage="rec">
                                        <datatype><dataRef name="string"/></datatype>
                                        <valList type="semi">   
                                            <xsl:apply-templates select="descendant::text//listOrg//@xml:id"/>
                                        </valList>
                                    </attDef>
                                </attList>    
                            </elementSpec>
                            <elementSpec ident="placeName" module="namesdates" mode="change">
                                <attList>
                                    <attDef ident="ref" mode="replace" usage="rec">
                                        <datatype><dataRef name="string"/></datatype>
                                        <valList type="semi">   
                                            <xsl:apply-templates select="descendant::text//listPlace//@xml:id"/>
                                        </valList>
                                    </attDef>
                                </attList>    
                            </elementSpec>
                            <elementSpec ident="title" module="core" mode="change">
                                <attList>
                                    <attDef ident="ref" mode="replace" usage="rec">
                                        <datatype><dataRef name="string"/></datatype>
                                        <valList type="semi">   
                                            <xsl:apply-templates select="descendant::text//listBibl//@xml:id"/>
                                            <xsl:apply-templates select="descendant::text//list[@sortKey='art']//@xml:id"/>
                                        </valList>
                                    </attDef>
                                </attList>    
                            </elementSpec>
                            <elementSpec ident="bibl" module="core" mode="change">
                                <attList>
                                    <attDef ident="corresp" mode="replace" usage="rec">
                                        <datatype><dataRef name="string"/></datatype>
                                        <valList type="semi">   
                                            <xsl:apply-templates select="descendant::text//listBibl//@xml:id"/>
                                        </valList>
                                    </attDef>
                                </attList>    
                            </elementSpec>
                            <elementSpec ident="name" module="core" mode="change">
                                <attList>
                                    <attDef ident="type" mode="replace" usage="rec">
                                        <valList type="closed">
                                            <valItem ident="plant"><gloss>Use to mark names of plants by kind, variety, genus, and/or species. If the mention is imprecise and you want to mark a short string of text as referring to a plant, use the rs element with type="plant".</gloss></valItem>
                                            <valItem ident="animal"><gloss>Use to mark references to animal types by kind, variety, genus, and/or species. If the mention is imprecise and you want to mark a short string of text as referring to a kind of animal, use the rs element with type="animal". </gloss></valItem>
                                            <valItem ident="event"><gloss>Use to mark names of events, like the Battle of Hastings. If the mention is imprecise and you want to mark a short string of text as referring to a specific event, use the rs element with type="event". </gloss></valItem>
                                        </valList>
                                    </attDef>
                                    <attDef ident="ref" mode="replace" usage="rec">
                                        <datatype><dataRef name="string"/></datatype>
                                        <valList type="semi">   
                                            <xsl:apply-templates select="descendant::text//listEvent//@xml:id"/>
                                            <xsl:apply-templates select="descendant::text//list//@xml:id"/>
                                        </valList>
                                    </attDef>
                                </attList>    
                            </elementSpec>
                        </specGrp>
                    </schemaSpec>
                </body>
            </text>
        </TEI>
    </xsl:template>
    <xsl:template match="@xml:id">
        <valItem ident="#{.}"><gloss><xsl:value-of select="parent::*/*[1]/normalize-space()"/>
            <xsl:if test="parent::*/birth"><xsl:text> | b. </xsl:text><xsl:value-of select="string-join(parent::*//birth/@*, '—')"/></xsl:if>
            <xsl:if test="parent::*/death"><xsl:text> | d. </xsl:text><xsl:value-of select="string-join(parent::*//death/@*, '—')"/></xsl:if>
            <xsl:if test="parent::*/date"><xsl:text> | </xsl:text><xsl:value-of select="string-join(parent::*/date/@*, '—')"/></xsl:if>
            <xsl:if test="parent::*/note"><xsl:text> | </xsl:text>
                <xsl:value-of select="parent::*/note[1]/normalize-space() ! substring(., 1, 80)"/></xsl:if></gloss></valItem>
    </xsl:template>
    
    
</xsl:stylesheet>