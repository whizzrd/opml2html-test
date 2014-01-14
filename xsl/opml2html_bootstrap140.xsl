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
	<xsl:template match="/">
	<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
		<xsl:apply-templates select="opml" />
	</html>
	</xsl:template>
	<xsl:template match="opml">
		<xsl:apply-templates select="head" />
		<xsl:apply-templates select="body" />
	</xsl:template>
	<xsl:template match="head">
	  <head>
		<xsl:copy-of select="title" />
		<xsl:copy-of select="meta" />
		<script src="js/jquery-1.4.3.min.js" type="text/javascript"></script>
		<script src="js/js/jquery.cookie.js" type="text/javascript"></script>
		<script src="js/jquery.treeview.js" type="text/javascript"></script>
		<link rel="stylesheet" href="css/jquery.treeview.lib.css" />
		<link rel="stylesheet" href="css/bootstrap.css " />
		<script type="text/javascript" src="js/bootstrap.js"></script>
		<style type="text/css">
		<![CDATA[
		  /* Override some defaults */
		  html, body {
			background-color: #eee;
			height: 100%;
		  }
		  body {
			padding-top: 40px; /* 40px to make the container go all the way to the bottom of the topbar */
		  }
		  .container {
			width: 90%;
		  }
		  .container > footer p {
			text-align: center; /* center align it with the container */
		  }
		  /* The white background content wrapper */
		  .content {
			background-color: #fff;
			padding: 20px;
			margin: 0 -20px; /* negative indent the amount of the padding to maintain the grid system */
			-webkit-border-radius: 0 0 6px 6px;
			   -moz-border-radius: 0 0 6px 6px;
					border-radius: 0 0 6px 6px;
			-webkit-box-shadow: 0 1px 2px rgba(0,0,0,.15);
			   -moz-box-shadow: 0 1px 2px rgba(0,0,0,.15);
					box-shadow: 0 1px 2px rgba(0,0,0,.15);
		  }
		  /* Page header tweaks */
		  .page-header {
			background-color: #f5f5f5;
			padding: 20px 20px 10px;
			margin: -20px -20px 20px;
		  }
		  li{
			font-size: 15px;
		  }
		  li.collapsable {
			font-size: 15px;
			font-weight: bold;
		  }
		  li p {
			whitespace: pre;
		  }
		  ]]>
		</style>
	  </head>
	</xsl:template>
	<xsl:template match="body">
		<body>
			<div id="topbar" class="topbar">
				<div class="topbar-inner">
					<div class="container-fluid">
						<h2 class="brand"><a href="{../head/ownerId}"><xsl:value-of select="../head/ownerName" /></a></h2>
						<ul class="nav">
							<li class="active">
								<a href="#">
									<xsl:value-of select="../head/title"/>
								</a>
							</li>
						</ul>
					</div>
				</div>
			</div>
			<div class="container"> 
				<div class="content">
				<xsl:apply-templates select="outline" />
				<footer>
					<p>This page is compiled from outlines by
						<a> 
							<xsl:attribute name="href">
								<xsl:value-of select="../head/ownerId"/>
							</xsl:attribute>
							<xsl:value-of select="../head/ownerName"/>
						</a>
						<xsl:call-template name="credits"/>
					</p>
				</footer>
			</div>
			</div>
			<script type="text/javascript">
			//$('#topbar').dropdown();
			</script>
		</body>
	</xsl:template>
	<xsl:template match="outline">
	<xsl:variable name="id" select="generate-id()"/>
		<xsl:choose>
			<xsl:when test="@type='link'">
			<li>
				  <xsl:call-template name="link" />
			</li>
		  </xsl:when>
			<xsl:when test="@type='rss'">
			<li>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="@htmlUrl"/>
					</xsl:attribute>
					<xsl:value-of select="@text" disable-output-escaping="yes"/>
				</a>
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="@xmlUrl"/>
					</xsl:attribute>
					<img src="img/rss-icon-16x16.png" alt="RSS" />
				</a>
				<xsl:if test="@description">
					<p xml:space="preserve"><xsl:value-of select="@description" /></p>
				</xsl:if>
				<xsl:if test="count(outline)">
					<ul>
						<xsl:apply-templates select="outline" />
					</ul>
				</xsl:if>
			</li>
			</xsl:when>
			<xsl:when test="@type='outline'">
				<ul id="tree{$id}" class="treeview">
			  <li>
				<xsl:value-of select="@text"/>
					<xsl:if test="count(outline)">
						<ul>
							<xsl:apply-templates select="outline" />
						</ul>
					</xsl:if>
					</li>
				</ul>
				<script type="text/javascript">
					$('#tree<xsl:value-of select="$id"/>').treeview({
						persist: "cookie",
						cookieId: "treeview",
						unique: true
					});
				</script>
			</xsl:when>
			<xsl:when test="@type='thumblist'">
				<ul class="media-grid">
					<xsl:apply-templates select="outline[@type='photo']"/>
				</ul>
			</xsl:when>
			<xsl:when test="@type='photo'">
				<li>
				  <a href="{@htmlUrl}">
					<img class="thumbnail" src="{@thumbUrl}" alt="{@text}" width="{@thumbWidth}" height="{@thumbHeight}" />
				  </a>
				</li>
			</xsl:when>
			<xsl:when test="@type='button'">
				<a href="#" class="btn">
					<xsl:attribute name="href">
						<xsl:choose>
							<xsl:when test="@url"><xsl:value-of select="@url"/></xsl:when>
							<xsl:otherwise>#</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
					<xsl:attribute name="onclick">
						<xsl:value-of select="@script"/>
						<xsl:if test="../@type='modal'">
							$('#modal<xsl:value-of select="generate-id(..)"/>').modal('hide');return false;
						</xsl:if>
					</xsl:attribute>
					<xsl:if test="@image">
						<img src="{@image}" border="0">
							<xsl:if test="@imageHover">
								<xsl:attribute name="onmouseover">this.src='<xsl:value-of select="@imageHover"/>'</xsl:attribute>
								<xsl:attribute name="onmouseout">this.src='<xsl:value-of select="@image"/>'</xsl:attribute>
							</xsl:if>
						</img>
				</xsl:if>
					<xsl:value-of select="@text"/>
				</a>
			</xsl:when>
			<xsl:when test="@type='script'">
				<script>
					<xsl:value-of select="@text" />
				</script>
			</xsl:when>
			<xsl:when test="@type='include'">
				<li><xsl:value-of select="@text" /><a href="{@url}"><img src="img/opml-icon-16x16.png" alt="OPML" /></a>
					<ul>
						<xsl:apply-templates select="document(@url)/opml/body/*" />
					</ul>
				</li>
			</xsl:when>
			<xsl:when test="@type='footer'">
				<footer>
					<p>
						<xsl:apply-templates />
					</p>
				</footer>
			</xsl:when>
			<xsl:when test="@type='html'">
				<xsl:copy-of select="node()[name()!='outline']" />
			</xsl:when>
			<xsl:when test="@type='input'">
				<br/><xsl:value-of select="@title"/><input type="text" name="{@text}"/><xsl:value-of select="@description"/>
			</xsl:when>
			<xsl:when test="@type='password'">
				<br/><xsl:value-of select="@title"/><input type="password" name="{@text}"/><xsl:value-of select="@description"/>
			</xsl:when>
			<xsl:when test="@type='checkbox'">
				<br/><xsl:value-of select="@title"/><input type="checkbox" name="{@text}"/><xsl:value-of select="@description"/>
			</xsl:when>
			<xsl:when test="@type='radio'">
				<br/><xsl:value-of select="@title"/><input type="radio" name="{@text}"/><xsl:value-of select="@description"/>
			</xsl:when>
			<xsl:when test="@type='modal'">
				<a href="#" onclick="$('#modal{$id}').modal('show'); return false;">
				  <xsl:value-of select="@text"/>
				</a>
				<div class="modal hide fade">
					<xsl:attribute name="id">modal<xsl:value-of select="$id"/></xsl:attribute>
					<div class="modal-header">
						<a href="#" class="close">X</a>
						<h3>
							<xsl:value-of select="@title"/>
						</h3>
					</div>
					<div class="modal-body">
						<p>
							<xsl:value-of select="@description"/>
						</p>
						<xsl:apply-templates select="outline"/>
					</div>
					<div class="modal-footer">
					</div>
				</div>
				<script type="text/javascript" defer="defer">
					$('#modal<xsl:value-of select="$id"/>').modal({
						backdrop: true,
						keyboard: true
					});
				</script>
			</xsl:when>
			<xsl:when test="@type='code'">
				<li>
					<pre><xsl:value-of select="@text"/></pre>
					<xsl:apply-templates />
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li>
					<xsl:call-template name="outline" />
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="@style">
		<xsl:copy>
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	<xsl:template match="@styles">
		<style type="text/css">
			<xsl:value-of select="." />
		</style>
	</xsl:template>
	<xsl:template match="@stylesheet">
		<link rel="stylesheet">
			<xsl:attribute name="href">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</link>
	</xsl:template>
	<xsl:template match="@icon">
		<img>
			<xsl:attribute name="src">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</img>
	</xsl:template>
	<xsl:template name="outline">
		<xsl:value-of select="@text" disable-output-escaping="yes"/>
		<xsl:if test="@type">
			[<xsl:value-of select="@type" />]
		</xsl:if>
		<xsl:copy-of select="node()[name()!='outline']" />
		<xsl:if test="count(outline)">
			<ul>
				<xsl:apply-templates />
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template name="link">
		<a>
			<xsl:attribute name="href">
				<xsl:value-of select="@url"/>
			</xsl:attribute>
			<xsl:apply-templates select="./@icon" />
			<xsl:value-of select="@text" disable-output-escaping="yes"/>
		</a>
		<xsl:if test="@description">
			<p xml:space="preserve"><xsl:value-of select="@description" /></p>
		</xsl:if>
		<xsl:if test="count(./outline) &gt; 0">
			<ul>
				<xsl:apply-templates select="*" />
			</ul>
		</xsl:if>
	</xsl:template>
	<xsl:template name="social">
		<xsl:param name="url" />
		<xsl:param name="text" />
		<xsl:param name="via">garagememories</xsl:param>
		<xsl:if test="$url">
			<br/>
			<g:plusone size="small" href="{$url}"></g:plusone>
			<a href="https://twitter.com/share" class="twitter-share-button" data-text="{$text}" data-url="{$url}" data-via="{$via}" data-lang="en">Tweet</a>
			<div class="fb-like" data-href="{$url}" data-send="true" data-layout="button_count" data-show-faces="false" data-ref="{$via}"></div>
			<a title="Send to linkblog." onclick="sendToLinkblog(encodeURIComponent('{$text}'), encodeURIComponent('{$url}'), encodeURIComponent'{$text}'))">
				<img src="img/opml-icon-16x16.png" alt="OPML" />
			</a>
		</xsl:if>
	</xsl:template>
	<xsl:template name="twitterfollow">
		<xsl:param name="username" />
		<a href="https://twitter.com/{$username}" class="twitter-follow-button" data-show-count="true" data-show-screen-name="false">Follow {$username}</a>
		<script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
	</xsl:template>
	<xsl:template name="googleanalytics">
		<script type="text/javascript">
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-21063256-4']);
		_gaq.push(['_trackPageview']);
		(function() {
		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		})();
		</script>
	</xsl:template>
	<xsl:template name="googleplusonescript">
		<script type="text/javascript">
		(function() {
		var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
		po.src = 'https://apis.google.com/js/plusone.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
		})();
		</script>
	</xsl:template>
	<xsl:template name="twitterscript">
		<script type="text/javascript">!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
	</xsl:template>
	<xsl:template name="facebookscript">
		<div id="fb-root"></div>
		<script type="text/javascript">
			<xsl:attribute name="src">http://connect.facebook.net/en_US/all.js#xfbml=1<xsl:if test="/opml/head/meta[@property='fb:app_id']/@content">&amp;appId=<xsl:value-of select="/opml/head/meta[@property='fb:app_id']/@content"/></xsl:if></xsl:attribute>
		</script>
	</xsl:template>
	<xsl:template name="credits">
		<xsl:for-each select="//outline[@type='include']">
			,<xsl:apply-templates select="document(@url)/opml/head/ownerName"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="ownerName">
		<a href="{../ownerId}"><xsl:value-of select="." /></a>
		<xsl:call-template name="credits" />
	</xsl:template>
</xsl:stylesheet>
