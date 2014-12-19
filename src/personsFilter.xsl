<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="resources">
		<select id="personsFilter">
			<option disabled="disabled" selected="selected">Sélectionnez une personne</option>
			<xsl:apply-templates />
		</select>
	</xsl:template>

	<xsl:template match="person">
		<option>
			<xsl:attribute name="value"><xsl:value-of select="./@id"/></xsl:attribute>
			<xsl:value-of select="./@firstName"/><xsl:text> </xsl:text><xsl:value-of select="./@lastName"/>
		</option>
	</xsl:template>

	<xsl:template match="tasks"></xsl:template>
	<xsl:template match="events"></xsl:template>
	<xsl:template match="locations"></xsl:template>
	<xsl:template match="ui"></xsl:template>

</xsl:stylesheet>