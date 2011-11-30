// this sets the background color of the master UIView (when there are no windows/tab groups on it)

function getOrientationModes() {
	return [Ti.UI.PORTRAIT];
}

function getBaseLayoutImagesDir() {
	return Ti.Filesystem.resourcesDirectory + '/images/';
}

Titanium.UI.setBackgroundColor('#000');

var window = Ti.UI.createWindow({
	orientationModes : getOrientationModes(),
	navBarHidden : true,
	tabBarHidden : true,
	fullscreen : true
});

function createZoomHighImage(image) {
    var imageView = Ti.UI.createImageView({
        width: 'auto',
        height: 'auto',
        image: image
    });
    
    var scrollView = Ti.UI.createScrollView({
        contentHeight: 'auto',
        contentWidth: 'auto',
        maxZoomScale: 1,
        minZoomScale: 0.5
    });
    
    imageView.addEventListener('load', function() {
        scrollView.zoomScale = 0.5;
    });
    
    scrollView.add(imageView);
    
    return scrollView;
}

var v1 = createZoomHighImage(getBaseLayoutImagesDir() + 'image.jpeg');
var v2 = createZoomHighImage(getBaseLayoutImagesDir() + 'image.jpeg');

var scroll = Ti.UI.createScrollableView({
	views:[v1, v2],
    showPagingControl:false,
    pagingControlHeight:30,
    enableZoomControls:false,
    currentPage: 0
});

window.add(scroll);

window.open({
	transition: Titanium.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
});
