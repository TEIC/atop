<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
        queryBinding="xslt3">
   <title>Schematron extracted from post-assembleSchemaSpecification.rng</title>
   <pattern id="d9e127844-constraint">
      <rule context="tei:content">
         <report test="descendant::*[not(namespace-uri(.) =               ('http://relaxng.org/ns/compatibility/annotations/1.0', 'http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'))]">content descendants must be in the
              namespaces
              'http://relaxng.org/ns/compatibility/annotations/1.0', 'http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'</report>
      </rule>
   </pattern>
   <pattern id="d9e129260-constraint">
      <rule context="tei:datatype">
         <report test="descendant::*[not(namespace-uri(.) =               ('http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'))]">datatype descendants must be in the
              namespaces
              'http://relaxng.org/ns/structure/1.0', 'http://www.tei-c.org/ns/1.0'</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.cmc-generatedBy-CMC_generatedBy_within_post-constraint-rule-1">
      <rule context="tei:*[@generatedBy]">
         <assert test="ancestor-or-self::tei:post">The @generatedBy attribute is for use within a &lt;post&gt; element.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.datable.w3c-att-datable-w3c-when-constraint-rule-2">
      <rule context="tei:*[@when]">
         <report test="@notBefore|@notAfter|@from|@to" role="nonfatal">The @when attribute cannot be used with any other att.datable.w3c attributes.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.datable.w3c-att-datable-w3c-from-constraint-rule-3">
      <rule context="tei:*[@from]">
         <report test="@notBefore" role="nonfatal">The @from and @notBefore attributes cannot be used together.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.datable.w3c-att-datable-w3c-to-constraint-rule-4">
      <rule context="tei:*[@to]">
         <report test="@notAfter" role="nonfatal">The @to and @notAfter attributes cannot be used together.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.global.source-source-only_1_ODD_source-constraint-rule-5">
      <rule context="tei:*[@source]">
         <let name="srcs" value="tokenize( normalize-space(@source),' ')"/>
         <report test="( self::tei:classRef               | self::tei:dataRef               | self::tei:elementRef               | self::tei:macroRef               | self::tei:moduleRef               | self::tei:schemaSpec )               and               $srcs[2]">
              When used on a schema description element (like
              <value-of select="name(.)"/>), the @source attribute
              should have only 1 value. (This one has <value-of select="count($srcs)"/>.)
            </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.measurement-att-measurement-unitRef-constraint-rule-6">
      <rule context="tei:*[@unitRef]">
         <report test="@unit" role="info">The @unit attribute may be unnecessary when @unitRef is present.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.typed-subtypeTyped-constraint-rule-7">
      <rule context="tei:*[@subtype]">
         <assert test="@type">The <name/> element should not be categorized in detail with @subtype unless also categorized in general with @type</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.pointing-targetLang-targetLang-constraint-rule-8">
      <rule context="tei:*[not(self::tei:schemaSpec)][@targetLang]">
         <assert test="@target">@targetLang should only be used on <name/> if @target is specified.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.spanning-spanTo-spanTo-points-to-following-constraint-rule-9">
      <rule context="tei:*[@spanTo]">
         <assert test="id(substring(@spanTo,2)) and following::*[@xml:id=substring(current()/@spanTo,2)]">
