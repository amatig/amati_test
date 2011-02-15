// function core

function RGBtoHex(R, G, B) { 
    return toHex(R) + toHex(G) + toHex(B);
};

function toHex(N) {
    if (N==null) return "00";
    N = parseInt(N) - 30;
    if (N==0 || isNaN(N)) return "00";
    N = Math.max(0, N);
    N = Math.min(N, 255); 
    N = Math.round(N);
    return "0123456789ABCDEF".charAt((N-N%16)/16) + "0123456789ABCDEF".charAt(N%16);
};

function manageAuth(elem) {
    if ($(this).text() == "Logout") {
	$.ajax({dataType: "json",
		url: "/logout/",
		success: function() {
		    location.href = "/";
		}
	    });
    } else
	runLogin();
};

function runLogin() {
    $("#dialog").dialog("option", "title", "Login");
    $("#dialog").html("");
    
    $.ajax({url: "/login/", 
	    dataType: "html",
	    success: function(data) {
		$("#dialog").html(data);
	    }
	});
    $("#dialog").dialog("open");
};

function getData(index) {
    var selected = index;
    if (selected == -1)
	selected = $("#tabs").tabs('option', 'selected');
    
    var login = $("#header #b_login");
    if (login.css("display") == "none") {
	login.button();
	login.show();
	login.click(manageAuth);
	if (login.text() == "Logout") {
	    $("#container #t1").show();
	    $("#container #t2").show();
	    $("#container #t3").show();
	    $("#container #t4").show();
	    $("#container #t5").show();
	    $("#container #t6").show();
	    $("#container #t7").show();
	    $("#container #t8").show();
	}
    }
    
    if (selected == 1)
	$.getJSON("/get/origin/", function(data) { ajax_origin(data, selected); });
    else if (selected == 2)
	$.getJSON("/get/dest/", function(data) { ajax_dest(data, selected); });
    else if (selected == 3)
	$.getJSON("/get/route/", function(data) { ajax_route(data, selected); });
    else if (selected == 4)
	$.getJSON("/get/previous/" + $("#page" + selected).text(), function(data) { ajax_previous(data, selected); });
    else if (selected == 6)
	$.getJSON("/get/notify/" + $("#page" + selected).text(), function(data) { ajax_notify(data, selected); });
    else if (selected == 7)
	$.getJSON("/get/user/" + $("#page" + selected).text(), function(data) { ajax_user(data, selected); });
    else if (selected == 8)
	$.getJSON("/get/settings/", function(data) { ajax_settings(data, selected); });
};

function enter_find_record(myfield, e) {
    var keycode;
    if (window.event) keycode = window.event.keyCode;
    else if (e) keycode = e.which;
    else return true;
    
    if (keycode == 13) {
	find_record();
	return false;
    }
    else
	return true;
};

function find_record() {
    var filename = $("#tabs-5 #show_prev5 .search .filename").val();
    var result = $("#tabs-5 #show_prev5 #sresult");
    result.children().remove();
    $.getJSON("/search/record/" + filename, function(data) {
	    var table = $("<table></table>");
	    
	    var trh = $("<tr></tr>");
	    var tdh1 = $("<th></th>").text("Filename");
	    var tdh2 = $("<th></th>").text("Destination");
	    var tdh3 = $("<th></th>").text("Path");
	    var tdh4 = $("<th></th>").text("Remote Path");
	    tdh1.appendTo(trh);
	    tdh2.appendTo(trh);
	    tdh3.appendTo(trh);
	    tdh4.appendTo(trh);
	    trh.appendTo(table);
	    
	    $.each(data, function(item) {
		    var tr1 = $("<tr></tr>");
		    var td11 = $("<td></td>").addClass("val").text(data[item][1][0]);
		    var td12 = $("<td></td>").addClass("val").text(data[item][1][1]);
		    var td13 = $("<td></td>").addClass("val").text(data[item][1][2]);
		    var td14 = $("<td></td>").addClass("val").text(data[item][1][3]);
		    
		    if (data[item][1][4] == 1) {
			td11.addClass("serror");
			td12.addClass("serror");
			td13.addClass("serror");
			td14.addClass("serror");
		    }
		    else if (data[item][1][4] == 2) {
			td11.addClass("sok");
			td12.addClass("sok");
			td13.addClass("sok");
			td14.addClass("sok");
		    }
		    
		    td11.appendTo(tr1);
		    td12.appendTo(tr1);
		    td13.appendTo(tr1);
		    td14.appendTo(tr1);
		    tr1.appendTo(table);
		});
	    
	    table.appendTo(result);
	});
};

