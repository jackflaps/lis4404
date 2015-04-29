<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns="http://purl.org/dc/elements/1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dc="http://purl.org/dc/elements/1.1/" version="1.0">

	<xsl:output method="xml" indent="yes"/>

	<xsl:template match="/">
		<xsl:element name="dc:collection">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="library">
		<xsl:for-each select="record">
			<xsl:element name="dc:record">
				<xsl:element name="dc:title">
					<xsl:value-of select="title"/>
				</xsl:element>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>