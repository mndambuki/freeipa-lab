<xsl:element name="srv">
    <xsl:attribute name="service">ldap</xsl:attribute>
    <xsl:attribute name="protocol">tcp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">389</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
<xsl:element name="srv">
    <xsl:attribute name="service">kerberos</xsl:attribute>
    <xsl:attribute name="protocol">tcp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">88</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
<xsl:element name="srv">
    <xsl:attribute name="service">kerberos</xsl:attribute>
    <xsl:attribute name="protocol">udp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">88</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
<xsl:element name="srv">
    <xsl:attribute name="service">kerberos-master</xsl:attribute>
    <xsl:attribute name="protocol">tcp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">88</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
<xsl:element name="srv">
    <xsl:attribute name="service">kerberos-master</xsl:attribute>
    <xsl:attribute name="protocol">udp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">88</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
<xsl:element name="srv">
    <xsl:attribute name="service">kpasswd</xsl:attribute>
    <xsl:attribute name="protocol">tcp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">464</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
<xsl:element name="srv">
    <xsl:attribute name="service">kpasswd</xsl:attribute>
    <xsl:attribute name="protocol">udp</xsl:attribute>
    <xsl:attribute name="target">${freeipa_host_fqdn}</xsl:attribute>
    <xsl:attribute name="port">464</xsl:attribute>
    <xsl:attribute name="priority">0</xsl:attribute>
    <xsl:attribute name="weight">100</xsl:attribute>
</xsl:element>/>
