package com.ronistretch 
{
	import com.extras.audio.SoundManager;
	import com.extras.stage.StageDimensionUpdater;
	import com.extras.utilities.StyleSheetLoader;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	import com.ronistretch.ui.NavigationButton;
	import com.ronistretch.ui.SidenavShell;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GradientGlowFilter;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Main extends MovieClip
	{
		public var navigationShell:MovieClip;
		public var title:MovieClip;
		public var contentShell:MovieClip;
		public var txtCopyright:TextField;
		public var btnCopyright:MovieClip;
		public var bg:Sprite;
		
		public static var styleSheet:StyleSheet;
		public static var colorNormal:uint =		0xD0CFCF;
		public static var colorRollover:uint = 	0x779CA8;
		public static var colorSelected:uint = 	0xFFFFFF;
		public static var xml:XML;
		public static var stageDimensions:StageDimensionUpdater;
		public static var soundManager:SoundManager = new SoundManager();
		//========== SECTIONS =========//
		public var sectionSplash:Splash;
		public var sectionBiography:Biography;
		//public var sectionReviews:Biography;
		public var sectionWork:Work;
		public var sectionLinks:Links;
		public var sectionContact:Contact;
		private var sectionTerms:Terms;
		
		private var sectionString:String;
		private var section:*;
		private var arrWorkSections:Array = new Array(0, 0);
		
		//=========== TWEENS ==========//
		private var autoHider:AutoHidePlugin;
		private static const TWEEN_DURATION:Number = 1;
		private var easeType:Function = Cubic.easeOut;
		private var tweenNav:GTween;
		private var tweenTitle:GTween;

		//private var tweenSplash:GTween;
		//private var tweenCopyright:GTween;
		//private var tweenWork:GTween;
		//private var tweenBiography:GTween;
		//private var tween
		
		private var styleSheetLoader:StyleSheetLoader;
		private var arrNavigation:Array = 	new Array();
		private var arrSections:Array = 	new Array();
		private var navigationLine:Sprite;
		private var numberSection:uint;
		
		
		private static const NAV_SPACING:uint = 3;
		
		private var arrSidenavShells:Array = new Array();
		private var arrSidenavShellButtons:Array = new Array();
		private var currentSection:* = sectionSplash;
		private var enteredSite:Boolean = false;
		private var sectionName:String;
		private var sectionNumber:uint;
		public static var sndRollover1:Sound;
		public static var sndRollover2:Sound;
		public static var sndClick:Sound;
		
		
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageDimensions = new StageDimensionUpdater(stage, 1000, 600);
			
			navigationLine = 	navigationShell.line;
			sectionSplash = 	contentShell.sectionSplash;
			sectionBiography = 	contentShell.sectionBiography;
			//sectionReviews = 	contentShell.sectionBiography;
			sectionWork = 		contentShell.sectionWork;
			sectionLinks = 		contentShell.sectionLinks;
			sectionContact = 	contentShell.sectionContact;
			sectionTerms = 		contentShell.sectionTerms;
			
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			tweenNav = 			new GTween(navigationShell, TWEEN_DURATION, { }, 	{ ease:easeType } );
			tweenTitle = 		new GTween(title, TWEEN_DURATION, { }, 				{ ease:easeType } );
			//tweenWork = 		new GTween(sectionWork, TWEEN_DURATION, { }, 		{ ease:easeType } );
			//tweenCopyright = 	new GTween(txtCopyright, TWEEN_DURATION, { }, 		{ ease:easeType } );
			//tweenSplash = 	new GTween(sectionSplash, TWEEN_DURATION, { }, 		{ ease:easeType } );
			
			sectionSplash.buttonMode = true;
			sectionSplash.mouseChildren = false;
			sectionSplash.addEventListener(MouseEvent.CLICK, 		sectionSplashHandler);
			
			navigationShell.visible = 		false;

			arrSections.push(sectionSplash, sectionWork, sectionBiography, sectionContact, sectionLinks, sectionTerms);
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				arrSections[i].alpha = 0;
				arrSections[i].tweenThis.setValue("alpha", 0);
				arrSections[i].visible = false;
			}
			sectionSplash.tweenThis.setValue("alpha", 1);
			sectionSplash.addEventListener("complete", splashCompleteHandler);
			
			loadXML("data/roniStretch.xml");
		}
		
		private function splashCompleteHandler(e:Event):void 
		{
			trace("splashCompleteHandler", sectionSplash.imageShell.height);
			tweenTitle.setValues( { x:500 + sectionSplash.imageShell.width / 2, y:sectionSplash.y - sectionSplash.imageShell.height / 2 - title.height } );
		}
		
		private function loadXML(path:String):void
		{
			var urlLoader:URLLoader = new URLLoader(new URLRequest(path));
			urlLoader.addEventListener(Event.COMPLETE, xmlLoaderHandler);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			urlLoader.load(new URLRequest(path));
		}
		
		private function xmlLoaderHandler(e:Event):void 
		{
			trace("xmlLoaderHandler");
			xml = new XML(e.target.data);
			
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				arrSections[i].xml = xml;
			}
			
			colorNormal = 		xml..navigation..colors..normal.text();
			colorRollover = 	xml..navigation..colors..rollover.text();
			colorSelected = 	xml..navigation..colors..selected.text();
			
			txtCopyright = btnCopyright.txt;
			txtCopyright.htmlText = xml..copyright.text();
			
			styleSheetLoader = new StyleSheetLoader(xml..styleSheet.text());
			styleSheetLoader.addEventListener(Event.COMPLETE, styleSheetCompleteHandler);
			
			//trace("xmlLoaderHandler", xml);
			//trace(colorNormal, colorRollover, colorSelected);
			setNavigation();
			setSound();
			navigationShell.alpha = 0;
			stageResizeHandler();
			sectionSplash.visible = true;
			sectionSplash.alpha = 1;
		}
		
		private function setSound():void
		{
			sndRollover1 = 	new Sound(new URLRequest(xml..audio.rollover1.text()));
			sndRollover2 = 	new Sound(new URLRequest(xml..audio.rollover2.text()));
			sndClick = 		new Sound(new URLRequest(xml..audio.click.text()));
		}
		
		private function styleSheetCompleteHandler(e:Event):void 
		{
			styleSheet = styleSheetLoader.styleSheet;
			sectionLinks.txt.styleSheet = styleSheet;
		}
		
		private function sectionSplashHandler(e:MouseEvent):void 
		{
			if(e.type == MouseEvent.CLICK)			
			{
				
				btnCopyright.buttonMode = true;
				btnCopyright.mouseChildren = false;
				btnCopyright.addEventListener(MouseEvent.ROLL_OVER, copyrightHandler);
				btnCopyright.addEventListener(MouseEvent.ROLL_OUT, copyrightHandler);
				btnCopyright.addEventListener(MouseEvent.CLICK, copyrightHandler);
				
				sectionSplash.visible = false;
				tweenNav.setValue("alpha", 1);
				enteredSite = true;
				numberSection = 1;
				openSection(sectionWork);
				//arrNavigation[0].expand();
				//selectNavButton(0);
				//arrSidenavShells[0].visible = true;
			}
		}
		
		private function titleHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				title.txt.textColor = colorRollover;
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				title.txt.textColor = 0x333333;
			}else if(e.type == MouseEvent.CLICK)		
			{
				numberSection = arrSections.length - 1;
				//sectionString = xml..navigation.link[numberSection].@section;
				numberSection = 0;
				openSection(sectionSplash);	
				tweenNav.setValue("alpha", 0);
			}
		}
		
		private function openSection(section:MovieClip):void
		{
			section.xml = xml;
			trace("openSection:", section);
			currentSection = section;
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				trace(arrSections[i]);
				arrSections[i].tweenThis.setValue("alpha", 0);
				arrSections[i].focus = false;
			}
			section.tweenThis.setValue("alpha", 1);
			section.focus = true;
			stageResizeHandler();
		}
		
		private function stageResizeHandler(e:Event = null):void 
		{
			stageDimensions.updateStageDimensions();
			trace(stage.stageWidth, stageDimensions.stageLeft);
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				arrSections[i].resize();
			}
			//sectionBiography.resize();
			//sectionWork.resize();
			//sectionSplash.resize();
			var xVal:int;
			var yVal:int;
			//trace("resize", numberSection, arrSections.length, currentSection.name);
			if (enteredSite == false)
			{
				xVal = 906;
				yVal = stage.stageHeight/2 - 185;
			}else
			{
				xVal = stageDimensions.stageRight - 20;
				yVal = stageDimensions.stageTop + 20;
			}
			tweenTitle.setValues( { x:xVal, y:yVal } );
			
			tweenNav.setValues( { y:stage.stageHeight / 2 - 140 } );
			navigationShell.x = stageDimensions.stageLeft + 20;
			//tweenWork.setValue("y", (stastage.stageHeight - txtCopyright.heightge.stageHeight-contentShell.y) / 2);
			//tweenCopyright.setValue("y", );
			//txtCopyright.y = stage.stageHeight - txtCopyright.height;
			btnCopyright.y = stage.stageHeight;
			
			bg.width = stage.stageWidth;
			bg.height = stage.stageHeight;
			bg.x = stageDimensions.stageLeft;
			bg.y = 0;
		}
		
		
		
		private function setNavigation():void
		{
			navigationShell.visible = true;
			
			title.buttonMode = true;
			title.mouseChildren = false;
			//title.txt.textColor = colorSelected;
			title.addEventListener(MouseEvent.ROLL_OVER, 	titleHandler);
			title.addEventListener(MouseEvent.ROLL_OUT, 	titleHandler);
			title.addEventListener(MouseEvent.CLICK, 		titleHandler);
			
			for (var i:int = 0; i < xml..navigation.link.length(); i++)// --- nav --- 
			{
				var btn:NavigationButton = new NavigationButton(xml..navigation.link[i].text(), i, null, colorNormal, colorRollover, colorSelected, false);
				//btn.rolloverSoundURL = xml..audio.rollover2.text();
				//btn.clickSoundURL = xml..audio.click.text();
				btn.y = i * (btn.height + NAV_SPACING);
				btn.yPosition = btn.y;
				navigationShell.addChild(btn);
				btn.addEventListener(MouseEvent.CLICK, navButtonHandler);
				//arrSections.push(xml..navigation.link.@section);
				arrNavigation.push(btn);
				
				for (var j:int = 0; j < xml..navigation.link[i].link.length(); j++) //--- subnav buttons---
				{
					//trace("subnav:", xml..navigation.link[i].link[j].@name);
					var subBtn:NavigationButton = new NavigationButton(xml..navigation.link[i].link[j].text(), j, null, colorNormal, colorRollover, colorSelected, true);
					btn.addSubnavButton(subBtn, (j+1) * (subBtn.height + NAV_SPACING));
					subBtn.x = 10;
					btn.addChild(subBtn);
					subBtn.addEventListener(MouseEvent.CLICK, subnavButtonHandler);
					subBtn.removeEventListener(MouseEvent.CLICK, navButtonHandler);
					//arrSections.push(xml..navigation.link.@section);
					//arrNavigation.push(subBtn);
					
					if (xml..navigation.link[i].link[j].link.length() > 0)
					{
						var sideNavShell:SidenavShell = new SidenavShell();
						sideNavShell.visible = false;
						sideNavShell.subButtonNumber = j;
						sideNavShell.selectedButtonNumber = 0;
						sideNavShell.x = 10;
						sideNavShell.y = btn.y + subBtn.yPosition;
						for (var k:int = 0; k < xml..navigation.link[i].link[j].link.length(); k++)// --- sub sub nav --- 
						{
							//trace("subsubnav:", xml..navigation.link[i].link[j].link[k].@name, subBtn.yPosition);
							var sideBtn:NavigationButton = new NavigationButton(xml..navigation.link[i].link[j].link[k].text(), k, null, colorNormal, colorRollover, colorSelected, false, true);
							if (k == 0)
							{
								sideBtn.selected = true;
							}
							sideBtn.y = k * (sideBtn.height + NAV_SPACING);
							sideNavShell.addChild(sideBtn);
							sideNavShell.arrButtons.push(sideBtn);
							sideBtn.addEventListener(MouseEvent.CLICK, sidenavButtonHandler);
						}
						arrSidenavShells.push(sideNavShell);
						arrSidenavShellButtons.push(sideNavShell.arrButtons);
						//navigationLine.addChild(sideNavShell);
					}
					
				}
				btn.expandedHeight = btn.height;
				btn.contract();
			}
			
			navigationLine.x = navigationShell.width + 10;
			navigationShell.x = stageDimensions.stageLeft + 20;
			
			var shapeMask:Shape = new Shape();
			shapeMask.graphics.lineStyle(0, 0, 0);
			shapeMask.graphics.beginFill(0x0000FF);
			shapeMask.graphics.drawRect(0, 0, 200, navigationLine.height);
			shapeMask.graphics.endFill();
			shapeMask.x = navigationLine.x;
			shapeMask.y = navigationLine.y;
			navigationShell.addChild(shapeMask);
			
			for (var n:int = 0; n < arrSidenavShells.length; n++) 
			{
				navigationShell.addChild(arrSidenavShells[n]);
				arrSidenavShells[n].x = navigationLine.x + 10;
				arrSidenavShells[n].mask = shapeMask;
			}
			for (var m:int = 0; m < arrNavigation.length; m++) 
			{
				arrNavigation[m].contract();
			}
		}
		
		private function copyrightHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				txtCopyright.textColor = colorRollover;
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				txtCopyright.htmlText = xml..copyright.text();
			}else if(e.type == MouseEvent.CLICK)			
			{
				txtCopyright.textColor = colorSelected;
				for (i = 0; i < arrNavigation.length; i++) 
				{
					var btn:NavigationButton = arrNavigation[i];
					btn.selected = false;
					btn.contract();
					btn.tween.setValue("y", btn.yPosition);
					btn.addEventListener(MouseEvent.CLICK, navButtonHandler);
				}
				
				for (var i:int = 0; i < arrSections.length; i++) 
				{
					arrSections[i].focus = false;
				}
				hideSideNav();
				sectionTerms.focus = true;
				openSection(sectionTerms);
			}
		}
		
		private function sidenavButtonHandler(e:MouseEvent):void 
		{
			var btn:NavigationButton = e.target as NavigationButton;
			selectSidenavButton(btn.number);
		}
		
		public function selectSidenavButton(number:uint):void
		{
			var sidenavShell:SidenavShell = arrSidenavShells[sectionWork.numberSubsection];
			var btn:NavigationButton = sidenavShell.arrButtons[number];
			trace("sidenav", btn.text, btn.number, sectionWork.numberSubsection);
			sectionWork.numberSet = number;
			
			for (var i:int = 0; i < arrSidenavShellButtons[sectionWork.numberSubsection].length; i++) 
			{
				arrSidenavShellButtons[sectionWork.numberSubsection][i].selected = false;
			}
			arrSidenavShellButtons[sectionWork.numberSubsection][btn.number].selected = true;
			sidenavShell.selectedButtonNumber = number;
			
		}
		
		private function subnavButtonHandler(e:MouseEvent):void 
		{
			var btn:NavigationButton = e.target as NavigationButton;
			selectSubnavButton(btn.number);
			
		}
		
		private function selectSubnavButton(number:uint):void
		{
			var btn:NavigationButton = arrNavigation[sectionNumber].arrSubnavButtons[number];
			var parentNumber:uint = (btn.parent as NavigationButton).number;
			var parentBtn:NavigationButton = arrNavigation[parentNumber];
			trace("subnavButtonHandler", btn.text, btn.parent.mouseEnabled, btn.number, parentNumber);
			for (var i:int = 0; i < arrNavigation[0].arrSubnavButtons.length; i++) 
			{
				parentBtn.arrSubnavButtons[i].selected = false;
				arrSidenavShells[i].visible = false;
			}
			trace(section, sectionName, btn.number);
			section.numberSubsection = btn.number;
			parentBtn.numberSubsection = btn.number;
			if (sectionName == "work")
			{
				//sectionWork.numberSubsection = btn.number;
				arrSidenavShells[btn.number].visible = true;
				//arrSidenavShellButtons[btn.number][0].selected = true;
				selectSidenavButton(btn.numberSubsection);
			}else
			{
				trace(number);
				//sectionBiography.section = "
			}
			
			btn.selected = true;
		}
		
		private function navButtonHandler(e:MouseEvent):void 
		{
			
			var btn:NavigationButton = e.target as NavigationButton;
			var i:int = 0;
			for (i = 0; i < arrNavigation.length; i++) 
			{
				arrNavigation[i].selected = false;
			}
			btn.selected = true;
			trace("navButtonHandler", btn.text, btn.mouseEnabled, btn.yPosition, btn.y);
			sectionName = xml..navigation.link[btn.number].@name;
			section = this[xml..navigation.link[btn.number].@section];
			sectionNumber = btn.number;
			trace("sectionName=", sectionName);
			if (sectionName == "work")
			{
				var sidenavShell:SidenavShell = arrSidenavShells[btn.numberSubsection];
				sidenavShell.visible = true;
				selectSidenavButton(sidenavShell.selectedButtonNumber);
			}else
			{
				hideSideNav();
			}
			
			selectNavButton(btn.number);
		}
		
		private function selectNavButton(number:uint):void
		{
			var btn:NavigationButton = arrNavigation[number];
			var i:int = 0;
			var button:NavigationButton;
				
			for (i = 0; i < arrNavigation.length-1; i++) // ------ contract all navigation buttons -------
			{
				button = arrNavigation[i];
				button.selected = false;
				button.contract();
				button.addEventListener(MouseEvent.CLICK, navButtonHandler);
			}

			if (btn.arrSubnavButtons.length > 0) // --------- if there are subsections ------------------
			{
				btn.expand();
				//todo: select subnav
				if (sectionName == "work")
				{
					arrSidenavShells[sectionWork.numberSubsection].visible = true;
					//selectSubnavButton[sectionWork.numberSubsection];
					//selectSidenavButton[sectionWork
				}else if (sectionName == "biography" || sectionName == "reviews")
				{
					section.sectionName = sectionName;
				}

				trace("123456789fuck");
				btn.arrSubnavButtons[section.numberSubsection].selected = true;
				btn.removeEventListener(MouseEvent.CLICK, navButtonHandler);
				
				var prevButton:NavigationButton;
				for (i = 0; i < arrNavigation.length; i++) 
				{
					button = arrNavigation[i];
					if (i > 0)
					{
						prevButton = arrNavigation[i - 1];
					}
					if (i <= btn.number)// -------------- tween button to new position here --------------------------
					{
						button.tween.setValue("y", button.yPosition);
					}else
					{
						button.tween.setValue("y", button.yPosition + btn.expandedHeight - btn.txt.height);
					}
				}
			}else
			{
				for (i = 0; i < arrNavigation.length; i++) 
				{
					button = arrNavigation[i];
					button.tween.setValue("y", button.yPosition);
				}
				hideSideNav();
			}
			
			btn.selected = true;
			openSection(section);
		}
		
		private function hideSideNav():void
		{
			for (var n:int = 0; n < arrSidenavShells.length; n++) 
			{
				arrSidenavShells[n].visible = false;
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(this, e);
		}
		
	}

}