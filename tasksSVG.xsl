<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
	<xsl:output method="xml" indent="yes" standalone="no" doctype-public="-//W3C//DTD SVG 1.1//EN"
      doctype-system="http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd"
      media-type="image/svg" />
	<xsl:template match="/">
			<!-- Nouveau SVG -->
			<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" height="1500" width="1500" style="border-style:solid;border-width:1px;">
				<!-- On défini un marker en forme de triangle, pour les flèches des lignes -->
				<defs>
			        <marker id="Triangle"
			                viewBox="0 0 10 10" 
			                refX="1" refY="5"
			                markerWidth="6" 
			                markerHeight="6"
			                orient="auto">
			            <path d="M 0 0 L 10 5 L 0 10 z" />
				    </marker>
			    </defs>
			    <!-- On applique les templates des éléments enfants -->
				<xsl:apply-templates />

				<!-- Message affiché dans le cas où le navigateur ne supporte pas le SVG inline -->
				Sorry, your browser does not support inline SVG.
			</svg>
	</xsl:template>

	<!-- Template pour les éléments de l'interface -->
	<xsl:template match="ui/*">
		<xsl:variable name="taskNode" select="//task[@id = current()/@task]" />
		<xsl:choose>
			<xsl:when test="name(.) = 'circle'">
				<circle cx="50" cy="50" r="40" stroke="black" stroke-width="1" fill="white">
					<xsl:attribute name="cx">
						<xsl:value-of select="./position/@x"/>
					</xsl:attribute>
					<xsl:attribute name="cy">
						<xsl:value-of select="./position/@y"/>
					</xsl:attribute>
					<xsl:attribute name="r">
						<xsl:value-of select="./@radius"/>
					</xsl:attribute>
				</circle>
				<a>
					<xsl:attribute name="xlink:href">taskDetails.html?taskId=<xsl:value-of select="$taskNode/@id"/></xsl:attribute>
					<text x="0" y="10" font-family="Verdana" font-size="20" fill="black" text-anchor="middle" style="dominant-baseline: middle;" >
						<xsl:attribute name="x">
							<xsl:value-of select="./position/@x"/>
						</xsl:attribute>
						<xsl:attribute name="y">
							<xsl:value-of select="./position/@y"/>
						</xsl:attribute>
						<xsl:value-of select="$taskNode/description"/>
					</text>
				</a>
			</xsl:when>
			<xsl:when test="name(.) = 'rectangle'">
				<rect x="50" y="20" rx="10" ry="10" width="300" height="100" style="fill:rgb(255,255,255);stroke-width:1;stroke:rgb(0,0,0)">
					<xsl:attribute name="x">
						<xsl:value-of select="./position/@x"/>
					</xsl:attribute>
					<xsl:attribute name="y">
						<xsl:value-of select="./position/@y"/>
					</xsl:attribute>
					<xsl:attribute name="width">
						<xsl:value-of select="./size/@width"/>
					</xsl:attribute>
					<xsl:attribute name="height">
						<xsl:value-of select="./size/@height"/>
					</xsl:attribute>
				</rect>
				<a>
					<xsl:attribute name="xlink:href">taskDetails.html?taskId=<xsl:value-of select="$taskNode/@id"/></xsl:attribute>
					<text x="0" y="10" font-family="Verdana" font-size="20" fill="black" text-anchor="middle" style="dominant-baseline: middle;" >
						<xsl:attribute name="x">
							<xsl:value-of select="./position/@x + (./size/@width div 2)"/>
						</xsl:attribute>
						<xsl:attribute name="y">
							<xsl:value-of select="./position/@y + (./size/@height div 2)"/>
						</xsl:attribute>
						<xsl:value-of select="$taskNode/description"/>
					</text>
				</a>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Template utilisé pour le traitement des événements (passage d'une tâche à une autre) -->
	<xsl:template match="events/event">
		<xsl:call-template name="outputTasksFromLinks">
			<!-- Aircraft contains my metadata -->
			<xsl:with-param name="fromList" select="./from/@task"></xsl:with-param>
			<xsl:with-param name="toList" select="./to/@task"></xsl:with-param>
			<xsl:with-param name="eventNode" select="."></xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- 
		Template : outputTasksFromLinks

		Template récursif qui parse une liste d'ID de taches "fromList" séparées par des espaces (ou un seul ID de tâche).
		Pour chacune des tâches "from", on appelle le deuxième template recursif "outputTasksToLinks" 
		qui va créer tous les liens SVG entre la tache "from" en cours et les tâches "to" de l'événement.
	-->
	<xsl:template name="outputTasksFromLinks">
		<xsl:param name="fromList"></xsl:param> <!-- Liste sous la forme "task_1 task_2" ou "task_1" -->
		<xsl:param name="toList"></xsl:param> <!-- Liste sous la forme "task_1 task_2" ou "task_1" -->
		<xsl:param name="eventNode"></xsl:param> <!-- Noeud de l'événement concerné (pour l'affichage de l'expression postfixée) -->

		<!-- Récupère le premier élément de la liste des id de "fromList" -->
		<xsl:variable name="first">
			<xsl:choose>
				<!-- Si c'est une liste séparée par des espaces, on récupère tout avant le premier espace -->
				<xsl:when test="contains($fromList, ' ')">
					<xsl:value-of select="substring-before($fromList,' ')" />
				</xsl:when>
				<!-- Sinon, on récupère juste l'ID fourni -->
				<xsl:otherwise>
					<xsl:value-of select="$fromList" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Enregistre tout le reste de la liste dans une autre variable, pour le prochain appel récursif -->
		<xsl:variable name="remaining" select="substring-after($fromList,' ')"></xsl:variable>

		<!-- On appelle le template qui se chargera de créer les liens entre la tâche 
		     ayant pour ID "from" et les tâches dont les ID sont dans "toList" -->
		<xsl:call-template name="outputTasksToLinks">
			<xsl:with-param name="from" select="$first"></xsl:with-param>
			<xsl:with-param name="toList" select="$toList"></xsl:with-param>
			<xsl:with-param name="eventNode" select="$eventNode"></xsl:with-param>
		</xsl:call-template>

		<!-- Si il reste encore des ID de "fromList" à traiter -->
		<xsl:if test="$remaining">
			<!-- On appelle le template récursivement avec le reste de la liste -->
			<xsl:call-template name="outputTasksFromLinks">
				<xsl:with-param name="fromList" select="$remaining"></xsl:with-param>
				<xsl:with-param name="toList" select="$toList"></xsl:with-param>
				<xsl:with-param name="eventNode" select="$eventNode"></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- 
		Template : outputTasksToLinks

		Template récursif qui parse une liste d'ID de taches "toList" séparées par des espaces (ou un seul ID de tâche).
		Il va ensuite créer un élément <line> dans le SVG pour lier la tache "from" à chacune des taches de "toList".
	-->
	<xsl:template name="outputTasksToLinks">
		<xsl:param name="from"></xsl:param> <!-- ID de la tâche de départ -->
		<xsl:param name="toList"></xsl:param> <!-- Liste sous la forme "task_1 task_2" ou "task_1" -->
		<xsl:param name="eventNode"></xsl:param> <!-- Noeud de l'événement concerné (pour l'affichage de l'expression postfixée) -->

		<!-- Récupère le premier élément de la liste des id de "toList" -->
		<xsl:variable name="first">
			<xsl:choose>
				<!-- Si c'est une liste séparée par des espaces, on récupère tout avant le premier espace -->
				<xsl:when test="contains($toList, ' ')">
					<xsl:value-of select="substring-before($toList,' ')" />
				</xsl:when>
				<!-- Sinon, on récupère juste l'ID fourni -->
				<xsl:otherwise>
					<xsl:value-of select="$toList" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Enregistre tout le reste de la liste dans une autre variable, pour le prochain appel récursif -->
		<xsl:variable name="remaining" select="substring-after($toList,' ')"></xsl:variable>

		<!-- On récupère les informations de l'élément UI de la tâche de départ et de fin -->
		<xsl:variable name="fromTaskUI" select="//ui/*[@task = $from]" />
		<xsl:variable name="toTaskUI" select="//ui/*[@task = $first]" />

		<!-- TODO: si une des tâches n'existe pas dans l'UI, ne pas créer de lien ? -->

		<!-- Créer un lien entre la tache "from" et la tache "to" -->
		<line x1="0" y1="0" x2="200" y2="200" style="stroke:rgb(0,0,0);stroke-width:2" marker-end="url(#Triangle)">
			<xsl:attribute name="x1">
				<xsl:value-of select="$fromTaskUI/position/@x"/>
			</xsl:attribute>
			<xsl:attribute name="y1">
				<xsl:value-of select="$fromTaskUI/position/@y"/>
			</xsl:attribute>
			<xsl:attribute name="x2">
				<xsl:value-of select="$toTaskUI/position/@x"/>
			</xsl:attribute>
			<xsl:attribute name="y2">
				<xsl:value-of select="$toTaskUI/position/@y"/>
			</xsl:attribute>
		</line>

		<!-- Récupère les noeuds <operande> et <operator> de l'événement pour parser l'expression postfixée -->
		<xsl:variable name="prefixedList" select="$eventNode/*[name() = 'operande' or name()='operator']" />

		<!-- On crée un élément <text> pour afficher la condition de l'événement (expression postfixée transformée en infixée) -->
		<text x="0" y="10" font-family="Verdana" font-size="15" fill="black" text-anchor="middle" style="dominant-baseline: middle;" >
			<!-- Positionne l'élément texte au milieu de la ligne de liaison -->
			<xsl:attribute name="x">
				<xsl:value-of select="($fromTaskUI/position/@x + $toTaskUI/position/@x) div 2"/>
			</xsl:attribute>
			<xsl:attribute name="y">
				<xsl:value-of select="($fromTaskUI/position/@y + $toTaskUI/position/@y) div 2"/>
			</xsl:attribute>

			<!-- Parse l'expression postfixée à l'aide du template "parsePrefixedExpression" -->
			<xsl:call-template name="parsePrefixedExpression">
				<xsl:with-param name="prefixedList" select="$prefixedList"></xsl:with-param>
			</xsl:call-template>
		</text>

		<!-- Si il reste encore des ID de "toList" à traiter -->
		<xsl:if test="$remaining">
			<!-- On appelle le template récursivement avec le reste de la liste -->
			<xsl:call-template name="outputTasksToLinks">
				<xsl:with-param name="from" select="$from"></xsl:with-param>
				<xsl:with-param name="toList" select="$remaining"></xsl:with-param>
				<xsl:with-param name="eventNode" select="$eventNode"></xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- 
		Template : countPrefixedExpressionDepth

		Template récursif qui compte le nombre d'éléments d'une expression postfixée représentée par une liste de noeuds <operator> et <operande>.
	-->
	<xsl:template name="countPrefixedExpressionDepth">
		<xsl:param name="prefixedList"></xsl:param> <!-- La liste de noeuds à traiter -->

		<!-- On récupère le dernier noeud (noeud courant à traiter) -->
		<xsl:variable name="last" select="$prefixedList[last()]" />

		<xsl:choose>
			<!-- Est-ce un opérateur ? -->
			<xsl:when test="name($last) = 'operator'">
				<!-- Compte récursivement le nombre d'éléments du premier paramètre de cet opérateur -->
				<xsl:variable name="firstPartCount">
					<xsl:call-template name="countPrefixedExpressionDepth">
						<xsl:with-param name="prefixedList" select="$prefixedList[not(position() > last() -1)]"></xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<!-- Compte récursivement le nombre d'éléments du deuxième paramètre de cet opérateur (en commencant à $firstPartCount - 1) -->
				<xsl:variable name="secondPartCount">
					<xsl:call-template name="countPrefixedExpressionDepth">
						<xsl:with-param name="prefixedList" select="$prefixedList[not(position() > last() - $firstPartCount - 1)]"></xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<!-- Total des éléments : opérateur + premier paramètre + deuxième paramètre -->
				<xsl:value-of select="1 + $firstPartCount + $secondPartCount" />
			</xsl:when>
			<!-- Ou une opérande ? -->
			<xsl:when test="name($last) = 'operande'">
				<xsl:text>1</xsl:text>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- 
		Template : parsePrefixedExpression

		Template récursif qui parse une liste de noeuds <operator> et <operande> en position postfixée et qui
		retourne un texte représentant ces noeuds de façon infixée (ex: (( ((task_1.progress) BIGGER_THAN (70)) ) OR ( ((task_1.status) EQUAL (COMPLETED)) ))).
	-->
	<xsl:template name="parsePrefixedExpression">
		<xsl:param name="prefixedList"></xsl:param> <!-- La liste de noeuds à traiter -->

		<!-- On récupère le dernier noeud (noeud courant à traiter) -->
		<xsl:variable name="last" select="$prefixedList[last()]" />

		<xsl:choose>
			<!-- Est-ce un opérateur ? -->
			<xsl:when test="name($last) = 'operator'">
				<xsl:text> ( (</xsl:text>

				<!-- Parse le premier paramètre de l'opérateur -->
				<xsl:call-template name="parsePrefixedExpression">
					<xsl:with-param name="prefixedList" select="$prefixedList[not(position() > last() -1)]"></xsl:with-param>
				</xsl:call-template>

				<!-- Compte le nombre d'éléments qui concernent le premier paramètre de l'opérateur-->
				<xsl:variable name="firstPartCount">
					<xsl:call-template name="countPrefixedExpressionDepth">
						<xsl:with-param name="prefixedList" select="$prefixedList[not(position() > last() -1)]"></xsl:with-param>
					</xsl:call-template>
				</xsl:variable>

				<xsl:text>) </xsl:text>
				<xsl:value-of select="$last/@name"/> <!-- Nom de l'opérateur -->
				<xsl:text> (</xsl:text>

				<!-- Parse le deuxième paramètre de l'opérateur (en commencant après tous les éléments du premier paramètre) -->
				<xsl:call-template name="parsePrefixedExpression">
					<xsl:with-param name="prefixedList" select="$prefixedList[not(position() > last() - $firstPartCount -1)]"></xsl:with-param>
				</xsl:call-template>

				<xsl:text>) ) </xsl:text>
			</xsl:when>
			<!-- Ou une opérande ? -->
			<xsl:when test="name($last) = 'operande'">
				<xsl:choose>
					<!-- C'est l'opérande "now" -->
					<xsl:when test="name(($last/*)[1]) = 'now'">
						<xsl:text>now</xsl:text>
					</xsl:when>
					<!-- C'est l'opérande "value" -->
					<xsl:when test="name(($last/*)[1]) = 'value'">
						<xsl:value-of select="(($last/*)[1])"/>
					</xsl:when>
					<!-- C'est l'opérande "taskValue" -->
					<xsl:when test="name(($last/*)[1]) = 'taskValue'">
						<xsl:value-of select="(($last/*)[1])/@task"/>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="(($last/*)[1])/@element"/>
					</xsl:when>
					<xsl:otherwise></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Eléments à ne pas afficher dans l'interface, leur template est vide -->
	<xsl:template match="tasks"></xsl:template>
	<xsl:template match="resources"></xsl:template>
	<xsl:template match="locations"></xsl:template>

</xsl:stylesheet>
