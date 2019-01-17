/*************************************************
 * Custom Right-Click Context Menu
 * version: 1.0.2
 * date: 11.26.2008
 * author: Justin Benoit <jbenoit@crewcreative.com>
 **************************************************
 * ------------------------------ builtInItems ---------------------------------------------------------
 *
 * @property		forwardAndBack		Boolean				set to 'true' to display this option in the menu
 * @property		loop         		Boolean				set to 'true' to display this option in the menu
 * @property		play				Boolean				set to 'true' to display this option in the menu
 * @property		print  				Boolean				set to 'true' to display this option in the menu
 * @property		quality				Boolean				set to 'true' to display this option in the menu
 * @property		rewind				Boolean				set to 'true' to display this option in the menu
 * @property		save				Boolean				set to 'true' to display this option in the menu
 * @property		zoom				Boolean				set to 'true' to display this option in the menu
 *
 * ------------------------------ custom Items ---------------------------------------------------------
 *
 * @property		fullscreen			Boolean				set to 'true' to display this option in the menu
 * @property		siteBy				Boolean				set to 'true' to display this option in the menu - This will display 'Site by: Crew Creative Advertising' which serves as a link to our website
 * @property		arrNavigation		Array				set to an Array containg label / function pairs - arrNavigation.push(["label", function]);
 * @property		arrExternalURLs		Array				set to an Array containg label / url pairs - arrExternalURLs.push(["label", "url", function]);
 * @property		arrMisc1			Array				set to an Array containg label / function pairs - arrMisc1.push(["label", function]);
 * @property		arrMisc1			Array				set to an Array containg label / function pairs - arrMisc1.push(["label", function]);
 * @property		objContactInfo		Object				set to an Object containg any of: title, address1, address2, phone, fax, email
 *
 * if you leave any of the above Boolean properties absent, it is automatically set to false - you can also explicity set to false
 * if you leave any of the above Object or Array parameters absent, it is automatically set to null - you can also explicity set to null
 *
 * set the parameters in the order in which you want them to appear in the context menu
 *
 * NOTE: if you pass 'this' as the target referring to any Document Class, the stage will automatically be referenced as the bounding area for the fullscreen function
 *
 * REMEMBER: you only have 15 custom item spaces to use - any more than that will not display - only the first 15 items pushed to customItems will display
 *
 * *************************************************/

