<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0">

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
  
  <xsl:template match="node() | @*">
    <xsl:copy>
	  <xsl:apply-templates select="node() | @*"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match="description">
    <xsl:if test="@lang eq 'es'">
      <xsl:element name="spanish">
        <xsl:value-of select="."/>
      </xsl:element>
    </xsl:if>
  </xsl:template>
      
</xsl:stylesheet>
