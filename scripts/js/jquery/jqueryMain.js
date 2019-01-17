$(document).ready(function(){
	
	var $currentWorksIndex = 0;
	var $nextWorksIndex;
	var $totalWorksImages = $('.worksImage').length;
	var $inDirection = "right";
	var $outDirection = "left";
	var $slideOutTime = 300;
	var $slideInTime = 500;
	
	//alert("number of images is "+$totalWorksImages);
	
	var $headerHeight = 50;//$('header').height();
    var $footerHeight = $('.worksFooter').height();
	var $worksThumbsHeight = $('.worksThumbs').height();
	var $worksInfoHeight = $('.worksInfo').height();
	var $worksImageSpacerTopHeight = $('.worksImageSpacerTop').height();
	var $worksImageMarginTop = 35;
	var $worksImageMarginBottom = 65;
	var $worksImageMarginTotal = $worksImageMarginTop+$worksImageMarginBottom;
	//var $worksInfoText;
	
    var $browserHeight = $( window ).height(); // returns height of browser viewport
   // var $browserWidth = $(window).width();
	var $documentHeight = $( document ).height(); // returns height of HTML document
	
	var $worksContentHeight;
	var $worksImageAreaHeight;
	
	var $navButton = $('.mainMenu li');
	var $subNav = $('.subMenu');
	var $subNavButton = $('.subMenu li');
	var $slideDownTime = 250;
	var $slideUpTime = 200;
	
	//disable Image download
	$('img').bind('contextmenu', function(e) {
		return false;
	}); 
	
	
	//navigation drop down ==================
	$navButton.click(function(event){
		var $thisSubNav = $(this).data("submenu");
		if($thisSubNav){
			event.preventDefault();
			//toggle subMenu
			$("#"+$thisSubNav).toggle();
		}
	});
	
	$navButton.mouseenter(function()
	{
		var $thisSubNav = $(this).data("submenu");
		//alert($thisSubNav);
		$(this).find('.navSignMain').addClass('navSignHover');
		//$(this).find('.navSignMain').animate({"margin-top":'3px'}, $navSpeed);
		//$(this).find('ul').slideDown($slideDownTime);
		$("#"+$thisSubNav).stop(true, true).slideDown($slideDownTime);
	});
	$navButton.mouseleave(function()
	{
		var $thisSubNav = $(this).data("submenu");
		if(!$(this).find('.navSignMain').hasClass('navSignCurrent'))
		{
			$(this).find('.navSignMain').removeClass('navSignHover');
		}	
		//$(this).find('ul').slideUp($slideUpTime);
		$("#"+$thisSubNav).stop(true, true).slideUp($slideUpTime);
	});
	
	$subNav.mouseenter(function()
	{
		//$(this).slideDown($slideDownTime/2);
		//$(this).stop(true, true).slideDown($slideDownTime);
		$(this).stop(true, true).slideDown(0);
	});
	$subNav.mouseleave(function()
	{
		//$(this).slideDown(slideDownTime/2);
		$(this).stop(true, true).slideUp($slideUpTime);
	});
	
	
	
	//============HAMMER============
	var $swipeElement = $('.worksImage');
	
	var hammertime = new Hammer($swipeElement, { drag_lock_to_axis: true });
   // hammertime.on("release dragleft dragright swipeleft swiperight", handleHammer);
    hammertime.on("swipeleft swiperight", handleHammer);
	
	/**
     * requestAnimationFrame and cancel polyfill
     */
    (function() {
        var lastTime = 0;
        var vendors = ['ms', 'moz', 'webkit', 'o'];
        for(var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
            window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
            window.cancelAnimationFrame =
                    window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
        }

        if (!window.requestAnimationFrame)
            window.requestAnimationFrame = function(callback, element) {
                var currTime = new Date().getTime();
                var timeToCall = Math.max(0, 16 - (currTime - lastTime));
                var id = window.setTimeout(function() { callback(currTime + timeToCall); },
                        timeToCall);
                lastTime = currTime + timeToCall;
                return id;
            };

        if (!window.cancelAnimationFrame)
            window.cancelAnimationFrame = function(id) {
                clearTimeout(id);
            };
    }());
	
	/*function setContainerOffset(percent, animate) {
		var px = (($swipeElement.width() / 100) * percent;
		$swipeElement.css("left", px+"px");
	}*/
	
	$('.worksImage').prepend('<img src="../../images/empty.gif" id="empty-gif"></img>');
	$('#empty-gif').bind('contextmenu', function(e) {
		return false;
	}); 
	
	function handleHammer(ev) 
	{
		//console.log(ev);
		// disable browser scrolling
		ev.gesture.preventDefault();

		switch(ev.type) {
			case 'dragright':
				//loadLeft();
				//ev.gesture.stopDetect();
				break;
			case 'dragleft':
				//loadRight();
				//ev.gesture.stopDetect();
				// stick to the finger
				//var pane_offset = -(100/pane_count)*current_pane;
				//var drag_offset = ((100/pane_width)*ev.gesture.deltaX) / pane_count;

				// slow down at the first and last pane
				/*if((current_pane == 0 && ev.gesture.direction == "right") ||
					(current_pane == pane_count-1 && ev.gesture.direction == "left")) {
					drag_offset *= .4;
				}*/

				//setContainerOffset(drag_offset + pane_offset);
				break;

			case 'swipeleft':
				//self.next();
				//ev.gesture.preventDefault();
				loadRight();
				ev.gesture.stopDetect();
				
				break;

			case 'swiperight':
				//self.prev();
				//ev.gesture.preventDefault();
				loadLeft();
				ev.gesture.stopDetect();
				
				break;

			case 'release':
				// more then 50% moved, navigate
				if(Math.abs(ev.gesture.deltaX) > pane_width/2) {
					if(ev.gesture.direction == 'right') {
						//self.prev();
						loadLeft();
					} else {
						//self.next();
						loadRight();
					}
				}
				else {
					//self.showPane(current_pane, true);
				}
				break;
		}
	}
    
	/*var hammertime = Hammer($swipeElement).on("tap", function(event) {
       // alert("tap: "+event);
    });
	var hammerSwipeLeft = Hammer($swipeElement).on("swipeleft", function(event) {
       // alert("swipeleft: "+event);
	   loadRight();
    });
	var hammerSwipeRight = Hammer($swipeElement).on("swiperight", function(event) {
       // alert("swiperight: "+event);
	   loadLeft();
    });
	
	
	
	var hammerDragLeft = Hammer($swipeElement).on("dragleft", function(event) {
       // alert("dragleft: type="+event.type + ", target="+event.target + ", distance="+event.distance + ", pointerType="+event.pointerType);
	   //$('header').append(event.distance);
	   //loadRight();
    });
	var hammerDragRight = Hammer($swipeElement).on("dragright", function(event) {
       // alert("dragRight: type="+event.type + ", target="+event.target + ", distance="+event.distance + ", pointerType="+event.pointerType);
	  // loadLeft();
	  //$('header').append(event.distance);
    })*/
	
	//use jquery UI for drag...
	//var dragDistance = $('.worksImage').draggable( "option", "distance" );
	
	
	
	//$swipeElement.touchDrag( null, null 'x' );
	/*$swipeElement.swipe( function( e, dx, dy ){
		if( dx < 0 ){
			alert( "swipe left!" );
		} else {
			alert( "swipe right!" );
		}
	});*/
	
	
	/////////////////////$('.worksImage').draggable({ axis: "x", revert: true });

	
	//$('.worksImage').droppable({ axis: "x", revert: true });
	//$('.worksImage').on("swipeleft", swipeleftHandler );
	//$('.worksImage').on("swiperight", swiperightHandler );
	// Callback function references the event target and adds the 'swipeleft' class to it
	//function swipeleftHandler( event ){
		//$( event.target ).addClass( "swipeleft" );
		//alert("swipeleft");
	//}
	
	// SWIPE
	//window.mySwipe = $('#mySwipe').Swipe().data('Swipe');
	/*window.mySwipe = $('#mySwipe').Swipe().data(
	{
	  startSlide: 2,
	  speed: 400,
	  auto: 3000,
	  continuous: true,
	  disableScroll: false,
	  stopPropagation: false,
	  callback: function(index, elem) {},
	  transitionEnd: function(index, elem) {}
	});*/

	
	//$(function() {
		//var $start_counter = $( "#event-start" ),
		  //$drag_counter = $( "#event-drag" ),
		  //$stop_counter = $( "#event-stop" ),
		  //counts = [ 0, 0, 0 ];
	 //
		//$('.worksImage').draggable({
		  //start: function() {
			//counts[ 0 ]++;
			//updateCounterStatus( $start_counter, counts[ 0 ] );
		  //},
		  //drag: function() {
			//counts[ 1 ]++;
			//updateCounterStatus( $drag_counter, counts[ 1 ] );
		  //},
		  //stop: function() {
			//counts[ 2 ]++;
			//updateCounterStatus( $stop_counter, counts[ 2 ] );
		  //}
		//});
	 //
		//function updateCounterStatus( $event_counter, new_count ) {
		  // first update the status visually...
		  //if ( !$event_counter.hasClass( "ui-state-hover" ) ) {
			//$event_counter.addClass( "ui-state-hover" )
			  //.siblings().removeClass( "ui-state-hover" );
		  //}
		  // ...then update the numbers
		  //$( "span.count", $event_counter ).text( new_count );
		//}
	//});
	
	//===============================
	$( window ).resize(function() {
		//resizeWorksThumbsDiv();
		setContentSize();
	});
	
	function resizeWorksThumbsDiv(){
		//var $div = $('.worksThumbs')[0];
		var $horScroll = false;
		
		$worksThumbsWidth = $('.worksThumbs').width();
		$worksThumbsScrollWidth = $('.worksThumbsInterior')[0].scrollWidth;
		//alert($worksThumbsWidth + " | " + $worksThumbsScrollWidth);
		
		//check to see if there is a horizontal scrollbar
		if ($worksThumbsWidth < $worksThumbsScrollWidth) {
			$horScroll = true;
		}
		//alert("client width: "+$div.clientWidth+" scroll width: "+$div.scrollWidth+" scroll? "+$horScroll);
		//if($horScroll==true){
			//$('.worksThumbs').height(100);
		//}else{
			//$('.worksThumbs').height(80);
		//}
		//alert($('.worksThumbs').height());
	}
	
	function setContentSize($num){
		//alert("setContentSize");
		var $image= $('.worksInfo').find("img");
		//alert($image);
		$worksImageSpacerTopHeight = $('.worksImageSpacerTop').height();
		//$worksInfoHeight = $('.worksInfo').height();
		$browserWidth = $(window).width();
		$browserHeight = $(window).height();
		$worksThumbsHeight = $('.worksThumbs').height();
		
		//alert("$worksImageSpacerTopHeight="+$worksImageSpacerTopHeight+", $worksInfoHeight="+$worksInfoHeight+", $worksThumbsHeight="+$worksThumbsHeight);
		
		$worksContentHeight = $browserHeight - $headerHeight - $footerHeight;// - $worksThumbsHeight;// - $worksInfoHeight;
		$worksImageAreaHeight = $browserHeight - $headerHeight - $footerHeight - $worksThumbsHeight;// - $worksInfoHeight;
		
		$('html').width($browserWidth);
		$('body').width($browserWidth);
		$('.contentArea').width($browserWidth);
		$('.content').width($browserWidth);
		$('.works').width($browserWidth);
		$('.worksContent').width($browserWidth);
		
		$('.worksThumbs').width($browserWidth);
		$('.worksThumbsInterior').width($browserWidth);
		
		//$('.contentArea').height($worksContentHeight);
		$('.contentArea').height($worksImageAreaHeight);
		$('.content').height($worksContentHeight);
		//$('.works').height($worksContentHeight-100);
		$('.works').height($worksImageAreaHeight);
		$('.worksContent').height($worksImageAreaHeight);
		//$('.works').css("maxHeight", $worksContentHeight);
		//$('.worksContent').css("maxHeight", $worksContentHeight);
		
		$('.arrow').height($worksImageAreaHeight);
		$('.arrowRight').css("left", $browserWidth-$('.arrowRight').width());
	
		$('.worksImage').width($browserWidth);
		$('.worksImage').height($worksImageAreaHeight);
		$('.worksImage').css("maxHeight", $worksImageAreaHeight);
		$('.worksImageInterior').height($worksImageAreaHeight - $worksImageMarginTotal);
		
		//$('header').empty();
		//$('header').append("$browserHeight="+$browserHeight);
		//$('header').append("$worksContentHeight="+$worksContentHeight);
		//$('header').append("contentAre height=" + $('.contentArea').height());
		//$('header').append("content height=" + $('.content').height());
		//$('header').append("works height=" + $('.works').height());
		//$('header').append("worksContent height=" + $('.worksContent').height());
		//$('header').append("worksImageInterior height="+$('.worksImageInterior').height());

		//alert($image.height());
		//$image.height(300);
	}
	
	
	
	//$('.worksImage').css("display","none");
	$('.worksImage').hide();
	
	$('.arrow').hover(
		function() {
			$(this).addClass("arrowHover");
		}, function() {
			$( this ).removeClass("arrowHover");
	});

	
	$('.arrowLeft').click(function(){
		loadLeft();
		$( this ).removeClass("arrowHover");
	});
	function loadLeft(){
		$nextWorksIndex = $currentWorksIndex-1;
		if($nextWorksIndex<0){
			$nextWorksIndex = $totalWorksImages-1;
		}
		$inDirection = "left";
		$outDirection = "right";
		loadWorksImage($nextWorksIndex);
	}
	
	$('.arrowRight').click(function(){
		loadRight();
		$( this ).removeClass("arrowHover");
	});
	function loadRight(){
		$nextWorksIndex = $currentWorksIndex+1;
		if($nextWorksIndex>=$totalWorksImages){
			$nextWorksIndex = 0;
		}
		$inDirection = "right";
		$outDirection = "left";
		loadWorksImage($nextWorksIndex);
	}
	
	
	
	//$('.worksInfo').append("$headerHeight: "+$headerHeight+", $footerHeight: "+$footerHeight+", $worksThumbsHeight: "+$worksThumbsHeight+", $worksInfoHeight: "+$worksInfoHeight+", $browserHeight: "+$browserHeight+", $documentHeight: "+$documentHeight);
	//alert("$headerHeight: "+$headerHeight+", $footerHeight: "+$footerHeight+", $browserHeight: "+$browserHeight+", $documentHeight: "+$documentHeight);
	
	function loadWorksImage($index){
		//alert("loadWorksImage "+$index);
		//$('.worksImage').css("display","none");
		//$('.worksImage').hide();
		$('.worksThumb').removeClass("thumbnailSelected");

		var $currentWorksImage = $('.worksImage:eq('+$currentWorksIndex+')');
		$currentWorksImage.stop(true, true).hide("slide",{ direction: $outDirection }, $slideOutTime);
		
		var $nextWorksImage = $('.worksImage:eq('+$index+')');
		//$nextWorksImage.width($(window).width());
		//setContentSize();
		$nextWorksImage.delay($slideOutTime+50).show("slide",{ direction: $inDirection }, $slideInTime);
		
		//alert($currentWorksImage.width()+" // "+$nextWorksImage.width());
		
		//$worksInfoText = $('.worksImage:eq('+$index+')').data("info");
		//$('.worksInfo').delay($slideOutTime).text($worksInfoText);
		$('.worksThumb:eq('+$index+')').addClass("thumbnailSelected");
		$currentWorksIndex = $index;
		scrollThumbs($index);
	}
	
	var $worksThumbsWidth;
	var $thumbsPercent = 0;
	var $thumbsScrollValue=0;
	function scrollThumbs($index){
		$worksThumbsWidth = $('.worksThumbs').width();
		$thumbsPercent = $index / $totalWorksImages;
		$thumbsScrollValue = $thumbsPercent*$worksThumbsWidth;
		//alert($worksThumbsWidth + " | " + $thumbsPercent + " | " + $thumbsScrollValue);
		$('.worksThumbsInterior').scrollLeft( $thumbsScrollValue );
		//$('.worksThumbsInterior').animate({scrollLeft: $('.worksThumbsInterior').offset().left}, $thumbsScrollValue);
        //return false;
		//alert($('.worksImage:eq('+$currentWorksIndex+')').css("z-index"));
	}
	
	var $thumbDelay = 50;
	$( ".worksImage" ).each(function( $index ) {
		$(this).width($(window).width());
		
		var $image = $(this).find(".worksImageInterior").find("img");
		var $imageSource = $image.attr('src');
		var $info1 = $(this).find(".worksImageInterior").attr('data-info1');
		var $info2 = $(this).find(".worksImageInterior").attr('data-info2');
		var $info3 = $(this).find(".worksImageInterior").attr('data-info3');
		var $title = $info1+" "+$info2+" "+$info3;
		var $thumbIndex = String("thumb"+$index);
		//alert($thumbIndex);
		var $thumb = '<img class="worksThumb '+$thumbIndex+'" src="thumbs/'+$imageSource+'" title="'+$title+'"/>';
		//alert($thumb);
		//var $worksInfo = $(this).find(".worksInfo")
		var $worksInfoText="";
		if($info1){
			$worksInfoText += "<br/><span class='worksInfo1'>"+$info1+"</span><br/>";
		}
		if($info2){
			$worksInfoText+="<span class='worksInfo2'>"+$info2+"</span><br/>";
		}
		if($info3){
			$worksInfoText+="<span class='worksInfo3'>"+$info3+"</span>";
		}
		//$worksInfo.empty();
		//$worksInfo.width($image.width());
		//$worksInfo.append("<b><i>"+$info1+"</i></b><br/>"+$info2+"<br/>"+$info3);
		$(this).find(".worksImageInterior").append($worksInfoText);
		
		$('.worksThumbsInterior').append($thumb);
		//$('.worksThumbs').append($thumb);
		
		
		
		//$('.worksThumbsInterior').find("img").height(20);
		//resizeWorksThumbsDiv();
		setContentSize();

		//$thumb.fadeOut(1000);
		//$("'."+$thumbIndex+"'").fadeOut(0);
		//$thumb.delay($thumbDelay*$index).fadeIn(1000);
		//$("'."+$thumbIndex+"'").fadeIn(1000);
		//animateInWorksThumb($thumb, $index*$thumbDelay);
	});
	
	//$( ".worksThumb" ).each(function( $index ) {
		//$(this).find("img").height(40);
		//$(this).fadeOut(0);
		//$(this).delay($thumbDelay*$index).fadeIn(400);
	//});
	
	function animateInWorksThumb($thumb, $delay){
		$thumb.delay($delay).slideUp(500);
	}
	
	$('.worksThumb').click(function(){
		$nextWorksIndex = $(this).index();

		if($nextWorksIndex>$currentWorksIndex){
			$inDirection = "right";
			$outDirection = "left";
		}else{
			$inDirection = "left";
			$outDirection = "right";
		}
		loadWorksImage($nextWorksIndex);
	});
	
	//$(document).keypress(function(event) {
	$(document).bind('keydown',function(event) {
		//alert("keypress "+event.keyCode );
		if ( event.keyCode == 37 ) {
			loadLeft();
			return false;
		}else if(event.keyCode == 39){
			loadRight();
			return false;
		}
	});
	
	
	
	// initialize -----------------------
	loadWorksImage($currentWorksIndex);
	$subNav.slideUp(0);
	//resizeWorksThumbsDiv();
	setContentSize();
});