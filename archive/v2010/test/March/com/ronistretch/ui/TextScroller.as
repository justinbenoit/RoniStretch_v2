package com.ronistretch.ui 
{
	import com.extras.color.tintColor;
	import com.gskinner.geom.ColorMatrix;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class TextScroller extends MovieClip
	{
		private var scrollbar:Sprite;	
		private var scrolltrack:Sprite;
		
		private var _textField:TextField;
		
		private var _colorNormal:Number = 0x999999;
		private var _colorRollover:Number = 0x779CA8;
		private var _colorSelected:Number = 0x0000FF;
		
		public function TextScroller(target:TextField, scrollbar:Sprite, scrolltrack:Sprite = null, colorNormal:Number = 0x999999, colorRollover:Number = 0xFF0000, colorSelected:Number = 0x0000FF) 
		{
			textField = target;
			
			trace(_colorNormal, _colorRollover)
			
			_colorNormal = colorNormal;
			_colorRollover = colorRollover;
			_colorSelected = colorSelected;
			
			this.scrollbar = scrollbar;
			this.scrolltrack = scrolltrack;
			
			//tintColor(scrollbar, _colorNormal, 1);
			scrollbar.buttonMode = true;
			scrollbar.mouseChildren = false;
			scrollbar.addEventListener(MouseEvent.ROLL_OVER, scrollbarHandler);
			scrollbar.addEventListener(MouseEvent.ROLL_OUT, scrollbarHandler);
			scrollbar.addEventListener(MouseEvent.MOUSE_DOWN, scrollbarHandler);
			scrollbar.addEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
		}
		
		private function scrollbarHandler(e:MouseEvent):void 
		{
			trace(_colorNormal, _colorRollover)
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				tintColor(scrollbar, _colorRollover, 1);
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				tintColor(scrollbar, _colorNormal, 0);
			}else if (e.type == MouseEvent.MOUSE_DOWN) 
			{
				scrollbar.startDrag(false, new Rectangle(scrollbar.x, 0, 0, 		scrolltrack.height - scrollbar.height));
				scrollbar.removeEventListener(MouseEvent.ROLL_OUT, 					scrollbarHandler);
				scrollbar.stage.addEventListener(MouseEvent.MOUSE_MOVE, 			scrollbarIsDraggingHandler);
				scrollbar.stage.addEventListener(MouseEvent.MOUSE_UP, 				stopScrollbarDrag);
				_textField.addEventListener(MouseEvent.MOUSE_UP, 					stopScrollbarDrag);
			}
		}
		
		private function scrollbarIsDraggingHandler(e:Event):void
		{
			var scrollRatio:Number = scrollbar.y / (scrolltrack.height - scrollbar.height);
			_textField.scrollV = uint(scrollRatio * _textField.maxScrollV);
			//scrollee.y = scrollAreaY - ((scrollee.height - scrollAreaVisibleHeight) * scrollRatio);
			//trace("dragging: ", scrollRatio);
		}
		
		private function stopScrollbarDrag(e:MouseEvent):void 
		{
			scrollbar.stopDrag();
			tintColor(scrollbar, _colorNormal, 0);
			scrollbar.addEventListener(MouseEvent.ROLL_OUT, scrollbarHandler);
			scrollbar.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scrollbarIsDraggingHandler);
			scrollbar.stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			scrollbar.removeEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
			_textField.removeEventListener(MouseEvent.MOUSE_UP, stopScrollbarDrag);
		}
		
		
		//============== GETTERS AND SETTERS =============//
		public function get colorNormal():Number { return _colorNormal; }
		
		public function set colorNormal(value:Number):void 
		{
			_colorNormal = value;
			trace(this, _colorNormal);
		}
		
		public function get colorRollover():Number { return _colorRollover; }
		
		public function set colorRollover(value:Number):void 
		{
			_colorRollover = value;
			trace(this, _colorRollover);
		}
		
		public function get colorSelected():Number { return _colorSelected; }
		
		public function set colorSelected(value:Number):void 
		{
			_colorSelected = value;
		}
		
		public function get textField():TextField { return _textField; }
		
		public function set textField(value:TextField):void 
		{
			_textField = value;
		}
		
	}

}