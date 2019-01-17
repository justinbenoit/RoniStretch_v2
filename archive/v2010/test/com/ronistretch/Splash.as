package com.ronistretch 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.ronistretch.ui.NavigationButton;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Splash extends MovieClip
	{
		
		public var btnEnterSite:NavigationButton;
		public var txt:TextField;
		
		private var _imageShell:Sprite = new Sprite();
		private var imageNumber:int = 0;
		private var _xml:XML;
		private var _focus:Boolean = false;
		
		private var _tweenThis:GTween;
		private var colorNormal:Number;
		private var colorRollover:Number;
		
		public function Splash() 
		{
			//imageShell0.alpha = 0;
			//imageShell1.alpha = 0;
			//imageShell2.alpha = 0;
			//imageShell3.alpha = 0;
			
			this.alpha = 0;
			_tweenThis = new GTween(this, 1, { y:stage.stageHeight / 2, alpha:1 }, { ease:Cubic.easeOut } );
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER, 	sectionSplashHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, 		sectionSplashHandler);
			
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
		}
		
		private function sectionSplashHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				btnEnterSite.txt.textColor = colorRollover;
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				btnEnterSite.txt.textColor = colorNormal;
			}
		}
		
		private function loadImage(number:int):void
		{
			//trace("loadImage", number);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.load(new URLRequest("images/splash/"+_xml..splash.image[number].text()));
		}
		
		private function completeHandler(e:Event):void 
		{
			var image:Bitmap = e.target.loader.content;
			//var imageShell:MovieClip = this["imageShell" + imageNumber];
			imageShell.addChild(image);
			image.width = stage.stageWidth - 100;
			
			if (image.scaleX > 1)
			{
				image.scaleX = 1;
			}
			image.scaleY = image.scaleX;
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			addChild(imageShell);
			
			image.alpha = 0;
			var tweenImage:GTween = new GTween(image, 1.5, { alpha:1 }, {ease:Cubic.easeIn} );
			var tweenImageShell:GTween = new GTween(imageShell, 1.5, { alpha:1 }, {ease:Cubic.easeIn} );
			
			//imageNumber++;
			//if (imageNumber < 4)
			//{
				//loadImage(imageNumber);
			//}
			
			btnEnterSite.y = imageShell.height / 2;
			btnEnterSite.x = imageShell.width / 2 - btnEnterSite.width;
			
			txt.y = btnEnterSite.y + btnEnterSite.height;	
			txt.width = imageShell.width;
			txt.x = -txt.width / 2;
			
			dispatchEvent(new Event("complete"));
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(e);
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
			
			colorNormal = _xml.navigation[0].colors[0].normal[0].text();
			colorRollover = _xml.navigation[0].colors[0].rollover[0].text();
			var buttonText:String = _xml..splash.entersite[0].text();
			btnEnterSite.text = buttonText;
			btnEnterSite.colorNormal = colorNormal;
			btnEnterSite.colorRollover = colorRollover;
			txt.htmlText = _xml..splash.text[0].text();
			loadImage(imageNumber);
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
		
		public function get imageShell():Sprite { return _imageShell; }
		
		public function set imageShell(value:Sprite):void 
		{
			_imageShell = value;
		}
		
	}

}