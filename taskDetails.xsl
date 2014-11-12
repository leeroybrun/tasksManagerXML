<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<html><head></head><body style="font-family:Verdana; font-size:10pt; color:black">
			<xsl:apply-templates />
 		</body></html>
	</xsl:template>

	<xsl:variable name="taskId">task_1</xsl:variable>
	<xsl:variable name="taskData" select="//tasks/task/[@id = $taskId]"/>

	<xsl:template match="tasks">

		<h1><xsl:value-of select="./description"/></h1>
		<p>Assigned to : <xsl:value-of select="//resources/person[@id = current()/assignedTo/@resource]/@firstName"/></p>
		<p>
			<div class="float:left;margin-right:10px;">Progress:</div>
			<div>
				<xsl:attribute name="style">
					width:<xsl:value-of select="./progress/@value"/>px; background-color:grey; height:20px; float:left;
				</xsl:attribute>
			</div>
			<div style="float:left;margin-left:10px;"><xsl:value-of select="./progress/@value"/> %</div>
		</p>
		<p>Place: <xsl:value-of select="//locations/location[@id = current()/place/@loc]/@name"/></p>
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
	</xsl:template>

</xsl:stylesheet>