package com.ronistretch 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import flash.display.MovieClip;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Contact extends MovieClip
	{
		private var _xml:XML;
		private var _focus:Boolean = false;
		private var _tweenThis:GTween;
		
		public function Contact() 
		{
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			tweenThis = new GTween(this, 1, { y:stage.stageHeight / 2}, { ease:Cubic.easeOut } );
		}
		
		private function populateInfo():void
		{
			txt.htmlText = _xml..contact.text[0].text();
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.width = txt.textWidth + 8;
			txt.x = -txt.width / 2;
			txt.y = -txt.height / 2;
		}
		
		public function resize():void
		{
			tweenThis.setValue("y", stage.stageHeight / 2);
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