var libConfig = function() {
	var configFile = Titanium.Filesystem.getFile(this.getConfigDir() + 'config.json');
	var config = JSON.parse(configFile.read().text);
	configFile = null;

	for (var name in config) {
		this[name] = config[name];
	}
};

libConfig.prototype.getConfigDir = function() {
	var dir = Titanium.Filesystem.applicationDataDirectory + 'downloader/ApplicationFolder/';
	var appFolder = Titanium.Filesystem.getFile(dir);
	var flag = appFolder.exists();
	appFolder = null;
	return flag ? dir : '';
};

libConfig.prototype.getImagesDir = function() {
	var dir = Titanium.Filesystem.applicationDataDirectory + 'downloader/ApplicationFolder/images/';
	var imgFolder = Titanium.Filesystem.getFile(dir);
	var flag = imgFolder.exists();
	imgFolder = null;
	return flag ? dir : '/images/';
};

exports.createConfig = function() {
	return new libConfig();
};