function ajax_origin(data, selected) {
    var context = "origin";
    var flag = false;
    $.each(data, function(item) {
	    if ($("#tabs-" + selected + " #list" + selected + " #" + context + data[item].pk).length == 0) {
		var a = $("<a></a>").attr("href", "#").attr("id", "a_" + data[item].pk).text(data[item].fields.label + " | " + data[item].pk);
		var h3 = $("<h3></h3>");
		var row = $("<div></div>").attr("id", context + data[item].pk).addClass("row");
		var desc = $("<div></div>").attr("id", "desc_" + data[item].pk).addClass("desc");
		var desc2 = $("<div></div>").attr("id", "desc3_" + data[item].pk).addClass("desc3");
		var table = $("<table></table>").addClass("table_short");
		var tr1 = $("<tr></tr>");
		var td11 = $("<td></td>").addClass("thx").text("Ip");
		var td12 = $("<td></td>").addClass("val v" + data[item].pk);
		td12.text(data[item].fields.ip).attr("id", "ip_" + data[item].pk);
		var tr2 = $("<tr></tr>");
		var td21 = $("<td></td>").addClass("thx").text("Type");
		var td22 = $("<td></td>").addClass("val v" + data[item].pk);
		td22.text(data[item].fields.otype).attr("id", "otype_" + data[item].pk);
		var tr3 = $("<tr></tr>");
		var td31 = $("<td></td>").addClass("thx").text("Path");
		var td32 = $("<td></td>").addClass("val v" + data[item].pk);
		td32.text(data[item].fields.path).attr("id", "path_" + data[item].pk);
		var tr4 = $("<tr></tr>");
		var td41 = $("<td></td>").addClass("thx").text("Back check");
		var td42 = $("<td></td>").addClass("val v" + data[item].pk);
		td42.text(data[item].fields.bc).attr("id", "bc_" + data[item].pk);
		var tr5 = $("<tr></tr>");
		var td51 = $("<td></td>").addClass("thx").text("Tollerance");
		var td52 = $("<td></td>").addClass("val v" + data[item].pk);
		td52.text(data[item].fields.tollerance).attr("id", "tollerance_" + data[item].pk);
		var tr6 = $("<tr></tr>");
		var td61 = $("<td></td>").addClass("thx").text("Label");
		var td62 = $("<td></td>").addClass("val v" + data[item].pk);
		td62.text(data[item].fields.label).attr("id", "label_" + data[item].pk);
		
		var tr7 = $("<tr></tr>").attr("id", "tr_u_" + data[item].pk);
		var td71 = $("<td></td>").addClass("thx").text("Username");
		var td72 = $("<td></td>").addClass("val v" + data[item].pk);
		td72.text(data[item].fields.uname).attr("id", "uname_" + data[item].pk);
		var tr8 = $("<tr></tr>").attr("id", "tr_p_" + data[item].pk);
		var td81 = $("<td></td>").addClass("thx").text("Password");
		var td82 = $("<td></td>").addClass("val v" + data[item].pk);
		td82.text(data[item].fields.passwd).attr("id", "passwd_" + data[item].pk);
		var tr9 = $("<tr></tr>").attr("id", "tr_rp_" + data[item].pk);
		var td91 = $("<td></td>").addClass("thx").text("Remote Path");
		var td92 = $("<td></td>").addClass("val v" + data[item].pk);
		td92.text(data[item].fields.remote_path).attr("id", "remote_path_" + data[item].pk);
		
		check_fold(selected, data[item].fields.otype, data[item].pk);
		
		td61.appendTo(tr6);
		td62.appendTo(tr6);
		td11.appendTo(tr1);
		td12.appendTo(tr1);
		td21.appendTo(tr2);
		td22.appendTo(tr2);
		td31.appendTo(tr3);
		td32.appendTo(tr3);
		td41.appendTo(tr4);
		td42.appendTo(tr4);
		td51.appendTo(tr5);
		td52.appendTo(tr5);
		
		td71.appendTo(tr7);
		td72.appendTo(tr7);
		td81.appendTo(tr8);
		td82.appendTo(tr8);
		td91.appendTo(tr9);
		td92.appendTo(tr9);
		
		tr6.appendTo(table);
		tr1.appendTo(table);
		tr2.appendTo(table);
		tr3.appendTo(table);
		tr4.appendTo(table);
		tr5.appendTo(table);
		tr7.appendTo(table);
		tr8.appendTo(table);
		tr9.appendTo(table);
		
		table.appendTo(desc);
		h3.appendTo(row);
		desc.appendTo(row);
		desc2.appendTo(desc);
		a.appendTo(h3);
		
		row.appendTo("#tabs-" + selected + " #list" + selected);
		
		var b1 = $("<button></button>").text("Change").attr("id", "butt1_" + data[item].pk);
		b1.addClass("butt1").button().click(function() {
			changeForm(selected, data[item].pk, context);
		    });
		var b2 = $("<button></button>").text("Save").attr("id", "butt2_" + data[item].pk);
		b2.addClass("butt2").button().hide().click(function() {
			saveForm(selected, data[item].pk, context, "/change/origin/");
		    });
		var b3 = $("<button></button>").text("Abort").attr("id", "butt3_" + data[item].pk);
		b3.addClass("butt3").button().hide().click(function() {
			restore_view(selected, data[item].pk, context);
		    });
		
		var panel = $("<div></div>").addClass("panel");
		b1.appendTo(panel);
		b2.appendTo(panel);
		b3.appendTo(panel);
		
		// dattagli
		var hcmd = $("<h4></h4>").text("Commands");
		var b4 = $("<button></button>").text("Reset").attr("id", "butt4_" + data[item].pk).addClass("commands");
		b4.addClass("butt4").button().click(function() {
			jConfirm("Are you sure you want to reset the origin?", "Warning", function(r) {
				if (r == true) {
				    $.ajax({type: "POST",
					    dataType: "json",
					    url: "/reset/origin/" + data[item].pk
				    });
				}
			    });
		    });
		var b5 = $("<button></button>").attr("id", "butt5_" + data[item].pk).addClass("commands");
		b5.addClass("butt5").button().click(function() {
			jConfirm("Are you sure you want to enable/disable the origin?", "Warning", function(r) {
				if (r == true) {
				    $.ajax({type: "POST",
					    dataType: "json",
					    url: "/remove/origin/" + data[item].pk,
					    success: function() { getData(-1); }
				    });
				}
			    });
		    });
		
		var hstats = $("<h4></h4>").text("Stats");
		var stats_value = $("<span></span>").text("Prova 10 ecc ecc").attr("id", "stats_" + data[item].pk);
		
		hcmd.appendTo(desc2);
		b5.appendTo(desc2);
		b4.appendTo(desc2);
		hstats.appendTo(desc2);
		stats_value.appendTo(desc2);
		
		panel.appendTo(desc);
		flag = true;
	    }
	    else {
		if ($("#tabs-" + selected + " #list" + selected + " #butt1_" + data[item].pk).is(":visible") == true) {
		    $("#tabs-" + selected + " #list" + selected + " #label_" + data[item].pk).text(data[item].fields.label);
		    $("#tabs-" + selected + " #list" + selected + " #ip_" + data[item].pk).text(data[item].fields.ip);
		    $("#tabs-" + selected + " #list" + selected + " #otype_" + data[item].pk).text(data[item].fields.otype);
		    $("#tabs-" + selected + " #list" + selected + " #path_" + data[item].pk).text(data[item].fields.path);
		    $("#tabs-" + selected + " #list" + selected + " #bc_" + data[item].pk).text(data[item].fields.bc);
		    $("#tabs-" + selected + " #list" + selected + " #tollerance_" + data[item].pk).text(data[item].fields.tollerance);
		    $("#tabs-" + selected + " #list" + selected + " #uname_" + data[item].pk).text(data[item].fields.uname);
		    $("#tabs-" + selected + " #list" + selected + " #passwd_" + data[item].pk).text(data[item].fields.passwd);
		    $("#tabs-" + selected + " #list" + selected + " #remote_path_" + data[item].pk).text(data[item].fields.remote_path);
		    
		    check_fold(selected, data[item].fields.otype, data[item].pk);
		    manage_row(data[item].fields.removed, selected, data[item].pk, context);
		}
		$("#tabs-" + selected + " #list" + selected + " #a_" + data[item].pk).text(data[item].fields.label + " | " + data[item].pk);
	    }
	    // rimuovere quelli nn + esistenti al max
	});
    if (flag) {
	$("#tabs-" + selected + " #accordion" + selected).accordion('destroy').accordion({header: "h3", autoHeight: false, collapsible: true});
	for (var item in data)
	    manage_row(data[item].fields.removed, selected, data[item].pk, context);
    }
};

function check_fold(selected, t, pk) {
    $.getJSON("/check/fold/" + t, function(retu2) {
	    $.each(retu2, function(itu2) {
		    if (retu2[itu2].fields.need_user == false)
			$("#tabs-" + selected + " #list" + selected + " #tr_u_" + pk).hide();
		    else
			$("#tabs-" + selected + " #list" + selected + " #tr_u_" + pk).show();
		    if (retu2[itu2].fields.need_passwd == false)
			$("#tabs-" + selected + " #list" + selected + " #tr_p_" + pk).hide();
		    else
			$("#tabs-" + selected + " #list" + selected + " #tr_p_" + pk).show();
		    if (retu2[itu2].fields.need_rpath == false)
			$("#tabs-" + selected + " #list" + selected + " #tr_rp_" + pk).hide();
		    else
			$("#tabs-" + selected + " #list" + selected + " #tr_rp_" + pk).show();
		});
	});
};

