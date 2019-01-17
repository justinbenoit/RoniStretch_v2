package com.extras.utilities
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class ScrollArea
	{
		private var theStage:Stage;
		private var scrollee:DisplayObject;
		private var scrollAreaY:int;
		private var scrollAreaVisibleHeight:uint;
		private var scrollbar:Sprite;
		private var scrollbarTopY:int;
		private var scrollbarDragHeight:uint;
		private var ratio:Number;
		private var _scrollbarMinimumHeight:uint = 40;
		private var elasticScrolling:Boolean;
		
		public function ScrollArea(stage:Stage, scrollee:DisplayObject, scrollAreaVisibleHeight:uint, scrollbar:Sprite, scrollbarDragHeight:uint = 0, elasticScrolling:Boolean = false, scrollbarMinimumHeight:uint = 40)
		{
			theStage = stage;
			this.scrollee = scrollee;
			this.scrollAreaY = scrollee.y;
			this.scrollAreaVisibleHeight = scrollAreaVisibleHeight;
			this.scrollbar = scrollbar;
			this.scrollbarTopY = scrollbar.y;
			if (scrollbarDragHeight == 0)
			{
				this.scrollbarDragHeight = scrollbar.height;
			}else
			{
				this.scrollbarDragHeight = scrollbarDragHeight;
			}
			this.elasticScrolling = elasticScrolling;
			this.scrollbarMinimumHeight = scrollbarMinimumHeight;

			if (scrollee.height <= scrollAreaVisibleHeight)
			{
				scrollbar.visible = false;
			}else
			{
				ratio = scrollAreaVisibleHeight / scrollee.height;
				//trace(ratio);
				scrollbar.height = this.scrollbarDragHeight * ratio;
				trace(scrollbar.height);
				if (scrollbar.height < _scrollbarMinimumHeight)
				{
					scrollbar.height = _scrollbarMinimumHeight;
				}
				scrollbar.buttonMode = true;
				scrollbar.mouseChildren = false;
				scrollbar.addEventListener(MouseEvent.MOUSE_DOWN, dragScrollbar);
			}
		}
		
		private function dragScrollbar(e:MouseEvent):void
		{
			scrollbar.startDrag(false, new Rectangle(scrollbar.x, scrollbarTopY, 0, scrollbarDragHeight - scrollbar.height));
			scrollbar.addEventListener(Event.ENTER_FRAME, scrollbarIsDraggingHandler);
			theStage.addEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			scrollbar.addEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			scrollee.addEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
		}
		
		private function scrollbarIsDraggingHandler(e:Event):void
		{
			var scrollRatio:Number = (scrollbar.y - scrollbarTopY) / (scrollbarDragHeight - scrollbar.height);
			scrollee.y = scrollAreaY - ((scrollee.height - scrollAreaVisibleHeight) * scrollRatio);
			//trace("dragging: ", scrollRatio);
		}
		
		private function stopScrollbarDrag(e:MouseEvent):void
		{
			scrollbar.stopDrag();
			trace("stopScrollbarDrag", "target=", e.target);
			scrollbar.removeEventListener(Event.ENTER_FRAME, scrollbarIsDraggingHandler);
			theStage.removeEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			scrollbar.removeEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			scrollee.removeEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			//trace("stopDrag");
		}
		
		public function get scrollbarMinimumHeight():uint { return _scrollbarMinimumHeight; }
		
		public function set scrollbarMinimumHeight(value:uint):void
		{
			_scrollbarMinimumHeight = value;
		}
	}
}