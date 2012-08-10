// this sets the background color of the master UIView (when there are no windows/tab groups on it)
Ti.include('scroller.js');

function getBaseLayoutImagesDir() {
	return Ti.Filesystem.resourcesDirectory + '/images/';
}

Titanium.UI.setBackgroundColor('#000');

var window = Ti.UI.createWindow({
	navBarHidden : true,
	tabBarHidden : true,
	fullscreen : true
});

var num = 5;
var imageNameArray = [];

for (var i = 0; i <= num; i++) {
	imageNameArray[i] = getBaseLayoutImagesDir() + 'image' + ((i % 5) + 1) + '.jpg';
}

var scrollingView = new createScroller(imageNameArray);

window.add(scrollingView.getLayout());

window.open({
	transition: Titanium.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
});