function ajax_dest(data, selected) {
    var context = "dest";
    var flag = false;
    $.each(data, function(item) {
 	    if ($("#tabs-" + selected + " #list" + selected + " #" + context + data[item].pk).length == 0) {
		var a = $("<a></a>").attr("href", "#").attr("id", "a_" + data[item].pk).text(data[item].fields.label + " | " + data[item].pk);
		var h3 = $("<h3></h3>");
		var row = $("<div></div>").attr("id", context + data[item].pk).addClass("row");
		var desc = $("<div></div>").attr("id", "desc_" + data[item].pk).addClass("desc");
		var desc2 = $("<div></div>").attr("id", "desc3_" + data[item].pk).addClass("desc3");
		var table = $("<table></table>").addClass("table_short");
		var tr1 = $("<tr></tr>");
		var td11 = $("<td></td>").addClass("thx").text("Ip");
		var td12 = $("<td></td>").addClass("val v" + data[item].pk);
		td12.text(data[item].fields.ip).attr("id", "ip_" + data[item].pk);
		var tr2 = $("<tr></tr>");
		var td21 = $("<td></td>").addClass("thx").text("Type");
		var td22 = $("<td></td>").addClass("val v" + data[item].pk);
		td22.text(data[item].fields.dtype).attr("id", "dtype_" + data[item].pk);
		var tr3 = $("<tr></tr>");
		var td31 = $("<td></td>").addClass("thx").text("Path");
		var td32 = $("<td></td>").addClass("val v" + data[item].pk);
		td32.text(data[item].fields.path).attr("id", "path_" + data[item].pk);
		var tr6 = $("<tr></tr>");
		var td61 = $("<td></td>").addClass("thx").text("Label");
		var td62 = $("<td></td>").addClass("val v" + data[item].pk);
		td62.text(data[item].fields.label).attr("id", "label_" + data[item].pk);
		
		var tr7 = $("<tr></tr>").attr("id", "tr_u_" + data[item].pk);
		var td71 = $("<td></td>").addClass("thx").text("Username");
		var td72 = $("<td></td>").addClass("val v" + data[item].pk);
		td72.text(data[item].fields.uname).attr("id", "uname_" + data[item].pk);
		var tr8 = $("<tr></tr>").attr("id", "tr_p_" + data[item].pk);
		var td81 = $("<td></td>").addClass("thx").text("Password");
		var td82 = $("<td></td>").addClass("val v" + data[item].pk);
		td82.text(data[item].fields.passwd).attr("id", "passwd_" + data[item].pk);
		var tr9 = $("<tr></tr>").attr("id", "tr_rp_" + data[item].pk);
		var td91 = $("<td></td>").addClass("thx").text("Remote Path");
		var td92 = $("<td></td>").addClass("val v" + data[item].pk);
		td92.text(data[item].fields.remote_path).attr("id", "remote_path_" + data[item].pk);
		
		check_fold(selected, data[item].fields.dtype, data[item].pk);
		
		td61.appendTo(tr6);
		td62.appendTo(tr6);
		td11.appendTo(tr1);
		td12.appendTo(tr1);
		td21.appendTo(tr2);
		td22.appendTo(tr2);
		td31.appendTo(tr3);
		td32.appendTo(tr3);
		
		td71.appendTo(tr7);
		td72.appendTo(tr7);
		td81.appendTo(tr8);
		td82.appendTo(tr8);
		td91.appendTo(tr9);
		td92.appendTo(tr9);
		
		tr6.appendTo(table);
		tr1.appendTo(table);
		tr2.appendTo(table);
		tr3.appendTo(table);
		tr7.appendTo(table);
		tr8.appendTo(table);
		tr9.appendTo(table);
		
		table.appendTo(desc);
		h3.appendTo(row);
		desc.appendTo(row);
		desc2.appendTo(desc);
		a.appendTo(h3);
		
		row.appendTo("#tabs-" + selected + " #list" + selected);
		
		var b1 = $("<button></button>").text("Change").attr("id", "butt1_" + data[item].pk);
		b1.addClass("butt1").button().click(function() {
			changeForm(selected, data[item].pk, context);
		    });
		var b2 = $("<button></button>").text("Save").attr("id", "butt2_" + data[item].pk);
		b2.addClass("butt2").button().hide().click(function() {
			saveForm(selected, data[item].pk, context, "/change/dest/");
		    });
		var b3 = $("<button></button>").text("Abort").attr("id", "butt3_" + data[item].pk);
		b3.addClass("butt3").button().hide().click(function() {
			restore_view(selected, data[item].pk, context);
		    });
		
		var panel = $("<div></div>").addClass("panel");
		b1.appendTo(panel);
		b2.appendTo(panel);
		b3.appendTo(panel);
		
		// dattagli
		var hcmd = $("<h4></h4>").text("Commands");
		var b5 = $("<button></button>").attr("id", "butt5_" + data[item].pk).addClass("commands");
		b5.addClass("butt5").button().click(function() {
			jConfirm("Are you sure you want to enable/disable the dest?", "Warning", function(r) {
				if (r == true) {
				    $.ajax({type: "POST",
					    dataType: "json",
					    url: "/remove/dest/" + data[item].pk,
					    success: function() { getData(-1); }
				    });
				}
			    });
		    });
		
		var hstats = $("<h4></h4>").text("Stats");
		var stats_value = $("<span></span>").text("Prova 10 ecc ecc").attr("id", "stats_" + data[item].pk);
		
		hcmd.appendTo(desc2);
		b5.appendTo(desc2);
		hstats.appendTo(desc2);
		stats_value.appendTo(desc2);
		
		panel.appendTo(desc);
		flag = true;
	    }
	    else {
		if ($("#tabs-" + selected + " #list" + selected + " #butt1_" + data[item].pk).is(":visible") == true) {
		    $("#tabs-" + selected + " #list" + selected + " #label_" + data[item].pk).text(data[item].fields.label);
		    $("#tabs-" + selected + " #list" + selected + " #ip_" + data[item].pk).text(data[item].fields.ip);
		    $("#tabs-" + selected + " #list" + selected + " #dtype_" + data[item].pk).text(data[item].fields.dtype);
		    $("#tabs-" + selected + " #list" + selected + " #path_" + data[item].pk).text(data[item].fields.path);
		    
		    $("#tabs-" + selected + " #list" + selected + " #uname_" + data[item].pk).text(data[item].fields.uname);
		    $("#tabs-" + selected + " #list" + selected + " #passwd_" + data[item].pk).text(data[item].fields.passwd);
		    $("#tabs-" + selected + " #list" + selected + " #remote_path_" + data[item].pk).text(data[item].fields.remote_path);
		    
		    check_fold(selected, data[item].fields.dtype, data[item].pk);
		    manage_row(data[item].fields.removed, selected, data[item].pk, context);
		}
		$("#tabs-" + selected + " #list" + selected + " #a_" + data[item].pk).text(data[item].fields.label + " | " + data[item].pk);
	    }
	    // rimuovere quelli nn + esistenti al max
	});
    if (flag) {
	$("#tabs-" + selected + " #accordion" + selected).accordion('destroy').accordion({header: "h3", autoHeight: false, collapsible: true});
	for (var item in data)
	    manage_row(data[item].fields.removed, selected, data[item].pk, context);
    }
};

