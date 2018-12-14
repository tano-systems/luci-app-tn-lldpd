# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

All dates in this document are in `DD.MM.YYYY` format.

## [Unreleased]
### Added
- Additional JavaScript checks for case when LLDPd not started.

## [Version 1.2.0] (15.12.2018)
### Added
- This CHANGELOG.md file.
- New screenshots.
- Extra validators for parameters.
- Local chassis information view.
- The ability to configure the following new parameters:
  * Port ID subtype applied to all interfaces (MAC or name of the interface)
  * The destination MAC address used to send LLDPDU
  * Receive-only mode (lldpd -r parameter)
  * Interfaces to use for computing chassis ID (lldpd -C parameter)
  * Filter neighbors (lldpd -H parameter)
  * Disable LLDP-MED inventory TLV transmission (lldpd -i parameter)
- Extra comments for existing parameters.

### Changed
- Improved tables appearance and usability. Allow to collapse/expand additional information
  for each table row.
- Merged status and config menu items as 3rd level pages under "Services"
  main menu item.

### Fixed
- HTML markup and JavaScript fixes.

## [Version 1.1.1] (18.09.2018)
### Fixed
- Fixed lldpd service reloading.
- Some HTML markup fixes.

## [Version 1.1.0] (17.07.2018)
### Added
- Added support for LuCI from OpenWrt 18.06.x branch.

## [Version 1.0.0] (05.07.2018)

Initial release

[Version 1.2.0]: https://github.com/tano-systems/luci-app-lldpd/releases/tag/v1.2.0
[Version 1.1.1]: https://github.com/tano-systems/luci-app-lldpd/releases/tag/v1.1.1
[Version 1.1.0]: https://github.com/tano-systems/luci-app-lldpd/releases/tag/v1.1.0
[Version 1.0.0]: https://github.com/tano-systems/luci-app-lldpd/releases/tag/v1.0.0
