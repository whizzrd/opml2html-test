<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	extension-element-prefixes="yaslt"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:yaslt="http://www.mod-xslt2.com/ns/1.0"
	xmlns:my="my:namespace"
	xmlns:g="google"
	xmlns="http://www.w3.org/1999/xhtml"
	exclude-result-prefixes="my"
>
<xsl:output 
	method="html" 
	doctype-system="http://www.w3.org/TR/html4/strict.dtd" 
	doctype-public="-//W3C//DTD HTML 4.01//EN" 
	media-type="text/html" />

	<!-- Include the Twitter Bootstrap based template -->
	<xsl:include href="opml2html_bootstrap140.xsl" />
	<!-- TODO: include additional templates -->
</xsl:stylesheet>