function ajax_route(data, selected) {
    var context = "route";
    var flag = false;
    $.each(data, function(item) {
 	    if ($("#tabs-" + selected + " #list" + selected + " #" + context + data[item].pk).length == 0) {
		var a = $("<a></a>").attr("href", "#").attr("id", "a_" + data[item].pk).text(data[item].fields.label + " | " + data[item].pk);
		var h3 = $("<h3></h3>");
		a.addClass("state" + data[item].fields.state);
		
		var row = $("<div></div>").attr("id", context + data[item].pk).addClass("row");
		var desc = $("<div></div>").attr("id", "desc_" + data[item].pk).addClass("desc");
		var desc2 = $("<div></div>").attr("id", "desc3_" + data[item].pk).addClass("desc3");
		var table = $("<table></table>").addClass("table_short");
		var tr1 = $("<tr></tr>");
		var td11 = $("<td></td>").addClass("thx").text("Origin");
		var td12 = $("<td></td>").addClass("val v" + data[item].pk);
		td12.text(data[item].fields.origin).attr("id", "origin_" + data[item].pk);
		var tr2 = $("<tr></tr>");
		var td21 = $("<td></td>").addClass("thx").text("Dest");
		var td22 = $("<td></td>").addClass("val v" + data[item].pk);
		td22.text(data[item].fields.dest).attr("id", "dest_" + data[item].pk);
		var tr3 = $("<tr></tr>");
		var td31 = $("<td></td>").addClass("thx").text("Start date");
		var td32 = $("<td></td>").addClass("val v" + data[item].pk);
		td32.text(data[item].fields.start).attr("id", "start_" + data[item].pk);
		var tr6 = $("<tr></tr>");
		var td61 = $("<td></td>").addClass("thx").text("End date");
		var td62 = $("<td></td>").addClass("val v" + data[item].pk);
		td62.text(data[item].fields.end).attr("id", "end_" + data[item].pk);
		var tr7 = $("<tr></tr>");
		var td71 = $("<td></td>").addClass("thx").text("Label");
		var td72 = $("<td></td>").addClass("val v" + data[item].pk);
		td72.text(data[item].fields.label).attr("id", "label_" + data[item].pk);
		
		td71.appendTo(tr7);
		td72.appendTo(tr7);
		td61.appendTo(tr6);
		td62.appendTo(tr6);
		td11.appendTo(tr1);
		td12.appendTo(tr1);
		td21.appendTo(tr2);
		td22.appendTo(tr2);
		td31.appendTo(tr3);
		td32.appendTo(tr3);
		tr7.appendTo(table);
		tr1.appendTo(table);
		tr2.appendTo(table);
		tr3.appendTo(table);
		tr6.appendTo(table);
		table.appendTo(desc);
		h3.appendTo(row);
		desc.appendTo(row);
		desc2.appendTo(desc);
		a.appendTo(h3);
		
		row.appendTo("#tabs-" + selected + " #list" + selected);
		
		var b1 = $("<button></button>").text("Change").attr("id", "butt1_" + data[item].pk);
		b1.addClass("butt1").button().click(function() {
			changeForm(selected, data[item].pk, context);
		    });
		var b2 = $("<button></button>").text("Save").attr("id", "butt2_" + data[item].pk);
		b2.addClass("butt2").button().hide().click(function() {
			saveForm(selected, data[item].pk, context, "/change/route/");
		    });
		var b3 = $("<button></button>").text("Abort").attr("id", "butt3_" + data[item].pk);
		b3.addClass("butt3").button().hide().click(function() {
			restore_view(selected, data[item].pk, context);
		    });
				
		var panel = $("<div></div>").addClass("panel");
		b1.appendTo(panel);
		b2.appendTo(panel);
		b3.appendTo(panel);
		
		// dattagli
		var hcmd = $("<h4></h4>").text("Commands");
		var b4 = $("<button></button>").text("Reset").attr("id", "butt4_" + data[item].pk).addClass("commands");
		b4.addClass("butt4").button().click(function() {
			jConfirm("Are you sure you want to reset the route?", "Warning", function(r) {
				if (r == true) {
				        $.ajax({type: "POST",
						dataType: "json",
						url: "/reset/route/" + data[item].pk
					    });
				}
			    });
		    });
		var b5 = $("<button></button>").attr("id", "butt5_" + data[item].pk).addClass("commands");
		b5.addClass("butt5").button().click(function() {
			jConfirm("Are you sure you want to enable/disable the route?", "Warning", function(r) {
				if (r == true) {
				    $.ajax({type: "POST",
					    dataType: "json",
					    url: "/remove/route/" + data[item].pk,
					    success: function() { getData(-1); }
				    });
				}
			    });
		    });
		
		var b6 = $("<button></button>").text("Del Schedules").attr("id", "butt6_" + data[item].pk).addClass("commands");
		b6.addClass("butt6").button().click(function() {
			runDeleteSched(data[item].pk);
		    });
		
		var b7 = $("<button></button>").text("Add Schedule").attr("id", "butt7_" + data[item].pk).addClass("commands");
		b7.addClass("butt7").button().click(function() {
			runAddSched(data[item].pk);
		    });
		
		var hstats = $("<h4></h4>").text("Stats");
		
		var s1 = $("<div></div>").addClass("row_stat");
		var stat_title = $("<span></span>").text("Records").addClass("title_stat");
		var stat_to_move = $("<span></span>").text("Pending: " + data[item].fields.stat_to_move)
		    .attr("id", "stat_to_move_" + data[item].pk).addClass("stat");
		var stat_errs = $("<span></span>").text("Waiting/Errors: " + data[item].fields.stat_errs)
		    .attr("id", "stat_errs_" + data[item].pk).addClass("stat");
		var stat_done = $("<span></span>").text("Archived: " + data[item].fields.stat_done)
		    .attr("id", "stat_done_" + data[item].pk).addClass("stat");
		
		var s2 = $("<div></div>").addClass("row_stat");
		var stat_title2 = $("<span></span>").text("Schedules").addClass("title_stat");		
		var stat_sched = $("<span></span>").text("Executed: " + data[item].fields.stat_sched)
		    .attr("id", "stat_sched_" + data[item].pk).addClass("stat");
		
		hcmd.appendTo(desc2);
		b5.appendTo(desc2);
		b4.appendTo(desc2);
		b7.appendTo(desc2);
		b6.appendTo(desc2);
		hstats.appendTo(desc2);
		
		stat_title.appendTo(s1);
		stat_to_move.appendTo(s1);
		stat_errs.appendTo(s1);
		stat_done.appendTo(s1);
		
		stat_title2.appendTo(s2);
		stat_sched.appendTo(s2);
		
		s1.appendTo(desc2);
		s2.appendTo(desc2);
		
		// schedule
		var cdiv = $("<div></div>").addClass("cdiv").attr("id", "cdiv_" + data[item].pk).text("Timeline Schedules");
		var timeline = $("<div></div>").addClass("timeline").attr("id", "timeline_" + data[item].pk);
		for (var i = 0; i < 24; i++) {
		    var ii = "";
		    if (i < 10) ii = "0" + i;
		    else ii = i.toString();
		    
		    var tcell = $("<div></div>").addClass("tcell").attr("id", "tcell_" + data[item].pk + "_" + ii).text(ii + ":00");
		    if (i == 23) tcell.addClass("tcell_last");
		    if (i == 0) tcell.addClass("tcell_first");
		    tcell.appendTo(timeline);
		}
				
		timeline.appendTo(cdiv);
		cdiv.appendTo(desc);
		
		panel.appendTo(desc);
		flag = true;
	    }
	    else {
		var temp1 = $("#tabs-" + selected + " #list" + selected + " #a_" + data[item].pk);
		if ($("#tabs-" + selected + " #list" + selected + " #butt1_" + data[item].pk).is(":visible") == true) {
		    $("#tabs-" + selected + " #list" + selected + " #label_" + data[item].pk).text(data[item].fields.label);
		    $("#tabs-" + selected + " #list" + selected + " #origin_" + data[item].pk).text(data[item].fields.origin);
		    $("#tabs-" + selected + " #list" + selected + " #dest_" + data[item].pk).text(data[item].fields.dest);
		    $("#tabs-" + selected + " #list" + selected + " #start_" + data[item].pk).text(data[item].fields.start);
		    $("#tabs-" + selected + " #list" + selected + " #end_" + data[item].pk).text(data[item].fields.end);
		    
		    $("#tabs-" + selected + " #list" + selected + " #stat_to_move_" + data[item].pk).text("Pending: " + data[item].fields.stat_to_move);
		    $("#tabs-" + selected + " #list" + selected + " #stat_errs_" + data[item].pk).text("Waiting/Errors: " + data[item].fields.stat_errs);
		    $("#tabs-" + selected + " #list" + selected + " #stat_done_" + data[item].pk).text("Archived: " + data[item].fields.stat_done);
		    $("#tabs-" + selected + " #list" + selected + " #stat_sched_" + data[item].pk).text("Executed: " + data[item].fields.stat_sched);
		    
		    $.getJSON("/get/schedule/" + data[item].pk, function(ret) {
			    var ii_s = new Array();
			    var real_s = new Array();
			    j = 0;
			    $.each(ret, function(it) {
				    var inizio = ret[it].fields.s_start.substring(0, 2);
				    if (inizio.charAt(0) == '0')
					inizio = inizio.substring(1, inizio.length);
				    inizio = parseInt(inizio);
				    var fine = 24;
				    if (ret[it].fields.s_end != null) {
					fine = ret[it].fields.s_end.substring(0, 2);
					if (fine.charAt(0) == '0')
					    fine = fine.substring(1, fine.length);
					fine = parseInt(fine);
					
					var tmp = ret[it].fields.s_end.substring(3, 5);
					if (tmp.charAt(0) == '0')
					    tmp = tmp.substring(1, tmp.length);
					tmp = parseInt(tmp);
					
					if (tmp > 30 && fine == 23)
					    fine = 24;
				    }
				    
				    for (i = inizio; i < fine; i++) {
					var ii = "";
					if (i < 10) ii = "0" + i;
					else ii = i.toString();
					
					ii_s[j] = ii;
					real_s[j] = ret[it].fields.s_start;
					j++;
				    }
				});
			    
			    var arr_items = $("#tabs-" + selected + " #list" + selected + " #desc_"+ data[item].pk + " .tcell");
			    
			    $.each(arr_items, function(it) {
				    var tcell = $(arr_items[it]);
				    var id = tcell.attr("id");
				    var code = id.substring(id.length - 2, id.length);
				    if ($.inArray(code, ii_s) == -1) {
					tcell.removeAttr("title").css("background-color", "#ffffff").removeClass("full");
				    } else {
					if (tcell.hasClass("full") == false) tcell.addClass("full");
					tcell.css("background-color", "#f8b750");
					
					var n = 0;
					var title = "";
					for (z in ii_s) { 
					    if (code == ii_s[z]) {
						n += 1;
						if (title == "")
						    title += "Start at " + real_s[z];
						else
						    title += "\nand at " + real_s[z];
					    }
					}
					
					for (var z = 0; z < n - 1; z++) { // uno in meno
					    var color = tcell.css("background-color");
					    var re = /^rgb\((\d{1,3}),\s*(\d{1,3}),\s*(\d{1,3})\)$/;
					    var rgb = re.exec(color);
					    tcell.css("background-color", "#" + RGBtoHex(rgb[1], rgb[2], rgb[3]));
					}
					tcell.attr("title", title);
				    }
				});
			});
		    manage_row(data[item].fields.removed, selected, data[item].pk, context);
		}
		temp1.text(data[item].fields.label + " | " + data[item].pk);
		temp1.removeClass("state0 state1 state2 state3");
		temp1.addClass("state" + data[item].fields.state);
	    }
	    // rimuovere quelli nn + esistenti al max
	});
    if (flag) {
	$("#tabs-" + selected + " #accordion" + selected).accordion('destroy').accordion({header: "h3", autoHeight: false, collapsible: true});
	for (var item in data)
	    manage_row(data[item].fields.removed, selected, data[item].pk, context);
    }
};

