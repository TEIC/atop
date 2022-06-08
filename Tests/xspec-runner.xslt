<xsl:stylesheet version="3.0" exclude-result-prefixes="xs xspec"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xspec="http://www.jenitennison.com/xslt/xspec">

  <xsl:param name="files" as="xs:string" required="true"/>

  <xsl:template match="/" as="element(project)">
    <project>
      <include file="../Lib/xspec/build.xml"/>
      <target name="xspec-runner">
        <xsl:for-each select="tokenize($files)">
          <antcall target="xspec.xspec" inheritall="false">
            <param name="xspec.xml" location="{.}"/>
            <param name="test.type" value="{if (doc(.)/xspec:description/@stylesheet) then 't' else 's'}"/>
            <param name="clean.output.dir" value="true"/>
          </antcall>
        </xsl:for-each>
      </target>
    </project>
  </xsl:template>

</xsl:stylesheet>
