package com.ronistretch 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.ronistretch.ui.TextScroller;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Biography extends MovieClip
	{
		public var txt:TextField;
		public var scroller:MovieClip;
		private var scrollText:TextScroller;
		
		private var colorNormal:Number;
		private var colorRollover:Number;
		private var _numberSubsection:uint = 0;
		
		private var tweenTxt:GTween;
		private var tweenScroller:GTween;
		private var _tweenThis:GTween;
		private var _xml:XML;
		private var _focus:Boolean = false;
		private var _textString:String;
		private var _sectionName:String = "biography";
		
		public function Biography() 
		{
			scrollText = new TextScroller(txt, scroller.scrollbar, scroller.scrolltrack);
			tweenTxt = new GTween(txt, 1, { }, { ease:Cubic.easeOut } );
			tweenScroller = new GTween(scroller, 1, { }, { ease:Cubic.easeOut } );
			_tweenThis = new GTween(this, 1, { alpha:0 }, { ease:Cubic.easeOut } );
			
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
		}
		
		private function populateInfo():void
		{
			trace("populateInfo()");
			txt.htmlText = _xml[_sectionName].children()[_numberSubsection].text();
			scrollText.resetScroll();
			//txt.autoSize = TextFieldAutoSize.LEFT;
			txt.width = 500;// txt.textWidth + 10;
			//txt.y = -txt.height / 2;
			this.x = - txt.width / 2 + 100;
			colorNormal = 		xml..navigation..colors..normal.text();
			colorRollover = 	xml..navigation..colors..rollover.text();
			//trace(colorNormal, colorRollover);
			scrollText.colorNormal = colorNormal;
			scrollText.colorRollover = colorRollover;
			resize();
		}
		
		public function resize():void
		{
			var offset:uint = 200;
			var txtHeight:uint;
			var txtY:uint;
			if (txt.textHeight > stage.stageHeight - offset)
			{
				txtHeight = stage.stageHeight - offset;
				txtY = 0;
			}else
			{
				txtHeight = txt.height;
				txtY = (stage.stageHeight) / 2 - txtHeight / 2 - offset / 2;
			}
			tweenTxt.setValues( { y: txtY, height:txtHeight } );
			tweenScroller.setValue("y", (stage.stageHeight - scroller.height) / 2 - offset/2);
			
			if (txt.textHeight <= txtHeight)
			{
				scroller.visible = false;
			}else
			{
				scroller.visible = true;
			}
		}
		
		//============== GETTERS AND SETTERS =============//
		public function get xml():XML { return _xml; }
		
		public function set xml(value:XML):void 
		{
			_xml = value;
			populateInfo();
		}
		
		public function get focus():Boolean { return _focus; }
		
		public function set focus(value:Boolean):void 
		{
			_focus = value;
		}
		
		public function get tweenThis():GTween { return _tweenThis; }
	
		public function set tweenThis(value:GTween):void 
		{
			_tweenThis = value;
		}
		
		public function get numberSubsection():uint { return _numberSubsection; }
		
		public function set numberSubsection(value:uint):void 
		{
			_numberSubsection = value;
			populateInfo();
		}
		
		public function get textString():String { return _textString; }
		
		public function set textString(value:String):void 
		{
			_textString = value;
		}
		
		public function get sectionName():String { return _sectionName; }
		
		public function set sectionName(value:String):void 
		{
			_sectionName = value;
			_numberSubsection = 0;
		}

	}
}