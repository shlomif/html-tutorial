<xsl:stylesheet
    exclude-resut-prefixes="d"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:d="http://docbook.org/ns/docbook"
    version='1.0'
    >
    <xsl:import href="xhtml/docbook.xsl"/>
    <xsl:param name="use.id.as.filename">1</xsl:param>
    <xsl:param name="html.stylesheet">style.css</xsl:param>
    <xsl:param name="itemizedlist.propagates.style">1</xsl:param>
    <xsl:param name="chunker.output.doctype-public">-//W3C//DTD XHTML 1.0 Transitional//EN</xsl:param>
    <xsl:param name="chunker.output.doctype-system">http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd</xsl:param>
    <!-- Parameters for Generating Strict Output. See:
    http://www.sagehill.net/docbookxsl/OtherOutputForms.html#StrictXhtmlValid
    -->
    <xsl:param name="css.decoration">0</xsl:param>
    <xsl:param name="ulink.target"></xsl:param>
    <xsl:param name="use.viewport">0</xsl:param>
    <!-- End of Strict Params -->    
    <xsl:param name="toc.section.depth">10</xsl:param> 
    <xsl:param name="generate.section.toc.level">10</xsl:param>
    <!-- Enable fop extensions - see:
    http://www.sagehill.net/docbookxsl/InstallingAnFO.html
    http://www.mail-archive.com/fop-users%40xmlgraphics.apache.org/msg06170.html
    -->
    <xsl:param name="fop1.extensions">1</xsl:param>

<xsl:template name="html_itemized_list">
    <div xmlns="http://www.w3.org/1999/xhtml" class="{name(.)}">
    <xsl:call-template name="anchor"/>
    <xsl:if test="title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <xsl:apply-templates select="*[not(self::listitem or self::title 
        or self::titleabbrev)]"/>

    <ul>
         <xsl:if test="@role">
             <xsl:attribute name="class">
                 <xsl:value-of select="@role"/>
             </xsl:attribute>
         </xsl:if>


      <xsl:if test="$css.decoration != 0">
        <xsl:attribute name="type">
          <xsl:call-template name="list.itemsymbol"/>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@spacing='compact'">
        <xsl:attribute name="compact">
          <xsl:value-of select="@spacing"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="listitem"/>
    </ul>
  </div>
</xsl:template>

<!-- Insert some AdSense Ads -->
<xsl:template name="user.header.navigation">
    <div class="site_nav_menu">
        <ul>
            <li><a href="{$docmake.output.path_to_root}">Home</a></li>
            <li><a href="{$docmake.output.path_to_root}humour/">Humour</a></li>
            <li><a href="{$docmake.output.path_to_root}philosophy/">Articles and Essays</a></li>
            <li><a href="{$docmake.output.path_to_root}puzzles/">Puzzles</a></li>
            <li><a href="{$docmake.output.path_to_root}art/">Computer Art</a></li>
        </ul>
    </div>
    <div class="center ads_top">
    <script type="text/javascript">
google_ad_client = "pub-2480595666283917";
google_ad_width = 468;
google_ad_height = 60;
google_ad_format = "468x60_as";
google_ad_type = "text";
google_ad_channel ="";
google_color_border = "336699";
google_color_text = "000000";
google_color_bg = "FFFFFF";
google_color_link = "0000FF";
google_color_url = "008000";
</script>
<script type="text/javascript"
  src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
    </div>
</xsl:template>

<xsl:template name="paragraph">
  <xsl:param name="class" select="''"/>
  <xsl:param name="content"/>

  <xsl:variable name="p">
    <p>
      <xsl:call-template name="language.attribute" />
      <xsl:call-template name="dir"/>
      <xsl:if test="$class != ''">
        <xsl:apply-templates select="." mode="class.attribute">
          <xsl:with-param name="class" select="$class"/>
        </xsl:apply-templates>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </p>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$html.cleanup != 0">
      <xsl:call-template name="unwrap.p">
        <xsl:with-param name="p" select="$p"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$p"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:legalnotice" mode="titlepage.mode">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$generate.legalnotice.link != 0">
      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir" select="$base.dir"/>
	  <xsl:with-param name="base.name" select="concat($id,$html.ext)"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="title">
        <xsl:apply-templates select="." mode="title.markup"/>
      </xsl:variable>

      <xsl:variable name="href">
        <xsl:apply-templates mode="chunk-filename" select="."/>
      </xsl:variable>

      <a href="{$href}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content"/>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <div>
                <xsl:apply-templates select="." mode="class.attribute"/>
                <xsl:apply-templates mode="titlepage.mode"/>
              </div>
            </body>
          </html>
          <xsl:value-of select="$chunk.append"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:call-template name="language.attribute" />
        <xsl:apply-templates select="." mode="class.attribute"/>
        <a id="{$id}"/>
        <xsl:apply-templates mode="titlepage.mode"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:programlisting|d:screen|d:synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:call-template name="anchor"/>

  <xsl:if test="$shade.verbatim != 0">
    <xsl:message>
      <xsl:text>The shade.verbatim parameter is deprecated. </xsl:text>
      <xsl:text>Use CSS instead,</xsl:text>
    </xsl:message>
    <xsl:message>
      <xsl:text>for example: pre.</xsl:text>
      <xsl:value-of select="local-name(.)"/>
      <xsl:text> { background-color: #E0E0E0; }</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$suppress-numbers = '0'       and @linenumbering = 'numbered'       and $use.extensions != '0'       and $linenumbering.extension != '0'">
      <xsl:variable name="rtf">
	<xsl:call-template name="apply-highlighting"/>
      </xsl:variable>
      <pre>
        <xsl:call-template name="language.attribute" />
        <xsl:apply-templates select="." mode="class.attribute"/>
	<xsl:call-template name="number.rtf.lines">
	  <xsl:with-param name="rtf" select="$rtf"/>
	</xsl:call-template>
      </pre>
    </xsl:when>
    <xsl:otherwise>
      <pre>
        <xsl:call-template name="language.attribute" />
        <xsl:apply-templates select="." mode="class.attribute"/>
	<xsl:call-template name="apply-highlighting"/>
      </pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <!-- * if you want output from the inline.charseq template wrapped in -->
  <!-- * something other than a Span, call the template with some value -->
  <!-- * for the 'wrapper-name' param -->
  <xsl:param name="wrapper-name">span</xsl:param>
  <xsl:element name="{$wrapper-name}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="class">
      <xsl:value-of select="local-name(.)"/>
    </xsl:attribute>
    <xsl:call-template name="language.attribute" />
    <xsl:call-template name="dir"/>
    <xsl:call-template name="generate.html.title"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </xsl:element>
</xsl:template>

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:call-template name="anchor"/>
    <xsl:call-template name="simple.xlink">
      <xsl:with-param name="content">
        <xsl:apply-templates/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:param>
  <code>
    <xsl:call-template name="language.attribute" />
    <xsl:apply-templates select="." mode="class.attribute"/>
    <xsl:call-template name="dir"/>
    <xsl:call-template name="generate.html.title"/>
    <xsl:copy-of select="$content"/>
    <xsl:call-template name="apply-annotations"/>
  </code>
</xsl:template>
</xsl:stylesheet>
