--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

local util = require "luci.util"

local m, s, o

m = Map("lldpd",
	translate("LLDP: Configure"),
	translate(
		"LLDPd is a implementation of IEEE 802.1ab " ..
		"(<abbr title=\"Link Layer Discovery Protocol\">LLDP</abbr>)."
	) ..
	translate(
		"On this page you may configure LLDPd parameters."
	)
)

s = m:section(TypedSection, "lldpd")
s.anonymous = true
s.addremove = false

s:tab("general", translate("General Settings"))
s:tab("ifaces", translate("Network Interfaces"))
s:tab("advanced", translate("Advanced Settings"))
s:tab("protocols", translate("Advanced Protocols Support"))

--
-- General settings
--

-- System description
o = s:taboption("general", Value, "lldp_description",
	translate("System description"),
	translate(
		"Override system description with the provided description."
	)
)

o.placeholder = "System description"

-- System hostname
o = s:taboption("general", Value, "lldp_hostname",
	translate("System hostname"),
	translate(
		"Override system hostname with the provided value."
	)
)

o.placeholder = "System hostname"

-- Platform
o = s:taboption("general", Value, "lldp_platform",
	translate("System platform description"),
	translate(
		"Override the CDP platform name with the provided value. " ..
		"The default description is the kernel name (Linux)."
	)
)

o.placeholder = "System platform description"

-- LLDP tx interval
o = s:taboption("general", Value, "lldp_tx_interval",
	translate("Transmit delay"),
	translate(
		"The transmit delay is the delay between two " ..
		"transmissions of LLDP PDU. The default value " ..
		"is 30 seconds."
	)
)

o.datatype = "uinteger"
o.default = 30
o.placeholder = 30
o.rmempty = false

-- LLDP tx hold
o = s:taboption("general", Value, "lldp_tx_hold",
	translate("Transmit hold value"),
	translate(
		"This value is used to compute the TTL of transmitted " ..
		"packets which is the product of this value and of the " ..
		"transmit delay. The default value is 4 and therefore " ..
		"the default TTL is 120 seconds."
	)
)

o.datatype = "uinteger"
o.default = 4
o.placeholder = 4
o.rmempty = false

-- TODO: Validate (can't be zero)

-- Received-only mode (-r)
o = s:taboption("general", Flag, "readonly_mode",
	translate("Enable receive-only mode"),
	translate(
		"With this option, LLDPd will not send any frames. " ..
		"It will only listen to neighbors"
	)
)

o.default = false

--
-- Network Interfaces
--

-- Interfaces to listen on
o = s:taboption("ifaces", DynamicList, "interface",
	translate("Network interfaces"),
	translate(
		"Specify which interface to listen and send LLDPDU to." ..
		"If no interfaces is specified, LLDPd will use all available physical interfaces."
	)
)

o.template  = "cbi/network_ifacelist"
o.nobridges = true
o.rmempty   = true
o.nocreate  = true
o.network   = ""
o.widget    = "checkbox"

-- ChassisID interfaces
o = s:taboption("ifaces", DynamicList, "cid_interface",
	translate("Network interfaces for ChassisID computing"),
	translate(
		"Specify which interfaces to use for computing chassis ID. " ..
		"If no interfaces is specified, all interfaces are considered. " ..
		"LLDPd will take the first MAC address from all the considered " ..
		"interfaces to compute the chassis ID."
	)
)

o.template  = "cbi/network_ifacelist"
o.nobridges = true
o.rmempty   = true
o.nocreate  = true
o.network   = ""
o.widget    = "checkbox"


--
-- Advanced Settings
--

-- SNMP agentX socket
o = s:taboption("advanced", Value, "agentxsocket",
	translate("SNMP agentX socket path"),
	translate(
		"If the path to the socket is set, then LLDPd will enable an " ..
		"SNMP subagent using AgentX protocol. This allows you to get " ..
		"information about local system and remote systems through SNMP."
	)
)

o.rmempty = false
o.placeholder = "/var/run/agentx.sock"
o.default = "/var/run/agentx.sock"


-- LLDP class
o = s:taboption("advanced", ListValue, "lldp_class",
	translate("LLDP-MED frame emission")
)

o:value(0, translate("Disable"))
o:value(1, translate("Generic Endpoint (Class I)"))
o:value(2, translate("Media Endpoint (Class II)"))
o:value(3, translate("Communication Device Endpoints (Class III)"))
o:value(4, translate("Network Connectivity Device (Class IV)"))

o.default = 4

-- LLDP-MED inventory TLV transmission (-i)
o = s:taboption("advanced", Flag, "lldpmed_no_inventory",
	translate("Disable LLDP-MED inventory TLV transmission"),
	translate(
		"LLDPd will still receive (and publish using SNMP if enabled) " ..
		"those LLDP-MED TLV but will not send them. Use this option " ..
		"if you don't want to transmit sensible information like serial numbers"
	)
)

o.default = false

-- Filter neighbors (-H)
o = s:taboption("advanced", Value, "filter",
	translate("Select neighbors filter"),
	translate(
		"For more details see \"FILTERING NEIGHBORS\" section " ..
		"<a href=\"https://vincentbernat.github.io/lldpd/usage.html\">here</a>."
	)
)

o.template = "lldpd/filter_select"
o.default  = 15

--
-- Advanced Protocols Support
--
o = s:taboption("protocols", Flag, "enable_cdp",
	translate("Enable <abbr title=\"Cisco Discovery Protocol\">CDP</abbr>"),
	translate("<abbr title=\"Cisco Discovery Protocol\">CDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Cisco Systems")
)

o.default = true
o.rmempty = false

o = s:taboption("protocols", Flag, "enable_fdp",
	translate("Enable <abbr title=\"Foundry Discovery Protocol\">FDP</abbr>"),
	translate("<abbr title=\"Foundry Discovery Protocol\">FDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Foundry Networks")
)

o.default = true
o.rmempty = false

o = s:taboption("protocols", Flag, "enable_edp",
	translate("Enable <abbr title=\"Extreme Discovery Protocol\">EDP</abbr>"),
	translate("<abbr title=\"Extreme Discovery Protocol\">EDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Extreme Networks")
)

o.default = true
o.rmempty = false

o = s:taboption("protocols", Flag, "enable_sonmp",
	translate("Enable <abbr title=\"Nortel Discovery Protocol\">NDP</abbr> " ..
		"(<abbr title=\"Bay Network Management Protocol\">BNMP</abbr>, " ..
		"<abbr title=\"Bay Discovery Protocol\">BDP</abbr>, " ..
		"<abbr title=\"Nortel Topology Discovery Protocol\">NTDP</abbr>, " ..
		"<abbr title=\"SynOptics Network Management Protocol\">SONMP</abbr>)"),
	translate("<abbr title=\"Nortel Discovery Protocol\">NDP</abbr> is a proprietary " ..
		"Data Link Layer protocol developed by Nortel"
	)
)

o.default = true
o.rmempty = false

s = m:section(SimpleSection, nil)
s.template = "lldpd/footer"

return m
