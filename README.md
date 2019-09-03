# LuCI support for LLDP daemon

## Description
This package allows you to control LLDPd and view discovered neighbors by LLDPd
in LuCI web interface.

## Dependencies
Package depends on lldpd package.

LLDPd LuCI application developed for LuCI 18.06 branch. For OpenWrt/LEDE 17.01
use old luci-app-lldpd [version 1.0.0].

Starting with [version 1.2.0], in order for all available settings to work correctly,
you must use the modified procd initialization script for lldpd, that can be founded
in [meta-tanowrt](https://github.com/tano-systems/meta-tanowrt.git) OpenEmbedded layer.

## Supported languages
- Russian
- English

## Screenshots

### Status

#### Discovered neighbors
![Discovered neighbors](screenshots/luci-app-lldpd-status-neighbors.png?raw=true "Discovered neighbors")

#### Local interfaces statistics
![Local interfaces statistics](screenshots/luci-app-lldpd-status-statistics.png?raw=true "Local interfaces statistics")

#### Local chassis information
![Local chassis](screenshots/luci-app-lldpd-status-chassis.png?raw=true "Local chassis")

### Settings

#### Basic settings
![Basic settings](screenshots/luci-app-lldpd-settings-basic.png?raw=true "Basic settings")

#### Network interfaces settings
![Network interfaces](screenshots/luci-app-lldpd-settings-interfaces.png?raw=true "Network interfaces")

#### Advanced settings
![Advanced settings](screenshots/luci-app-lldpd-settings-advanced.png?raw=true "Advanced settings")

#### Protocols support
![Protocols support](screenshots/luci-app-lldpd-settings-protocols.png?raw=true "Protocols support")

[version 1.2.0]: https://github.com/tano-systems/luci-app-lldpd/releases/tag/v1.2.0
[version 1.0.0]: https://github.com/tano-systems/luci-app-lldpd/releases/tag/v1.0.0
