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

	entry({"admin", "services", "lldpd", "status"}, template("lldpd/status"), _("Status"), 10)
	entry({"admin", "services", "lldpd", "config"}, cbi("lldpd/config"), _("Settings"), 20)

	entry({"admin", "services", "lldpd", "get_info"},
		call("action_get_info"))
end

-- LLDPCLI commands

function lldpcli_show(section, format)
	if not format then
		format = "plain"
	end

	return luci.util.exec("lldpcli show " .. section .. " -f " .. format)
end

-- Info

function action_get_info()

	luci.http.prepare_content("application/json")
	
	luci.http.write('{"statistics":');
	luci.http.write(lldpcli_show("statistics", "json0"))
	luci.http.write(',');

	luci.http.write('"neighbors":');
	luci.http.write(lldpcli_show("neighbors", "json0"))
	luci.http.write(',');

	luci.http.write('"interfaces":');
	luci.http.write(lldpcli_show("interfaces", "json0"))
	luci.http.write(',');

	luci.http.write('"chassis":');
	luci.http.write(lldpcli_show("chassis", "json0"))
	luci.http.write('}');
end
