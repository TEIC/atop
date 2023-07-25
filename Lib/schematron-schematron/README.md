# The Schematron Schematron

## About

Schematron Schematron is a Schematron schema that checks XPath expressions in your Schematron. It uses parsers for XPath
2.0 or XPath 3.1 depeding on the @‍queryBinding attribute to check the syntax of XPath expressions.

It checks the following attributes:

- ```sch:assert/@test```
- ```sch:let/@value```
- ```sch:path/@name```
- ```sch:pattern/@documents```
- ```sch:report/@test```
- ```sch:rule/@context```
- ```sch:value-of/@name```
- ```xsl:copy-of/@select```

Starting with version 1.1 it also performs a static analysis of the expression and warns about the following potential
problems:

- QNames with prefixes that are not declared by a ```sch:ns``` element
- function in the null namespaces that are not defined by the XPath function and operator specifications

The idea of Schematron Schematron was conceived during the [TEI 2022 Conference](https://conferences.ncl.ac.uk/tei2022/)
in a discussion with [Martin Holmes](https://github.com/martindholmes).

**Note** Schematron Schematron relies on a Schematron processor that supports the ```xsl:include``` element. This is
non-conformant behaviour but supported by both, the [Skeleton](https://github.com/schematron/schematron) and
[SchXslt](https://github.com/schxslt/schxslt).

**Note** Contrary to the specification it uses ```xslt2``` as default value when no @‍queryBinding is defined. You can override
the default value by passing the parameter ```queryBinding``` to the validation stylesheet.

## License

Schematron Schematron is copyright (c) by David Maus &lt;dmaus@dmaus.name&gt; and released under the terms of the MIT
license.

The [XPath 2.0](src/main/resources/xpath20.xslt) and [XPath 3.1](src/main/resources/xpath31.xslt) parsers are generated
by the [REx Parser Generator](https://bottlecaps.de/rex/) by Gunther Rademacher and contain fragments of REx source code
supplied under the Apache 2.0 license.

The function and operator libraries where extract from the respective documents, the XPath 2.0
[specification](https://www.w3.org/TR/2010/REC-xpath-functions-20101214/xpath-functions-20101214.xml) and the XPath 3.1
[function catalog](https://www.w3.org/TR/2017/REC-xpath-functions-31-20170321/function-catalog.xml).

## Authors

David Maus &lt;dmaus@dmaus.name&gt;

## Bibliography

Kosek, Jirka. 2017. “Improving Validation of Structured Text.” In XML London 2017 Conference Proceedings, 56–67. London,
United Kingdom: XML London. https://doi.org/10.14337/XMLLondon17.Kosek01.
