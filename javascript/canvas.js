function is_on(x, y, rect) {
    if (x >= rect[0] && y >= rect[1] && 
	x <= rect[0] + rect[2] && y <= rect[1] + rect[3])
	return true;
    else
	return false;
}

function draw(elem) {
    var canvas = document.getElementById("area");
    if (canvas.getContext) {
	var ctx = canvas.getContext("2d");
	ctx.clearRect(0, 0, canvas.width, canvas.height); // clear
	
	var img_add = new Image();
	img_add.addEventListener('load', function () {
		ctx.drawImage(img_add, 10, 10, 32, 32);
	    }, false);
	img_add.src = "./add.png";
	
	var img_line = new Image();
	img_line.addEventListener('load', function () {
		ctx.drawImage(img_line, 50, 10, 32, 32);
	    }, false);
	img_line.src = "./line.png";
	
	for (var i = 0; i < elem.length; i++) {
	    var e = elem[i];
	    //ctx.shadowOffsetX = 3;
	    //ctx.shadowOffsetY = 3;
	    //ctx.shadowBlur = 4;
	    //ctx.shadowColor = '#eee';
	    ctx.fillStyle = "eee";
	    ctx.fillRect(e.x, e.y, e.w, e.h);
	    ctx.strokeRect(e.x, e.y, e.w, e.h);
	}
    }
}

function init() {
    var pick = null;
    var elem = [{x:200, y:100, w:100, h:60}];
    draw(elem);
    
    //set it true on mousedown
    $("#area").mousedown(function(e) {
	    var offset = $("#area").offset();
	    var x = event.pageX - offset.left;
	    var y = event.pageY - offset.top;
	    if (is_on(x, y, [10, 10, 32, 32]))
		{
		    elem.push({x:200, y:100, w:100, h:60});
		    draw(elem);
		}
	    else {
		for (var i = elem.length - 1; i >= 0; i--) {
		    var e = elem[i];
		    if (is_on(x, y, [e.x, e.y, e.w, e.h])) {
			elem.splice(i, 1);
			elem.push(e);
			pick = e;
			break;
		    }
		}
	    }
	});
    
    //reset it on mouseup
    $("#area").mouseup(function(e) {
	    var offset = $("#area").offset();
	    pick = null;
	});
    
    $("#area").mousemove(function(e) {
	    var offset = $("#area").offset();
            if (pick) {
		var x = event.pageX - offset.left;
		var y = event.pageY - offset.top;
		pick.x = x - pick.w / 2;
		pick.y = y - pick.h / 2;
		draw(elem);
		/*ctx.lineWidth = 15;
		ctx.lineCap = "round";
		ctx.beginPath();
		ctx.moveTo(e.pageX - offset.left, e.pageY - offset.top);
		ctx.lineTo(e.pageX - offset.left + 1, e.pageY - offset.top + 1);
		ctx.stroke();*/
            }
	});
}

$(document).ready(init);