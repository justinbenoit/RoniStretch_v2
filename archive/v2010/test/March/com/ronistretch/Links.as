package com.ronistretch 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.ronistretch.ui.NavigationButton;
	import com.ronistretch.ui.TextScroller;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Links extends MovieClip
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
		
		public function Links() 
		{
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			
			tweenTxt = new GTween(txt, 1, { }, { ease:Cubic.easeOut } );
			tweenScroller = new GTween(scroller, 1, { }, { ease:Cubic.easeOut } );
			_tweenThis = new GTween(this, 1, { alpha:0 }, { ease:Cubic.easeOut } );
		}
		
		private function populateInfo():void
		{
			txt.htmlText = "";
			for (var i:int = 0; i < _xml..links.link.length(); i++) 
			{
				var textString:String = "<font size='13'><a href='http://" + _xml..links.link[i].text() + "' target='_blank'>•  </font><font size='18'>" + _xml..links.link[i].text() + "</font></a>";
				txt.htmlText += textString;
				if (i != _xml..links.link.length()-1)
				{
					txt.htmlText += "<br/><br/>";
				}
			}
			
			scrollText = new TextScroller(txt, scroller.scrollbar, scroller.scrolltrack, colorNormal, colorRollover, colorRollover);
		}
		
		public function resize():void
		{
			var txtHeight:uint = stage.stageHeight - 200;
			tweenTxt.setValues( { height:txtHeight } );
			tweenScroller.setValue("y", (txtHeight - scroller.height) / 2);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(e);
		}
		
		//============== GETTERS AND SETTERS =============//
		public function get xml():XML { return _xml; }
		
		public function set xml(value:XML):void 
		{
			_xml = value;
			colorNormal = 		xml..navigation..colors..normal.text();
			colorRollover = 	xml..navigation..colors..rollover.text();
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