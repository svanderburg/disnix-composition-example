<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="/expr/list">
    <lookupservice>
      <xsl:for-each select="attrs">
	<service>
	  <name><xsl:value-of select="attr[@name='service']/string/@value" /></name>
	  <URL>http://<xsl:value-of select="attr[@name='target']/string/@value" />:<xsl:value-of select="attr[@name='tomcatPort']/int/@value" />/<xsl:value-of select="attr[@name='service']/string/@value" />/services/<xsl:value-of select="attr[@name='service']/string/@value" /></URL>
	</service>
      </xsl:for-each>
    </lookupservice>
  </xsl:template>
</xsl:stylesheet>
