<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html><head></head><body style="font-family:Verdana; font-size:10pt; color:black">
			<xsl:apply-templates />
 		</body></html>
	</xsl:template>

	<xsl:template match="tasks">
		<TABLE STYLE="width:1000px;" Border="1">
			<TR STYLE="width:1000px; background-color:lightgrey">
				<TD>Description</TD>
				<TD>Resource</TD>
				<TD>Progrès</TD>
				<TD>Emplacement</TD>
				<TD>Durée</TD>
				<TD>Status</TD>
			</TR>
			<xsl:for-each select="task">
				<xsl:element name="TR">
					<TD><xsl:value-of select="./description"/></TD>
					<TD><xsl:value-of select="//resources/person[@id = current()/assignedTo/@resource]/@firstName"/></TD>
					<TD>
						<div>
							<xsl:attribute name="style">
								width:<xsl:value-of select="./progress/@value"/>px
							</xsl:attribute>
						</div>
						<xsl:value-of select="./progress/@value"/>
					</TD>
					<TD><xsl:value-of select="//locations/location[@id = current()/place/@loc]/@name"/></TD>
					<TD>
						<xsl:choose>
							<xsl:when test="(./duration/@hour)">
								<xsl:value-of select="./duration/@hour"/> heures
							</xsl:when>
        					<xsl:otherwise>
        						-
        					</xsl:otherwise>
						</xsl:choose>
					</TD>
					<td>
						<xsl:attribute name="STYLE">
							<xsl:if test="(./status/@value='IN_PROGRESS')">
								background-color:orange
							</xsl:if>
							<xsl:if test="(./status/@value='COMPLETED')">
								background-color:green
							</xsl:if>
							<xsl:if test="(./status/@value='NOT_STARTED')">
								background-color:red
							</xsl:if>
						</xsl:attribute>
						<xsl:value-of select="./status/@value"/>
					</td>
				</xsl:element>
			</xsl:for-each>

		</TABLE>	
	</xsl:template>

</xsl:stylesheet>