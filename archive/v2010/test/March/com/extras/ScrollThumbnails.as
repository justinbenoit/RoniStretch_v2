package com.crewcreative.utilities 
{
	import com.gskinner.motion.GTween;
	import fl.motion.easing.Linear;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class ScrollThumbnails
	{
		private var scrollee:DisplayObject;
		private var scrollAreaY:int;
		private var scrollAreaVisibleHeight:uint;
		private var upArrow:Sprite;
		private var downArrow:Sprite;
		private var upArrowName:String = "up";
		private var downArrowName:String = "down";
		private var ratio:Number;
		private var elasticScrolling:Boolean;
		private var initialScrollSpeed:Number = 1;
		private var scrollSpeed:Number;
		private var scrollSpeedMax:Number;
		private var tweenScrollee:GTween;
		private var _disabledAlpha:Number = 0.25;
		private var _originalAlpha:Number = 1;
		private var _tweenTime:Number = 0.4;
		private var colorNormal:Number;
		private var colorRollover:Number;
		private var colorHit:Number;
		private var singleClickScroll:Boolean;
		//private var scrollUp:Boolean = false;
		
		public function ScrollThumbnails(scrollee:DisplayObject, scrollAreaVisibleHeight:uint, upArrow:Sprite, downArrow:Sprite, singleClickScroll:Boolean = true, scrollSpeed:Number = 6, elasticScrolling:Boolean = false, colorNormal:Number = 0xFFFFFF, colorRollover:Number = 0x999999, colorHit:Number = 0x666666) 
		{
			this.scrollee = scrollee;
			this.scrollAreaY = scrollee.y;
			this.scrollAreaVisibleHeight = scrollAreaVisibleHeight;
			this.upArrow = upArrow;
			this.downArrow = downArrow;
			upArrow.visible = downArrow.visible = false;
			if (this.upArrow.name != null && this.downArrow.name != null)
			{
				upArrowName = this.upArrow.name;
				downArrowName = this.downArrow.name;
			}
			this.singleClickScroll = singleClickScroll;
			if (singleClickScroll == true)
			{
				tweenScrollee = new GTween(scrollee, _tweenTime, { }, { ease:Linear.easeOut } );
			}
			this.elasticScrolling = elasticScrolling;	
			initialScrollSpeed = scrollSpeed / 4;
			scrollSpeedMax = scrollSpeed;
			this.colorNormal = colorNormal;
			this.colorRollover = colorRollover;
			this.colorHit = colorHit;
			_originalAlpha = downArrow.alpha;
			if (scrollee.height <= scrollAreaVisibleHeight)
			{
				//trace("no scrolling.  hide arrows");
				upArrow.visible = downArrow.visible = false;
				upArrow.mouseEnabled = downArrow.mouseEnabled = false;
			}else
			{
				ratio = scrollAreaVisibleHeight / scrollee.height;
				trace("ratio=" + ratio);
				upArrow.visible = downArrow.visible = true;
				enableArrow(downArrow);
				disableArrow(upArrow);
			}
		}
		
		private function arrowUpHandler(e:MouseEvent):void 
		{
			trace("arrowUpHandler");
			tintColor(e.target, colorHit, 1);
			scrollSpeed = Math.abs(initialScrollSpeed);
			enableArrow(downArrow);
			e.target.stage.addEventListener(Event.ENTER_FRAME, scrollingHandler);
		}
		private function arrowDownHandler(e:MouseEvent):void 
		{
			trace("arrowDownHandler");
			tintColor(e.target, colorHit, 1);
			scrollSpeed = -1 * Math.abs(initialScrollSpeed);
			trace(scrollSpeed);
			enableArrow(upArrow);
			e.target.stage.addEventListener(Event.ENTER_FRAME, scrollingHandler);
		}
		
		private function arrowHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER)
			{
				tintColor(e.target, colorRollover, 1);
			}else if (e.type == MouseEvent.ROLL_OUT)
			{
				tintColor(e.target, colorNormal, 1);
			}else if (e.type == MouseEvent.MOUSE_DOWN)
			{
				tintColor(e.target, colorHit, 1);
			}else if (e.type == MouseEvent.MOUSE_UP)
			{
				tintColor(upArrow, colorNormal, 1);
				tintColor(downArrow, colorNormal, 1);
				if (singleClickScroll == true)
				{
					e.target.stage.removeEventListener(Event.ENTER_FRAME, scrollingHandler);
					scrollSpeed = initialScrollSpeed;
					if (scrollee.y == scrollAreaY)
					{
						disableArrow(upArrow);
					}else if (scrollee.y == scrollAreaY - (scrollee.height - scrollAreaVisibleHeight))
					{
						disableArrow(downArrow);
					}
				}
			}else if (e.type == MouseEvent.CLICK)
			{
				var remainingScrollable:int;
				var changeY:int;
				if (e.target.name == upArrowName || e.target.name == "up")
				{
					enableArrow(downArrow);
					remainingScrollable = scrollAreaY - scrollee.y;
					if (remainingScrollable >= scrollAreaVisibleHeight)
					{
						changeY = scrollAreaVisibleHeight;
						if (remainingScrollable == scrollAreaVisibleHeight)
						{
							disableArrow(upArrow);
						}
					}else
					{
						trace("% up", remainingScrollable, remainingScrollable % scrollAreaVisibleHeight);
						changeY = remainingScrollable % scrollAreaVisibleHeight;
						disableArrow(upArrow);
					}
					tweenScrollee.setProperty("y", scrollee.y + changeY);
				}else
				{
					enableArrow(upArrow);
					remainingScrollable = (scrollee.y + scrollee.height) - (scrollAreaY + scrollAreaVisibleHeight);
					if (remainingScrollable >= scrollAreaVisibleHeight)
					{
						changeY = -scrollAreaVisibleHeight;
						if (remainingScrollable == scrollAreaVisibleHeight)
						{
							disableArrow(downArrow);
						}
					}else
					{
						trace("% down", remainingScrollable, remainingScrollable % scrollAreaVisibleHeight);
						changeY = -(remainingScrollable % scrollAreaVisibleHeight);
						disableArrow(downArrow);
					}
					tweenScrollee.setProperty("y", scrollee.y + changeY);
				}
				trace("changeY",changeY);
			}
		}
		
		private function disableArrow(arrow:Sprite):void
		{
			trace("disableArrow", arrow.name);
			arrow.mouseEnabled = false;
			arrow.alpha = disabledAlpha;
			arrow.mouseEnabled = false;
			arrow.buttonMode = false;
			arrow.removeEventListener(MouseEvent.ROLL_OVER, arrowHandler);
			arrow.removeEventListener(MouseEvent.ROLL_OUT, arrowHandler);

			if (singleClickScroll == true)
			{
				arrow.removeEventListener(MouseEvent.CLICK, arrowHandler);
				arrow.removeEventListener(MouseEvent.MOUSE_DOWN, arrowHandler);
				arrow.removeEventListener(MouseEvent.MOUSE_UP, arrowHandler);
			}else
			{
				if (arrow.name == upArrowName || arrow.name == "up")
				{
					arrow.removeEventListener(MouseEvent.MOUSE_DOWN, arrowUpHandler);
				}else
				{
					arrow.removeEventListener(MouseEvent.MOUSE_DOWN, arrowDownHandler);
				}
				arrow.stage.removeEventListener(MouseEvent.MOUSE_UP, arrowHandler);
			}
		}
		private function enableArrow(arrow:Sprite):void
		{
			trace("enableArrow", arrow.name);
			arrow.mouseEnabled = true;
			arrow.alpha = _originalAlpha;
			arrow.visible = true;
			arrow.mouseEnabled = true;
			arrow.buttonMode = true;
			arrow.mouseChildren = false;
			arrow.addEventListener(MouseEvent.ROLL_OVER, arrowHandler);
			arrow.addEventListener(MouseEvent.ROLL_OUT, arrowHandler);
			
			if (singleClickScroll == true)
			{
				arrow.addEventListener(MouseEvent.CLICK, arrowHandler);
				arrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowHandler);
				arrow.addEventListener(MouseEvent.MOUSE_UP, arrowHandler);
			}else
			{
				if (arrow.name == upArrowName || arrow.name == "up")
				{
					arrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowUpHandler);
				}else
				{
					arrow.addEventListener(MouseEvent.MOUSE_DOWN, arrowDownHandler);
				}
				arrow.stage.addEventListener(MouseEvent.MOUSE_UP, arrowHandler);
			}
		}
		
		private function scrollingHandler(e:Event):void 
		{
			if (Math.abs(scrollSpeed) < scrollSpeedMax)
			{
				scrollSpeed *= 1.07;
			}
			if (scrollSpeed > 0)
			{
				if (scrollee.y + scrollSpeed < scrollAreaY)
				{
					scrollee.y += scrollSpeed;
				}else
				{
					scrollee.y = scrollAreaY;
				}
			}else
			{
				if (scrollee.y + scrollSpeed > (scrollAreaY - (scrollee.height - scrollAreaVisibleHeight)))
				{
					scrollee.y += scrollSpeed;
				}else
				{
					scrollee.y = scrollAreaY - (scrollee.height - scrollAreaVisibleHeight);
				}
			}
			
		}
		
		
		//============== GETTERS AND SETTERS ===============================
		public function get disabledAlpha():Number { return _disabledAlpha; }
		
		public function set disabledAlpha(value:Number):void 
		{
			_disabledAlpha = value;
		}
		
		public function get originalAlpha():Number { return _originalAlpha; }
		
		public function set originalAlpha(value:Number):void 
		{
			_originalAlpha = value;
		}
		
		public function set tweenTime(value:Number):void 
		{
			_tweenTime = value;
		}
	}
}