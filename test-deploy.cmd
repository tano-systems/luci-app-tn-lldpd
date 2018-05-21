@echo off

set LUCI_PATH=/usr/lib/lua/5.1/luci

set HOST=%1
set PASSWORD=%2
set EXTRA_OPTIONS=-pw "%PASSWORD%"

if [%HOST%] == [] goto host_empty

pscp -r %EXTRA_OPTIONS% %PASSWORD% %~dp0/luasrc/* %HOST%:%LUCI_PATH%

rem Clear LuCI index cache
plink %EXTRA_OPTIONS% %HOST% "/etc/init.d/uhttpd stop; rm -rf /tmp/luci-*; /etc/init.d/uhttpd start"

echo Success
goto done

:host_empty
echo Usage: %0 [user@]host [password]

:done
