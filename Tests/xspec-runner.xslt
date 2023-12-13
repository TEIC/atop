<xsl:stylesheet version="3.0" exclude-result-prefixes="xs xspec"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xspec="http://www.jenitennison.com/xslt/xspec"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl">
  <xd:doc>
    <xd:desc>This runner file submits a sequence of XSpec files to the XSpec
    lib's ant target to be run. This enables us to run all our tests as a block.</xd:desc>
  </xd:doc>
  
  <xd:doc>
    <xd:desc><xd:ref name="files" as="xs:string"/> is a space-separated list of all the
    XSpec files.</xd:desc>
  </xd:doc>
  <xsl:param name="files" as="xs:string" required="true"/>

  <xd:doc>
    <xd:desc>The root template that does the work.</xd:desc>
  </xd:doc>
  <xsl:template match="/" as="element(project)">
    <project>
      <include file="../Lib/xspec/build.xml"/>
      <target name="xspec-runner">
        <!-- For each of our XSpec files. -->
        <xsl:for-each select="tokenize($files, '&#x241d;')">
          <!-- call the xspec target in the build file. -->
          <antcall target="xspec.xspec" inheritall="false">
            <!-- Pass the location of the XSpec file we want to run. -->
            <param name="xspec.xml" location="{.}"/>
            <!-- Pass the target test type: t = XSLT, s = Schematron. -->
            <param name="test.type" value="{if (doc(.)/xspec:description/@stylesheet) then 't' else 's'}"/>
            <param name="clean.output.dir" value="true"/>
          </antcall>
        </xsl:for-each>
      </target>
    </project>
  </xsl:template>

</xsl:stylesheet>
