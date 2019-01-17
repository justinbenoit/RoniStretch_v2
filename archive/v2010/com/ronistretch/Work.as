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
		public var txtStatement:TextField;
		
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
		private var tweenOldImage:GTween;
		private var tweenTextDescription:GTween;
		private var tweenTxtNumbers:GTween;
		private var tweenPreloaderBar:GTween;
		private var _tweenThis:GTween;
		private var tweenTextStatement:GTween;
		
		private var tweenDuration:Number = 1;
		private var easeType:Function = Cubic.easeOut;
		
		private var loader:Loader = new Loader();
		private var oldImage:Bitmap = new Bitmap();
		private var image:Bitmap = new Bitmap();
		private var colorNormal:Number;
		private var colorRollover:Number;
		
		private var initialImage:Boolean = true;
		
		private var _xml:XML;
		private var oldImageWidth:uint = 600;
		private var oldImageHeight:uint = 400;
		private var imageWidth:uint = 600;
		private var imageHeight:uint = 400;
		private var maxWidth:uint = 1000;
		private var maxHeight:uint = 600;
		private var nextPress:Boolean = true;
		private var textUp:Boolean = false;
		private var infoPopulated:Boolean = false;
		
		
		public function Work() 
		{
			AutoHidePlugin.enabled = true;
			
			textDescription.txt.multiline = true;
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
			
			arrowLeft.visible = arrowRight.visible = false;
			
			imageShell.buttonMode = true;
			imageShell.mouseChildren = false;
			imageShell.buttonMode = true;
			imageShell.addEventListener(MouseEvent.ROLL_OVER, 	imageShellHandler);
			imageShell.addEventListener(MouseEvent.ROLL_OUT, 	imageShellHandler);
			imageShell.addEventListener(MouseEvent.CLICK, 	imageShellHandler);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			image.width = image.height = 400;
			
			tweenArrowLeft = new GTween(arrowLeft, tweenDuration, 				{ }, { ease:easeType } );
			tweenArrowRight = new GTween(arrowRight, tweenDuration, 			{ }, { ease:easeType } );
			tweenImageShell = new GTween(imageShell, 4, 			{ }, { ease:easeType } );
			tweenImage = new GTween(image, tweenDuration, 						{ }, { ease:easeType } );
			tweenOldImage = new GTween(image, tweenDuration, 					{ }, { ease:easeType } );
			tweenTextDescription = new GTween(textDescription, tweenDuration, 	{ }, { ease:easeType } );
			tweenTxtNumbers = new GTween(textNumbers, tweenDuration, 			{ }, { ease:easeType } );
			tweenPreloaderBar = new GTween(preloaderBar, tweenDuration, 		{ }, { ease:easeType } );
			tweenTextStatement = new GTween(txtStatement, tweenDuration, 		{ }, { ease:easeType } );
			
			textNumbers.mouseEnabled = textNumbers.mouseChildren = false;
			
			tweenImage.onComplete = tweenImageCompleteHandler;
			tweenThis = new GTween(this, 1, { y:stage.stageHeight / 2, x:70 }, { ease:Cubic.easeOut } );
			
			txtStatement.visible = false;
			txtStatement.alpha = 0;
			txtStatement.autoSize = TextFieldAutoSize.CENTER;
		}
		
		private function imageShellHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				if (lengthSet > 1)
				{
					textNumbers.visible = true;
				}
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				textNumbers.visible = false;
			}else if(e.type == MouseEvent.CLICK)			
			{
				nextImage();
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
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(e);
			if (nextPress == true)
			{
				nextImage();
			}else
			{
				previousImage();
			}
		}
		
		
		//private function loadImage(section:String, numberSubsection:uint, numberSubsectionB:uint):void
		private function loadInitialImage():void
		{
			loader.load(new URLRequest(xml..landing.@folder + xml..landing.image[0].text()));
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			lengthSet = 0;
			textNumbers.visible = false;
			//arrowLeft.visible = false;
			//arrowRight.visible = false;
			imageShell.width = imageShell.height = 1;
		}
		
		
		private function loadImage():void
		{
			trace("loadImage", _section, _numberSubsection, _numberSet, _numberImage);
			folder = xml[_section].children()[_numberSubsection].children()[_numberSet].@folder;
			lengthSet = xml[_section].children()[_numberSubsection].children()[_numberSet].image.length();
			if (lengthSet <= 1)
			{
				arrowLeft.visible = arrowRight.visible = false;
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
				
			}else
			{
				arrowLeft.visible = arrowRight.visible = true;
				stage.addEventListener(KeyboardEvent.KEY_UP, keyboardHandler);
			}
			var text:String = xml[_section].children()[_numberSubsection].children()[_numberSet].image[_numberImage].@text;
			trace("text=", text);
			if (text == "")
			{
				textUp = true;
				//imageShell.visible = false;
				//for (var i:int = 0; i < imageShell.numChildren; i++) 
				//{
					//imageShell.removeChildAt(0);
				//}
				//txtStatement.visible = true;
				tweenTextStatement.setValues( { alpha:1 } );
				
				//imageShell.width = txtStatement.width;
				//imageShell.height = txtStatement.height;
				//tweenImageShell.setValues( { alpha:1 } );
				trace(imageShell.numChildren);
				//tweenImage.setValues( { width:txtStatement.width, height:txtStatement.height, alpha:0.5 } );
				tweenImageShell.setValues( { width:txtStatement.width, height:txtStatement.height, alpha:0.5 } );

				textDescription.visible = false;
				txtStatement.htmlText = xml[_section].children()[_numberSubsection].children()[_numberSet].image[_numberImage].text();
				txtStatement.y = -txtStatement.height / 2;
				tweenArrowLeft.setValues( { x: -txtStatement.width / 2 });
				tweenArrowRight.setValues( { x: txtStatement.width / 2 } ); 
				//_numberImage++;
				trace("textUp number image:", _numberImage);
				resize();
			}else
			{
				textUp = false;
				//imageShell.visible = true;
				//txtStatement.visible = false;
				tweenTextStatement.setValues( { alpha:0 } );
				tweenImageShell.setValues( { alpha:1 } );
				textDescription.visible = true;
				loader.load(new URLRequest(folder + xml[_section].children()[_numberSubsection].children()[_numberSet].image[_numberImage].text()));
			}
		}
		
		private function loaderCompleteHandler(e:Event):void 
		{
			oldImageWidth = imageShell.getChildAt(0).width;
			oldImageHeight = imageShell.getChildAt(0).height;
			
			//oldImageWidth = imageShell.width;
			//oldImageHeight = imageShell.height;
			
			while (imageShell.numChildren > 1)
			{
				imageShell.removeChildAt(imageShell.numChildren - 1);
			}
			
			image = loader.content as Bitmap;
			image.smoothing = true;
			
			trace("**********************", image, imageShell.numChildren, oldImageWidth, oldImageHeight);
			/*if (imageShell.numChildren > 1)
			{
				imageShell.removeChildAt(0);
			}*/
			
			setImageWidthAndHeight();
			
			//imageShell.addChild(image);
			//imageShell.alpha = 1;
			
			image.width = oldImageWidth;
			image.height = oldImageHeight;
			
			image.x = -image.width / 2;
			image.y = -image.height / 2;
			
			if (initialImage == true)
			{
				trace("initialImage is TRUE");
				//imageShell.scaleX = imageShell.scaleY = 0.4;
				imageShell.alpha = 0;
				tweenImageShell.duration = 4;
				initialImage = false;
				
			}else
			{
				//imageShell.scaleX = imageShell.scaleY = 1;
				tweenImageShell.duration = tweenDuration;
			}
			trace("image:", imageShell.getChildAt(0), imageShell.getChildAt(0).width, imageShell.getChildAt(0).height, image.width, image.height);
			tweenImageShell.duration = tweenDuration;
			
			image.alpha = 0;
			//tweenImageShell.setValues({alpha:1, scaleX:1, scaleY:1} );
			tweenImageShell.setValues({alpha:1, width:imageWidth, height:imageHeight} );
			
			trace(imageShell.getChildAt(0));
			resize();
			
			preloaderBar.width = 0;
			preloaderBar.visible = false;
			preloaderBar.x = -imageWidth / 2;
			preloaderBar.y = imageHeight / 2;
			
			imageShell.addChild(image);
			//imageShell.alpha = 1;
			//image.alpha = 1;
			
			trace("jjjjjjjjjjjjjj imageShell numChildren:", imageShell.numChildren);
			
			loader.unload();
			
			textDescription.text = xml[_section].children()[_numberSubsection].children()[_numberSet].image[_numberImage].@text;
			textDescription.txt.x = -textDescription.txt.textWidth/2;
			textDescription.x = 0;
			textDescription.colorNormal = 0xFFFFFF;
			textDescription.mouseEnabled = false;
			
			textNumbers.txt.htmlText = (_numberImage + 1) + " / " + lengthSet;
			//textNumbers.txt.x = -textDescription.txt.width / 2;
			//textNumbers.txt.y = -textDescription.txt.height;
			initialImage = false;
		}
		
		public function resize():void
		{
			tweenThis.setValues( { x:70, y: stage.stageHeight / 2 } );
						
			//setImageWidthAndHeight();
			//tweenImageShell.resetValues();
			//tweenImageShell.addEventListener(Event.COMPLETE, tweenImageCompleteHandler);
			
			tweenTextDescription.setValues( { y:imageHeight / 2 +5} );
			tweenTxtNumbers.setValues( { x:imageWidth/2, y:imageHeight / 2 } );
			
			tweenImage.target = image;
			tweenImage.setValues( { alpha:1 } );
			
			if (textUp == true)
			{
				tweenArrowLeft.setValues({ x: -txtStatement.width / 2 });
				tweenArrowRight.setValues( { x: txtStatement.width / 2 } ); 
				tweenImageShell.setValues({ alpha:0, width:txtStatement.width, height:txtStatement.height }); 
			}else
			{
				tweenArrowLeft.setValues({ x: -imageWidth / 2 });
				tweenArrowRight.setValues( { x: imageWidth / 2 } ); 
				tweenImageShell.setValues({ alpha:1, width:imageWidth, height:imageHeight }); 
			}
		}
		
		private function setImageWidthAndHeight():void
		{
			maxWidth = stage.stageWidth - 350;
			maxHeight = stage.stageHeight - 140;
			
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
			trace("tweenImageCompleteHandler",imageShell.numChildren);
		}
		
		private function arrowHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				tintColor(e.target, colorRollover, 1);
				Main.soundManager.playSoundURL(xml..audio.rollover1.text());
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
			nextPress = true;
			//Main.soundManager.playSoundURL(xml..audio.click.text());
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
			nextPress = false;
			//Main.soundManager.playSoundURL(xml..audio.click.text());
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
			if (infoPopulated == false)
			{
				colorNormal = 		xml..navigation..colors..normal.text();
				colorRollover = 	xml..navigation..colors..rollover.text();
				tintColor(arrowLeft, colorNormal, 1);
				tintColor(arrowRight, colorNormal, 1);
				//lengthSet = xml[_section].children()[_numberSubsection].children()[_numberSet].image.length();
				folder = xml[_section].children()[_numberSubsection].children()[_numberSet].@folder;
				trace(lengthSet, folder);
				preloaderBar.width = 0;
			
				loadInitialImage();
				infoPopulated = true;
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