The element indicated by @spanTo (<value-of select="@spanTo"/>) must follow the current element <name/>
         </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.styleDef-schemeVersion-schemeVersionRequiresScheme-constraint-rule-10">
      <rule context="tei:*[@schemeVersion]">
         <assert test="@scheme and not(@scheme = 'free')">
              @schemeVersion can only be used if @scheme is specified.
            </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.calendarSystem-calendar-calendar_attr_on_empty_element-constraint-rule-11">
      <rule context="tei:*[@calendar]">
         <assert test="string-length( normalize-space(.) ) gt 0"> @calendar indicates one or more
              systems or calendars to which the date represented by the content of this element belongs,
              but this <name/> element has no textual content.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-p-abstractModel-structure-p-in-ab-or-p-constraint-rule-12">
      <rule context="tei:p">
         <report test="(ancestor::tei:ab or ancestor::tei:p) and                        not( ancestor::tei:floatingText                           | parent::tei:exemplum                           | parent::tei:item                           | parent::tei:note                           | parent::tei:q                           | parent::tei:quote                           | parent::tei:remarks                           | parent::tei:said                           | parent::tei:sp                           | parent::tei:stage                           | parent::tei:cell                           | parent::tei:figure )">
          Abstract model violation: Paragraphs may not occur inside other paragraphs or ab elements.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-p-abstractModel-structure-p-in-l-or-lg-constraint-rule-13">
      <rule context="tei:p">
         <report test="( ancestor::tei:l  or  ancestor::tei:lg ) and                        not( ancestor::tei:floatingText                           | parent::tei:figure                           | parent::tei:note )">
          Abstract model violation: Lines may not contain higher-level structural elements such as div, p, or ab, unless p is a child of figure or note, or is a descendant of floatingText.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-desc-deprecationInfo-only-in-deprecated-constraint-rule-14">
      <rule context="tei:desc[ @type eq 'deprecationInfo']">
         <assert test="../@validUntil">Information about a
        deprecation should only be present in a specification element
        that is being deprecated: that is, only an element that has a
        @validUntil attribute should have a child &lt;desc
        type="deprecationInfo"&gt;.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-rt-target-rt-target-not-span-constraint-rule-15">
      <rule context="tei:rt/@target">
         <report test="../@from | ../@to">When target= is present, neither from= nor to= should be.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-rt-from-rt-from-constraint-rule-16">
      <rule context="tei:rt/@from">
         <assert test="../@to">When from= is present, the to= attribute of <name/> is required.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-rt-to-rt-to-constraint-rule-17">
      <rule context="tei:rt/@to">
         <assert test="../@from">When to= is present, the from= attribute of <name/> is required.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-ptr-ptrAtts-constraint-rule-18">
      <rule context="tei:ptr">
         <report test="@target and @cRef">Only one of the attributes @target and @cRef may be supplied on <name/>.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-ref-refAtts-constraint-rule-19">
      <rule context="tei:ref">
         <report test="@target and @cRef">Only one of the attributes @target' and @cRef' may be supplied on <name/>
         </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-list-gloss-list-must-have-labels-constraint-rule-20">
      <rule context="tei:list[@type='gloss']">
         <assert test="tei:label">The content of a "gloss" list should include a sequence of one or more pairs of a label element followed by an item element</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-relatedItem-targetorcontent1-constraint-rule-21">
      <rule context="tei:relatedItem">
         <report test="@target and count( child::* ) &gt; 0">If the @target attribute on <name/> is used, the relatedItem element must be empty</report>
         <assert test="@target or child::*">A relatedItem element should have either a @target attribute or a child element to indicate the related bibliographic item</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-l-abstractModel-structure-l-in-l-constraint-rule-22">
      <rule context="tei:l">
         <report test="ancestor::tei:l[not(.//tei:note//tei:l[. = current()])]">Abstract model violation: Lines may not contain lines or lg elements.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-lg-atleast1oflggapl-constraint-rule-23">
      <rule context="tei:lg">
         <assert test="count(descendant::tei:lg|descendant::tei:l|descendant::tei:gap) &gt; 0">An lg element must contain at least one child l, lg, or gap element.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-lg-abstractModel-structure-lg-in-l-constraint-rule-24">
      <rule context="tei:lg">
         <report test="ancestor::tei:l[not(.//tei:note//tei:lg[. = current()])]">Abstract model violation: Lines may not contain line groups.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-quotation-quotationContents-constraint-rule-25">
      <rule context="tei:quotation">
         <report test="not( @marks )  and  not( tei:p )">
          On <name/>, either the @marks attribute should be used, or a paragraph of description provided
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-citeStructure-match-citestructure-outer-match-constraint-rule-26">
      <rule context="tei:citeStructure[not(parent::tei:citeStructure)]">
         <assert test="starts-with(@match,'/')">An XPath in @match on the outer <name/> must start with '/'.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-citeStructure-match-citestructure-inner-match-constraint-rule-27">
      <rule context="tei:citeStructure[parent::tei:citeStructure]">
         <assert test="not(starts-with(@match,'/'))">An XPath in @match must not start with '/' except on the outer <name/>.</assert>
      </rule>
   </pattern>
   <ns prefix="tei" uri="http://www.tei-c.org/ns/1.0"/>
   <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
   <ns prefix="rng" uri="http://relaxng.org/ns/structure/1.0"/>
   <ns prefix="rna" uri="http://relaxng.org/ns/compatibility/annotations/1.0"/>
   <ns prefix="sch" uri="http://purl.oclc.org/dsdl/schematron"/>
   <ns prefix="sch1x" uri="http://www.ascc.net/xml/schematron"/>
   <pattern id="post-assembleSchemaSpecification-div-abstractModel-structure-div-in-l-or-lg-constraint-rule-28">
      <rule context="tei:div">
         <report test="(ancestor::tei:l or ancestor::tei:lg) and not(ancestor::tei:floatingText)">
          Abstract model violation: Lines may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-div-abstractModel-structure-div-in-ab-or-p-constraint-rule-29">
      <rule context="tei:div">
         <report test="(ancestor::tei:p or ancestor::tei:ab) and not(ancestor::tei:floatingText)">
          Abstract model violation: p and ab may not contain higher-level structural elements such as div, unless div is a descendant of floatingText.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-shift-shiftNew-constraint-rule-30">
      <rule context="tei:shift">
         <assert test="@new" role="warning">              
          The @new attribute should always be supplied; use the special value
          "normal" to indicate that the feature concerned ceases to be
          remarkable at this point.
        </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-msDesc-one_ms_singleton_max-constraint-rule-31">
      <rule context="tei:msContents|tei:physDesc|tei:history|tei:additional">
         <let name="gi" value="name(.)"/>
         <report test="preceding-sibling::*[ name(.) eq $gi ]                           and                           not( following-sibling::*[ name(.) eq $gi ] )">
          Only one <name/> is allowed as a child of <value-of select="name(..)"/>.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-catchwords-catchword_in_msDesc-constraint-rule-32">
      <rule context="tei:catchwords">
         <assert test="ancestor::tei:msDesc or ancestor::tei:egXML">The <name/> element should not be used outside of msDesc.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-dimensions-duplicateDim-constraint-rule-33">
      <rule context="tei:dimensions">
         <report test="count(tei:width) gt 1">
          The element <name/> may appear once only
        </report>
         <report test="count(tei:height) gt 1">
          The element <name/> may appear once only
        </report>
         <report test="count(tei:depth) gt 1">
          The element <name/> may appear once only
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-secFol-secFol_in_msDesc-constraint-rule-34">
      <rule context="tei:secFol">
         <assert test="ancestor::tei:msDesc or ancestor::tei:egXML">The <name/> element should not be used outside of msDesc.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-signatures-signatures_in_msDesc-constraint-rule-35">
      <rule context="tei:signatures">
         <assert test="ancestor::tei:msDesc or ancestor::tei:egXML">The <name/> element should not be used outside of msDesc.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-msIdentifier-msId_minimal-constraint-rule-36">
      <rule context="tei:msIdentifier">
         <report test="not( parent::tei:msPart )                           and                           ( child::*[1]/self::idno  or  child::*[1]/self::altIdentifier  or  normalize-space(.) eq '')">An msIdentifier must contain either a repository or location.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-facsimile-no_facsimile_text_nodes-constraint-rule-37">
      <rule context="tei:facsimile//tei:line | tei:facsimile//tei:zone">
         <report test="child::text()[ normalize-space(.) ne '']">
          A facsimile element represents a text with images, thus
          transcribed text should not be present within it.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-path-pathmustnotbeclosed-constraint-rule-38">
      <rule context="tei:path[@points]">
         <let name="firstPair" value="tokenize( normalize-space( @points ), ' ')[1]"/>
         <let name="lastPair"
              value="tokenize( normalize-space( @points ), ' ')[last()]"/>
         <let name="firstX" value="xs:float( substring-before( $firstPair, ',') )"/>
         <let name="firstY" value="xs:float( substring-after( $firstPair, ',') )"/>
         <let name="lastX" value="xs:float( substring-before( $lastPair, ',') )"/>
         <let name="lastY" value="xs:float( substring-after( $lastPair, ',') )"/>
         <report test="$firstX eq $lastX and $firstY eq $lastY">The first and
          last elements of this path are the same. To specify a closed polygon, use
          the zone element rather than the path element. </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-addSpan-addSpan-requires-spanTo-constraint-rule-39">
      <rule context="tei:addSpan">
         <assert test="@spanTo">The @spanTo attribute of <name/> is required.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-addSpan-addSpan-requires-spanTo-fr-constraint-rule-40">
      <rule context="tei:addSpan">
         <assert test="@spanTo">L'attribut spanTo est requis.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-damageSpan-damageSpan-requires-spanTo-constraint-rule-41">
      <rule context="tei:damageSpan">
         <assert test="@spanTo">The @spanTo attribute of <name/> is required.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-damageSpan-damageSpan-requires-spanTo-fr-constraint-rule-42">
      <rule context="tei:damageSpan">
         <assert test="@spanTo">L'attribut spanTo est requis.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-delSpan-delSpan-requires-spanTo-constraint-rule-43">
      <rule context="tei:delSpan">
         <assert test="@spanTo">The @spanTo attribute of <name/> is required.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-delSpan-delSpan-requires-spanTo-fr-constraint-rule-44">
      <rule context="tei:delSpan">
         <assert test="@spanTo">L'attribut spanTo est requis.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-subst-substContents1-constraint-rule-45">
      <rule context="tei:subst">
         <assert test="child::tei:add and (child::tei:del or child::tei:surplus)">
            <name/> must have at least one child add and at least one child del or surplus</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-rdgGrp-only1lem-constraint-rule-46">
      <rule context="tei:rdgGrp">
         <assert test="count(tei:lem) lt 2">Only one &lt;lem&gt; element may appear within a &lt;rdgGrp&gt;</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-variantEncoding-location-variantEncodingLocation-constraint-rule-47">
      <rule context="tei:variantEncoding">
         <report test="@location eq 'external' and @method eq 'parallel-segmentation'">
              The @location value "external" is inconsistent with the
              parallel-segmentation method of apparatus markup.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-relation-ref-or-key-or-name-constraint-rule-48">
      <rule context="tei:relation">
         <assert test="@ref or @key or @name">One of the attributes @name, @ref or @key must be supplied</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-relation-active-mutual-constraint-rule-49">
      <rule context="tei:relation">
         <report test="@active and @mutual">Only one of the attributes @active and @mutual may be supplied</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-relation-active-passive-constraint-rule-50">
      <rule context="tei:relation">
         <report test="@passive and not(@active)">the attribute @passive may be supplied only if the attribute @active is supplied</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-link-linkTargets3-constraint-rule-51">
      <rule context="tei:link">
         <assert test="contains(normalize-space(@target),' ')">You must supply at least two values for @target or  on <name/>
         </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-ab-abstractModel-structure-ab-in-l-or-lg-constraint-rule-52">
      <rule context="tei:ab">
         <report test="(ancestor::tei:l or ancestor::tei:lg) and not( ancestor::tei:floatingText |parent::tei:figure |parent::tei:note )">
          Abstract model violation: Lines may not contain higher-level divisions such as p or ab, unless ab is a child of figure or note, or is a descendant of floatingText.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-join-joinTargets3-constraint-rule-53">
      <rule context="tei:join">
         <assert test="contains( normalize-space( @target ),' ')">
          You must supply at least two values for @target on <name/>
         </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-standOff-nested_standOff_should_be_typed-constraint-rule-54">
      <rule context="tei:standOff">
         <assert test="@type or not(ancestor::tei:standOff)">This
        <name/> element must have a @type attribute, since it is
        nested inside a <name/>
         </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-s-noNestedS-constraint-rule-55">
      <rule context="tei:s">
         <report test="tei:s">You may not nest one s element within another: use seg instead</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-span-target-from-constraint-rule-56">
      <rule context="tei:span">
         <report test="@from and @target">
          Only one of the attributes @target and @from may be supplied on <name/>
         </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-span-targetto-constraint-rule-57">
      <rule context="tei:span">
         <report test="@to and @target">
          Only one of the attributes @target and @to may be supplied on <name/>
         </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-span-tonotfrom-constraint-rule-58">
      <rule context="tei:span">
         <report test="@to and not(@from)">
          If @to is supplied on <name/>, @from must be supplied as well
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-span-tofrom-constraint-rule-59">
      <rule context="tei:span">
         <report test="contains(normalize-space(@to),' ') or contains(normalize-space(@from),' ')">
          The attributes @to and @from on <name/> may each contain only a single value
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.repeatable-MINandMAXoccurs-constraint-rule-60">
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
   <pattern id="post-assembleSchemaSpecification-att.identified-spec-in-module-constraint-rule-62">
      <rule context="tei:elementSpec[@module]|tei:classSpec[@module]|tei:macroSpec[@module]">
         <assert test="(not(ancestor::tei:schemaSpec | ancestor::tei:TEI | ancestor::tei:teiCorpus)) or (not(@module) or (not(//tei:moduleSpec) and not(//tei:moduleRef)) or (//tei:moduleSpec[@ident = current()/@module]) or (//tei:moduleRef[@key = current()/@module]))">
        Specification <value-of select="@ident"/>: the value of the module attribute ("<value-of select="@module"/>") 
