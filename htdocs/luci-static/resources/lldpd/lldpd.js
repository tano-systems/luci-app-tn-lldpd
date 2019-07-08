/*
 * Copyright (c) 2018, Tano Systems. All Rights Reserved.
 * Anton Kikin <a.kikin@tano-systems.com>
 */

function lldpd_id(str)
{
	return str.replace(/[^a-z0-9]/gi, '-')
}

function lldpd_fmt_number(v)
{
	if (parseInt(v))
		return v

	return '&#8211;'
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

function lldpd_fmt_age(v)
{
	return '<nobr>' + v + '</nobr>'
}

function lldpd_fmt_protocol(v)
{
	if (v == 'unknown')
		return "&#8211;"
	else if (v == 'LLDP')
		return '<span class="lldpd-protocol-badge lldpd-protocol-lldp">' + v + '</span>'
	else if ((v == 'CDPv1') || (v == 'CDPv2'))
		return '<span class="lldpd-protocol-badge lldpd-protocol-cdp">' + v + '</span>'
	else if (v == 'FDP')
		return '<span class="lldpd-protocol-badge lldpd-protocol-fdp">' + v + '</span>'
	else if (v == 'EDP')
		return '<span class="lldpd-protocol-badge lldpd-protocol-edp">' + v + '</span>'
	else if (v == 'SONMP')
		return '<span class="lldpd-protocol-badge lldpd-protocol-sonmp">' + v + '</span>'
	else
		return '<span class="lldpd-protocol-badge">' + v + '</span>'
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

function lldpd_fmt_port_kvtable(port, only_id_and_ttl)
{
	var unfolded = ''

	unfolded = '<table class="lldpd-kvtable">'

	if (!only_id_and_ttl)
	{
		unfolded += lldpd_kvtable_add_row(_("Name"), port.name)
		unfolded += lldpd_kvtable_add_row(_("Age"), lldpd_fmt_age(port.age))
	}

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

var lldpd_row_folded = []

function lldpd_folding_img_file(folded) {
	return L.resource('lldpd/details_' +
		(folded ? 'show' : 'hide') + '.svg')
}

function lldpd_folding_toggle(row, row_id)
{
	var e_img      = document.getElementById("lldpd-fold-img-" + row_id);
	var e_folded   = document.querySelectorAll("[id='lldpd-cell-" + row_id + "-folded']");
	var e_unfolded = document.querySelectorAll("[id='lldpd-cell-" + row_id + "-unfolded']");

	if (e_folded.length != e_unfolded.length)
		return

	var do_fold = e_folded[0].classList.contains('lldpd-cell-hidden')
	lldpd_row_folded[row_id] = do_fold

	for (var i = 0; i < e_folded.length; i++)
	{
		if (do_fold)
		{
			e_folded[i].classList.remove("lldpd-cell-hidden")
			e_folded[i].classList.add("lldpd-cell-visible")
			e_unfolded[i].classList.remove("lldpd-cell-visible")
			e_unfolded[i].classList.add("lldpd-cell-hidden")
		}
		else
		{
			e_folded[i].classList.remove("lldpd-cell-visible")
			e_folded[i].classList.add("lldpd-cell-hidden")
			e_unfolded[i].classList.remove("lldpd-cell-hidden")
			e_unfolded[i].classList.add("lldpd-cell-visible")
		}
	}

	e_img.src = lldpd_folding_img_file(do_fold)
}

function lldpd_folding_row(row_id, cells_folded, cells_unfolded, default_folded)
{
	var row = []
	var len = cells_folded.length
	var i

	if (!len || (cells_folded.length != cells_unfolded.length))
		return null

	if (typeof lldpd_row_folded[row_id] == 'undefined')
		lldpd_row_folded[row_id] = default_folded

	for (i = 0; i < len; i++)
	{
		var cell = ''

		if (i == 0)
		{
			cell += '<div style="display: flex; flex-wrap: nowrap">'

			// Fold/unfold icon
			cell += '<div style="padding: 0 8px 0 0">'
			cell += '<img id="lldpd-fold-img-' + row_id + '" width="16px" src="' +
				lldpd_folding_img_file(lldpd_row_folded[row_id]) + '" />'

			cell += '</div><div>'
		}

		if ((cells_unfolded[i] !== null) && (cells_folded[i] !== null))
		{
			cell += '<div id="lldpd-cell-' + row_id + '-folded" ' +
				'class="lldpd-cell-' + (lldpd_row_folded[row_id] ? 'visible' : 'hidden') + '">'
			cell += cells_folded[i]
			cell += '</div>'

			cell += '<div id="lldpd-cell-' + row_id + '-unfolded" ' +
				'class="lldpd-cell-' + (lldpd_row_folded[row_id] ? 'hidden' : 'visible') + '">'
			cell += cells_unfolded[i]
			cell += '</div>'
		}
		else
		{
			cell += (cells_folded[i] == null)
				? cells_unfolded[i]
				: cells_folded[i]
		}

		if (i == 0)
			cell += '</div></div>'

		cell += '</div>'

		row.push(cell)
	}

	return row
}

function lldpd_update_table(table, data, placeholder) {
	var target = isElem(table) ? table : document.querySelector(table);

	if (!isElem(target))
		return;

	target.querySelectorAll('.tr.table-titles, .cbi-section-table-titles').forEach(function(thead) {
		var titles = [];

		thead.querySelectorAll('.th').forEach(function(th) {
			titles.push(th);
		});

		if (Array.isArray(data)) {
			var n = 0, rows = target.querySelectorAll('.tr');

			data.forEach(function(row) {
				var id = row[0]
				var trow = E('div', { 'class': 'tr', 'onclick': 'lldpd_folding_toggle(this, \'' + id + '\')' });

				for (var i = 0; i < titles.length; i++) {
					var text = (titles[i].innerText || '').trim();
					var td = trow.appendChild(E('div', {
						'class': titles[i].className,
						'data-title': (text !== '') ? text : null
					}, row[i + 1] || ''));

					td.classList.remove('th');
					td.classList.add('td');
				}

				trow.classList.add('cbi-rowstyle-%d'.format((n++ % 2) ? 2 : 1));

				if (rows[n])
					target.replaceChild(trow, rows[n]);
				else
					target.appendChild(trow);
			});

			while (rows[++n])
				target.removeChild(rows[n]);

			if (placeholder && target.firstElementChild === target.lastElementChild) {
				var trow = target.appendChild(E('div', { 'class': 'tr placeholder' }));
				var td = trow.appendChild(E('div', { 'class': titles[0].className }, placeholder));

				td.classList.remove('th');
				td.classList.add('td');
			}
		}
		else {
			thead.parentNode.style.display = 'none';

			thead.parentNode.querySelectorAll('.tr, .cbi-section-table-row').forEach(function(trow) {
				if (trow !== thead) {
					var n = 0;
					trow.querySelectorAll('.th, .td').forEach(function(td) {
						if (n < titles.length) {
							var text = (titles[n++].innerText || '').trim();
							if (text !== '')
								td.setAttribute('data-title', text);
						}
					});
				}
			});

			thead.parentNode.style.display = '';
		}
	});
}
