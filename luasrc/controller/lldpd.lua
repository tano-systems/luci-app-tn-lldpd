--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

module("luci.controller.lldpd", package.seeall)

function index()
	entry({"admin", "services", "lldpd"}, firstchild(), _("LLDPd"), 80)

	entry({"admin", "services", "lldpd", "config"}, cbi("lldpd/config"), _("Configure"), 1)

	entry({"admin", "services", "lldpd", "neighbors"}, template("lldpd/neighbors"), _("Neighbors"), 2)
	entry({"admin", "services", "lldpd", "neighbors_request"}, call("action_neighbors_request")).leaf = true

	entry({"admin", "services", "lldpd", "statistics"}, template("lldpd/statistics"), _("Statistics"), 3)
	entry({"admin", "services", "lldpd", "statistics_request"}, call("action_statistics_request")).leaf = true

	entry({"admin", "services", "lldpd", "information"}, call("action_information"), _("Information"), 4)

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
	luci.http.write(lldpcli_show("neighbors", "json"))
end

-- Statistics page

function action_statistics_request()
	luci.http.prepare_content("application/json")
	luci.http.write(lldpcli_show("statistics", "json"))
end

-- Information page

function action_information()
	local lldpd_configuration = lldpcli_show("configuration")
	local lldpd_chassis = lldpcli_show("chassis")
	local lldpd_interfaces = lldpcli_show("interfaces")

	luci.template.render("lldpd/information", {
		lldpd_configuration = lldpd_configuration,
		lldpd_chassis       = lldpd_chassis,
		lldpd_interfaces    = lldpd_interfaces
	})
end
