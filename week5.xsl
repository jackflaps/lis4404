<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:element name="collection">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="library">
		<xsl:element name="library">
			<xsl:text>library</xsl:text>
		</xsl:element>
	</xsl:template>

</xsl:stylesheet>