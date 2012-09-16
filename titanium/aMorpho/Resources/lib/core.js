var libCore = function() {
	// Ti.include('lib/underscore-min.js');

	// implementation of extend
	Object.prototype.extend = function(obj) {
		var temp = new Object();
		for (var name in this) {
			temp[name] = this[name];
		}
		for (var name in obj) {
			temp[name] = obj[name];
		}
		return temp;
	}
};

libCore.prototype.createController = function(name, params) {
	var c = require('controllers/' + name).createController();
	this.createView(c, name);
	if (c.init)
		c.init(params);
	return c;
};

libCore.prototype.createView = function(controller, name) {
	controller.views = {};

	var style = {};
	// LOAD STYLE
	var styleFile = Ti.Filesystem.getFile(App.Config.getConfigDir() + "styles/" + name + ".json");
	if (styleFile.exists())
		style = JSON.parse(styleFile.read().text);
	styleFile = null;

	// LOAD XML
	var xmlFile = Ti.Filesystem.getFile(App.Config.getConfigDir() + "views/" + name + ".xml");
	if (xmlFile.exists()) {
		var xml = Ti.XML.parseString(xmlFile.read().text);
		var root = xml.documentElement.getElementsByTagName('Window').item(0);
		if (root)
			visita(null, root);
	}
	xmlFile = null;

	function visita(parent, node) {
		// GET STYLE
		var attrs = style['.' + node.getAttribute('class')] || {};
		var temp_attrs = style['#' + node.getAttribute('id')] || {};
		attrs = attrs.extend(temp_attrs);

		// CREATE VIEW
		controller.views[node.getAttribute('id')] = eval('Ti.UI.create' + node.getNodeName())(attrs);
		if (parent)
			controller.views[parent.getAttribute('id')].add(controller.views[node.getAttribute('id')]);
		else
			controller.window = controller.views[node.getAttribute('id')];

		var children = node.childNodes;
		for (var i = 0; i < children.item.length; i++) {
			var c = children.item(i);
			if (c.getNodeType() == c.ELEMENT_NODE)
				visita(node, c);
		}
	}

};

exports.createApp = function() {
	return new libCore();
};
