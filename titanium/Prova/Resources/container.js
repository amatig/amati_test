
function createContainer() {
	var view = Titanium.UI.createView();
	
	var containerViewLeft = Titanium.UI.createImageView({
		zIndex: 1000,
		width: 768, 
		height: 1024
	});
	
	var containerViewRight = Titanium.UI.createImageView({
		zIndex: 900,
		//backgroundColor: 'red',
		visible: false,
		width: 768, 
		height: 1024
	});
	
	view.add(containerViewLeft);
	view.add(containerViewRight);
	
	view.page = null;
	view.index = null;
	
	view.changeImage = function(type, index, imageNameArray, page) {
		//Ti.API.info('-> ' + type + ' - ' + index);
		
		if (page) view.page = page;
		view.index = index;
		
		if (type == 'portrait') {
			containerViewLeft.image = imageNameArray[index];
		} else {
			var indexLeft = view.index * 2;
			Ti.API.info('-> ' + indexLeft + ' ' + imageNameArray.length);
			
			containerViewLeft.image = imageNameArray[indexLeft];
			if (imageNameArray.length - 1 > indexLeft)
				containerViewRight.image = imageNameArray[indexLeft + 1];
		}
	}
	
	view.changeOrientation = function(e, step, imageNameArray) {
		var half = 666;
		var tr_single = Titanium.UI.create2DMatrix();
		
		if (e.orientation == 1 || e.orientation == 2) {
			Ti.API.info('--> ' + step + ' ' + view.index + ' ' + view.page);
			
			tr_single = tr_single.scale(1);
			
			containerViewLeft.left = 0;
			containerViewLeft.transform = tr_single;
			
			containerViewRight.visible = false;
			
			containerViewRight.left = 0;
			containerViewRight.transform = tr_single;
			
			containerViewLeft.image = imageNameArray[view.index];
		} else {
			//view.page = Math.floor(view.page / 2) + index;
			Ti.API.info('--> ' + step + ' ' + view.index + ' ' + view.page);
			
			var indexLeft = step * 2;
			
			tr_single = tr_single.scale(half / 1000);
			
			containerViewRight.visible = true;
			
			containerViewLeft.left = -half / 4 + 39;
			containerViewLeft.transform = tr_single;
			
			containerViewRight.left = half / 2 + 51;
			containerViewRight.transform = tr_single;
			
			containerViewLeft.image = imageNameArray[indexLeft];
			if (imageNameArray.length - 1 > indexLeft)
				containerViewRight.image = imageNameArray[indexLeft + 1];
		}
	} 
	
	return view;
}
