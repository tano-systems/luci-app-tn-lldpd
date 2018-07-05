--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

module("luci.controller.lldpd", package.seeall)

function index()
	entry({"admin", "services", "lldpd"}, cbi("lldpd/config"), _("LLDPd"), 80)

	entry({"admin", "status", "lldpd"}, firstchild(), _("LLDPd"), 80)

	entry({"admin", "status", "lldpd", "neighbors"}, template("lldpd/neighbors"), _("Neighbors"), 2)
	entry({"admin", "status", "lldpd", "neighbors_request"}, call("action_neighbors_request")).leaf = true

	entry({"admin", "status", "lldpd", "statistics"}, template("lldpd/statistics"), _("Statistics"), 3)
	entry({"admin", "status", "lldpd", "statistics_request"}, call("action_statistics_request")).leaf = true
end

-- LLDPCLI commands

function lldpcli_show(section, format)
	if not format then
		format = "plain"
	end

	return luci.util.exec("lldpcli show " .. section .. " -f " .. format)
end

-- Neighbors page

function action_neighbors_request()
	luci.http.prepare_content("application/json")
	luci.http.write(lldpcli_show("neighbors", "json0"))
end

-- Statistics page

function action_statistics_request()
	luci.http.prepare_content("application/json")
	
	luci.http.write('{"statistics":');
	luci.http.write(lldpcli_show("statistics", "json0"))
	luci.http.write(',');

	luci.http.write('"interfaces":');
	luci.http.write(lldpcli_show("interfaces", "json0"))
	luci.http.write('}');
end

