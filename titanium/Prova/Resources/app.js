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

var num = 5;

var imageViewArray = [];
var imageNameArray = [];

for (var i = 0; i < 3 ; i++) {
	//var temp = Titanium.UI.createScrollView();
	//temp.add(Titanium.UI.createImageView())
	var temp = Titanium.UI.createImageView();
	imageViewArray[i] = temp;
}

for(var i = 0; i <= num; i++) {
	imageNameArray[i] = getBaseLayoutImagesDir() + 'image' + ((i % 5) + 1) + '.jpg';
}

var scrollingView = Ti.UI.createScrollableView({
	views: imageViewArray,
    //showPagingControl:false,
    pagingControlHeight:30,
    //touchEnabled:true,
    //enableZoomControls:true,
    minZoomScale: 1,
    maxZoomScale: 3
});

scrollingView.views[0].image = imageNameArray[0];
scrollingView.views[1].image = imageNameArray[1];
scrollingView.views[2].image = imageNameArray[2];


//var prevImageIndex = 0;
var nextImageIndex = 1;

scrollingView.addEventListener('scroll', function(e) {
	//Ti.API.info("P=" + prevImageIndex);
	//Ti.API.info("C=" + e.currentPage);
	//Ti.API.info("N=" + nextImageIndex);
	update(e);
});

function update(e) {
	if (e.currentPage == 2 && nextImageIndex < imageNameArray.length - 3) {
  		Ti.API.info("aggiundi destra");
  		nextImageIndex += 1;
  		
  		var first = scrollingView.views[0];
  		imageViewArray[0] = scrollingView.views[1];
  		imageViewArray[1] = scrollingView.views[2];
  		scrollingView.removeView(first);
  		first.image = imageNameArray[nextImageIndex]; // elimina affetto sfarfallio
  		imageViewArray[2] = first;
  		
  		scrollingView.views = imageViewArray;
		scrollingView.currentPage = 1;
		
		first.image = imageNameArray[nextImageIndex + 1];
	} else if (e.currentPage == 0 && nextImageIndex > 1) {
		Ti.API.info("aggiundi sinistra");
		nextImageIndex -= 1;
  		
  		var first = scrollingView.views[2];
  		imageViewArray[1] = scrollingView.views[0];
  		imageViewArray[2] = scrollingView.views[1];
  		scrollingView.removeView(first);
  		first.image=imageNameArray[nextImageIndex];
  		imageViewArray[0] = first;
  		
  		scrollingView.views = imageViewArray;
  		scrollingView.currentPage = 1;
  		
  		first.image = imageNameArray[nextImageIndex - 1];
	}
}

window.add(scrollingView);

window.open({
	transition: Titanium.UI.iPhone.AnimationStyle.FLIP_FROM_LEFT
});

Ti.Gesture.addEventListener('orientationchange', function(e){
    Ti.UI.orientation = e.orientation;
});
