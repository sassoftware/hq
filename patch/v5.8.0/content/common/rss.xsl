<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
<xsl:output method="html"/>
<xsl:template match="/">
  <xsl:apply-templates select="rss/channel"/>
</xsl:template>
<xsl:template match="rss/channel">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title>
  <xsl:value-of select="title"/>
</title>
</head>
<body>
<div>
  <h3><a href="{link}"><xsl:value-of select="title"/></a></h3>
  <p><xsl:value-of select="description"/></p>
</div>
<div>
  <xsl:apply-templates select="item"/>
</div>
</body>
</html>
</xsl:template>
<xsl:template match="item">
<div>
  <a href="{link}"><xsl:value-of select="title"/></a>
  <xsl:value-of select="description"/>
</div>
</xsl:template>
</xsl:stylesheet>
