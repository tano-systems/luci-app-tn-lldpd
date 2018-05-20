--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

module("luci.controller.lldpd", package.seeall)

function index()
	entry({"admin", "services", "lldpd"}, firstchild(), _("LLDP"), 80)
	entry({"admin", "services", "lldpd", "config"}, cbi("lldpd/config"), _("Configure"), 1)
	entry({"admin", "services", "lldpd", "neighbors"}, call("action_neighbors"), _("Neighbors"), 2)
	entry({"admin", "services", "lldpd", "information"}, call("action_information"), _("Information"), 3)
end

-- LLDPCLI commands

function lldpcli_show_neighbors()
	return luci.util.exec("lldpcli show neighbors")
end

function lldpcli_show_statistics()
	return luci.util.exec("lldpcli show statistics")
end

function lldpcli_show_interfaces()
	return luci.util.exec("lldpcli show interfaces")
end

function lldpcli_show_configuration()
	return luci.util.exec("lldpcli show configuration")
end

function lldpcli_show_chassis()
	return luci.util.exec("lldpcli show chassis")
end

-- Neighbors page

function action_neighbors()
	local lldpd_neighbors = lldpcli_show_neighbors()
	luci.template.render("lldpd/neighbors", {lldpd_neighbors=lldpd_neighbors})
end

-- Information page

function action_information()
	local lldpd_statistics    = lldpcli_show_statistics()
	local lldpd_configuration = lldpcli_show_configuration()
	local lldpd_chassis       = lldpcli_show_chassis()
	local lldpd_interfaces    = lldpcli_show_interfaces()

	luci.template.render("lldpd/information", {
		lldpd_statistics    = lldpd_statistics,
		lldpd_configuration = lldpd_configuration,
		lldpd_chassis       = lldpd_chassis,
		lldpd_interfaces    = lldpd_interfaces,
	})
end