package com.extras.contextMenus
{
	//import fl.video.FLVPlayback;
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.events.ContextMenuEvent;
	import flash.events.*;
	
	import flash.net.navigateToURL;
	//import com.adobe.viewsource.ViewSource;

	public class CustomContextMenu implements ICustomContextMenuControllable
	{
		private var myContextMenu:ContextMenu = new ContextMenu();
		private var target:DisplayObject;
		// ------- built in items --------
		private var _forwardAndBack:Boolean = false;
		private var _loop:Boolean = false;
		private var _play:Boolean = false;
		private var	_print:Boolean = false;
		private var	_quality:Boolean = false;
		private var	_rewind:Boolean = false;
		private var	_save:Boolean = false;
		private var	_zoom:Boolean = false;
		// -------------------------------
		private var siteBy:Boolean = false;
		private var siteByIndex:int;//this refers to the position of this item within the custom context menu, i.e. how far down the list it appears
		private var fullscreen:Boolean = false;
		private var fullscreenIndex:int;
		//
		private var _label_FullscreenOn:String =  	"View Full Screen";
		private var _label_FullscreenOff:String = 	"Exit Full Screen";
		private var _label_SiteBy:String = 			"Site by: Crew Creative Advertising";
		private var _label_SiteByURL:String = 		"http://www.crewcreative.com";
		//
		private var arrFullscreenLabels:Array;
		private var arrContextMenuItems:Array = new Array();
		private var _arrNavigation:Array = new Array();
		private var arrNavigationIndex:int;
		private var _arrMisc1:Array = new Array();
		private var _arrMisc2:Array = new Array();
		private var _arrInteractiveItems:Array = new Array();
		private var _arrExternalURLs:Array = new Array();
		private var objContactInformation:Object = new Object();
		private var arrToggleItems:Array = new Array();
		
		protected var toggleItemsIndex:int;
		private var _fullscreenRectangle:Rectangle;
		
		public function CustomContextMenu(target:*, navigationItems:Array = null, fullscreen:Boolean = false, miscLinks1:Array = null, miscLinks2:Array = null, externalURLs:Array = null, contactInformation:Object = null, siteBy:Boolean = false, forwardAndBack:Boolean = false, loop:Boolean = false, play:Boolean = false, print:Boolean = false, quality:Boolean = false, rewind:Boolean = false, save:Boolean = false, zoom:Boolean = false):void
		{
			this.target = target;
			if (navigationItems != null)
			{
				arrNavigation = navigationItems;
			}
			arrFullscreenLabels = new Array(_label_FullscreenOn, _label_FullscreenOff);
			this.fullscreen = fullscreen;
			_fullscreenRectangle = new Rectangle(target.stage.x, target.stage.y, target.stage.stageWidth, target.stage.stageHeight);
			if (miscLinks1 != null)
			{
				arrMisc1 = miscLinks1;
			}
			if (miscLinks2 != null)
			{
				arrMisc2 = miscLinks2;
			}
			if (externalURLs != null)
			{
				arrExternalURLs = externalURLs;
			}
			if (contactInformation != null)
			{
				objContactInformation = contactInformation;
			}
			this.siteBy = siteBy;
			this.forwardAndBack = forwardAndBack;
			this.loop = loop;
			this.play = play;
			this.print = print;
			this.quality = quality;
			this.rewind = rewind;
			this.save = save;
			this.zoom = zoom;
			myContextMenu.hideBuiltInItems();
			target.contextMenu = myContextMenu;
			myContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
			buildContextMenu();
			//trace("target: "+target.width+"x"+target.height);
			//trace(stage: "+target.stage.stageWidth+"x"+target.stage.stageHeight);
		}
		
		
		// ----------------------- BUILD CONTEXT MENU --------------------------
		private function buildContextMenu():void
		{
			myContextMenu.customItems.length = 0;// reset custom items and rebuild from scratch
			
			if (arrNavigation.length > 0)
			{
				addNavigation(arrNavigation);
			}
			if (fullscreen == true)
			{
				fullscreenIndex = myContextMenu.customItems.length;
				createFullscreenItem();
			}
			if (arrToggleItems.length > 0)
			{
				toggleItemsIndex = myContextMenu.customItems.length;
				for (var i:uint = 0; i < arrToggleItems.length; i++)
				{
					createToggleItem(arrToggleItems[i], i);
				}
			}
			if (arrMisc1.length > 0)
			{
				//arrMisc1Index = myContextMenu.customItems.length;
				addNavigation(arrMisc1);
			}
			if (arrMisc2.length > 0)
			{
				//arrMisc2Index = myContextMenu.customItems.length;
				addNavigation(arrMisc2);
			}
			if (arrExternalURLs.length > 0)
			{
				addExternalURLs();
			}
			if (objContactInformation != null)
			{
				addContactInformation();
			}
			if (siteBy == true)
			{
				siteByIndex = myContextMenu.customItems.length;
				addSiteBy();
			}
		}
		private function addSeparator(item, addedSeparator):Boolean
		{
			if(addedSeparator==false){
				if (myContextMenu.customItems.length != 0) {
					item.separatorBefore = true;
				}
				return true;
			}else {
				return false;
			}
		}
		// ----------------------- NAVIGATION & MISC ---------------------------
		private function addNavigation(arr:Array):void
		{
			//trace("addNavigation arr: "+arr);
			var addedSeparator:Boolean = false;
			for (var i:int = 0; i < arr.length; i++)
			{
				var item:ContextMenuItem = new ContextMenuItem(arr[i][0]);
				var func:Function = arr[i][1];
				var params:Array = arr[i][2];
				//trace("label"+item, "function = " + func, "target.root = "+target.root, "parameters: "+params);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, navigationItemHandler);
				myContextMenu.customItems.push(item);
			}
		}
		
		/**
		* Adds a link to the context menu representing a navigational section of the site.
		* Ex. Home, Synopsis, Videos, Gallery, etc.
		*
		* @param	label
		* @param	functionName
		* @param	parameters
		*/
		public function addNavigationItem(label:String, functionToCall:Function, parameters:Array=null):void
		{
			var navItem:Array = new Array(label, functionToCall, parameters);
			arrNavigation.push(navItem);
			buildContextMenu();
		}
		private function navigationItemHandler(e:ContextMenuEvent):void
		{
			//trace("navigationItemHandler", e, e.target.caption);
			for (var i:uint = 0; i < arrNavigation.length; i++)
			{
				if (arrNavigation[i][0] == e.target.caption)
				{
					var func:Function = arrNavigation[i][1];
					func.call(target, e);
				}
			}
		}
		/**
		* Removes a previously added link from the context menu.
		*
		* @param	label
		*/
		public function removeNavigationItem(label:String):void
		{
			for (var i:uint = 0; i < arrNavigation.length; i++)
			{
				if (arrNavigation[i][0] == label)
				{
					trace("remove " + label, "index: "+i);
					var arr1:Array = arrNavigation.slice(0, i);
					var arr2:Array = arrNavigation.slice((i + 1), arrNavigation.length);
					trace("arr1: "+arr1,"arr2: "+arr2);
					arrNavigation = arr1.concat(arr2);
					break;
				}
			}
		}
		/**
		* Adds a link to the context menu representing an interactive function of the site.
		* Any items added to group 1 will be separated into their own set.
		* @param	label
		* @param	functionName
		*/
		public function addInteractiveItem_group1(label:String, functionToCall:Function, menuGroup:uint = 1):void
		{
			var navLink:Array = new Array(label, functionToCall, null);
			trace("addInteractiveItem_group1 call function:", functionToCall);
			_arrMisc1.push(navLink);
			buildContextMenu();
		}
		
		/**
		* Adds a link the context menu representing an interactive function of the site.
		* * Any items added to group 2 will be separated into their own set.
		* @param	label
		* @param	functionName
		*/
		//public function addInteractiveItem_group2(label:String, functionToCall:Function):void
		//{
			//var navLink:Array = new Array(label, functionToCall);
			//_arrMisc2.push(navLink);
			//buildContextMenu();
		//}
		
	
		// ------------------------- EXTERNAL LINKS ---------------------------
		private function addExternalURLs():void
		{
			var addedSeparator:Boolean = false;
			for (var i:int = 0; i < arrExternalURLs.length; i++) {
				var item:ContextMenuItem = new ContextMenuItem(arrExternalURLs[i][1]);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, externalURLHandler);
				myContextMenu.customItems.push(item);
			}
		}
		private function externalURLHandler(e:ContextMenuEvent):void
		{
			for (var i:int = 0; i < arrExternalURLs.length; i++) {
				if (e.target.caption == arrExternalURLs[i][1]) {
					var func:Function = arrExternalURLs[i][2];
					var url:String = arrExternalURLs[i][0];
					var urlRequest:URLRequest = new URLRequest(url);
					navigateToURL(urlRequest, "_blank");
					if (func != null)
					{
						func.call(target);
					}
					break;
				}
			}
		}
		/**
		* Adds a web link to the context menu.  URL may include "http://" but not necessary.  It will be added automatically if missing.
		* You can call a function with functionToCall. For example a pause site function is commonly called when visiting an external URL.
		* @param	url (required) - may include "http://" but not necessary.  It will be added automatically if missing.
		* @param	label (optional - url used if not present)
		* @param	functionToCall (optional - no function is called if this is not set)
		*/
		public function addExternalURL(url:String, label:String = null, functionToCall:Function = null):void
		{
			if (label == null) {
				label = stripURLprefix(url);
			}
			url = addURLprefix(url);
			var externalURL:Array = new Array(url, label, functionToCall);
			arrExternalURLs.push(externalURL);
			buildContextMenu();
		}
		/**
		* Removes "http://" or "https://" from url if present
		*/
		private function stripURLprefix(url:String):String
		{
			if (url.substring(0, 7) == "http://") {
				url = url.substring(7,url.length);
			}else if (url.substring(0, 8) == "https://") {
				url = url.substring(8,url.length);
			}
			return url;
		}
		/**
		* Adds "http://" to url if not present
		*/
		private function addURLprefix(url:String):String
		{
			if (url.substring(0, 7) != "http://" && url.substring(0, 8) != "https://") {
				url = "http://"+url;
			}
			return url;
		}
		// ------------------------- CONTACT INFO ----------------------------
		/**
		* Adds contact information to the context menu.  Each category is added to a new line.
		* The only interactive label is "emailAddress" which will link to the email address.
		* @param	title
		* @param	address1
		* @param	address2
		* @param	phoneNumber
		* @param	faxNumber
		* @param	emailAddress
		*/
		public function setContactInformation(title:String=null, address1:String=null, address2:String=null, phoneNumber:String=null, faxNumber:String=null, emailAddress:String=null):void
		{
			objContactInformation.title = title;
			objContactInformation.address1 = address1;
			objContactInformation.address2 = address2;
			objContactInformation.phoneNumber = phoneNumber;
			objContactInformation.faxNumber = faxNumber;
			objContactInformation.emailAddress = emailAddress;
			buildContextMenu();
		}
		private function addContactInformation():void
		{
			var addedSeparator:Boolean = false;
			var item:ContextMenuItem;
			if(objContactInformation.title!=null){
				item = new ContextMenuItem(objContactInformation.title);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				myContextMenu.customItems.push(item);
			}
			if(objContactInformation.address1!=null){
				item= new ContextMenuItem(objContactInformation.address1);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				myContextMenu.customItems.push(item);
			}
			if(objContactInformation.address2!=null){
				item = new ContextMenuItem(objContactInformation.address2);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				myContextMenu.customItems.push(item);
			}
			if(objContactInformation.phoneNumber!=null){
				item = new ContextMenuItem("Phone: "+objContactInformation.phoneNumber);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				myContextMenu.customItems.push(item);
			}
			if(objContactInformation.faxNumber!=null){
				item = new ContextMenuItem("Fax: "+objContactInformation.faxNumber);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				myContextMenu.customItems.push(item);
			}
			if (objContactInformation.emailAddress != null) {
				item = new ContextMenuItem(objContactInformation.emailAddress);
				if (addSeparator(item, addedSeparator) == true) {
					addedSeparator = true;
				}
				item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, contactInfoEmailHandler);
				myContextMenu.customItems.push(item);
			}
		}
		private function contactInfoEmailHandler(event):void
		{
			var urlRequest:URLRequest = new URLRequest("mailto:" + objContactInformation.emailAddress);
			navigateToURL(urlRequest);
		}
		// -------------------------- SITE BY -------------------------------
		private function addSiteBy():void
		{
			var item:ContextMenuItem = new ContextMenuItem(_label_SiteBy);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, sityByHandler);
			if (myContextMenu.customItems.length != 0) {
				item.separatorBefore = true;
			}
			myContextMenu.customItems.push(item);
		}
		private function sityByHandler(event:ContextMenuEvent):void
		{
			var urlRequest:URLRequest = new URLRequest(addURLprefix(label_SiteByURL));
			navigateToURL(urlRequest, "_blank");
		}
		// ------------------------ FULL SCREEN ------------------------------
		public function setFullscreenLabels(goFullscreenLabel:String, exitFullscreenLabel:String):void
		{
			arrFullscreenLabels[0] = goFullscreenLabel;
			arrFullscreenLabels[1] = exitFullscreenLabel;
		}
		private function createFullscreenItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(arrFullscreenLabels[int(target.stage.displayState == StageDisplayState.FULL_SCREEN)]);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullscreenHandler);
			if (myContextMenu.customItems.length != 0 && fullscreenIndex > 0) {
				item.separatorBefore = true;
			}
			myContextMenu.customItems[fullscreenIndex] = item;
		}
		private function fullscreenHandler(event:ContextMenuEvent):void
		{
			target.stage.fullScreenSourceRect = _fullscreenRectangle;
			trace(target, _fullscreenRectangle);
			if (target.stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				target.stage.displayState = StageDisplayState.NORMAL;
			}else
			{
				target.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
		}
		// ------------------------ TOGGLE ITEM ------------------------------
		/**
		* Adds an item to context menu that changes every time it is selected from label1 to label2.
		* function1 is called when label1 is clicked.  function2 is called when label2 is clicked.
		* @param	label1
		* @param	label2
		* @param	function1
		* @param	function2
		*/
		public function addToggleItem(label1:String, label2:String, function1:Function, function2:Function/*function1:String, function2:String*/):void
		{
			var arrToggleItem:Array = new Array(label1, label2, function1, function2, true);
			arrToggleItems.push(arrToggleItem);
			buildContextMenu();
		}
		private function createToggleItem(arrToggleItem:Array, index:uint)
		{
			var labelNum:uint = uint(arrToggleItem[4]);
			var item:ContextMenuItem = new ContextMenuItem(arrToggleItem[labelNum]);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, toggleItemHandler);
			item.separatorBefore = true;
			myContextMenu.customItems[toggleItemsIndex+index] = item;
		}
		private function toggleItemHandler(e:ContextMenuEvent):void
		{
			for (var i:uint = 0; i < arrToggleItems.length; i++)
			{
				for (var j:uint = 0; j < 2; j++){
					if (arrToggleItems[i][j] == e.target.caption)
					{
						var func:Function = arrToggleItems[i][j + 2];
						trace("4. "+arrToggleItems[i][4]);
						func.call(target, e);
						arrToggleItems[i][4] = !arrToggleItems[i][4];
					}
				}
			}
		}
		// ------------------------ MENU SELECT ------------------------------
		private function menuSelectHandler(event:ContextMenuEvent):void
		{
            //trace("menuSelectHandler: " + event);
			trace("this context menu has "+myContextMenu.customItems.length+" custom items");
			if (fullscreen == true){
				createFullscreenItem();
			}
			for (var i:uint = 0; i < arrToggleItems.length; i++)
			{
				/*trace("building in " + (i+1) + " toggle items");
				var activated:Boolean = arrToggleItems[i][4];
				if (activated == true)
				{
					create
				}*/
				createToggleItem(arrToggleItems[i], i);
			}
        }
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		// --------------------------------------------------------------------
		// -------------------- GETTERS AND SETTERS ---------------------------
		/**
		* Indicates whether the context menu will include the builtInItems Forward and Back.
		* @default false
		* */
		public function get forwardAndBack():Boolean { return _forwardAndBack; }
		
		public function set forwardAndBack(value:Boolean):void
		{
			_forwardAndBack = value;
			myContextMenu.builtInItems.forwardAndBack = _forwardAndBack;
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Loop.
		* @default false
		* */
		public function get loop():Boolean { return _loop; }
		
		public function set loop(value:Boolean):void
		{
			_loop = value;
			myContextMenu.builtInItems.loop = _loop
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Play.
		* @default false
		* */
		public function get play():Boolean { return _play; }
		
		public function set play(value:Boolean):void
		{
			_play = value;
			myContextMenu.builtInItems.play = _play;
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Print.
		* @default false
		* */
		public function get print():Boolean { return _print; }
		
		public function set print(value:Boolean):void
		{
			_print = value;
			myContextMenu.builtInItems.print = _print;
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Quality.
		* @default false
		* */
		public function get quality():Boolean { return _quality; }
		
		public function set quality(value:Boolean):void
		{
			_quality = value;
			myContextMenu.builtInItems.quality = _quality;
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Rewind.
		* @default false
		* */
		public function get rewind():Boolean { return _rewind; }
		
		public function set rewind(value:Boolean):void
		{
			_rewind = value;
			myContextMenu.builtInItems.rewind = _rewind;
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Save.
		* @default false
		* */
		public function get save():Boolean { return _save; }
		
		public function set save(value:Boolean):void
		{
			_save = value;
			myContextMenu.builtInItems.save = _save;
		}
		
		/**
		* Indicates whether the context menu will include the builtInItem Zoom.
		* @default false
		* */
		public function get zoom():Boolean { return _zoom; }
		
		public function set zoom(value:Boolean):void
		{
			_zoom = value;
			myContextMenu.builtInItems.zoom = _zoom;
		}
		
		/**
		* An array representing the navigational sections of the application.
		* The array consists of value pairs in a two value array: [label, function]
		* The first value indicates the label that shows up in the context menu.
		* The second value indicates the function that is called when the label is clicked.
		* @default null
		* */
		public function get arrNavigation():Array { return _arrNavigation; }
		
		public function set arrNavigation(value:Array):void
		{
			_arrNavigation = value;
			buildContextMenu();
		}
		
		/**
		* An array representing any miscelaneous interactivity section of the site.
		* The array consists of value pairs which are part of two value array: [label, function]
		* The first value indicates the label that shows up in the context menu.
		* The second value indicates the function that is called when the label is clicked.
		* @default null
		* */
		public function get arrMisc1():Array { return _arrMisc1; }
		
		public function set arrMisc1(value:Array):void
		{
			_arrMisc1 = value;
			buildContextMenu();
		}
		
		/**
		* An array representing any miscelaneous interactivity section of the site.
		* The array consists of value pairs which are part of two value array: [label, function]
		* The first value indicates the label that shows up in the context menu.
		* The second value indicates the function that is called when the label is clicked.
		* @default null
		* */
		public function get arrMisc2():Array { return _arrMisc2; }
		
		public function set arrMisc2(value:Array):void
		{
			_arrMisc2 = value;
			buildContextMenu();
		}
		
		/**
		* An array representing any miscelaneous interactivity section of the site.
		* The array consists of three values in an array: [label, function, menuGroup]
		* The first value indicates the label that shows up in the context menu.
		* The second value indicates the function that is called when the label is clicked.
		* The third value indicates which group in the context menu in which to place the item.  A separator is added between groups.
		* @default null
		* */
		public function get arrInteractiveItems():Array { return _arrInteractiveItems; }
		
		public function set arrInteractiveItems(value:Array):void
		{
			_arrInteractiveItems = value;
		}
		
		/**
		* Indicates whether the context menu will include a Full Screen toggle button.
		* This button will switch from "View Full Screen" to "Exit Full Screen" depending on the current display state.
		* @default true
		* */
		public function get include_Fullscreen():Boolean { return fullscreen; }
		
		public function set include_Fullscreen(value:Boolean):void
		{
			fullscreen = value;
			buildContextMenu();
		}
		
		/**
		* An array representing weblinks.
		* The array consists of three values in an array: [url, label, function]
		* The first value indicates the url to navigate to when the label is clicked.  Adding "http://" to the url is optional.  It will be added if not present.
		* The second value indicates the label that shows up in the context menu.  Adding a label is optional.  The URL (minus "http://" or "https://") will be used if not present.
		* The third value indicates a function to be called when the URL is clicked.  This is optional.
		* @default null
		* */
		public function get arrExternalURLs():Array { return _arrExternalURLs; }
		
		public function set arrExternalURLs(value:Array):void
		{
			_arrExternalURLs = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include who created the site.  Default is "Site created by: Crew Creative".  This can be overwritten.
		* This label can link to an external URL, to an email address, or to nothing.  The default is the Crew Creative website: "www.crewcreative.com".
		* @default false
		* */
		public function get include_SiteBy():Boolean { return siteBy; }
		
		public function set include_SiteBy(value:Boolean):void
		{
			siteBy = value;
			buildContextMenu();
		}
		
		/**
		* Who created the website? default is "Crew Creative Advertising"
		* @default "Site by: Crew Creative Advertising"
		* */
		public function get label_SiteBy():String { return _label_SiteBy; }
		
		public function set label_SiteBy(value:String):void
		{
			_label_SiteBy = value;
		}
		
		/**
		* URL to where the Site by label links.
		* @default "http://www.crewcreative.com"
		* */
		public function get label_SiteByURL():String { return _label_SiteByURL; }
		
		public function set label_SiteByURL(value:String):void
		{
			_label_SiteByURL = value;
		}
		/**
		* default is the main swf stage size
		* */
		public function set fullscreenRectangle(value:Rectangle):void
		{
			_fullscreenRectangle = value;
		}
		/**
		* default is "View Full Screen"
		* @default "View Full Screen"
		* */
		public function set label_FullscreenOn(value:String):void
		{
			_label_FullscreenOn = value;
			arrFullscreenLabels[0] = _label_FullscreenOn;
		}
		/**
		* default is "Exit Full Screen"
		* @default "Exit Full Screen"
		* */
		public function set label_FullscreenOff(value:String):void
		{
			_label_FullscreenOff = value;
			arrFullscreenLabels[1] = _label_FullscreenOn;
		}
	}
}
