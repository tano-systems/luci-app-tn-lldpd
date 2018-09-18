--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

local util = require "luci.util"

m = Map("lldpd",
	translate("LLDPd: Configure"),
	translate(
		"<p>LLDPd is a implementation of IEEE 802.1ab " ..
		"(<abbr title=\"Link Layer Discovery Protocol\">LLDP</abbr>)</p>"
	)
)

s = m:section(TypedSection, "lldpd", translate("General settings"))

s.anonymous = true
s.addremove = false

--
-- General settings
--

-- System description
lldp_description = s:option(Value, "lldp_description",
	translate("Description")
)

lldp_description.placeholder = "System description"

-- System hostname
lldp_hostname = s:option(Value, "lldp_hostname",
	translate("Hostname")
)

lldp_hostname.placeholder = "System hostname"

-- System location
lldp_location = s:option(Value, "lldp_location",
	translate("Location")
)

lldp_location.placeholder = "System location"

-- LLDP class
lldp_class = s:option(Value, "lldp_class",
	translate("Class")
)

lldp_class.datatype = "uinteger"
lldp_class.placeholder = 4

-- LLDP tx interval
lldp_tx_internal = s:option(Value, "lldp_tx_interval",
	translate("Transmit interval"),
	translate("Seconds")
)

lldp_tx_internal.datatype = "uinteger"
lldp_tx_internal.placeholder = 10

-- SNMP agentX socket
agentxsocket = s:option(Value, "agentxsocket",
	translate("SNMP agentX socket path")
)

agentxsocket.rmempty = false
agentxsocket.placeholder = "/var/run/agentx.sock"

--
-- Advanced settings
--

s = m:section(TypedSection, "lldpd", translate("Advanced settings"))

s.anonymous = true

s:tab("interfaces", translate("Interfaces"))
s:tab("protocols", translate("Protocols"))

--
-- Interfaces tab
--

-- Interfaces to listen on
ifname_multi = s:taboption("interfaces", DynamicList, "interface",
	translate("Interfaces")
)

ifname_multi.template  = "cbi/network_ifacelist"
ifname_multi.nobridges = true
ifname_multi.rmempty   = false
ifname_multi.nocreate  = true
ifname_multi.network   = ""
ifname_multi.widget    = "checkbox"

--
-- Protocols tab
--

enable_cdp = s:taboption("protocols", Flag, "enable_cdp",
	translate("Enable <abbr title=\"Cisco Discovery Protocol\">CDP</abbr>"),
	translate("<abbr title=\"Cisco Discovery Protocol\">CDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Cisco Systems")
)

enable_cdp.rmempty = false

enable_fdp = s:taboption("protocols", Flag, "enable_fdp",
	translate("Enable <abbr title=\"Foundry Discovery Protocol\">FDP</abbr>"),
	translate("<abbr title=\"Foundry Discovery Protocol\">FDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Foundry Networks")
)

enable_fdp.rmempty = false

enable_edp = s:taboption("protocols", Flag, "enable_edp",
	translate("Enable <abbr title=\"Extreme Discovery Protocol\">EDP</abbr>"),
	translate("<abbr title=\"Extreme Discovery Protocol\">EDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Extreme Networks")
)

enable_edp.rmempty = false

enable_sonmp = s:taboption("protocols", Flag, "enable_sonmp",
	translate("Enable <abbr title=\"Nortel Discovery Protocol\">NDP</abbr> " ..
		"(<abbr title=\"Bay Network Management Protocol\">BNMP</abbr>, " ..
		"<abbr title=\"Bay Discovery Protocol\">BDP</abbr>, " ..
		"<abbr title=\"Nortel Topology Discovery Protocol\">NTDP</abbr>, " ..
		"<abbr title=\"SynOptics Network Management Protocol\">SONMP</abbr>)"),
	translate("<abbr title=\"Nortel Discovery Protocol\">NDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Nortel"
	)
)

enable_sonmp.rmempty = false

f = m:section(SimpleSection, nil)
f.template = "lldpd/footer"

return m
