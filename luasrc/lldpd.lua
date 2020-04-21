--
-- Copyright (c) 2018, Tano Systems. All Rights Reserved.
-- Anton Kikin <a.kikin@tano-systems.com>
--

module "luci.lldpd"

local app_version = "1.3.0"
local app_home = "https://github.com/tano-systems/luci-app-tn-lldpd"

function version()
	return app_version
end

function home()
	return app_home
end
