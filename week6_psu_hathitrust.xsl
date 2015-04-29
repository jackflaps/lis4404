<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:marc="http://www.loc.gov/MARC21/slim"
      exclude-result-prefixes="xs marc"
      version="2.0">
    
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    
    <xsl:template match="node() | @*">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="marc:record">
		<xsl:apply-templates/>
		<!-- XSLT code to add the notes field -->
		<xsl:element name="marc:datafield">
			<xsl:attribute name="ind1">&nbsp;</xsl:attribute>
			<xsl:attribute name="ind2">&nbsp;</xsl:attribute>
			<xsl:attribute name="tag">955</xsl:attribute>
			<xsl:element name="marc:subfield">
				<xsl:attribute name="code">b</xsl:attribute>
				<!-- ARK or local identifier -->
			</xsl:element>
			<xsl:element name="marc:subfield">
				<xsl:attribute name="code">q</xsl:attribute>
				<!-- Internet Archive ID -->
			</xsl:element>
			<xsl:element name="marc:subfield">
				<xsl:attribute name="code">v</xsl:attribute>
				<!-- Enumeration/Chronology info -->
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
