<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html><head><link rel="stylesheet" href="taskDetails.css"/></head><body style="font-family:Verdana; font-size:10pt; color:black">
			<xsl:apply-templates />
 		</body></html>
	</xsl:template>

	<xsl:variable name="taskId">task_1</xsl:variable>

	<!-- Est-ce correct ? Devrais-je faire autrement ? -->
	<xsl:template match="//tasks/task[@id != $taskId]"></xsl:template>

	<xsl:template match="//tasks/task[@id = $taskId]">

		<h1><xsl:value-of select="./description"/></h1>
		<p>Assigned to : <xsl:value-of select="//resources/person[@id = current()/assignedTo/@resource]/@firstName"/></p>
		<p style="overflow:hidden;">
			<div class="progress-title">Progress:</div>
			<div class="progress-bar-wrapper">
				<div class="progress-bar">
					<xsl:attribute name="style">
						width:<xsl:value-of select="./progress/@value"/>px;
					</xsl:attribute>
				</div>
			</div>
			<div style="float:left;margin-left:10px;"><xsl:value-of select="./progress/@value"/> %</div>
		</p>
		<p style="clear:both;overflow:hidden;">Place: <xsl:value-of select="//locations/location[@id = current()/place/@loc]/@name"/></p>
		<p>Duration: 
			<xsl:choose>
				<xsl:when test="(./duration/@hour)">
					<xsl:value-of select="./duration/@hour"/> heures
				</xsl:when>
				<xsl:otherwise>
					-
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<p>Status: 
			<span>
				<xsl:attribute name="STYLE">
					<xsl:if test="(./status/@value='IN_PROGRESS')">
						color:orange
					</xsl:if>
					<xsl:if test="(./status/@value='COMPLETED')">
						color:green
					</xsl:if>
					<xsl:if test="(./status/@value='NOT_STARTED')">
						color:red
					</xsl:if>
				</xsl:attribute>
				<xsl:value-of select="./status/@value"/>
			</span>
		</p>
		<xsl:if test="count(./comments/comment) > 0">
			<p>Commentaires:</p>
			<ul>
				<xsl:for-each select="./comments/comment">
					<li><b><xsl:value-of select="//resources/person[@id = current()/@from]/@firstName"/>:</b><xsl:text> </xsl:text><xsl:value-of select="."/></li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template match="events"></xsl:template>
	<xsl:template match="resources"></xsl:template>
	<xsl:template match="locations"></xsl:template>
	<xsl:template match="ui"></xsl:template>

</xsl:stylesheet>