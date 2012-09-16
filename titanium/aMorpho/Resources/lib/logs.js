var libLog = function() {

};

libLog.prototype.info = function(msg) {
	if (App.Config.log)
		Ti.API.info(msg);
};

libLog.prototype.warn = function(msg) {
	if (App.Config.log)
		Ti.API.warn(msg);
};

libLog.prototype.error = function(msg) {
	if (App.Config.log)
		Ti.API.error(msg);
};

libLog.prototype.debug = function(msg) {
	if (App.Config.log)
		Ti.API.debug(msg);
};

exports.createLog = function() {
	return new libLog();
};
