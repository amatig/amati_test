
function createScroller(imageMap) {
	var viewArray = [];
	var imageNameArray = imageMap;
	
	var nextImageIndex = 1;
	var page = 1;
	
	var scrollingView = Ti.UI.createScrollableView({
	    //showPagingControl:false,
	    //pagingControlHeight:30,
	    //touchEnabled:true,
	    //enableZoomControls:true,
	    minZoomScale: 1,
	    maxZoomScale: 3
	});
	
	function init() {
		for (var i = 0; i < 3 ; i++) {
			viewArray[i] = Titanium.UI.createView();
			var containerView = Titanium.UI.createImageView({
				width: 768, 
				height: 1024
			});
			viewArray[i].add(containerView);
		}
		scrollingView.views = viewArray;
		
		scrollingView.views[0].children[0].image = imageNameArray[0];
		scrollingView.views[1].children[0].image = imageNameArray[1];
		scrollingView.views[2].children[0].image = imageNameArray[2];
		scrollingView.views[0].index = 1;
		scrollingView.views[1].index = 2;
		scrollingView.views[2].index = 3;
	}
	
	scrollingView.addEventListener('scroll', function(e) {
		update(e);
		Ti.API.info('PAGE ' + scrollingView.views[scrollingView.currentPage].index);
	});
	
	function update(e) {
		if (e.currentPage == 2 && nextImageIndex < imageNameArray.length - 3) {
	  		Ti.API.info("- aggiundi destra -");
	  		nextImageIndex += 1;
	  		
	  		var first = scrollingView.views[0];
	  		viewArray[0] = scrollingView.views[1];
	  		viewArray[1] = scrollingView.views[2];
	  		//scrollingView.removeView(first);
	  		first.children[0].image = imageNameArray[nextImageIndex]; // elimina affetto sfarfallio
	  		viewArray[2] = first;
	  		
	  		scrollingView.views = viewArray;
			scrollingView.currentPage = 1;
			
			first.children[0].image = imageNameArray[nextImageIndex + 1];
			
			first.index = scrollingView.views[1].index + 1; // inc indice
		} else if (e.currentPage == 0 && nextImageIndex > 1) {
			Ti.API.info("- aggiundi sinistra -");
			nextImageIndex -= 1;
	  		
	  		var first = scrollingView.views[2];
	  		viewArray[1] = scrollingView.views[0];
	  		viewArray[2] = scrollingView.views[1];
	  		//scrollingView.removeView(first);
	  		first.children[0].image=imageNameArray[nextImageIndex];
	  		viewArray[0] = first;
	  		
	  		scrollingView.views = viewArray;
	  		scrollingView.currentPage = 1;
	  		
	  		first.children[0].image = imageNameArray[nextImageIndex - 1];
	  		
			first.index = scrollingView.views[1].index - 1; // dec indice
		}
	}
	
	Ti.Gesture.addEventListener('orientationchange', function(e) {
		if (e.orientation != 0) {
			var tr_single = Titanium.UI.create2DMatrix();
			if (e.orientation == 1 || e.orientation == 2) {
				tr_single = tr_single.scale(1);
				//scrollingView.views[scrollingView.currentPage].width = 768;
				//scrollingView.views[scrollingView.currentPage].height = 1024;
				scrollingView.views[0].children[0].left = 0;
				scrollingView.views[0].children[0].transform = tr_single;
				scrollingView.views[1].children[0].left = 0;
				scrollingView.views[1].children[0].transform = tr_single;
				scrollingView.views[2].children[0].left = 0;
				scrollingView.views[2].children[0].transform = tr_single;
			} else {
				tr_single = tr_single.scale(1024 * 512 / 768 / 1000);
				//scrollingView.views[scrollingView.currentPage].width = 1024;
				//scrollingView.views[scrollingView.currentPage].height = 768;
				scrollingView.views[0].children[0].left = 1024 * 512 / 768 / 2 - 463;
				scrollingView.views[0].children[0].transform = tr_single;
				scrollingView.views[1].children[0].left = 1024 * 512 / 768 / 2 - 463;
				scrollingView.views[1].children[0].transform = tr_single;
				scrollingView.views[2].children[0].left = 1024 * 512 / 768 / 2 - 463;
				scrollingView.views[2].children[0].transform = tr_single;
			}
		}
	});
	
	this.getLayout = function() {
		return scrollingView;
	}
	
	init();
}