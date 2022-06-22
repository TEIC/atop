xquery version "3.1";
(: 2021-07-03 ebb: Diagnostic XQuery to test parsing of si_Add files referenced in catalogue on SI repo.  :)
declare default element namespace "http://www.tei-c.org/ns/1.0";
declare variable $siAddColl := collection('https://digitalmitford.github.io/DM_SiteIndex//si_Add_Staged/catalogue.xml');
$siAddColl//person