<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

     <!-- Identity template -->
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Override for target element -->
    <xsl:template match="dns[@enable='yes']">
        <!-- Copy the element -->
        <xsl:copy>
            <!-- Add everything inside it -->
            <xsl:apply-templates select="@* | *"/>
            <!-- SRV records -->
            ${dns_srv_records}
            <!-- PTR records -->
            ${dns_ptr_records}
            <!-- TXT records -->
            ${dns_txt_records}
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>