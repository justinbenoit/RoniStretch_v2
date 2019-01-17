package com.extras.utilities
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class StyleSheetLoader extends EventDispatcher
	{
		private var _styleSheet:StyleSheet = new StyleSheet();
		
		public function StyleSheetLoader(url:String = null)
		{
			if (url)
			{
				loadStyleSheet(url);
			}
		}
		
		public function loadStyleSheet(url:String):void
		{
		   var urlLoader:URLLoader = new URLLoader();
		   var urlRequest:URLRequest = new URLRequest(url);
		   urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		   urlLoader.addEventListener(Event.COMPLETE, loadCompleteHandler);
		   urlLoader.load(urlRequest);
		}
		
		private function loadCompleteHandler(e:Event):void
		{
			styleSheet.parseCSS(e.target.data);
			//trace("StyleSheet loadCompleteHandler()");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//==================== GETTERS AND SETTERS ========================//
		public function get styleSheet():StyleSheet { return _styleSheet; }
		
		public function set styleSheet(value:StyleSheet):void
		{
			_styleSheet = value;
		}
		
	}

}