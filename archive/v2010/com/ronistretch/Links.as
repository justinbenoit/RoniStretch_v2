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
	import flash.text.TextFieldAutoSize;
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
			//txt.styleSheet = Main.styleSheet;
			for (var i:int = 0; i < _xml..links.link.length(); i++) 
			{
				//var textString:String = "<font size='13'><a href='http://" + _xml..links.link[i].text() + "' target='_blank'>•  </font><font size='18'>" + _xml..links.link[i].text() + "</font></a>";
				var textString:String = "<a href='http://" + _xml..links.link[i].text() + "' target='_blank'><font size='14'>" + _xml..links.link[i].text() + "</font></a>";
				txt.htmlText += textString;
				if (i != _xml..links.link.length()-1)
				{
					txt.htmlText += "<br/>";
				}
			}
			
			scrollText = new TextScroller(txt, scroller.scrollbar, scroller.scrolltrack, colorNormal, colorRollover, colorRollover);
			resize();
		}
		
		public function resize():void
		{
			var offset:uint = 110;
			var txtHeight:uint;
			var txtY:uint;

			if (txt.textHeight > (stage.stageHeight - offset))
			{
				txtHeight = stage.stageHeight - offset;
				txtY = 0;
			}else
			{
				txtHeight = txt.textHeight + 20;
				txtY = (stage.stageHeight - offset) / 2 - txtHeight / 2;
			}
			tweenTxt.setValues( { y: txtY, height:txtHeight } );
			trace(this, txtY, txtHeight);
			tweenScroller.setValues( {y: txtY} );
			//scroller.y = (txtY + txt.height)/2 - scroller.height/2;
			//scroller.y = txt.y;
			//if (txt.textHeight <= txtHeight)
			
			trace("$$$$$$$$$$$$$$", txt.maxScrollV);
			if(txt.maxScrollV <= 1)
			{
				scroller.visible = false;
			}else
			{
				scroller.visible = true;
			}

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