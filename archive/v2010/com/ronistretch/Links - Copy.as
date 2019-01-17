package com.ronistretch 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.ronistretch.ui.NavigationButton;
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
		public var linksShell:MovieClip;
		
		private var _xml:XML;
		private var _focus:Boolean = false;
		private var number:uint = 0;
		private var loader:Loader = new Loader();
		
		private var _tweenThis:GTween;
		
		private static const SPACING:uint = 0;
		private var arrLinks:Array = new Array();
		
		public function Links() 
		{
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			tweenThis = new GTween(this, 1, { y:stage.stageHeight / 2}, { ease:Cubic.easeOut } );
		}
		
		private function populateInfo():void
		{
			createLink(number);
		}
		
		private function createLink(number:uint):void
		{
			trace("createLink", number);
			if (number < _xml..links.link.length())
			{
				var btn:NavigationButton = new NavigationButton(_xml..links.link[number].text(), number, "http://" + _xml..links.link[number].text());
				btn.y = number * (SPACING + btn.height);
				arrLinks.push(btn);
				linksShell.addChild(btn);
				trace("load image", "http://" + _xml..links.link[number].@image);
				loader.load(new URLRequest("http://"+_xml..links.link[number].@image));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			}
		}
		
		private function completeHandler(e:Event):void
		{
			var ico:Bitmap = loader.content as Bitmap;
			trace("completeHandler", e);
			ico.width = ico.height = 16;
			ico.x = -20;
			arrLinks[number].addChild(ico);
			
			nextLink();
		}
		
		private function nextLink():void
		{
			number++;
			createLink(number);
			linksShell.x = -linksShell.width / 2;
			linksShell.y = -linksShell.height / 2;
		}
		
		public function resize():void
		{
			tweenThis.setValue("y", stage.stageHeight / 2);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(number, e);
			nextLink();
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