function ajax_previous(data, selected) {
    var context = "previous";

    var desc = $("<div></div>").attr("id", "show_prev" + selected).addClass("show_prev");

    var panel = $("<div></div>").addClass("page_command");
    
    var pages = 0;
    if (data[0] != undefined) pages = data[0].count;
    
    if (pages > 0) {
	for (var i=0; i<=pages; i++) {
	    var b = $("<button></button>").text(i + 1);
	    if (i == parseInt($("#page" + selected).text()))
		b.addClass("pressed");
	    b.button().click(function() {
		    $("#page" + selected).text(parseInt($(this).text()) - 1);
		    getData(-1);
		});
	    b.appendTo(panel);
	}
    }
    
    panel.appendTo(desc);
    
    var table = $("<table></table>");
    
    var trh = $("<tr></tr>");
    var tdh0 = $("<th></th>").text(" ").addClass("tp_first");
    var tdh1 = $("<th></th>").text("First filename");
    var tdh2 = $("<th></th>").text("Last filename");
    var tdh3 = $("<th></th>").text("Destination");
    tdh0.appendTo(trh);
    tdh1.appendTo(trh);
    tdh2.appendTo(trh);
    tdh3.appendTo(trh);
    trh.appendTo(table);
    
    $.each(data, function(item) {
	    var del = $("<button></button>").text("Del");
	    del.button().click(function() {
		    jConfirm("Are you sure you want to delete the previous history?", "Warning", function(r) {
			    if (r == true) {
				$.ajax({url: "/del/previous/" + data[item].pk,
					success: function() {
					    $("#page" + selected).text("0");
					    getData(-1);
					}
				    });
			    }
			});
		});
	    
	    var tr1 = $("<tr></tr>").attr("id", context + data[item].pk);
	    if (item % 2 == 1)
		tr1.addClass("tipo2");
	    var td10 = $("<td></td>").addClass("val vx" + data[item].pk).addClass("tp_first");
	    var td11 = $("<td></td>").addClass("val vf" + data[item].pk).text(data[item].fields.first);
	    var td12 = $("<td></td>").addClass("val vl" + data[item].pk).text(data[item].fields.last);
	    var td13 = $("<td></td>").addClass("val vd" + data[item].pk).text(data[item].fields.dest);
	    del.appendTo(td10);
	    td10.appendTo(tr1);
	    td11.appendTo(tr1);
	    td12.appendTo(tr1);
	    td13.appendTo(tr1);
	    tr1.appendTo(table);
	});
    
    table.appendTo(desc);
    
    $("#tabs-" + selected + " #show_prev" + selected).replaceWith(desc);
};

