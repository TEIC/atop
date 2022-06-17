# Schemas

Current versions of the ELTeC schema in RELAX NG  are maintained in this repository, either for download to your
local system, or directly via HTTP.

## PLEASE NOTE THAT TWO ELTEC-2 SCHEMAS ARE AVAILABLE

### ELTEC-2 does *not* validate w/@pos or require `<s>` tags
### ELTEC-2_STRICT does 

To check whether a text is valid against an ELTeC schema in oXygen, insert PIs like the following at the
start of the document:

```
    <?xml-model href="https://github.com/COST-ELTEC/Schemas/raw/master/eltec-1.rng" type="application/xml" 
            schematypens="http://relaxng.org/ns/structure/1.0"?>
    <?xml-model href="https://github.com/COST-ELTEC/Schemas/raw/master/eltec-1.rng" type="application/xml" 
            schematypens="http://purl.oclc.org/dsdl/schematron"?>
```
or, if you have downloaded this repository to a location on your system:

```
    <?xml-model href="/path/to/eltec-1.rng" type="application/xml" 
            schematypens="http://relaxng.org/ns/structure/1.0"?>
    <?xml-model href="/path/to/eltec-1.rng" type="application/xml" 
            schematypens="http://purl.oclc.org/dsdl/schematron"?>

```
The RELAXNG schema contains embedded schematron rules, which oXygen (and other validators) will apply during validation

# Documentation

For complete documentation of each schema, please read: 

- https://distantreading.github.io/Schema/eltec-0.html (level 0)
- https://distantreading.github.io/Schema/eltec-1.html (level 1)
- https://distantreading.github.io/Schema/eltec-2.html (level 2)

A copy of this documentation is also available in this repository in the folder `Doc`

# ODD sources

The schemas and their documentation are produced by processing a TEI-conformant ODD specification, which
is also available from this repository, in the folder `ODD`. 

The shell script `rebuild` in the ODD directory rebuilds all the schemas and documentation. It requires a local installation of the TEI Stylesheets, and references a local copy of the TEI ODD sources distributed as `p5subset.xml`

The ELTeC schemas are built incrementally. First we compile `eltec.xml` into `eltec-library.xml`: this library contains declarations for every element used by any of the more specific ELTeC schemas (eltec-0, eltec-1, eltec-2, eltec-x, eltec-repo). The ODD for each of these more specific schemas uses the eltec-library.xml declarations as its base for further selection or modification. The reference to p5subset.xml is still required however. See further 
[https://teic.github.io/TCW/howtoChain.html](https://teic.github.io/TCW/howtoChain.html)

In addition to the three schemas listed above, this repo includes
 -  `eltec-x`  an experimental schema for ELTeC collections with a broader time coverage
 - `eltec-repo` an experimental schema for validating an entire ELTeC collection as a single TEI corpus.

Lou Burnard, April 2021

