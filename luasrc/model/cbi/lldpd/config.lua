--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

local sys  = require "luci.sys"
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

s:tab("basic", translate("Basic Settings"))
s:tab("ifaces", translate("Network Interfaces"))
s:tab("advanced", translate("Advanced Settings"))
s:tab("protocols", translate("Protocols Support"))

-----------------------------------------------------------------------------------
--
-- Basic settings
--
-----------------------------------------------------------------------------------

-- Service enable/disable
o = s:taboption("basic", Flag, "enabled",
	translate("Enable service")
)

o.rmempty = false

function o.cfgvalue(self, section)
	return sys.init.enabled("lldpd") and self.enabled or self.disabled
end

function o.write(self, section, value)
	if value == "1" then
		sys.init.enable("lldpd")
		sys.call("/etc/init.d/lldpd start >/dev/null 2>&1")
	else
		sys.call("/etc/init.d/lldpd stop >/dev/null 2>&1")
		sys.init.disable("lldpd")
	end

	return Flag.write(self, section, value)
end

-- System description
o = s:taboption("basic", Value, "lldp_description",
	translate("System description"),
	translate(
		"Override system description with the provided description."
	)
)

o.placeholder = "System description"

-- System hostname
o = s:taboption("basic", Value, "lldp_hostname",
	translate("System hostname"),
	translate(
		"Override system hostname with the provided value."
	)
)

o.placeholder = "System hostname"

-- Platform
o = s:taboption("basic", Value, "lldp_platform",
	translate("System platform description"),
	translate(
		"Override the platform description with the provided value. " ..
		"The default description is the kernel name (Linux)."
	)
)

o.placeholder = "System platform description"

-- Management addresses of this system
o = s:taboption("basic", Value, "lldp_sys_mgmt_ip",
	translate("Management addresses of this system"),
	translate(
		"Specify the management addresses of this system. " ..
		"If not specified, the first IPv4 and the first " ..
		"IPv6 are used. If an exact IP address is provided, it is used " ..
		"as a management address without any check. If you want to " ..
		"blacklist IPv6 addresses, you can use <code>!*:*</code>. " ..
		"See more details about available patterns " ..
		"<a href=\"https://vincentbernat.github.io/lldpd/usage.html\">here</a>."
	)
)

o.placeholder = "Management addresses"

-- LLDP tx interval
o = s:taboption("basic", Value, "lldp_tx_interval",
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

function o.validate(self, value, section)
	if tonumber(value) <= 0 then
		return nil, translate("Transmit delay must be greater than 0")
	end
	return Value.validate(self, value, section)
end

-- LLDP tx hold
o = s:taboption("basic", Value, "lldp_tx_hold",
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

function o.validate(self, value, section)
	if tonumber(value) <= 0 then 
		return nil, translate("Transmit hold value must be greater than 0")
	end
	return Value.validate(self, value, section)
end

-- Received-only mode (-r)
o = s:taboption("basic", Flag, "readonly_mode",
	translate("Enable receive-only mode"),
	translate(
		"With this option, LLDPd will not send any frames. " ..
		"It will only listen to neighbors."
	)
)

o.default = "0"

-----------------------------------------------------------------------------------
--
-- Network Interfaces
--
-----------------------------------------------------------------------------------

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
	translate("Network interfaces for chassis ID computing"),
	translate(
		"Specify which interfaces to use for computing chassis ID. " ..
		"If no interfaces is specified, all interfaces are considered. " ..
		"LLDPd will take the first MAC address from all the considered " ..
		"interfaces to compute the chassis ID."
	)
)

o.template  = "cbi/network_ifacelist"
o.nobridges = false
o.rmempty   = true
o.nocreate  = true
o.network   = ""
o.widget    = "checkbox"


-----------------------------------------------------------------------------------
--
-- Advanced Settings
--
-----------------------------------------------------------------------------------

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
	translate("LLDP-MED device class")
)

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
		"if you don't want to transmit sensible information like serial numbers."
	)
)

o.default = "0"

-- Filter neighbors (-H)
o = s:taboption("advanced", Value, "filter",
	translate("Specify the behaviour when detecting multiple neighbors"),
	translate(
		"The default filter is 15. For more details see \"FILTERING NEIGHBORS\" section " ..
		"<a href=\"https://vincentbernat.github.io/lldpd/usage.html\">here</a>."
	)
)

o.template = "lldpd/filter_select"
o.default  = 15

-- Force port ID subtype
o = s:taboption("advanced", ListValue, "lldp_portidsubtype",
	translate("Force port ID subtype"),
	translate(
		"With this option, you can force the port identifier " ..
		"to be the interface name or the MAC address."
	)
)

o:value("macaddress", translate("Interface MAC address"))
o:value("ifname", translate("Interface name"))

o.default = "macaddress"