function ajax_user(data, selected) {
    var context = "user";
    
    var desc = $("<div></div>").attr("id", "show_prev" + selected).addClass("show_prev");
    
    var panel = $("<div></div>").addClass("page_command");
    
    var pages = 0;
    if (data[0] != undefined) pages = data[0].count;
    
    if (pages > 0) {
	for (var i=0; i<=pages; i++) {
	    var b = $("<button></button>").text(i + 1);
	    if (i == parseInt($("#page" + selected).text()))
		b.addClass("pressed");
	    b.button().click(function() {
		    $("#page" + selected).text(parseInt($(this).text()) - 1);
		    getData(-1);
		});
	    b.appendTo(panel);
	}
    }
    
    panel.appendTo(desc);
    
    var table = $("<table></table>");
    
    var trh = $("<tr></tr>");
    var tdh0 = $("<th></th>").text(" ").addClass("tp_first");
    var tdh01 = $("<th></th>").text(" ").addClass("tp_first");
    var tdh1 = $("<th></th>").text("Username");
    var tdh2 = $("<th></th>").text("Superuser status");
    tdh0.appendTo(trh);
    tdh01.appendTo(trh);
    tdh1.appendTo(trh);
    tdh2.appendTo(trh);
    trh.appendTo(table);
    
    $.each(data, function(item) {
	    var edit = $("<button></button>").text("Edit");
	    edit.button().click(function() {
		    runEditUser(data[item].pk);
		});
	    var del = $("<button></button>").text("Del");
	    del.button().click(function() {
		    jConfirm("Are you sure you want to delete user?", "Warning", function(r) {
			    if (r == true) {
				$.ajax({url: "/del/user/" + data[item].pk,
					success: function() {
					    $("#page" + selected).text("0");
					    getData(-1);
					}
				    });
			    }
			});
		});
	    
	    var tr1 = $("<tr></tr>").attr("id", context + data[item].pk);
	    if (item % 2 == 1)
		tr1.addClass("tipo2");
	    var td101 = $("<td></td>").addClass("val ve" + data[item].pk).addClass("tp_first");
	    var td10 = $("<td></td>").addClass("val vx" + data[item].pk).addClass("tp_first");
	    var td11 = $("<td></td>").addClass("val vu" + data[item].pk).text(data[item].fields.username);
	    var td12 = $("<td></td>").addClass("val vt" + data[item].pk).text(data[item].fields.is_superuser).addClass("info").attr("title", "If true, user can manage all users");
	    edit.appendTo(td101);
	    del.appendTo(td10);
	    td101.appendTo(tr1);
	    td10.appendTo(tr1);
	    td11.appendTo(tr1);
	    td12.appendTo(tr1);
	    tr1.appendTo(table);
	});
    
    table.appendTo(desc);
    
    $("#tabs-" + selected + " #show_prev" + selected).replaceWith(desc);
};

function ajax_notify(data, selected) {
    var context = "notify";
    
    var desc = $("<div></div>").attr("id", "show_prev" + selected).addClass("show_prev");
    
    var panel = $("<div></div>").addClass("page_command");
    
    var pages = 0;
    if (data[0] != undefined) pages = data[0].count;
    
    if (pages > 0) {
	for (var i=0; i<=pages; i++) {
	    var b = $("<button></button>").text(i + 1);
	    if (i == parseInt($("#page" + selected).text()))
		b.addClass("pressed");
	    b.button().click(function() {
		    $("#page" + selected).text(parseInt($(this).text()) - 1);
		    getData(-1);
		});
	    b.appendTo(panel);
	}
    }
    
    panel.appendTo(desc);
    
    var table = $("<table></table>");
    
    var trh = $("<tr></tr>");
    var tdh1 = $("<th></th>").text("Recording date").addClass("ufirst");
    var tdh2 = $("<th></th>").text("IP:PID").addClass("ufirst");
    var tdh3 = $("<th></th>").text("Message");
    tdh1.appendTo(trh);
    tdh2.appendTo(trh);
    tdh3.appendTo(trh);
    trh.appendTo(table);
    
    $.each(data, function(item) {
	    var tr1 = $("<tr></tr>").attr("id", context + data[item].pk);
	    var td11 = $("<td></td>").addClass("val vf" + data[item].pk).text(data[item].fields.date);
	    var td12 = $("<td></td>").addClass("val vl" + data[item].pk).text(data[item].fields.pid);
	    var td13 = $("<td></td>").addClass("val vd" + data[item].pk).text(data[item].fields.msg).addClass("umsg");
	    if (parseInt(data[item].fields.level) == 0) {
		td11.addClass("unormal");
		td12.addClass("unormal");
		td13.addClass("unormal");
	    } else if (parseInt(data[item].fields.level) > 0) {
		td11.addClass("uok");
		td12.addClass("uok");
		td13.addClass("uok");
	    } else {
		td11.addClass("uerror");
		td12.addClass("uerror");
		td13.addClass("uerror");
	    }
	    td11.appendTo(tr1);
	    td12.appendTo(tr1);
	    td13.appendTo(tr1);
	    tr1.appendTo(table);
	});
    
    table.appendTo(desc);
    
    $("#tabs-" + selected + " #show_prev" + selected).replaceWith(desc);
};

function clean_all() {
    $.ajax({url: "/cleanall/notify/",
	    success: function() {
		$("#page6").text("0");
		getData(-1);
	    }
	});
};

function clean_positive() {
    $.ajax({url: "/cleanpositive/notify/",
	    success: function() {
		$("#page6").text("0");
		getData(-1);
	    }
	});
};

function ret_fh(name, value) {
    var obj = $("<object></object>").attr("classid", "clsid:d27cdb6e-ae6d-11cf-96b8-444553540000")
	.attr("width", "14").attr("height", "14").attr("class", "clippy").attr("id", "clippy");
    
    var p1 = $("<param />").attr("name", "movie").attr("value", "/site_media/swf/clippy.swf");
    var p2 = $("<param />").attr("name", "allowScriptAccess").attr("value", "always");
    var p3 = $("<param />").attr("name", "quality").attr("value", "high");
    var p4 = $("<param />").attr("name", "scale").attr("value", "noscale");
    var p5 = $("<param />").attr("name", "FlashVars").attr("value", "text=" + value).attr("id", name);
    var p6 = $("<param />").attr("name", "wmode").attr("value", "opaque");
    
    var embed = $("<embed />").attr("src", "/site_media/swf/clippy.swf").attr("width", "14").attr("height", "14")
	.attr("name", "clippy").attr("quality", "high").attr("allowScriptAccess", "always")
	.attr("type", "application/x-shockwave-flash").attr("pluginspage", "http://www.macromedia.com/go/getflashplayer")
	.attr("FlashVars", "text=" + value).attr("wmode", "opaque");
    
    p1.appendTo(obj);
    p2.appendTo(obj);
    p3.appendTo(obj);
    p4.appendTo(obj);
    p5.appendTo(obj);
    p6.appendTo(obj);
    embed.appendTo(obj);
    
    return obj;
};

