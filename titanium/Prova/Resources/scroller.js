
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
			var containerViewLeft = Titanium.UI.createImageView({
				width: 768, 
				height: 1024
			});
			var containerViewRight = Titanium.UI.createImageView({
				//backgroundColor: 'red',
				visible: false,
				width: 768, 
				height: 1024
			});
			viewArray[i].add(containerViewRight);
			viewArray[i].add(containerViewLeft);
		}
		scrollingView.views = viewArray;
		
		try {
			scrollingView.views[0].children[1].image = imageNameArray[0];
			//scrollingView.views[0].children[0].image = imageNameArray[1];
			scrollingView.views[1].children[1].image = imageNameArray[1];
			//scrollingView.views[1].children[0].image = imageNameArray[3];
			scrollingView.views[2].children[1].image = imageNameArray[2];
			//scrollingView.views[2].children[0].image = imageNameArray[5];
		} catch(e) {
			Ti.API.error(e);
		}
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
	  		first.children[1].image = imageNameArray[nextImageIndex]; // elimina affetto sfarfallio
	  		viewArray[2] = first;
	  		
	  		scrollingView.views = viewArray;
			scrollingView.currentPage = 1;
			
			first.children[1].image = imageNameArray[nextImageIndex + 1];
			
			first.index = scrollingView.views[1].index + 1; // inc indice
		} else if (e.currentPage == 0 && nextImageIndex > 1) {
			Ti.API.info("- aggiundi sinistra -");
			nextImageIndex -= 1;
	  		
	  		var first = scrollingView.views[2];
	  		viewArray[1] = scrollingView.views[0];
	  		viewArray[2] = scrollingView.views[1];
	  		//scrollingView.removeView(first);
	  		first.children[1].image=imageNameArray[nextImageIndex];
	  		viewArray[0] = first;
	  		
	  		scrollingView.views = viewArray;
	  		scrollingView.currentPage = 1;
	  		
	  		first.children[1].image = imageNameArray[nextImageIndex - 1];
			
			first.index = scrollingView.views[1].index - 1; // dec indice
		}
	}
	
	Ti.Gesture.addEventListener('orientationchange', function(e) {
		if (e.orientation != 0) {
			var half = 666;
			
			var tr_single = Titanium.UI.create2DMatrix();
			if (e.orientation == 1 || e.orientation == 2) {
				tr_single = tr_single.scale(1);
				
				scrollingView.views[0].children[1].left = 0;
				scrollingView.views[0].children[1].transform = tr_single;
				scrollingView.views[1].children[1].left = 0;
				scrollingView.views[1].children[1].transform = tr_single;
				scrollingView.views[2].children[1].left = 0;
				scrollingView.views[2].children[1].transform = tr_single;
				
				scrollingView.views[0].children[0].visible = false;
				scrollingView.views[1].children[0].visible = false;
				scrollingView.views[2].children[0].visible = false;
				
				scrollingView.views[0].children[0].left = 0;
				scrollingView.views[0].children[0].transform = tr_single;
				scrollingView.views[1].children[0].left = 0;
				scrollingView.views[1].children[0].transform = tr_single;
				scrollingView.views[2].children[0].left = 0;
				scrollingView.views[2].children[0].transform = tr_single;
			} else {
				tr_single = tr_single.scale(half / 1000);
				
				scrollingView.views[0].children[0].visible = true;
				scrollingView.views[1].children[0].visible = true;
				scrollingView.views[2].children[0].visible = true;
				
				scrollingView.views[0].children[1].left = -half / 4 + 39;
				scrollingView.views[0].children[1].transform = tr_single;
				scrollingView.views[1].children[1].left = scrollingView.views[0].children[1].left;
				scrollingView.views[1].children[1].transform = tr_single;
				scrollingView.views[2].children[1].left = scrollingView.views[0].children[1].left;
				scrollingView.views[2].children[1].transform = tr_single;
				
				scrollingView.views[0].children[0].left = half / 2 + 51;
				scrollingView.views[0].children[0].transform = tr_single;
				scrollingView.views[1].children[0].left = scrollingView.views[0].children[0].left;
				scrollingView.views[1].children[0].transform = tr_single;
				scrollingView.views[2].children[0].left = scrollingView.views[0].children[0].left;
				scrollingView.views[2].children[0].transform = tr_single;
			}
		}
	});
	
	this.getLayout = function() {
		return scrollingView;
	}
	
	init();
}