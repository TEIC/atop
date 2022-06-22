# Stages of Updating the Digital Mitford Project ODD

 BEGIN with mitfordPre-Editable.odd. Canonicalize it to mitfordEditable.odd before beginning to edit. The full ODD file is mitfordODD.odd.
      
To make/edit/update the complete ODD: 

* Open mitfordPre-Editable.odd and run canonicalize in oXygen to pull in the latest rules on the <occupation> element encoding from the SI GitHub repo. Output as mitfordEditable.odd.
      
* Make any necessary edits to the document model (element modules from the TEI, general constraints, anything except Site Index updates) in the mitfordEditable.odd file.
      
* If updating the ODD because of Site Index updates, 
           
     1) Be sure the new SI is posted at http://digitalmitford.org/si.xml. 
            
     1) Generate elementSpecs for new named entity markup (persons, places, titles, etc) with attribute values for @ref and @corresp 
      by running si-to-ODD.xsl over the current si.xml stored at http://digitalmitford.org/si.xml. Save the output file as MRMProsopRef.odd 
      
* Finally generate the full ODD file by running mitfordODD-Combiner.xsl on mitfordEditable.odd, which pulls in site index data stored in MRMProsopRef.odd. Save the output as mitfordODD.odd
     
* "Run the wrench" in oXygen to generate the new Relax-NG XML-syntax project schema and HTML documentation for the project.
     
The canonical version of the Mitford ODD is stored here in the DM_Documentation GitHub repo. Project schema lines should point to the ODD-generated Relax NG schema at https://digitalmitford.github.io/DM_documentation/MitfordODD/out/mitfordODD.rng 

