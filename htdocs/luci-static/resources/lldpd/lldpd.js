/*
 * Copyright (c) 2018, Tano Systems. All Rights Reserved.
 * Anton Kikin <a.kikin@tano-systems.com>
 */

function lldpd_cell_id(str)
{
	return str.replace(/[^a-z0-9]/gi, '-')
}

function lldpd_fmt_number(v)
{
	if (parseInt(v))
		return v

	return '&ndash;'
}

function lldpd_fmt_port_id_type(v)
{
	if (v == 'mac')
		return _("MAC address")
	else if (v == 'ifname')
		return _("Interface name")
	else if (v == 'local')
		return _("Local ID")
	else if (v == 'ip')
		return _("IP address")

	return v
}

function lldpd_fmt_protocol(v)
{
	if (v == 'unknown')
		return "&ndash;"
	else if (v == 'LLDP')
		return '<span class="alert-message success">' + v + '</span>'
	else if ((v == 'CDPv1') || (v == 'CDPv2'))
		return '<span class="alert-message info">' + v + '</span>'
	else if ((v == 'FDP') || (v == 'EDP') || (v == 'SONMP'))
		return '<span class="alert-message warning">' + v + '</span>'
	else
		return '<span class="alert-message error">' + v + '</span>'
}

function lldpd_kvtable_add_row(description, value)
{
	if (typeof value == 'undefined')
		return

	return '<tr><td>' + description +
		':</td><td>' + value + '</td></tr>'
}

function lldpd_fmt_chassis_kvtable(ch)
{
	var unfolded = ''

	unfolded += '<table class="lldpd-kvtable">'
	unfolded += lldpd_kvtable_add_row(_("Name"), ch.name[0].value)
	unfolded += lldpd_kvtable_add_row(_("Description"), ch.descr[0].value)
	unfolded += lldpd_kvtable_add_row(_("ID type"), lldpd_fmt_port_id_type(ch.id[0].type))
	unfolded += lldpd_kvtable_add_row(_("ID"), ch.id[0].value)

	// Management addresses
	if (typeof ch["mgmt-ip"] !== 'undefined')
	{
		var ips = ""

		if (ch["mgmt-ip"].length > 0)
		{
			// Array of addresses
			for (var ip = 0; ip < ch["mgmt-ip"].length; ip++)
				ips += ch["mgmt-ip"][ip].value + "<br />"
		}
		else
		{
			// One address
			ips += ch["mgmt-ip"][0].value
		}

		unfolded += lldpd_kvtable_add_row(_("Management IP(s)"), ips)
	}

	if (typeof ch.capability !== 'undefined')
	{
		var caps = ""

		if (ch.capability.length > 0)
		{
			// Array of capabilities
			for (var cap = 0; cap < ch.capability.length; cap++)
			{
				caps += ch.capability[cap].type
				caps += " (" + (ch.capability[cap].enabled ? _("enabled") : _("disabled")) + ")"
				caps += "<br />"
			}
		}
		else
		{
			// One capability
			caps += ch.capability[0].type
			caps += " (" + (ch.capability[0].enabled ? _("enabled") : _("disabled")) + ")"
		}

		unfolded += lldpd_kvtable_add_row(_("Capabilities"), caps)
		unfolded += "</td></tr>"
	}

	unfolded += "</table>"

	return unfolded
}

function lldpd_fmt_chassis(ch)
{
	var folded = ''

	if (typeof ch.name[0].value !== 'undefined' &&
	    typeof ch.descr[0].value !== 'undefined')
	{
		folded += '<strong>' + ch.name[0].value + '</strong>'
		folded += '<br />' + ch.descr[0].value
	}
	else if (typeof ch.name[0].value !== 'undefined')
		folded += '<strong>' + ch.name[0].value + '</strong>'
	else if (typeof ch.descr[0].value !== 'undefined')
		folded += ch.descr[0].value
	else if (typeof ch.id[0].value !== 'undefined')
		folded += ch.id[0].value
	else
		folded += _('Unknown')

	return folded
}

