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
            <!-- And everything inside it -->
            <xsl:apply-templates select="@* | *"/>
            <!-- A records for FreeIPA master -->
            <host ip="${freeipa_master_ip}">
                <hostname>${freeipa_console_cname}</hostname>
                <hostname>${freeipa_ldap_cname}</hostname>
            </host>
            <!-- A records for FreeIPA replicas -->
            <host ip="${freeipa_replica_ip}">
                <hostname>${freeipa_console_cname}</hostname>
                <hostname>${freeipa_ldap_cname}</hostname>
            </host>
            <!-- SRV records for FreeIPA master -->
            <xsl:element name="srv">
                <xsl:attribute name="service">ldap</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">389</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos</xsl:attribute>
                <xsl:attribute name="protocol">udp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos-master</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos-master</xsl:attribute>
                <xsl:attribute name="protocol">udp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kpasswd</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">464</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kpasswd</xsl:attribute>
                <xsl:attribute name="protocol">udp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_master_fqdn}</xsl:attribute>
                <xsl:attribute name="port">464</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <!-- SRV records for FreeIPA replicas -->
            <xsl:element name="srv">
                <xsl:attribute name="service">ldap</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">389</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos</xsl:attribute>
                <xsl:attribute name="protocol">udp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos-master</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kerberos-master</xsl:attribute>
                <xsl:attribute name="protocol">udp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">88</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kpasswd</xsl:attribute>
                <xsl:attribute name="protocol">tcp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">464</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="srv">
                <xsl:attribute name="service">kpasswd</xsl:attribute>
                <xsl:attribute name="protocol">udp</xsl:attribute>
                <xsl:attribute name="target">${freeipa_replica_fqdn}</xsl:attribute>
                <xsl:attribute name="port">464</xsl:attribute>
                <xsl:attribute name="priority">0</xsl:attribute>
                <xsl:attribute name="weight">100</xsl:attribute>
            </xsl:element>/>
            <!-- PTR records -->
            <xsl:element name="ptr">
                <xsl:attribute name="name">${freeipa_master_ptr}.in-addr.arpa</xsl:attribute>
                <xsl:attribute name="value">${freeipa_master_fqdn}</xsl:attribute>
            </xsl:element>/>
            <xsl:element name="ptr">
                <xsl:attribute name="name">${freeipa_replica_ptr}.in-addr.arpa</xsl:attribute>
                <xsl:attribute name="value">${freeipa_replica_fqdn}</xsl:attribute>
            </xsl:element>/>
            <!-- TXT records -->
            <xsl:element name="txt">
                <xsl:attribute name="name">_KERBEROS.${kerberos_realm}</xsl:attribute>
                <xsl:attribute name="value">${kerberos_realm}</xsl:attribute>
            </xsl:element>/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>