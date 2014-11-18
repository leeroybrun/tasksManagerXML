<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:variable name="personId">res_1</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="tasks">
		<h1>Taches pour <xsl:value-of select="//resources/person[@id = $personId]/@firstName"/><xsl:text> </xsl:text><xsl:value-of select="//resources/person[@id = $personId]/@lastName"/></h1>
		<TABLE class="tasks-list" cellspacing="0" cellpadding="0">
			<TR class="heading">
				<th class="description">Description</th>
				<th class="resource">Resource</th>
				<th class="progress">Progrès</th>
				<th class="place">Emplacement</th>
				<th class="duration">Durée</th>
				<th class="status">Status</th>
			</TR>

			<xsl:apply-templates />

		</TABLE>
	</xsl:template>

	<xsl:template match="task">
		<xsl:if test="./assignedTo/@resource = $personId">
			<xsl:element name="TR">
				<TD><a>
					<xsl:attribute name="href">../taskDetails/taskDetails.html?taskId=<xsl:value-of select="./@id"/></xsl:attribute>
					<xsl:value-of select="./description"/>
				</a></TD>
				<TD><xsl:value-of select="//resources/person[@id = current()/assignedTo/@resource]/@firstName"/></TD>
				<TD style="width:140px">
					<div class="progress-bar-wrapper">
						<div class="progress-bar">
							<xsl:attribute name="style">
								width:<xsl:value-of select="./progress/@value"/>px;
							</xsl:attribute>
						</div>
					</div>
					<div class="progress-value"><xsl:value-of select="./progress/@value"/> %</div>
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
					<xsl:if test="(./status/@value='IN_PROGRESS')">
						<xsl:attribute name="style">background-color:#66CC99</xsl:attribute>
						<xsl:text>En cours</xsl:text>
					</xsl:if>
					<xsl:if test="(./status/@value='COMPLETED')">
						<xsl:attribute name="style">background-color:#26A65B</xsl:attribute>
						<xsl:text>Terminée</xsl:text>
					</xsl:if>
					<xsl:if test="(./status/@value='NOT_STARTED')">
						<xsl:attribute name="style">background-color:#D35400</xsl:attribute>
						<xsl:text>Pas commencée</xsl:text>
					</xsl:if>
				</td>
			</xsl:element>
		</xsl:if>
	</xsl:template>

	<xsl:template match="events"></xsl:template>
	<xsl:template match="resources"></xsl:template>
	<xsl:template match="locations"></xsl:template>
	<xsl:template match="ui"></xsl:template>

</xsl:stylesheet>
