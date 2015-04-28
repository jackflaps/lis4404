<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:marc="http://www.loc.gov/MARC21/slim"
      exclude-result-prefixes="xs marc"
      version="2.0">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="node() | @*">
		<xsl:copy-of select="node() | @*">
			<xsl:apply-templates/>
		</xsl:copy-of>
	</xsl:template>

	<xsl:template match="marc:record">
		<xsl:apply-templates/>
		<!-- XSLT code to add the notes field -->
		<!-- XSLT code to add the source of digitization -->
	</xsl:template>
</xsl:stylesheet>