function lldpd_fmt_port_kvtable(port)
{
	var unfolded = ''

	unfolded = '<table class="lldpd-kvtable">'
	unfolded += lldpd_kvtable_add_row(_("Name"), port.name)
	unfolded += lldpd_kvtable_add_row(_("Age"), port.age)

	if (typeof port.port !== 'undefined')
	{
		if (typeof port.port[0].id !== 'undefined')
		{
			unfolded += lldpd_kvtable_add_row(_("Port ID type"),
				lldpd_fmt_port_id_type(port.port[0].id[0].type))

			unfolded += lldpd_kvtable_add_row(_("Port ID"), port.port[0].id[0].value)
		}

		if (typeof port.port[0].descr !== 'undefined')
			unfolded += lldpd_kvtable_add_row(_("Port description"), port.port[0].descr[0].value)

		if (typeof port.ttl !== 'undefined')
			unfolded += lldpd_kvtable_add_row(_("TTL"), port.ttl[0].ttl)
		else if (port.port[0].ttl !== 'undefined')
			unfolded += lldpd_kvtable_add_row(_("TTL"), port.port[0].ttl[0].value)
	}

	unfolded += "</table>"

	return unfolded
}

function lldpd_fmt_port(port)
{
	var folded = ''

	if (typeof port.port !== 'undefined')
	{
		if (typeof port.port[0].descr !== 'undefined' &&
		    typeof port.port[0].id[0].value !== 'undefined' &&
		    port.port[0].descr[0].value !== port.port[0].id[0].value)
		{
			folded += '<strong>' + port.port[0].descr[0].value + '</strong>' +
				'<br />' + port.port[0].id[0].value
		}
		else
		{
			if (typeof port.port[0].descr !== 'undefined')
				folded += port.port[0].descr[0].value
			else
				folded += port.port[0].id[0].value
		}
	}
	else
	{
		folded = "%s".format(port.name)
	}

	return folded
}

var lldpd_cell_folded = []

function lldpd_folding_img_file(folded) {
	return L.resource('lldpd/details_' +
		(folded ? 'show' : 'hide') + '.svg')
}

function lldpd_folding_icon(cell_id)
{
	var img = L.resource('lldpd/details_' +
		(lldpd_cell_folded[cell_id] ? 'hide' : 'show') + '.svg')

	return '<img width="16px" src="' +
		lldpd_folding_img_file(lldpd_cell_folded[cell_id]) +
		'" onclick="lldpd_folding_toggle(this, \'' + cell_id + '\')" />'
}

function lldpd_folding_toggle(img, cell_id)
{
	var e_folded   = document.querySelectorAll("[id='lldpd-cell-" + cell_id + "-folded']");
	var e_unfolded = document.querySelectorAll("[id='lldpd-cell-" + cell_id + "-unfolded']");

//	var e_folded   = document.getElementById('lldpd-cell-' + cell_id + '-folded')
//	var e_unfolded = document.getElementById('lldpd-cell-' + cell_id + '-unfolded')

	if (e_folded.length != e_unfolded.length)
		return

	var do_fold = (e_folded[0].style.display === "none")
	lldpd_cell_folded[cell_id] = do_fold

	for (var i = 0; i < e_folded.length; i++)
	{
		e_folded[i].style.display = do_fold ? "block" : "none"
		e_unfolded[i].style.display = do_fold ? "none"  : "block"
	}

	img.src = lldpd_folding_img_file(do_fold)
}

function lldpd_folding_cell_add(cell_id, folded, unfolded, icon, default_folded)
{
	var cell = ''

	if (typeof lldpd_cell_folded[cell_id] == 'undefined')
		lldpd_cell_folded[cell_id] = default_folded

	cell += '<div style="display: flex; flex-wrap: nowrap">'

	/* Fold/unfold icon */
	if (icon)
	{
		cell += '<div style="padding: 0 8px 0 0">'
		cell += lldpd_folding_icon(cell_id)
		cell += '</div>'
	}

	cell += '<div id="lldpd-cell-' + cell_id + '-folded" ' +
		'style="display:' + (lldpd_cell_folded[cell_id] ? 'block' : 'none') + '">'
	cell += folded
	cell += '</div>'

	cell += '<div id="lldpd-cell-' + cell_id + '-unfolded" ' +
		'style="display:' + (lldpd_cell_folded[cell_id] ? 'none' : 'block') + '">'
	cell += unfolded
	cell += '</div>'

	cell += '</div>'

	return cell
}
