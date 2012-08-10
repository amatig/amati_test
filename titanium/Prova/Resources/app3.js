var initMem = Math.floor(Titanium.Platform.availableMemory);
Titanium.API.info('INIT memory free: ' + initMem);

function actMem() {
	Titanium.API.info('memory used: ' + Math.floor(initMem - Titanium.Platform.availableMemory) + 
	' - memory free: ' + Math.floor(Titanium.Platform.availableMemory));
}

function getOrientationModes() {
	return [Ti.UI.PORTRAIT];
}

function getBaseLayoutImagesDir() {
	return Ti.Filesystem.resourcesDirectory + '/images/';
}

Titanium.UI.setBackgroundColor('#000');

var window = Ti.UI.createWindow({
	orientationModes: getOrientationModes(),
	navBarHidden: true,
	tabBarHidden: true,
	fullscreen: true
});

var num = 5; // immagini totali
var nimage = 5; // immagini fisiche
var nview = 3;

var imageViewArray = [];
var imageNameArray = [];
var nextImageIndex = 1;

for(var i = 0; i <= num; i++) {
	imageNameArray[i] = getBaseLayoutImagesDir() + 'image' + ((i % nimage) + 1) + '.jpg';
}

view = Ti.UI.createView({width: 768 * 3});

for (var i = 0; i < 3 ; i++) {
	imageViewArray[i] = Titanium.UI.createImageView({left: i * 768, width: 768});
	imageViewArray[i].image = imageNameArray[i % num];
	view.add(imageViewArray[i]);
}

view.left = -768;

var pick = null;

view.addEventListener('touchstart', function(e) {
	pick = e.globalPoint.x;
});

view.addEventListener('touchmove', function(e) {
	view.left = 384 + e.globalPoint.x;
});

view.addEventListener('touchend', function(e) {
	var movement = pick - e.globalPoint.x;
	if (movement > 10) {
		var loadFromRightAnimation = Ti.UI.createAnimation({
			duration : 500,
			left : -768,
			//curve:Titanium.UI.ANIMATION_CURVE_EASE_IN
		});
		view.animate(loadFromRightAnimation);
	}
});

window.add(view);

window.open({
	transition: Titanium.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
});

Ti.Gesture.addEventListener('orientationchange', function(e){
    Ti.UI.orientation = e.orientation;
});