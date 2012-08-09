Ti.include('container.js');

function createScroller(imageMap) {
	var viewArray = [];
	var imageNameArray = imageMap;
	var nextImageIndex = 1;
	
	var scrollingView = Ti.UI.createScrollableView({
	    //showPagingControl:false,
	    pagingControlHeight:30,
	    //touchEnabled:true,
	    //enableZoomControls:true,
	    minZoomScale: 1,
	    maxZoomScale: 3
	});
	
	function getOrientation() {
		var type;
		if (Ti.UI.orientation == 1 || Ti.UI.orientation == 2)
			type = 'portrait';
		else if (Ti.UI.orientation == 3 || Ti.UI.orientation == 4)
			type = 'landscape';
		return type;
	}
	
	function init() {
		// inizializza le 3 views
		for (var i = 0; i < 3 ; i++) {
			var temp = createContainer();
			temp.changeImage(getOrientation(), i, imageNameArray, i + 1);
			viewArray[i] = temp;
		}
		scrollingView.views = viewArray;
	}
	
	scrollingView.addEventListener('scroll', function(e) {
		update(e);
		Ti.API.info('PAGE ' + scrollingView.views[scrollingView.currentPage].page);
	});
	
	scrollingView.maxPage = function() {
		if (Ti.UI.orientation == 1 || Ti.UI.orientation == 2) {
			return imageNameArray.length - 1;
		} else {
			return Math.floor((imageNameArray.length - 1) / 2);
		}
	}
	
	function update(e) {
		var type = getOrientation();
		
		if (e.currentPage == 2 && nextImageIndex < (e.source.maxPage() - 2)) {
	  		Ti.API.info("- aggiundi destra -");
	  		nextImageIndex += 1;
	  		
	  		var first = scrollingView.views[0];
	  		viewArray[0] = scrollingView.views[1];
	  		viewArray[1] = scrollingView.views[2];
	  		//this.scrollingView.removeView(first);
	  		first.changeImage(type, nextImageIndex, imageNameArray); // elimina effetto sfarfallio
	  		viewArray[2] = first;
	  		
	  		scrollingView.views = viewArray;
			scrollingView.currentPage = 1;
			
			first.changeImage(type, nextImageIndex + 1, imageNameArray, scrollingView.views[1].page + 1);
			
			//first.index = scrollingView.views[1].index + 1; // inc indice
		} else if (e.currentPage == 0 && nextImageIndex > 1) {
			Ti.API.info('---> ' + nextImageIndex);
			Ti.API.info("- aggiundi sinistra -");
			nextImageIndex -= 1;
	  		
	  		var first = scrollingView.views[2];
	  		viewArray[1] = scrollingView.views[0];
	  		viewArray[2] = scrollingView.views[1];
	  		//this.scrollingView.removeView(first);
	  		first.changeImage(type, nextImageIndex, imageNameArray);
	  		viewArray[0] = first;
	  		
	  		scrollingView.views = viewArray;
	  		scrollingView.currentPage = 1;
	  		
	  		first.changeImage(type, nextImageIndex - 1, imageNameArray, scrollingView.views[1].page - 1);
			
			//first.index = scrollingView.views[1].index - 1; // dec indice
		}
	}
	
	/*Ti.Gesture.addEventListener('orientationchange', function(e) {
		if (e.orientation != 0) {
			Ti.API.info('change orientation');
			
			if (scrollingView.currentPage == 2) {
				Ti.API.info('2 1 0');
				viewArray[2].changeOrientation(e, 0, imageNameArray);
				viewArray[1].changeOrientation(e, -1, imageNameArray);
				viewArray[0].changeOrientation(e, -2, imageNameArray);
			} else if (scrollingView.currentPage == 0) {
				Ti.API.info('0 1 2');
				viewArray[0].changeOrientation(e, 0, imageNameArray);
				viewArray[1].changeOrientation(e, 1, imageNameArray);
				viewArray[2].changeOrientation(e, 2, imageNameArray);
			} else {
				Ti.API.info('1 0 2');
				viewArray[1].changeOrientation(e, 0, imageNameArray);
				viewArray[0].changeOrientation(e, -1, imageNameArray);
				viewArray[2].changeOrientation(e, 1, imageNameArray);
			}
			
			//for (var i = 0; i < 3 ; i++)
			//	viewArray[i].changeOrientation(e, i, imageNameArray);
		}
	});*/
	
	this.getLayout = function() {
		return scrollingView;
	}
	
	init();
}