function ajax_settings(data, selected) {
    var context = "settings";
    var flag = false;
    $.each(data, function(item) {
 	    if ($("#tabs-" + selected + " #list" + selected + " #" + context + item).length == 0) {
		var a = $("<a></a>").attr("href", "#").attr("id", "a_" + item).text(item);
		var h3 = $("<h3></h3>");
		var row = $("<div></div>").attr("id", context + item).addClass("row");
		var desc = $("<div></div>").attr("id", "desc_" + item).addClass("desc");
		var table = $("<table></table>");
		for (var i in data[item]) {
		    var tr1 = $("<tr></tr>");
		    var td11 = $("<td></td>").addClass("thx").addClass("thx3").addClass("info").attr("title", data[item][i].description);
		    
		    var div_clip = $("<div></div>");
		    var label = $("<div></div>").text(data[item][i].name).addClass("thx1");
		    var label_fh = $("<div></div>").attr("id", "fh_" + data[item][i].name + "_" + item)
			.append(ret_fh("fhv_" + data[item][i].name + "_" + item, data[item][i].value))
			.addClass("thx2");
		    
		    label.appendTo(div_clip);
		    label_fh.appendTo(div_clip);
		    div_clip.appendTo(td11);
		    
		    var td12 = $("<td></td>").addClass("val v" + data[item][i].name).addClass("info").attr("title", data[item][i].description);
		    if (data[item][i].editable == false)
			td12.addClass("no_edit");
		    td11.attr("id", "l_" + data[item][i].name + "_" + item);
		    td12.text(data[item][i].value).attr("id", data[item][i].name + "_" + item);
		    
		    td11.appendTo(tr1);
		    td12.appendTo(tr1);
		    tr1.appendTo(table);
		}
		
		table.appendTo(desc);
		h3.appendTo(row);
		desc.appendTo(row);
		a.appendTo(h3);
		
		row.appendTo("#tabs-" + selected + " #list" + selected);
		
		var b1 = $("<button></button>").text("Change").attr("id", "butt1_" + item);
		b1.addClass("butt1").button().click(function() {
			changeForm(selected, item, context);
		    });
		var b2 = $("<button></button>").text("Save").attr("id", "butt2_" + item);
		b2.addClass("butt2").button().hide().click(function() {
			saveForm(selected, item, context, "/change/settings/");
		    });
		var b3 = $("<button></button>").text("Abort").attr("id", "butt3_" + item);
		b3.addClass("butt3").button().hide().click(function() {
			restore_view(selected, item, context);
		    });
		
		var panel = $("<div></div>").addClass("panel");
		b1.appendTo(panel);
		b2.appendTo(panel);
		b3.appendTo(panel);
		panel.appendTo(desc);
		
		flag = true;
	    }
	    else {
		if ($("#tabs-" + selected + " #list" + selected + " #butt1_" + item).is(":visible") == true) {
		    for (var i in data[item]) {
			$("#tabs-" + selected + " #list" + selected + " #l_" + data[item][i].name + "_" + item).attr("title", data[item][i].description);
			if ($("#tabs-" + selected + " #list" + selected + " #fhv_" + data[item][i].name + "_" + item)
			    .attr("value") != "text=" + data[item][i].value) {
			    $("#tabs-" + selected + " #list" + selected + " #fh_" + data[item][i].name + "_" + item)
				.children(0).replaceWith(ret_fh("fhv_" + data[item][i].name + "_" + item, data[item][i].value));
			}
			var temp = $("#tabs-" + selected + " #list" + selected + " #" + data[item][i].name + "_" + item)
			    .text(data[item][i].value).attr("title", data[item][i].description);
			if (data[item][i].editable == false) {
			    if (temp.hasClass("no_edit") == false) temp.addClass("no_edit");
			}
			else
			    temp.removeClass("no_edit");
		    }
		}
	    }
	    // rimuovere quelli nn + esistenti al max
	});
    if (flag)
	$("#tabs-" + selected + " #accordion" + selected).accordion('destroy').accordion({header: "h3", autoHeight: false, collapsible: true});
};

