package com.ronistretch 
{
	import com.extras.color.tintColor;
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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Work extends MovieClip
	{
		public var arrowLeft:Sprite;	
		public var arrowRight:Sprite;	
		public var imageShell:MovieClip;	
		public var textDescription:NavigationButton;
		public var textNumbers:MovieClip;
		public var preloaderBar:Sprite;
		
		private var _section:String = "work";
		private var _numberSubsection:uint = 0;
		private var _numberSet:uint = 0;
		private var _numberImage:uint = 0;
		private var folder:String;
		private var _focus:Boolean = false;
		
		private var lengthSet:uint = 0;
		
		private var tweenArrowLeft:GTween;
		private var tweenArrowRight:GTween;
		private var tweenImageShell:GTween;
		private var tweenImage:GTween;
		private var tweenTextDescription:GTween;
		private var tweenTxtNumbers:GTween;
		private var tweenPreloaderBar:GTween;
		private var _tweenThis:GTween;
		
		private var tweenDuration:Number = 1;
		private var easeType:Function = Cubic.easeOut;
		
		private var loader:Loader = new Loader();
		private var image:Bitmap = new Bitmap();
		private var colorNormal:Number;
		private var colorRollover:Number;
		
		private var _xml:XML;
		private var oldImageWidth:uint = 600;
		private var oldImageHeight:uint = 400;
		private var imageWidth:uint = 600;
		private var imageHeight:uint = 400;
		private var maxWidth:uint = 1000;
		private var maxHeight:uint = 600;
		
		public function Work() 
		{
			AutoHidePlugin.enabled = true;
			
			textDescription.txt.width = 600;
			textDescription.txt.autoSize = TextFieldAutoSize.CENTER;
			textDescription.txt.x = -textDescription.txt.width / 2;
			textDescription.x = 0;
			textDescription.colorNormal = 0xFFFFFF;
			textDescription.mouseEnabled = false;
			
			arrowLeft.buttonMode = true;
			arrowLeft.mouseChildren = false;
			arrowLeft.addEventListener(MouseEvent.ROLL_OVER, 	arrowHandler);
			arrowLeft.addEventListener(MouseEvent.ROLL_OUT, 	arrowHandler);
			arrowLeft.addEventListener(MouseEvent.CLICK,		arrowHandler);
			
			arrowRight.buttonMode = true;
			arrowRight.mouseChildren = false;
			arrowRight.addEventListener(MouseEvent.ROLL_OVER, 	arrowHandler);
			arrowRight.addEventListener(MouseEvent.ROLL_OUT, 	arrowHandler);
			arrowRight.addEventListener(MouseEvent.CLICK,		arrowHandler);
			
			imageShell.buttonMode = false;
			imageShell.addEventListener(MouseEvent.ROLL_OVER, 	imageShellHandler);
			imageShell.addEventListener(MouseEvent.ROLL_OUT, 	imageShellHandler);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHnadler);
			
			image.width = image.height = 40;
			
			tweenArrowLeft = new GTween(arrowLeft, tweenDuration, 				{}, { ease:easeType } );
			tweenArrowRight = new GTween(arrowRight, tweenDuration, 			{}, { ease:easeType } );
			tweenImageShell = new GTween(imageShell, tweenDuration, 			{}, { ease:easeType } );
			tweenImage = new GTween(image, tweenDuration, 						{}, { ease:easeType } );
			tweenTextDescription = new GTween(textDescription, tweenDuration, 	{}, { ease:easeType } );
			tweenTxtNumbers = new GTween(textNumbers, tweenDuration, 			{}, { ease:easeType } );
			tweenPreloaderBar = new GTween(preloaderBar, tweenDuration, 		{}, { ease:easeType } );
			
			textNumbers.mouseEnabled = false;
			
			tweenImage.onComplete = tweenImageCompleteHandler;
			tweenThis = new GTween(this, 1, { y:stage.stageHeight / 2}, { ease:Cubic.easeOut } );
		}
		
		private function imageShellHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				textNumbers.visible = true;
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				textNumbers.visible = false;
			}else if(e.type == MouseEvent.CLICK)			
			{
				
			}
		}
		
		private function keyboardHandler(e:KeyboardEvent):void 
		{
			//trace(e);
			if (e.keyCode == 39)// next
			{
				nextImage();
			}else if (e.keyCode == 37)// previous
			{
				previousImage();
			}
		}
		
		private function progressHandler(e:ProgressEvent):void 
		{
			var ratio:Number = e.bytesLoaded / e.bytesTotal;
			trace(ratio, e.bytesLoaded, e.bytesTotal);
			if (ratio > 1)
			{
				ratio = 1;
			}
			preloaderBar.visible = true;
			preloaderBar.width = ratio * imageShell.width;
		}
		
		private function ioErrorHnadler(e:IOErrorEvent):void 
		{
			trace(e);
			nextImage();
		}
		
		
		//private function loadImage(section:String, numberSubsection:uint, numberSubsectionB:uint):void
		private function loadImage():void
		{
			trace("loadImage", _section, _numberSubsection, _numberSet, _numberImage);
			folder = xml[_section].children()[_numberSubsection].children()[_numberSet].@folder;
			lengthSet = xml[_section].children()[_numberSubsection].children()[_numberSet].image.length();
			loader.load(new URLRequest(folder + xml[_section].children()[_numberSubsection].children()[_numberSet].image[_numberImage].text()));
		}
		
		private function loaderCompleteHandler(e:Event):void 
		{
			oldImageWidth = imageShell.getChildAt(0).width;
			oldImageHeight = imageShell.getChildAt(0).height;
			
			image = loader.content as Bitmap;
			image.smoothing = true;
			
			setImageWidthAndHeight();
			
			image.width = oldImageWidth;
			image.height = oldImageHeight;
			
			image.x = -image.width/2;
			image.y = -image.height/2;
			trace("image:", imageShell.getChildAt(0), imageShell.getChildAt(0).width, imageShell.getChildAt(0).height, image.width, image.height);
			
			image.alpha = 0;
			
			resize();
			
			preloaderBar.width = 0;
			preloaderBar.visible = false;
			preloaderBar.x = -imageWidth / 2;
			preloaderBar.y = imageHeight / 2;
			
			imageShell.addChild(image);
			loader.unload();
			
			textDescription.text = xml[_section].children()[_numberSubsection].children()[_numberSet].image[_numberImage].@text;
			textDescription.txt.x = -textDescription.txt.textWidth/2;
			textDescription.x = 0;
			textDescription.colorNormal = 0xFFFFFF;
			textDescription.mouseEnabled = false;
			
			textNumbers.txt.htmlText = (_numberImage + 1) + " / " + lengthSet;
			//textNumbers.txt.x = -textDescription.txt.width / 2;
			//textNumbers.txt.y = -textDescription.txt.height;
			
		}
		
		private function setImageWidthAndHeight():void
		{
			maxWidth = stage.stageWidth - 300;
			maxHeight = stage.stageHeight - 100;
			
			trace("setImageWidthAndHeight:",maxWidth, maxHeight, image.width, image.height);
			if (image.width > maxWidth || image.height > maxHeight)
			{
				var ratio:Number = 1;
				var widthRatio:Number = maxWidth / image.width;
				var heightRatio:Number = maxHeight / image.height;
				if (widthRatio < heightRatio)
				{
					ratio = widthRatio;
				}else
				{
					ratio = heightRatio;
				}
				imageWidth = image.width * ratio;
				imageHeight = image.height * ratio;
			}else
			{
				imageWidth = image.width;
				imageHeight = image.height;
			}
		}
		
		private function tweenImageCompleteHandler(tween:GTween):void 
		{
			while (imageShell.numChildren > 1)
			{
				imageShell.removeChildAt(0);
			}
			//trace("abs",imageShell.numChildren);
		}
		
		private function arrowHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				tintColor(e.target, colorRollover, 1);
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				tintColor(e.target, colorNormal, 1);
			}else if(e.type == MouseEvent.CLICK)			
			{
				if (e.target.name == "arrowRight")
				{
					nextImage();
				}else
				{
					previousImage();
				}
							
			}
		}
		
		private function nextImage():void
		{
			if (_numberImage < lengthSet-1)
			{
				_numberImage++;
			}else
			{
				_numberImage = 0;
			}
			loadImage();
		}
		
		private function previousImage():void
		{
			if (_numberImage > 0)
			{
				_numberImage--;
			}else
			{
				_numberImage = lengthSet-1;
			}
			loadImage();
		}

		private function populateInfo():void
		{
			colorNormal = 		xml..navigation..colors..normal.text();
			colorRollover = 	xml..navigation..colors..rollover.text();
			tintColor(arrowLeft, colorNormal, 1);
			tintColor(arrowRight, colorNormal, 1);
			lengthSet = xml[_section].children()[_numberSubsection].children()[_numberSet].image.length();
			folder = xml[_section].children()[_numberSubsection].children()[_numberSet].@folder;
			trace(lengthSet, folder);
			preloaderBar.width = 0;
			
			loadImage();
		}
		
		public function resize():void
		{
			tweenThis.setValue("y", stage.stageHeight / 2);
			
			//setImageWidthAndHeight();
			
			tweenArrowLeft.setValues({ x: -imageWidth / 2 });
			tweenArrowRight.setValues( { x: imageWidth / 2 } ); 
			//tweenImageShell.resetValues();
			tweenImageShell.addEventListener(Event.COMPLETE, tweenImageCompleteHandler);
			tweenImageShell.setValues({ width:imageWidth, height:imageHeight }); 
			tweenTextDescription.setValues( { y:imageHeight / 2 +5} );
			tweenTxtNumbers.setValues( { y:imageHeight / 2 } );
			
			tweenImage.target = image;
			tweenImage.setValues( { alpha:1 } );
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
			if (_focus == true)
			{
				stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
			}else
			{
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
			}
		}
		
		public function get section():String { return _section; }
		
		public function set section(value:String):void 
		{
			_section = value;
			_numberSubsection = 0;
			_numberSet = 0;
			_numberImage = 0;
			loadImage();
		}
		
		public function get numberSubsection():uint { return _numberSubsection; }
		
		public function set numberSubsection(value:uint):void 
		{
			_numberSubsection = value;
			_numberSet = 0;
			_numberImage = 0;
			loadImage();
		}
		
		public function get numberSet():uint { return _numberSet; }
		
		public function set numberSet(value:uint):void 
		{
			_numberSet = value;
			_numberImage = 0;
			loadImage();
		}
		
		public function get numberImage():uint { return _numberImage; }
		
		public function set numberImage(value:uint):void 
		{
			_numberImage = value;
			loadImage();
		}
		
		public function get tweenThis():GTween { return _tweenThis; }
		
		public function set tweenThis(value:GTween):void 
		{
			_tweenThis = value;
		}
	}

}