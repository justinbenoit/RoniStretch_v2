package com.ronistretch 
{
	import com.extras.stage.StageDimensionUpdater;
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.gskinner.motion.plugins.IGTweenPlugin;
	import com.ronistretch.ui.NavigationButton;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.GradientGlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
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
		
		//========== SECTIONS =========//
		private var sectionSplash:Splash;
		private var sectionBiography:Biography;
		private var sectionWork:Work;
		private var sectionLinks:Links;
		private var sectionContact:Contact;
		
		private var sectionString:String;
		private var section:*;
		private var arrWorkSections:Array = new Array(0, 0);
		
		//=========== TWEENS ==========//
		private var autoHider:AutoHidePlugin;
		private static const TWEEN_DURATION:Number = 1;
		private var easeType:Function = Cubic.easeOut;
		private var tweenNav:GTween;
		//private var tweenTitle:GTween;
		//private var tweenSplash:GTween;
		//private var tweenCopyright:GTween;
		
		//private var tweenWork:GTween;
		//private var tweenBiography:GTween;
		//private var tween
		
		
		
		private var stageDimensions:StageDimensionUpdater;
		private var xml:XML;
		private var arrNavigation:Array = 	new Array();
		private var arrSections:Array = 	new Array();
		private var navigationLine:Sprite;
		private var numberSection:uint;
		
		private var colorNormal:uint =		0xD0CFCF;
		private var colorRollover:uint = 	0x779CA8;
		private var colorSelected:uint = 	0xFFFFFF;
		private static const NAV_SPACING:uint = 3;
		
		private var arrSidenavShells:Array = new Array();
		private var arrSidenavShellButtons:Array = new Array();
		
		
		public function Main() 
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.addEventListener(Event.RESIZE, stageResizeHandler);
			stageDimensions = new StageDimensionUpdater(stage, 1000, 600);
			
			navigationLine = 	navigationShell.line;
			sectionSplash = 	contentShell.sectionSplash;
			sectionBiography = 	contentShell.sectionBiography;
			sectionWork = 		contentShell.sectionWork;
			sectionLinks = 		contentShell.sectionLinks;
			sectionContact = 	contentShell.sectionContact;
			
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			tweenNav = 			new GTween(navigationShell, TWEEN_DURATION, { }, 	{ ease:easeType } );
			//tweenTitle = 		new GTween(title, TWEEN_DURATION, { }, 				{ ease:easeType } );
			//tweenWork = 		new GTween(sectionWork, TWEEN_DURATION, { }, 		{ ease:easeType } );
			//tweenCopyright = 	new GTween(txtCopyright, TWEEN_DURATION, { }, 		{ ease:easeType } );
			//tweenSplash = 		new GTween(sectionSplash, TWEEN_DURATION, { }, 		{ ease:easeType } );
			
			sectionSplash.buttonMode = true;
			sectionSplash.mouseChildren = false;
			sectionSplash.addEventListener(MouseEvent.CLICK, 		sectionSplashHandler);
			
			navigationShell.visible = 		false;

			arrSections.push(sectionSplash, sectionWork, sectionBiography, sectionContact, sectionLinks);//TODO: add links, contact, big_bear
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				arrSections[i].alpha = 0;
				arrSections[i].tweenThis.setValue("alpha", 0);
				arrSections[i].visible = false;
			}
			sectionSplash.tweenThis.setValue("alpha", 1);
			
			loadXML("data/roniStretch.xml");
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
			xml = new XML(e.target.data);
			
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				arrSections[i].xml = xml;
			}
			
			colorNormal = 		xml..navigation..colors..normal.text();
			colorRollover = 	xml..navigation..colors..rollover.text();
			colorSelected = 	xml..navigation..colors..selected.text();
			
			txtCopyright.htmlText = xml..copyright.text();
			//trace("xmlLoaderHandler", xml);
			//trace(colorNormal, colorRollover, colorSelected);
			setNavigation();
			navigationShell.alpha = 0;
			stageResizeHandler();
			sectionSplash.visible = true;
			sectionSplash.alpha = 1;
		}
		
		private function sectionSplashHandler(e:MouseEvent):void 
		{
			if(e.type == MouseEvent.CLICK)			
			{
				sectionSplash.visible = false;
				tweenNav.setValue("alpha", 1);
				//openSection(sectionWork);
				//arrNavigation[0].expand();
				selectNavButton(0);
				arrSidenavShells[0].visible = true;
			}
		}
		
		private function titleHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				title.txt.textColor = colorRollover;
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				title.txt.textColor = colorSelected;
			}else if(e.type == MouseEvent.CLICK)		
			{
				numberSection = arrSections.length - 1;
				sectionString = xml..navigation.link[numberSection].@section;
				
				openSection(sectionWork);							
			}
		}
		
		private function openSection(section:MovieClip):void
		{
			section.xml = xml;
			trace("openSection:",section);
			for (var i:int = 0; i < arrSections.length; i++) 
			{
				trace(arrSections[i]);
				arrSections[i].tweenThis.setValue("alpha", 0);
				arrSections[i].focus = false;
			}
			section.tweenThis.setValue("alpha", 1);
			section.focus = true;
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
			
			tweenNav.setValues( { y:stage.stageHeight / 2 - 140 } );
			navigationShell.x = stageDimensions.stageLeft + 20;
			//tweenWork.setValue("y", (stastage.stageHeight - txtCopyright.heightge.stageHeight-contentShell.y) / 2);
			//tweenCopyright.setValue("y", );
			txtCopyright.y = stage.stageHeight - txtCopyright.height;
			
			
		}
		
		
		
		private function setNavigation():void
		{
			navigationShell.visible = true;
			
			//title.buttonMode = true;
			//title.mouseChildren = false;
			//title.txt.textColor = colorSelected;
			//title.addEventListener(MouseEvent.ROLL_OVER, 	titleHandler);
			//title.addEventListener(MouseEvent.ROLL_OUT, 	titleHandler);
			//title.addEventListener(MouseEvent.CLICK, 		titleHandler);
			
			for (var i:int = 0; i < xml..navigation.link.length(); i++)// --- nav --- 
			{
				var btn:NavigationButton = new NavigationButton(xml..navigation.link[i].text(), i, null, colorNormal, colorRollover, colorSelected, false);
				btn.y = i * (btn.height + NAV_SPACING);
				btn.yPosition = i * (btn.height + NAV_SPACING);
				navigationShell.addChild(btn);
				btn.addEventListener(MouseEvent.CLICK, navButtonHandler);
				//arrSections.push(xml..navigation.link.@section);
				arrNavigation.push(btn);
				
				for (var j:int = 0; j < xml..navigation.link[i].link.length(); j++) //--- subnav buttons---
				{
					trace("subnav:", xml..navigation.link[i].link[j].@name);
					var subBtn:NavigationButton = new NavigationButton(xml..navigation.link[i].link[j].text(), j, null, colorNormal, colorRollover, colorSelected, true);
					btn.addSubnavButton(subBtn, (j+1) * (subBtn.height + NAV_SPACING));
					subBtn.x = 15;
					btn.addChild(subBtn);
					subBtn.addEventListener(MouseEvent.CLICK, subnavButtonHandler);
					subBtn.removeEventListener(MouseEvent.CLICK, navButtonHandler);
					//arrSections.push(xml..navigation.link.@section);
					//arrNavigation.push(subBtn);
					
					if (xml..navigation.link[i].link[j].link.length() > 0)
					{
						var sideNavShell:MovieClip = new MovieClip();
						sideNavShell.visible = false;
						var arrayButtons:Array = new Array();
						sideNavShell.x = 10;
						sideNavShell.y = btn.y + subBtn.yPosition;
						for (var k:int = 0; k < xml..navigation.link[i].link[j].link.length(); k++)// --- sub sub nav --- 
						{
							trace("subsubnav:", xml..navigation.link[i].link[j].link[k].@name, subBtn.yPosition);
							var sideBtn:NavigationButton = new NavigationButton(xml..navigation.link[i].link[j].link[k].text(), k, null, colorNormal, colorRollover, colorSelected, false, true);
							sideBtn.y = k * (sideBtn.height + NAV_SPACING);
							sideNavShell.addChild(sideBtn);
							arrayButtons.push(sideBtn);
							sideBtn.addEventListener(MouseEvent.CLICK, sidenavButtonHandler);
						}
						arrSidenavShells.push(sideNavShell);
						arrSidenavShellButtons.push(arrayButtons);
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
		
		private function sidenavButtonHandler(e:MouseEvent):void 
		{
			var btn:NavigationButton = e.target as NavigationButton;
			trace("sidenav", btn.text, btn.number, sectionWork.numberSubsection);
			sectionWork.numberSet = btn.number;
			for (var i:int = 0; i < arrSidenavShellButtons[sectionWork.numberSubsection].length; i++) 
			{
				arrSidenavShellButtons[sectionWork.numberSubsection][i].selected = false;
			}
			arrSidenavShellButtons[sectionWork.numberSubsection][btn.number].selected = true;
		}
		
		private function subnavButtonHandler(e:MouseEvent):void 
		{
			var btn:NavigationButton = e.target as NavigationButton;
			var parentNumber:uint = (btn.parent as NavigationButton).number;
			var parentBtn:NavigationButton = arrNavigation[parentNumber];
			trace("subnavButtonHandler", btn.text, btn.parent.mouseEnabled, btn.number, parentNumber);
			for (var i:int = 0; i < parentBtn.arrSubnavButtons.length; i++) 
			{
				parentBtn.arrSubnavButtons[i].selected = false;
				arrSidenavShells[i].visible = false;
			}
			sectionWork.numberSubsection = btn.number;
			arrSidenavShells[btn.number].visible = true;
			arrSidenavShellButtons[btn.number][0].selected = true;
			btn.selected = true;
		}
		
		private function navButtonHandler(e:MouseEvent):void 
		{
			
			var btn:NavigationButton = e.target as NavigationButton;
			trace("navButtonHandler", btn.text, btn.mouseEnabled);
			selectNavButton(btn.number);
			
		}
		
		private function selectNavButton(number:uint):void
		{
			var btn:NavigationButton = arrNavigation[number];
			var i:int = 0;
			for (i = 0; i < arrNavigation.length; i++) 
			{
				arrNavigation[i].selected = false;
				if (arrNavigation[i].arrSubnavButtons.length > 0)
				{
					if (arrNavigation[i].number != btn.number)
					{
						arrNavigation[i].contract();
						arrNavigation[i].addEventListener(MouseEvent.CLICK, navButtonHandler);
					}
				}
			}
			if (btn.arrSubnavButtons.length > 0)
			{
				btn.expand();
				arrSidenavShells[sectionWork.numberSubsection].visible = true;
				btn.removeEventListener(MouseEvent.CLICK, navButtonHandler);
				btn.arrSubnavButtons[sectionWork.numberSubsection].selected = true;
				var button:NavigationButton;
				for (i = 1; i < arrNavigation.length; i++) 
				{
					button = arrNavigation[i];
					if (i <= btn.number)
					{
						button.tween.setValue("y", arrNavigation[i - 1].yPosition);
					}else
					{
						button.tween.setValue("y", btn.expandedHeight + arrNavigation[i - 1].yPosition + NAV_SPACING);
					}
				}
			}else
			{
				for (i = 0; i < arrNavigation.length; i++) 
				{
					button = arrNavigation[i];
					button.tween.setValue("y", arrNavigation[i].yPosition);
				}
				for (var n:int = 0; n < arrSidenavShells.length; n++) 
				{
					arrSidenavShells[n].visible = false;
				}
			}
			
			btn.selected = true;
			openSection(this[xml.navigation[0].link[btn.number].@section]);
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(this, e);
		}
		
	}

}