function manage_row(state, selected, index, context) {
    var b_label = "";
    if (state == 0) {
	$("#tabs-" + selected + " #list" + selected + " #butt1_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
	$("#tabs-" + selected + " #list" + selected + " #butt4_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
	$("#tabs-" + selected + " #list" + selected + " #butt6_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
	$("#tabs-" + selected + " #list" + selected + " #butt7_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
	
	$("#tabs-" + selected + " #list" + selected + " #" + context + index + " h3").removeClass('ui-state-disabled');
	$("#tabs-" + selected + " #list" + selected + " #" + context + index + " #a_" + index).removeClass('disabled2');
	$("#tabs-" + selected + " #list" + selected + " #" + context + index + " h3 span").removeClass('ui-icon-close');
	b_label = "Disable";
    } else {
	$("#tabs-" + selected + " #list" + selected + " #butt1_" + index).addClass('ui-state-disabled').attr('disabled', true);
	$("#tabs-" + selected + " #list" + selected + " #butt4_" + index).addClass('ui-state-disabled').attr('disabled', true);
	$("#tabs-" + selected + " #list" + selected + " #butt6_" + index).addClass('ui-state-disabled').attr('disabled', true);
	$("#tabs-" + selected + " #list" + selected + " #butt7_" + index).addClass('ui-state-disabled').attr('disabled', true);
	
	$("#tabs-" + selected + " #list" + selected + " #" + context + index + " h3").addClass('ui-state-disabled');
	$("#tabs-" + selected + " #list" + selected + " #" + context + index + " #a_" + index).addClass('disabled2');
	$("#tabs-" + selected + " #list" + selected + " #" + context + index + " h3 span").addClass('ui-icon-close');
	b_label = "Enable";
    }
    $("#tabs-" + selected + " #list" + selected + " #butt5_" + index).button("option", "label", b_label);
};

function changeForm(selected, index, context) {
    $("#tabs-" + selected + " #list" + selected + " #butt1_" + index).hide();
    $("#tabs-" + selected + " #list" + selected + " #butt2_" + index).show();
    $("#tabs-" + selected + " #list" + selected + " #butt3_" + index).show();
    $("#tabs-" + selected + " #list" + selected + " #butt4_" + index).addClass('ui-state-disabled').attr('disabled', true);
    $("#tabs-" + selected + " #list" + selected + " #butt5_" + index).addClass('ui-state-disabled').attr('disabled', true);
    $("#tabs-" + selected + " #list" + selected + " #butt6_" + index).addClass('ui-state-disabled').attr('disabled', true);
    $("#tabs-" + selected + " #list" + selected + " #butt7_" + index).addClass('ui-state-disabled').attr('disabled', true);
    
    $("#tabs-" + selected + " #list" + selected + " #" + context + index).find(".val").each(function(index) {
	    var text = $(this).text();
	    var code = $(this).attr("id");
	    code = code.substring(0, code.lastIndexOf("_"));
	    
	    $(this).text("");
	    var i;
	    
	    var aurls = "";
	    if ((context == "origin" || context == "dest") && index == 2)
		aurls = "/get/select1/";
	    else if (context == "route" && index == 1)
		aurls = "/get/select2/";
	    else if (context == "route" && index == 2)
		aurls = "/get/select3/";
	    
	    if (aurls != "") {
		i = $("<select></select>").attr("id", code);
		$.ajax({type: "POST",
			    dataType: "json",
			    data: {"sel": text},
			    url: aurls,
			    success: function(data) {
			    $.each(data, function(item) {
				    var opt = $("<option></option>").attr("value", data[item][0]).text(data[item][1]);
				    if (data[item][2] == 1)
					opt.attr("selected", "yes");
				    opt.appendTo(i);
				});
			}
		    });
	    }
	    else {
		i = $("<input></input>").attr("type", "text").addClass("myselect").attr("id", code).val(text);
		if (context == "route" && (index == 3 || index == 4))
		    i.datepicker({ dateFormat: 'yy-mm-dd', showAnim: 'fadeIn'});
	    }
	    if ($(this).hasClass("no_edit"))
		$(this).text(text);
	    else
		i.appendTo($(this));
	});
};

function remove_errors(selected, index, context) {
    $("#tabs-" + selected + " #list" + selected + " #" + context + index).find(".val").each(function(index) {
	    $(this).removeClass("error");
	    $(this).children(".error_item").remove();
	});
};

function restore_view(selected, index, context) {
    $("#tabs-" + selected + " #list" + selected + " #butt1_" + index).show();
    $("#tabs-" + selected + " #list" + selected + " #butt2_" + index).hide();
    $("#tabs-" + selected + " #list" + selected + " #butt3_" + index).hide();
    $("#tabs-" + selected + " #list" + selected + " #butt4_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
    $("#tabs-" + selected + " #list" + selected + " #butt5_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
    $("#tabs-" + selected + " #list" + selected + " #butt6_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
    $("#tabs-" + selected + " #list" + selected + " #butt7_" + index).removeClass('ui-state-disabled').removeAttr('disabled');
    
    remove_errors(selected, index, context);
    getData(-1);
};

function saveForm(selected, index, context, urls) {
    // prendi i dati dalle input x inviarli
    var elem = {};
    $("#tabs-" + selected + " #list" + selected + " #" + context + index).find(":input").each(function(index) {
	    if ($(this).attr("type") != "submit") {
		elem[$(this).attr("id")] = $(this).val();
	    }
	});
    
    $.ajax({type: "POST",
	    dataType: "json",
	    url: urls + index, 
	    data: elem, 
	    success: function(ret) {
		remove_errors(selected, index, context);
		
		if (ret.result != "success") {
		    for (var i=0; i<ret.result.length; i++) {
			var val_field = $("#tabs-" + selected + " #list" + selected + " #" + ret.result[i].key + "_" + index);
			val_field.addClass("error");
			var err = $("<span></span>").attr("id", "error_" + ret.result[i].key).addClass("error_item").text(ret.result[i].value);
			val_field.append(err);
		    }
		}
		else
		    restore_view(selected, index, context);
	    }});
};

function runDeleteSched(code) {
    $("#dialog").dialog( "option", "title", "Delete schedules");
    $("#dialog").html("");
    
    $.ajax({url: "/del/schedule/" + code, 
	    dataType: "html",
	    success: function(data) {
		$("#dialog").html(data);
	    }});
    
    $("#dialog").dialog("open");
};

function runAdd() {
    $("#dialog").dialog( "option", "title", "Add new");
    $("#dialog").html("");
    
    var selected = $("#tabs").tabs('option', 'selected');
    var purl = "";
    if (selected == 1)
	purl = "/add/origin/";
    else if (selected == 2)
	purl = "/add/dest/";
    else if (selected == 3)
	purl = "/add/route/";
    else if (selected == 4)
	purl = "/add/previous/";
    else if (selected == 7)
	purl = "/add/user/";
    
    if (purl != "") {
	$.ajax({url: purl, 
		dataType: "html",
		success: function(data) {
		    $("#dialog").html(data);
		    if (selected == 3) {
			$("#id_start").datepicker({ dateFormat: 'yy-mm-dd', showAnim: 'fadeIn'});
			$("#id_end").datepicker({ dateFormat: 'yy-mm-dd', showAnim: 'fadeIn'});
			$("#id_s_start").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
			$("#id_s_end").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
		    }
		}});
    }
    
    $("#dialog").dialog("open");
};

function runEditUser(code) {
    $("#dialog").dialog( "option", "title", "Edit user");
    $("#dialog").html("");
    
    $.ajax({url: "/edit/user/" + code, 
	    dataType: "html",
	    success: function(data) {
		$("#dialog").html(data);
	    }
	});
    
    $("#dialog").dialog("open");
};

function runAddSched(code) {
    $("#dialog").dialog( "option", "title", "Add schedule");
    $("#dialog").html("");
    
    $.ajax({url: "/add/schedule/" + code, 
	    dataType: "html",
	    success: function(data) {
		$("#dialog").html(data);
		$("#id_s_start").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
		$("#id_s_end").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
	    }
	});
    
    $("#dialog").dialog("open");
};

function checkForm(context, purl) {
    var firstButton = $('.ui-dialog-buttonpane button:first');
    firstButton.addClass('ui-state-disabled');
    firstButton.attr('disabled', true);
    var secondButton = firstButton.next();
    secondButton.addClass('ui-state-disabled');
    secondButton.attr('disabled', true);
    $("#dialog").find(":input").each(function(index) {
	    $(this).attr('disabled', true);
	});
    $("#dialog .loading").show();
    
    var elem = {};
    $("#dialog").find(":input").each(function(index) {
	    var code = $(this).attr("id");
	    code = code.substring(code.indexOf("_") + 1, code.length);
	    
	    if ($(this).attr("type") == "checkbox")
		elem[code] = $(this).attr('checked');
	    else
		elem[code] = $(this).val();
	});
    
    $.ajax({type: "POST",
	    dataType: "html",
	    url: purl, 
	    data: elem, 
	    success: function(ret) {
	        $("#dialog").html(ret);
		
		firstButton.removeClass('ui-state-disabled');
		firstButton.attr('disabled', false);
		secondButton.removeClass('ui-state-disabled');
		secondButton.attr('disabled', false);
		
		if (context == 3) {
		    $("#id_start").datepicker({ dateFormat: 'yy-mm-dd', showAnim: 'fadeIn'});
		    $("#id_end").datepicker({ dateFormat: 'yy-mm-dd', showAnim: 'fadeIn'});
		    $("#id_s_start").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
		    $("#id_s_end").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
		} else if (context == 10) { // schedule
		    $("#id_s_start").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
		    $("#id_s_end").timepicker({showSecond: true, timeFormat: 'hh:mm:ss', showAnim: 'fadeIn'});
		}
		
		if ($("#dialog form .err").html() == "False") {
		    if (context == 100) {// login
			$("#dialog").dialog("close");
			location.href = "/";
		    }
		    else {
			getData(-1);
			$("#dialog").dialog("close");
		    }
		}
	    }
	});
};

function checkForm2(purl) {
    var firstButton = $('.ui-dialog-buttonpane button:first');
    firstButton.addClass('ui-state-disabled');
    firstButton.attr('disabled', true);
    var secondButton = firstButton.next();
    secondButton.addClass('ui-state-disabled');
    secondButton.attr('disabled', true);
    $("#dialog").find(":input").each(function(index) {
	    $(this).attr('disabled', true);
	});
    $("#dialog .loading").show();
    
    var elem = {};
    var i = 0
    $("#dialog").find(":input").each(function(index) {
	    if ($(this).attr("value") == "on") {
		elem["v_" + i] = $(this).attr("name");
		i++;
	    }
	});
    
    $.ajax({type: "POST",
	    url: purl, 
	    data: elem, 
	    success: function(ret) {
		firstButton.removeClass('ui-state-disabled');
		firstButton.attr('disabled', false);
		secondButton.removeClass('ui-state-disabled');
		secondButton.attr('disabled', false);
		
		getData(-1);
		$("#dialog").dialog("close");
	    }
	});
};