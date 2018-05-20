--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

m = Map("lldpd",
	translate("Link Layer Discovery Protocol"),
	translate("This page allows you to configure lldpd")
)

s = m:section(TypedSection, "lldpd")

function s.parse(self, ...)
	TypedSection.parse(self, ...)
	os.execute("/etc/init.d/lldpd reload")
end

s:tab("general", translate("General Settings"))
s:tab("protocols", translate("Protocols"))

s.anonymous = true
s.addremove = false

-- General tab

lldp_description = s:taboption("general", Value, "lldp_description",
	translate("Description"),
	translate("")
)

lldp_hostname = s:taboption("general", Value, "lldp_hostname",
	translate("Hostname"),
	translate("")
)

lldp_hostname = s:taboption("general", Value, "lldp_location",
	translate("Location"),
	translate("")
)

lldp_tx_internal = s:taboption("general", Value, "lldp_tx_interval",
	translate("Transmit interval"),
	translate("Seconds")
)

lldp_tx_internal.datatype = "uinteger"
lldp_tx_internal.placeholder = 10

lldp_class = s:taboption("general", Value, "lldp_class",
	translate("Class"),
	translate("")
)

lldp_class.datatype = "uinteger"
lldp_class.placeholder = 4

agentxsocket = s:taboption("general", Value, "agentxsocket",
	translate("SNMP agentX socket path"),
	translate("")
)

agentxsocket.rmempty = false

-- Protocols tab

enable_cdp = s:taboption("protocols", Flag, "enable_cdp",
	translate("Enable CDP"),
	translate("")
)

enable_cdp.rmempty = false

enable_fdp = s:taboption("protocols", Flag, "enable_fdp",
	translate("Enable FDP"),
	translate("")
)

enable_fdp.rmempty = false

enable_sonmp = s:taboption("protocols", Flag, "enable_sonmp",
	translate("Enable SONMP"),
	translate("")
)

enable_sonmp.rmempty = false

enable_edp = s:taboption("protocols", Flag, "enable_edp",
	translate("Enable EDP"),
	translate("")
)

enable_edp.rmempty = false

return m