-- The destination MAC address used to send LLDPDU
o = s:taboption("advanced", ListValue, "lldp_agenttype",
	translate("The destination MAC address used to send LLDPDU"),
	translate(
		"The destination MAC address used to send LLDPDU allows an agent " ..
		"to control the propagation of LLDPDUs. By default, the " ..
		"<code>01:80:c2:00:00:0e</code> MAC address is used and limit the propagation " ..
		"of the LLDPDU to the nearest bridge."
	)
)

o:value("nearest-bridge",          "01:80:c2:00:00:0e (nearest-bridge)")
o:value("nearest-nontpmr-bridge",  "01:80:c2:00:00:03 (nearest-nontpmr-bridge)")
o:value("nearest-customer-bridge", "01:80:c2:00:00:00 (nearest-customer-bridge)")

o.default = "nearest-bridge"

-----------------------------------------------------------------------------------
--
-- Protocols Support
--
-----------------------------------------------------------------------------------

local function make_proto_subtitle(s, title)
	local t = s:taboption("protocols", DummyValue, "_cdp", "&#160;")
	t.default = '<h3>' .. title .. "</h3>"
	t.rawhtml = true
end

-- LLDP
make_proto_subtitle(s, translate("LLDP protocol"))

o = s:taboption("protocols", Flag, "enable_lldp",
	translate("Enable LLDP")
)

o.default = "1"
o.rmempty = true

--
o = s:taboption("protocols", Flag, "force_lldp",
	translate("Force to send LLDP packets"),
	translate(
		"Force to send LLDP packets even when there is no LLDP peer " ..
		"detected but there is a peer speaking another protocol detected. " ..
		"By default, LLDP packets are sent when there is a peer speaking " ..
		"LLDP detected or when there is no peer at all."
	)
)

o.default = "0"
o.rmempty = true
o:depends("enable_lldp", true)

-- CDP
make_proto_subtitle(s, translate("CDP protocol"))

o = s:taboption("protocols", Flag, "enable_cdp",
	translate("Enable CDP"),
	translate(
		"Enable the support of CDP protocol to deal with Cisco routers " ..
		"that do not speak LLDP"
	)
)

o.default = "1"
o.rmempty = false

--
o = s:taboption("protocols", ListValue, "cdp_version",
	translate("CDP version"))

o:value("cdpv1v2", translate("CDPv1 and CDPv2"))
o:value("cdpv2",   translate("Only CDPv2"))
o:depends("enable_cdp", true)

o.default = "cdpv1v2"

--
o = s:taboption("protocols", Flag, "force_cdp",
	translate("Send CDP packets even if no CDP peer detected"))

o.default = "0"
o.rmempty = true
o:depends("enable_cdp", true)

o = s:taboption("protocols", Flag, "force_cdpv2",
	translate("Force sending CDPv2 packets"))

o.default = "0"
o.rmempty = true
o:depends({
	force_cdp = true,
	enable_cdp = true,
	cdp_version = "cdpv1v2"
})

-- FDP
make_proto_subtitle(s, translate("FDP protocol"))

o = s:taboption("protocols", Flag, "enable_fdp",
	translate("Enable FDP"),
	translate(
		"Enable the support of FDP protocol to deal with Foundry routers " ..
		"that do not speak LLDP"
	)
)

o.default = "1"
o.rmempty = false

--
o = s:taboption("protocols", Flag, "force_fdp",
	translate("Send FDP packets even if no FDP peer detected"))

o.default = "0"
o.rmempty = true
o:depends("enable_fdp", true)

-- EDP
make_proto_subtitle(s, translate("EDP protocol"))

o = s:taboption("protocols", Flag, "enable_edp",
	translate("Enable EDP"),
	translate(
		"Enable the support of EDP protocol to deal with Extreme routers " ..
		"and switches that do not speak LLDP."
	)
)

o.default = "1"
o.rmempty = false

--
o = s:taboption("protocols", Flag, "force_edp",
	translate("Send EDP packets even if no EDP peer detected"))

o.default = "0"
o.rmempty = true
o:depends("enable_edp", true)

-- SONMP
make_proto_subtitle(s, translate("SONMP protocol"))

o = s:taboption("protocols", Flag, "enable_sonmp",
	translate("Enable SONMP"),
	translate(
		"Enable the support of SONMP protocol to deal with Nortel " ..
		"routers and switches that do not speak LLDP."
	)
)

o.default = "1"
o.rmempty = false

--
o = s:taboption("protocols", Flag, "force_sonmp",
	translate("Send SONMP packets even if no SONMP peer detected"))

o.default = "0"
o.rmempty = true
o:depends("enable_sonmp", true)

-----------------------------------------------------------------------------------

s = m:section(SimpleSection, nil)
s.template = "lldpd/footer"

return m
