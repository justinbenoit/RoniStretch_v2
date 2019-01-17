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
		
		private var tweenTxt:GTween;
		private var tweenScroller:GTween;
		private var _tweenThis:GTween;
		private var _xml:XML;
		private var _focus:Boolean = false;
		
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
			txt.htmlText = _xml..biography.text();
			//txt.autoSize = TextFieldAutoSize.LEFT;
			txt.width = txt.textWidth + 10;
			this.x = - txt.width / 2;
			colorNormal = 		xml..navigation..colors..normal.text();
			colorRollover = 	xml..navigation..colors..rollover.text();
			//trace(colorNormal, colorRollover);
			scrollText.colorNormal = colorNormal;
			scrollText.colorRollover = colorRollover;
			resize();
		}
		
		public function resize():void
		{
			//trace(stage.stageHeight);
			var txtHeight:uint = stage.stageHeight - 200;
			tweenTxt.setValues( { height:txtHeight } );
			tweenScroller.setValue("y", (txtHeight - scroller.height) / 2);
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

	}
}