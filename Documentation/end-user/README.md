# atop partial pre-release

The ATOP project is building its ODD processor in stages, starting from the final stage, which takes as input what we call a PLODD file (a pruned, localized ODD file), and *transpiles* it to create RELAXNG (XML form) and Schematron. (The Schematron is also bundled inside the RELAXNG file.)

You can use or test this final stage if you have a file which conforms to the PLODD specification; basically this means that 

 - It validates against the Schemas/ploddSchemaSpecification.rng file.
 - It has documentation in only one language, or in one language plus English versions where there is no content in the target language.
 - It does not refer to any external components (ODDs, TEI datatypes, external RELAXNG files).
 
If you have an ODD file that conforms to this specification, it needs no preprocessing and can be directly transpiled. You can do that at the command line by navigating to the root folder of the release package and running the following command:

`ant transpilePlodd -DinputPlodd=[path_to_your_file]`

Please report any problems you encounter by raising issues on GitHub (https://github.com/TEIC/atop/issues).




