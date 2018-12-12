--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

module("luci.controller.lldpd", package.seeall)

require("luci.sys")

function index()
	if not nixio.fs.access("/etc/config/lldpd") then
		return
	end

	entry({"admin", "services", "lldpd"}, firstchild(), _("LLDP"), 80)

	entry({"admin", "services", "lldpd", "status"}, firstchild(), _("Status"), 10)
	entry({"admin", "services", "lldpd", "config"}, cbi("lldpd/config"), _("Settings"), 20)

	entry({"admin", "services", "lldpd", "status", "neighbors"},
		template("lldpd/neighbors"), _("Neighbors"), 10)

	entry({"admin", "services", "lldpd", "status", "statistics"},
		template("lldpd/statistics"), _("Statistics"), 20)

	entry({"admin", "services", "lldpd", "get_neighbors"},
		call("action_get_neighbors"))

	entry({"admin", "services", "lldpd", "get_statistics"},
		call("action_get_statistics"))
end

-- LLDPCLI commands

function lldpcli_show(section, format)
	if not format then
		format = "plain"
	end

	return luci.util.exec("lldpcli show " .. section .. " -f " .. format)
end

-- Neighbors page

function action_get_neighbors()
	luci.http.prepare_content("application/json")
	luci.http.write(lldpcli_show("neighbors", "json0"))
end

-- Statistics page

function action_get_statistics()
	luci.http.prepare_content("application/json")
	
	luci.http.write('{"statistics":');
	luci.http.write(lldpcli_show("statistics", "json0"))
	luci.http.write(',');

	luci.http.write('"interfaces":');
	luci.http.write(lldpcli_show("interfaces", "json0"))
	luci.http.write('}');
end

