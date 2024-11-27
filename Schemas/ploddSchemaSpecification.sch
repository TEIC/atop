<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
        queryBinding="xslt3">
   <title>Schematron extracted from ploddSchemaSpecification.rng</title>
   <pattern id="d10e24090-constraint">
      <rule context="tei:content">
         <report test="descendant::*[not(namespace-uri(.) =               ('http://relaxng.org/ns/compatibility/annotations/1.0', 'http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'))]">content descendants must be in the
              namespaces
              'http://relaxng.org/ns/compatibility/annotations/1.0', 'http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'</report>
      </rule>
   </pattern>
   <pattern id="d10e24424-constraint">
      <rule context="tei:constraint">
         <report test="descendant::*[not(namespace-uri(.) =               ('http://purl.oclc.org/dsdl/schematron', 'http://www.schematron-quickfix.com/validator/process', 'http://www.tei-c.org/ns/1.0'))]">constraint descendants must be in the
              namespaces
              'http://purl.oclc.org/dsdl/schematron', 'http://www.schematron-quickfix.com/validator/process', 'http://www.tei-c.org/ns/1.0'</report>
      </rule>
   </pattern>
   <pattern id="d10e25510-constraint">
      <rule context="tei:datatype">
         <report test="descendant::*[not(namespace-uri(.) =               ('http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'))]">datatype descendants must be in the
              namespaces
              'http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-att.typed-subtypeTyped-constraint-rule-1">
      <rule context="tei:*[@subtype]">
         <assert test="@type">The <name/> element should not be categorized in detail with @subtype unless also categorized in general with @type</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-att.calendarSystem-calendar-calendar_attr_on_empty_element-constraint-rule-2">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
              systems or calendars to which the date represented by the content of this element belongs,
              but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-p-abstractModel-structure-p-in-ab-or-p-constraint-rule-3">
      <rule context="tei:p">
         <report test="(ancestor::tei:ab or ancestor::tei:p) and                        not( ancestor::tei:floatingText                           | parent::tei:exemplum                           | parent::tei:item                           | parent::tei:note                           | parent::tei:q                           | parent::tei:quote                           | parent::tei:remarks                           | parent::tei:said                           | parent::tei:sp                           | parent::tei:stage                           | parent::tei:cell                           | parent::tei:figure )">
          Abstract model violation: Paragraphs may not occur inside other paragraphs or ab elements.
        </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-p-abstractModel-structure-p-in-l-or-lg-constraint-rule-4">
      <rule context="tei:p">
         <report test="( ancestor::tei:l  or  ancestor::tei:lg ) and                        not( ancestor::tei:floatingText                           | parent::tei:figure                           | parent::tei:note )">
          Abstract model violation: Lines may not contain higher-level structural elements such as div, p, or ab, unless p is a child of figure or note, or is a descendant of floatingText.
        </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-desc-deprecationInfo-only-in-deprecated-constraint-rule-5">
      <rule context="tei:desc[ @type eq 'deprecationInfo']">
         <assert test="../@validUntil">Information about a
        deprecation should only be present in a specification element
        that is being deprecated: that is, only an element that has a
        @validUntil attribute should have a child &lt;desc
        type="deprecationInfo"&gt;.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-name-calendar-calendar-check-name-constraint-rule-6">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
                        systems or calendars to which the date represented by the content of this element belongs,
                        but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-ptr-ptrAtts-constraint-rule-7">
      <rule context="tei:ptr">
         <report test="@target and @cRef">Only one of the attributes @target and @cRef may be supplied on <name/>.</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-ref-refAtts-constraint-rule-8">
      <rule context="tei:ref">
         <report test="@target and @cRef">Only one of the attributes @target' and @cRef' may be supplied on <name/>
         </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-list-gloss-list-must-have-labels-constraint-rule-9">
      <rule context="tei:list[@type='gloss']">
         <assert test="tei:label">The content of a "gloss" list should include a sequence of one or more pairs of a label element followed by an item element</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-author-calendar-calendar-check-author-constraint-rule-10">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
                        systems or calendars to which the date represented by the content of this element belongs,
                        but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-editor-calendar-calendar-check-editor-constraint-rule-11">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
                        systems or calendars to which the date represented by the content of this element belongs,
                        but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-resp-calendar-calendar-check-resp-constraint-rule-12">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
                        systems or calendars to which the date represented by the content of this element belongs,
                        but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-title-calendar-calendar-check-title-constraint-rule-13">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
                        systems or calendars to which the date represented by the content of this element belongs,
                        but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-relatedItem-targetorcontent1-constraint-rule-14">
      <rule context="tei:relatedItem">
         <report test="@target and count( child::* ) &gt; 0">If the @target attribute on <name/> is used, the relatedItem element must be empty</report>
         <assert test="@target or child::*">A relatedItem element should have either a @target attribute or a child element to indicate the related bibliographic item</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-application-calendar-calendar-check-application-constraint-rule-15">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
                        systems or calendars to which the date represented by the content of this element belongs,
                        but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
   <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
   <ns prefix="rng" uri="http://relaxng.org/ns/structure/1.0"/>
   <ns prefix="rna" uri="http://relaxng.org/ns/compatibility/annotations/1.0"/>
   <ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
   <ns prefix="sch1x" uri="http://www.ascc.net/xml/schematron"/>
   <pattern id="ploddSchemaSpecification-att.repeatable-MINandMAXoccurs-constraint-rule-17">
      <rule context="tei:*[ @minOccurs and @maxOccurs ]">
         <let name="min" value="@minOccurs cast as xs:integer"/>
         <let name="max"
              value="if ( normalize-space( @maxOccurs ) eq 'unbounded') then -1 else @maxOccurs cast as xs:integer"/>
         <assert test="$max eq -1 or $max ge $min">@maxOccurs should be greater than or equal to @minOccurs</assert>
      </rule>
      <rule context="tei:*[ @minOccurs and not( @maxOccurs ) ]">
         <assert test="@minOccurs cast as xs:integer lt 2">When @maxOccurs is not specified, @minOccurs must be 0 or 1</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-moduleRef-only_rng_in_moduleRef_content-constraint-rule-19">
      <rule context="tei:moduleRef/tei:content">
         <report test="*[ not( self::rng:* or self::a:* ) ]">
                  The content of an ATOP PLODD module reference needs to
                  be RELAX NG and RELAX NG *only*.
                </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-moduleRef-modref-constraint-rule-20">
      <rule context="tei:moduleRef">
         <report test="* and @key">
          Child elements of <name/> are only allowed when an external module is being loaded
        </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-moduleRef-not-same-prefix-constraint-rule-21">
      <rule context="tei:moduleRef">
         <report test="//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix">The prefix attribute
            of <name/> should not match that of any other
            element (it would defeat the purpose)</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-moduleRef-not-except-and-include-constraint-rule-22">
      <rule context="tei:moduleRef">
         <report test="@except and @include">It is an error to supply both the @include and @except attributes</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-moduleRef-prefix-not-same-prefix-constraint-rule-23">
      <rule context="tei:moduleRef">
         <report test="//*[ not( generate-id(.) eq generate-id( current() ) ) ]/@prefix = @prefix">The prefix attribute
            of <name/> should not match that of any other
            element (it would defeat the purpose)</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-moduleRef-prefix-not-except-and-include-constraint-rule-24">
      <rule context="tei:moduleRef">
         <report test="@except and @include">It is an error to supply both the @include and @except attributes</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-schemaSpec-only_1_elementSpec_each-constraint-rule-25">
      <rule context="tei:schemaSpec">
         <let name="elementSpecs"
              value="for $e in ./tei:elementSpec                                 return concat('{', ($e/ancestor-or-self::*/@ns)[last()], '}', $e/@ident )"/>
         <let name="unique_elementSpecs" value="distinct-values( $elementSpecs )"/>
         <assert test="count( $elementSpecs ) eq count( $unique_elementSpecs )">
                  
                  Duplicate elementSpec(s); the element specifications
                  for the following each occur more than once: <value-of select="string-join(                   ( for $qname in $unique_elementSpecs return if (count($elementSpecs[. eq $qname]) gt 1) then $qname else '' )[normalize-space(.)],                   ', ' ) "/>
         </assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-schemaSpec-start-only_defined_elements_can_be_starter-constraint-rule-26">
      <rule context="tei:schemaSpec/@start">
         <let name="GIs" value="//tei:elementSpec/@ident"/>
         <assert test="every $gi in tokenize(.) satisfies $gi = $GIs">
                      Each value of @start must be the GI of a defined
                      element (i.e., equal elementSpec/@ident); one of these
                      ("<value-of select="."/>") does not. The list
                      of valid values is "<value-of select="$GIs"/>".
                    </assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-elementSpec-child-constraint-based-on-mode-constraint-rule-27">
      <rule context="tei:elementSpec[ @mode eq 'delete' ]">
         <report test="child::*">This elementSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements.</report>
      </rule>
      <rule context="tei:elementSpec[ @mode = ('add','change','replace') ]">
         <assert test="child::* | (@* except (@mode, @ident))">This elementSpec element has a mode= of "<value-of select="@mode"/>", but does not have any child elements or schema-changing attributes. Specify child elements, use validUntil=, predeclare=, ns=, or prefix=, or change the mode= to "delete".</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-dataSpec-no_elements_in_data_content-constraint-rule-29">
      <rule role="warn" context="tei:dataSpec/tei:content">
         <report test=".//tei:anyElement | .//tei:classRef | .//tei:elementRef">
          A datatype specification should not refer to an element or a class.
        </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-sequence-sequencechilden-constraint-rule-30">
      <rule context="tei:sequence">
         <assert test="count(*) gt 1">The sequence element must have at least two child elements</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-alternate-alternatechilden-constraint-rule-31">
      <rule context="tei:alternate">
         <assert test="count(*) gt 1">The alternate element must have at least two child elements</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraint-schematron_requires_context-constraint-rule-32">
      <rule context="tei:constraint[ .//sch:assert | .//sch:report ]">
         <let name="we_need_context" value=".//sch:assert|.//sch:report"/>
         <let name="we_have_context"
              value="for $e in $we_need_context return $e/ancestor::sch:*[@context][1]"/>
         <report test="count( $we_need_context ) &gt; count( $we_have_context )">
                  Uh-oh. One or more sch:assert or sch:report elements in this constraint do not have a context explicitly specified.
                </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-empty-based-on-mode-constraint-rule-34">
      <rule context="tei:constraintSpec[ @mode eq 'delete']">
         <report test="child::*">This constraintSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements.</report>
      </rule>
      <rule context="tei:constraintSpec[ @mode eq 'change']">
         <assert test="child::*">This constraintSpec element has a mode= of "change", but does not have any child elements. Specify child elements, or change the mode= to "delete".</assert>
      </rule>
      <rule context="tei:constraintSpec[ @mode = ('add','replace') ]">
         <assert test="child::tei:constraint">This constraintSpec element has a mode= of "<value-of select="@mode"/>", but does not have a child 'constraint' element. Use a child 'constraint' element or change the mode= to "delete" or "change".</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-sch_no_more-constraint-rule-37">
      <rule context="tei:constraintSpec">
         <report test="tei:constraint/sch1x:* and @scheme = ('isoschematron','schematron')">Rules
        in the Schematron 1.* language must be inside a constraintSpec
        with a value other than 'schematron' or 'isoschematron' on the
        scheme attribute</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-isosch-constraint-rule-38">
      <rule context="tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]">
         <report test="tei:constraint/sch:* and not( @scheme eq 'schematron')">Rules
          in the ISO Schematron language must be inside a constraintSpec
          with the value 'schematron' on the scheme attribute</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-context-required-constraint-rule-39">
      <rule context="tei:constraintSpec[ @scheme eq 'schematron']/tei:constraint[ .//sch:assert | .//sch:report ]">
         <let name="assertsHaveContext"
              value="for $a in .//sch:assert return exists( $a/ancestor::sch:rule/@context )"/>
         <let name="reportsHaveContext"
              value="for $r in .//sch:report return exists( $r/ancestor::sch:rule/@context )"/>
         <report test="( $assertsHaveContext, $reportsHaveContext ) = false()"
                 role="warning">The use of an &lt;sch:assert&gt; or &lt;sch:report&gt; that does not have a context (i.e., does not have an ancestor &lt;sch:rule&gt; with a @context attribute) in an ISO Schematron constraint specification is deprecated, and will become invalid after 2025-03-15.</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-unique-constraintSpec-ident-constraint-rule-40">
      <rule context="tei:constraintSpec[ @mode eq 'add' or not( @mode ) ]">
         <let name="myIdent" value="normalize-space(@ident)"/>
         <report test="preceding::tei:constraintSpec[ normalize-space(@ident) eq $myIdent ]">
        The @ident of 'constraintSpec' should be unique; this one (<value-of select="$myIdent"/>) is the same as that of a previous 'constraintSpec'.
        </report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-usage_based_on_mode-constraint-rule-41">
      <rule context="tei:constraintSpec[ @mode = ('add','replace')  or  not( @mode ) ]">
         <assert test="@scheme">The @scheme attribute of &lt;constraintSpec&gt; is required when the @mode is <value-of select="if (@mode) then concat('&#34;',@mode,'&#34;') else 'not specified'"/>.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-constraintSpec-scheme-usage_based_on_mode-constraint-rule-44">
      <rule context="tei:constraintSpec[ @mode = ('add','replace')  or  not( @mode ) ]">
         <assert test="@scheme">The @scheme attribute of &lt;constraintSpec&gt; is required when the @mode is <value-of select="if (@mode) then concat('&#34;',@mode,'&#34;') else 'not specified'"/>.</assert>
      </rule>
   </pattern>
   <ns prefix="teix" uri="http://www.tei-c.org/ns/Examples"/>
   <pattern id="ploddSchemaSpecification-attDef-attDefContents-constraint-rule-45">
      <rule context="tei:attDef">
         <assert test="ancestor::teix:egXML[ @valid eq 'feasible']                        or @mode eq 'change'                        or @mode eq 'delete'                        or tei:datatype                        or tei:valList[ @type eq 'closed']">
          Attribute: the definition of the @<value-of select="@ident"/> attribute in the
          <value-of select="ancestor::*[@ident][1]/@ident"/>
            <value-of select="' '"/>
            <value-of select="local-name(ancestor::*[@ident][1])"/> should
          have a closed valList or a datatype
        </assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-attDef-noDefault4Required-constraint-rule-46">
      <rule context="tei:attDef[@usage eq 'req']">
         <report test="tei:defaultVal">Since the @<value-of select="@ident"/> attribute is required, it will always be specified. Thus the default value (of "<value-of select="normalize-space(tei:defaultVal)"/>") will never be used. Either change the definition of the attribute so it is not required ("rec" or "opt"), or remove the defaultVal element.</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-attDef-defaultIsInClosedList-twoOrMore-constraint-rule-47">
      <rule context="tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[ @maxOccurs &gt; 1  or  @minOccurs &gt; 1  or  @maxOccurs eq 'unbounded']                                    ]">
         <assert test="tokenize(normalize-space(tei:defaultVal),' ') = tei:valList/tei:valItem/@ident">In the <value-of select="local-name(ancestor::*[@ident][1])"/> defining
        <value-of select="ancestor::*[@ident][1]/@ident"/> the default value of the
        @<value-of select="@ident"/> attribute is not among the closed list of possible
        values</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-attDef-defaultIsInClosedList-one-constraint-rule-48">
      <rule context="tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[                                             not(@maxOccurs)                                         or  ( if ( @maxOccurs castable as xs:integer ) then ( @maxOccurs cast as xs:integer eq 1 ) else false() )                                                      ]                                    ]">
         <assert test="string(tei:defaultVal) = tei:valList/tei:valItem/@ident">In the <value-of select="local-name(ancestor::*[@ident][1])"/> defining
        <value-of select="ancestor::*[@ident][1]/@ident"/> the default value of the
        @<value-of select="@ident"/> attribute is not among the closed list of possible
        values</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-dataRef-restrictDataFacet-constraint-rule-49">
      <rule context="tei:dataRef[tei:dataFacet]">
         <assert test="@name" role="nonfatal">Data facets can only be specified for references to datatypes specified by
          XML Schema Part 2: Datatypes Second Edition — that is, for there to be a 'dataFacet' child there must be a @name attribute.</assert>
         <report test="@restriction" role="nonfatal">Data facets and restrictions cannot both be expressed on the same data reference — that is, the @restriction attribute cannot be used when a 'dataFacet' element is present.</report>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-dataRef-restrictAttResctrictionName-constraint-rule-50">
      <rule context="tei:dataRef[@restriction]">
         <assert test="@name" role="nonfatal">Restrictions can only be specified for references to datatypes specified by
          XML Schema Part 2: Datatypes Second Edition — that is, for there to be a @restriction attribute there must be a @name attribute, too.</assert>
      </rule>
   </pattern>
   <pattern id="ploddSchemaSpecification-att.identified-spec-in-module-constraint-rule-52">
      <rule context="tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]">
         <assert test="(not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or (not(@module) or (not(//tei:moduleSpec) and not(//tei:moduleRef)) or (//tei:moduleSpec[@ident = current()/@module]) or (//tei:moduleRef[@key = current()/@module]))">
        Specification <value-of select="@ident"/>: the value of the module attribute ("<value-of select="@module"/>") 
should correspond to an existing module, via a moduleSpec or
      moduleRef</assert>
      </rule>
   </pattern>
   <ns prefix="a" uri="http://relaxng.org/ns/compatibility/annotations/1.0"/>
   <ns prefix="xi" uri="http://www.w3.org/2001/XInclude"/>
   <pattern id="ploddSchemaSpecification-no_XInclude-constraint-rule-51">
      <rule context="/">
         <report test="//xi:*" role="fatal">There should be no XInclude elements in a derived PLODD</report>
      </rule>
   </pattern>
</schema>