should correspond to an existing module, via a moduleSpec or
      moduleRef</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.deprecated-validUntil-deprecation-two-month-warning-constraint-rule-63">
      <rule context="tei:*[@validUntil]">
         <let name="advance_warning_period"
              value="current-date() + xs:dayTimeDuration('P60D')"/>
         <let name="me_phrase"
              value="if (@ident) then concat('The ', @ident ) else concat('This ', local-name(.), ' of ', ancestor::tei:*[@ident][1]/@ident )"/>
         <assert test="@validUntil cast as xs:date ge current-date()">
            <value-of select="concat( $me_phrase, ' construct is outdated (as of ', @validUntil, '); ODD processors may ignore it, and its use is no longer supported' )"/>
         </assert>
         <assert role="warning"
                 test="@validUntil cast as xs:date ge $advance_warning_period">
            <value-of select="concat( $me_phrase, ' construct becomes outdated on ', @validUntil )"/>
         </assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-att.deprecated-validUntil-deprecation-should-be-explained-constraint-rule-64">
      <rule context="tei:*[@validUntil][ not( self::tei:valDesc | self::tei:valList | self::tei:defaultVal | self::tei:remarks )]">
         <assert test="child::tei:desc[ @type eq 'deprecationInfo']">
              A deprecated construct should include, whenever possible, an explanation, but this <value-of select="name(.)"/> does not have a child &lt;desc type="deprecationInfo"&gt;</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-elementSpec-child-constraint-based-on-mode-constraint-rule-67">
      <rule context="tei:elementSpec[ @mode eq 'delete' ]">
         <report test="child::*">This elementSpec element has a mode= of "delete" even though it has child elements. Change the mode= to "add", "change", or "replace", or remove the child elements.</report>
      </rule>
      <rule context="tei:elementSpec[ @mode = ('add','change','replace') ]">
         <assert test="child::* | (@* except (@mode, @ident))">This elementSpec element has a mode= of "<value-of select="@mode"/>", but does not have any child elements or schema-changing attributes. Specify child elements, use validUntil=, predeclare=, ns=, or prefix=, or change the mode= to "delete".</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-dataSpec-no_elements_in_data_content-constraint-rule-69">
      <rule role="warn" context="tei:dataSpec/tei:content">
         <report test=".//tei:anyElement | .//tei:classRef | .//tei:elementRef">
          A datatype specification should not refer to an element or a class.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-listRef-TagDocsNestinglistRef-constraint-rule-70">
      <rule context="( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef">
         <report test="tei:listRef">In the context of tagset documentation, the listRef element must not self-nest.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-listRef-TagDocslistRefChildren-constraint-rule-71">
      <rule context="( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ptr | ( tei:classSpec | tei:dataSpec | tei:elementSpec | tei:macroSpec | tei:moduleSpec | tei:schemaSpec | tei:specGrp )/tei:listRef/tei:ref">
         <assert test="@target and not( matches( @target,'\s') )">In the context of tagset documentation, each ptr or ref element inside a listRef must have a target attribute with only 1 pointer as its value.</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-model-no_dup_default_models-constraint-rule-72">
      <rule context="tei:model[ not( parent::tei:modelSequence ) ][ not( @predicate ) ]">
         <let name="output" value="normalize-space( @output )"/>
         <report test="following-sibling::tei:model [ not( @predicate )] [ normalize-space( @output ) eq $output ]">
          There are 2 (or more) 'model' elements in this '<value-of select="local-name(..)"/>'
          that have no predicate, but are targeted to the same output
          ("<value-of select="( $output, parent::modelGrp/@output, 'all')[1]"/>")</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-model-no_dup_models-constraint-rule-73">
      <rule context="tei:model[ not( parent::tei:modelSequence ) ][ @predicate ]">
         <let name="predicate" value="normalize-space( @predicate )"/>
         <let name="output" value="normalize-space( @output )"/>
         <report test="following-sibling::tei:model [ normalize-space( @predicate ) eq $predicate ] [ normalize-space( @output ) eq $output ]">
          There are 2 (or more) 'model' elements in this
          '<value-of select="local-name(..)"/>' that have
          the same predicate, and are targeted to the same output
          ("<value-of select="( $output, parent::modelGrp/@output, 'all')[1]"/>")</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-modelSequence-no_outputs_nor_predicates_4_my_kids-constraint-rule-74">
      <rule context="tei:modelSequence">
         <report test="tei:model[@output]" role="warning">The 'model' children
        of a 'modelSequence' element inherit the @output attribute of the
        parent 'modelSequence', and thus should not have their own</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-sequence-sequencechilden-constraint-rule-75">
      <rule context="tei:sequence">
         <assert test="count(*) gt 1">The sequence element must have at least two child elements</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-alternate-alternatechilden-constraint-rule-76">
      <rule context="tei:alternate">
         <assert test="count(*) gt 1">The alternate element must have at least two child elements</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-constraintSpec-empty-based-on-mode-constraint-rule-78">
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
   <pattern id="post-assembleSchemaSpecification-constraintSpec-sch_no_more-constraint-rule-81">
      <rule context="tei:constraintSpec">
         <report test="tei:constraint/sch1x:* and @scheme = ('isoschematron','schematron')">Rules
        in the Schematron 1.* language must be inside a constraintSpec
        with a value other than 'schematron' or 'isoschematron' on the
        scheme attribute</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-constraintSpec-isosch-constraint-rule-82">
      <rule context="tei:constraintSpec[ @mode = ('add','replace') or not( @mode ) ]">
         <report test="tei:constraint/sch:* and not( @scheme eq 'schematron')">Rules
          in the ISO Schematron language must be inside a constraintSpec
          with the value 'schematron' on the scheme attribute</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-constraintSpec-context-required-constraint-rule-83">
      <rule context="tei:constraintSpec[ @scheme eq 'schematron']/tei:constraint[ .//sch:assert | .//sch:report ]">
         <let name="assertsHaveContext"
              value="for $a in .//sch:assert return exists( $a/ancestor::sch:rule/@context )"/>
         <let name="reportsHaveContext"
              value="for $r in .//sch:report return exists( $r/ancestor::sch:rule/@context )"/>
         <report test="( $assertsHaveContext, $reportsHaveContext ) = false()"
                 role="warning">The use of an &lt;sch:assert&gt; or &lt;sch:report&gt; that does not have a context (i.e., does not have an ancestor &lt;sch:rule&gt; with a @context attribute) in an ISO Schematron constraint specification is deprecated, and will become invalid after 2025-03-15.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-constraintSpec-unique-constraintSpec-ident-constraint-rule-84">
      <rule context="tei:constraintSpec[ @mode eq 'add' or not( @mode ) ]">
         <let name="myIdent" value="normalize-space(@ident)"/>
         <report test="preceding::tei:constraintSpec[ normalize-space(@ident) eq $myIdent ]">
        The @ident of 'constraintSpec' should be unique; this one (<value-of select="$myIdent"/>) is the same as that of a previous 'constraintSpec'.
        </report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-constraintSpec-scheme-usage_based_on_mode-constraint-rule-87">
      <rule context="tei:constraintSpec[ @mode = ('add','replace')  or  not( @mode ) ]">
         <assert test="@scheme">The @scheme attribute of &lt;constraintSpec&gt; is required when the @mode is <value-of select="if (@mode) then concat('&#34;',@mode,'&#34;') else 'not specified'"/>.</assert>
      </rule>
   </pattern>
   <ns prefix="teix" uri="http://www.tei-c.org/ns/Examples"/>
   <pattern id="post-assembleSchemaSpecification-attDef-attDefContents-constraint-rule-88">
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
   <pattern id="post-assembleSchemaSpecification-attDef-noDefault4Required-constraint-rule-89">
      <rule context="tei:attDef[@usage eq 'req']">
         <report test="tei:defaultVal">Since the @<value-of select="@ident"/> attribute is required, it will always be specified. Thus the default value (of "<value-of select="normalize-space(tei:defaultVal)"/>") will never be used. Either change the definition of the attribute so it is not required ("rec" or "opt"), or remove the defaultVal element.</report>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-attDef-defaultIsInClosedList-twoOrMore-constraint-rule-90">
      <rule context="tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[ @maxOccurs &gt; 1  or  @minOccurs &gt; 1  or  @maxOccurs eq 'unbounded']                                    ]">
         <assert test="tokenize(normalize-space(tei:defaultVal),' ') = tei:valList/tei:valItem/@ident">In the <value-of select="local-name(ancestor::*[@ident][1])"/> defining
        <value-of select="ancestor::*[@ident][1]/@ident"/> the default value of the
        @<value-of select="@ident"/> attribute is not among the closed list of possible
        values</assert>
      </rule>
   </pattern>
   <pattern id="post-assembleSchemaSpecification-attDef-defaultIsInClosedList-one-constraint-rule-91">
      <rule context="tei:attDef[     tei:defaultVal                                      and tei:valList[ @type eq 'closed']                                      and tei:datatype[                                             not(@maxOccurs)                                         or  ( if ( @maxOccurs castable as xs:integer ) then ( @maxOccurs cast as xs:integer eq 1 ) else false() )                                                      ]                                    ]">
         <assert test="string(tei:defaultVal) = tei:valList/tei:valItem/@ident">In the <value-of select="local-name(ancestor::*[@ident][1])"/> defining
        <value-of select="ancestor::*[@ident][1]/@ident"/> the default value of the
        @<value-of select="@ident"/> attribute is not among the closed list of possible
        values</assert>
      </rule>
   </pattern>
   <ns prefix="a" uri="http://relaxng.org/ns/compatibility/annotations/1.0"/>
   <ns prefix="xi" uri="http://www.w3.org/2001/XInclude"/>
   <pattern id="post-assembleSchemaSpecification-no_XInclude-constraint-rule-94">
      <rule context="/">
         <report role="fatal" test="//xi:*">There should be no XInclude elements in a
                assembled ODD</report>
      </rule>
   </pattern>
</schema>
