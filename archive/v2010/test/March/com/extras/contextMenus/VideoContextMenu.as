/*-------------------------------------------------
 * Crew Creative Main Right-Click Context Menu
 * version: 1.0.0
 * date: 10.20.2008
 * author: Justin Benoit <jbenoit@crewcreative.com>
 *-------------------------------------------------
 *
 * Usage:var [name]:videoContextMenu = new videoContextMenu([target]);
 *           [name].property = [value];
 *
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
 * @property		arrNavigation		Array				set to an Array containg label / function pairs - arrNavigation.push(["label", "functionName"]);
 * @property		arrExternalLinks	Array				set to an Array containg label / url pairs - arrExternalLinks.push(["label", "url"]);
 * @property		arrMisc1			Array				set to an Array containg label / function pairs - arrMisc1.push(["label", "functionName"]);
 * @property		arrMisc1			Array				set to an Array containg label / function pairs - arrMisc1.push(["label", "functionName"]);
 * @property		objContactInfo		Object				set to an Object containg any of: title, address1, address2, phone, fax, email
 *
 * if you leave any of the above Boolean properties absent, it is automatically set to false - you can also explicity set to false
 * if you leave any of the above Object or Array parameters absent, it is automatically set to null - you can also explicity set to null
 *
 * set the parameters in the order in which you want them to appear in the context menu
 *
 * note: if you pass 'this' as the target referring to any Document Class, the stage will automatically be referenced as the bounding area for the fullscreen function
 *
 * remember: you only have 15 custom item spaces to use - any more than that will not display - only the first 15 items pushed to customItems will display
 *
 *///---------------------------------------------------------------------------------------------------
package com.extras.contextMenus
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetStream;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.events.ContextMenuEvent;
	//import fl.video.FLVPlayback;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	public class VideoContextMenu extends EventDispatcher
	{
		private var myContextMenu:ContextMenu = new ContextMenu();
		private var target:DisplayObject;
		private var netStream:NetStream;
		private var soundTransform:SoundTransform;
		//private var flvPlayback:FLVPlayback;
		//========== menu includes ============
		private var fullscreen:Boolean;
		private var muteUnmute:Boolean;
		private var playPause:Boolean;
		private var play:Boolean;
		private var pause:Boolean;
		private var stop:Boolean;
		private var startOver:Boolean;
		private var previous:Boolean;
		private var next:Boolean;
		//========= video states ==============
		private var _playing:Boolean = false;
		private var _muted:Boolean = false;
		//========= menu labels ===============
		private var _label_Play:String =  			">   Play";
		private var _label_Pause:String = 			"||   Pause";
		private var _label_Stop:String =  			"  Stop";
		private var _label_StartOver:String =  		"|<  Start Over";
		private var _label_Mute:String =  			"Mute";
		private var _label_Unmute:String =  		"Unmute";
		private var _label_FullscreenOn:String =  	"View Full Screen";
		private var _label_FullscreenOff:String = 	"Exit Full Screen";
		//
		private var arrFullscreenLabels:Array;
		private var arrPlayPauseLabels:Array;
		private var arrMuteUnmuteLabels:Array;
		private var playPauseIndex:uint;
		private var fullscreenIndex:uint;
		private var muteUnmuteIndex:uint;
		private var playIndex:uint;
		private var pauseIndex:uint;
		private var stopIndex:uint;
		private var startOverIndex:uint;
		private var nextIndex:uint;
		private var previousIndex:uint;
		private var videoVolume:Number;
		private var _fullscreenRectangle:Rectangle;
		//
		public static const MUTE:String = 		"mute";
		public static const UNMUTE:String = 	"unmute";
		public static const PLAY:String = 		"play";
		public static const PAUSE:String = 		"pause";
		public static const STOP:String = 		"stop";
		public static const START_OVER:String = "start_over";
		
		
		
		public function VideoContextMenu(target:*, netStreamOrFLVPlaybackObject:*, netStreamSoundTransform:SoundTransform = null, fullscreen:Boolean = true, playPause:Boolean = true, play:Boolean = false, pause:Boolean = false, muteUnmute:Boolean = true, stop:Boolean = true, startOver:Boolean = true, next:Boolean = false, previous:Boolean = false, videoList:Array = null, currentIndex:uint = 0):void
		{
			this.target = target;
			//trace(target, netStreamOrFLVPlaybackObject, "Class name for " + target.name + ": " + getQualifiedClassName(netStreamOrFLVPlaybackObject));
			//trace(target.constructor);
			//trace(netStreamOrFLVPlaybackObject.constructor);
			if (getQualifiedClassName(netStreamOrFLVPlaybackObject) == "flash.net::NetStream")
			{
				this.netStream = netStreamOrFLVPlaybackObject;
				trace("soundTransform", netStream.soundTransform == netStreamSoundTransform, netStream.soundTransform, netStreamSoundTransform);
				if (netStreamSoundTransform != null)
				{
					//netStreamSoundTransform.volume = 0;
					//netStream.soundTransform = netStreamSoundTransform;
					//soundTransform = netStreamSoundTransform;
					soundTransform = netStream.soundTransform;
					videoVolume = soundTransform.volume;
					trace(videoVolume, soundTransform.volume);
				}else
				{
					netStream.soundTransform.volume = 0;
				}
			}else
			{
				this.netStream = null;
				//this.flvPlayback = netStreamOrFLVPlaybackObject;
				//flvPlayback.fullScreenTakeOver = false;
				//flvPlayback.autoRewind = true;
			}
			this.fullscreen = fullscreen;
			_fullscreenRectangle = new Rectangle(target.x, target.y, target.width, target.height);
			this.playPause = playPause;
			if (playPause == true)
			{
				play = false;
				pause = false;
			}else
			{
				play = play;
				pause = pause;
			}
			this.muteUnmute = muteUnmute;
			this.stop = stop;
			this.startOver = startOver;
			this.next = next;
			this.previous = previous;
			//
			arrFullscreenLabels = new Array(_label_FullscreenOn, _label_FullscreenOn);
			arrMuteUnmuteLabels = new Array(_label_Mute, _label_Unmute);
			arrPlayPauseLabels  = new Array(_label_Play, _label_Pause);
			//
			myContextMenu.hideBuiltInItems();
			target.contextMenu = myContextMenu;
			myContextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuSelectHandler);
			buildContextMenu();
			//trace("target: "+target.width+"x"+target.height,"stage: "+target.stage.stageWidth+"x"+target.stage.stageHeight);
		}
		// ----------------------- BUILD CONTEXT MENU --------------------------
		private function buildContextMenu():void
		{
			//trace("buildContextMenu");
			myContextMenu.customItems.length = 0;// reset custom items and rebuild from scratch
			if (playPause == true)
			{
				playPauseIndex = myContextMenu.customItems.length;
				createPlayPauseItem();
			}else
			{
				if (play == true)
				{
					playIndex = myContextMenu.customItems.length;
					createPlayItem();
				}
				if (pause == true)
				{
					pauseIndex = myContextMenu.customItems.length;
					createPauseItem();
				}
			}
			if (stop == true)
			{
				stopIndex = myContextMenu.customItems.length;
				createStopItem();
			}
			if (startOver == true)
			{
				startOverIndex = myContextMenu.customItems.length;
				createStartOverItem();
			}
			// ---------------------
			if (muteUnmute == true)
			{
				muteUnmuteIndex = myContextMenu.customItems.length;
				createMuteUnmuteItem();
			}
			// ---------------------
			if (fullscreen == true)
			{
				fullscreenIndex = myContextMenu.customItems.length;
				createFullscreenItem();
			}
			if (next == true)
			{
				//createNextItem();
				//TODO: create method
			}
			if (previous == true)
			{
				//createPreviousItem();
				//TODO: create method
			}
			//trace("buildContextMenu length "+myContextMenu.customItems.length);
			//trace(playPauseIndex, fullscreenIndex);
		}
		// ------------------------ PLAY / PAUSE ------------------------------
		private function createPlayPauseItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(arrPlayPauseLabels[int(_playing)]);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, playPauseHandler);
			//if (myContextMenu.customItems.length >= 0 && playPauseIndex > 0) {
				//item.separatorBefore = true;
			//}
			myContextMenu.customItems[playPauseIndex] = item;
		}
		private function playPauseHandler(event:ContextMenuEvent):void
		{
			if (netStream != null)
			{
				if (_playing==true)
				{
					netStream.pause();
					_playing = false;
				}else
				{
					netStream.resume();
					_playing = true;
				}
			}else
			{
				//flvPlayback.playing
				//if (_playing==true)
				//{
					//flvPlayback.pause();
					//_playing = false;
				//}else
				//{
					//flvPlayback.play();
					//_playing = true;
				//}
			}
		}
		// ------------------------ PLAY ITEM ------------------------------
		private function createPlayItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(_label_Play);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, playHandler);
			myContextMenu.customItems[playIndex] = item;
		}
		private function playHandler(event:ContextMenuEvent):void
		{
			_playing = true;
			if (netStream !=null)
			{
				netStream.resume();
			}else
			{
				//flvPlayback.play();
			}
		}
		// ------------------------ PAUSE ITEM ------------------------------
		private function createPauseItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(_label_Pause);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, pauseHandler);
			myContextMenu.customItems[pauseIndex] = item;
		}
		private function pauseHandler(event:ContextMenuEvent):void
		{
			trace(netStream);
			_playing = false;
			if (netStream !=null)
			{
				netStream.pause();
			}else
			{
				//flvPlayback.pause();
			}
		}
		// ------------------------ STOP ITEM ------------------------------
		private function createStopItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(_label_Stop);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, stopHandler);
			myContextMenu.customItems[stopIndex] = item;
		}
		private function stopHandler(event:ContextMenuEvent):void
		{
			_playing = false;
			if (netStream !=null)
			{
				netStream.seek(0);
				netStream.pause();
			}else
			{
				//flvPlayback.stop();
			}
		}
		// ------------------------ START OVER ITEM ------------------------------
		private function createStartOverItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(_label_StartOver);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, startOverHandler);
			myContextMenu.customItems[startOverIndex] = item;
		}
		private function startOverHandler(event:ContextMenuEvent):void
		{
			_playing = true;
			if (netStream !=null)
			{
				netStream.seek(0);
				netStream.resume();
			}else
			{
				//flvPlayback.stop();
				//flvPlayback.play();
			}
		}
		// ------------------------ MUTE / UNMUTE ------------------------------
		private function createMuteUnmuteItem():void
		{
			var item:ContextMenuItem = new ContextMenuItem(arrMuteUnmuteLabels[int(muted)]);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, muteUnmuteHandler);
			if (myContextMenu.customItems.length != 0 && muteUnmuteIndex > 0) {
				item.separatorBefore = true;
			}
			myContextMenu.customItems[muteUnmuteIndex] = item;
		}
		private function muteUnmuteHandler(event:ContextMenuEvent):void
		{
			//trace("muted: " + muted, netStream);
			if (netStream != null)// << netStream
			{
				//trace(netStream.soundTransform, netStream.soundTransform.volume);
				if (muted == true)
				{
					//soundTransform.volume = videoVolume;
					dispatchEvent(new Event(MUTE));
					muted = false;
				}else
				{
					trace(netStream.soundTransform.volume);
					netStream.soundTransform.volume = 0;
					//soundTransform.volume = 0;
					dispatchEvent(new Event(UNMUTE));
					muted = true;
				}
				trace("volume set to: ", netStream.soundTransform.volume, videoVolume);
				//trace("soundTransform.volume = " + soundTransform.volume);
			}else // flvPlayback
			{
				//trace("getVideoPlayer", flvPlayback.getVideoPlayer, "boundingBox_mc", flvPlayback.boundingBox_mc, "autoPlay", flvPlayback.autoPlay);
				//flvPlayback.muteButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
				//if (muted == true)
				//{
					//flvPlayback.volume = videoVolume;
					//muted = false;
				//}else
				//{
					//videoVolume = flvPlayback.volume;
					//flvPlayback.volume = 0;
					//muted = true;
				//}
			}
		}
		// ------------------------ FULL SCREEN ------------------------------
		private function createFullscreenItem():void
		{
			//trace(arrFullscreenLabels[int(target.stage.displayState == StageDisplayState.FULL_SCREEN)]);
			var item:ContextMenuItem = new ContextMenuItem(arrFullscreenLabels[int(target.stage.displayState == StageDisplayState.FULL_SCREEN)]);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, fullscreenHandler);
			if (myContextMenu.customItems.length != 0) {
				item.separatorBefore = true;
			}
			myContextMenu.customItems[fullscreenIndex] = item;
		}
		private function fullscreenHandler(event:ContextMenuEvent):void
		{
			if (netStream !=null)
			{
				target.stage.fullScreenSourceRect = _fullscreenRectangle;
				if (target.stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					target.stage.displayState = StageDisplayState.NORMAL;
				}else
				{
					target.stage.displayState = StageDisplayState.FULL_SCREEN;
				}
			}else
			{
				//rect = new Rectangle(target.x, target.y, flvPlayback.width, flvPlayback.height);
				//target.stage.fullScreenSourceRect = _fullscreenRectangle;
				//if (target.stage.displayState == StageDisplayState.FULL_SCREEN)
				//{
					//flvPlayback.fullScreenTakeOver = false;
					//target.stage.displayState = StageDisplayState.NORMAL;
				//}else
				//{
					//flvPlayback.fullScreenTakeOver = true;
					//target.stage.displayState = StageDisplayState.FULL_SCREEN;
					//flvPlayback.fullScreenTakeOver = false;
				//}
			}
		}
		// ------------------------ MENU SELECT ------------------------------
		private function menuSelectHandler(event:ContextMenuEvent):void
		{
            //trace("menuSelectHandler: " + event);
			//trace(myContextMenu.customItems.length+" custom items");
			//trace(arrPlayPauseLabels[int(_playing)]);
			if (fullscreen==true){
				createFullscreenItem();
			}
			if (playPause==true){
				createPlayPauseItem();
			}
			if (muteUnmute==true){
				createMuteUnmuteItem();
			}
			//buildContextMenu();
        }
		// --------------------------------------------------------------------
		// -------------------- GETTERS AND SETTERS ---------------------------
		/**
		* Indicates whether the context menu will include a Play / Pause toggle button.
		* This button will switch from ">  Play" to "|| Pause" (set labels to change Strings) depending on whether the video is playing at the time.
		* @default true
		* */
		public function get include_PlayPause():Boolean { return playPause; }
		
		public function set include_PlayPause(value:Boolean):void
		{
			playPause = value;
			if (playPause == true)
			{
				play = false;
				pause = false;
			}else
			{
				play = play;
				pause = pause;
			}
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Full Screen toggle button.
		* This button will switch from "View Full Screen" to "Exit Full Screen" (set labels to change Strings) depending on the current display state.
		* @default true
		* */
		public function get include_Fullscreen():Boolean { return fullscreen; }
		
		public function set include_Fullscreen(value:Boolean):void
		{
			fullscreen = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Mute toggle button.
		* This button will switch from "Mute" to "Unmute" (set labels to change Strings) depending on whether the video is muted at the time.
		* @default true
		* */
		public function get include_MuteUnmute():Boolean { return muteUnmute; }
		
		public function set include_MuteUnmute(value:Boolean):void
		{
			muteUnmute = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Play button.
		* This value is automatically set to false if the Play / Pause button is enabled.
		* @default false
		* */
		public function get include_Play():Boolean { return play; }
		
		public function set include_Play(value:Boolean):void
		{
			play = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Pause button.
		* This value is automatically set to false if the Play / Pause button is enabled.
		* @default false
		* */
		public function get include_Pause():Boolean { return pause; }
		
		public function set include_Pause(value:Boolean):void
		{
			pause = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Stop button.
		* This button stops the video if playing and seeks to time 0.
		* @default false
		* */
		public function get include_Stop():Boolean { return stop; }
		
		public function set include_Stop(value:Boolean):void
		{
			stop = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Start Over button.
		* This button seeks the video to 0 and begins playback.
		* @default false
		* */
		public function get include_StartOver():Boolean { return startOver; }
		
		public function set include_StartOver(value:Boolean):void
		{
			startOver = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Previous button.
		* This button loads the previous video in a user-included array of videos.
		* @default false
		* */
		public function get include_Previous():Boolean { return previous; }
		
		public function set include_Previous(value:Boolean):void
		{
			previous = value;
			buildContextMenu();
		}
		
		/**
		* Indicates whether the context menu will include a Next button.
		* This button loads the next video in a user-included array of videos.
		* @default false
		* */
		public function get include_Next():Boolean { return next; }
		
		public function set include_Next(value:Boolean):void
		{
			next = value;
			buildContextMenu();
		}
		
		// -----------------------------------------------
		/**
		* Indicates whether or not the video associated with this context menu is currently playing.
		* This value is used for the Play and Pause buttons.
		* @default false
		* */
		public function get playing():Boolean { return _playing; }
		
		public function set playing(value:Boolean):void
		{
			_playing = value;
		}
		
		/**
		* Indicates whether or not the video associated with this context menu is currently muted.
		* This value is used for the Mute button.
		* @default false
		* */
		public function get muted():Boolean { return _muted; }
		
		public function set muted(value:Boolean):void
		{
			_muted = value;
		}
		
		// -----------------------------------------------
		/**
		* Sets the rectangle to use for fullscreen video mode.
		* Rectangle default value: new Rectangle(target.x, target.y, target.width, target.height);
		* */
		public function get fullscreenRectangle():Rectangle { return _fullscreenRectangle; }
		
		public function set fullscreenRectangle(value:Rectangle):void
		{
			_fullscreenRectangle = value;
		}
		// ============= label setters ==================
		/**
		 * String default value: ">   Play"
		 */
		public function set label_Play(value:String):void
		{
			_label_Play = value;
			arrPlayPauseLabels[0] = _label_Play;
		}
		/**
		 * String default value: "||   Pause"
		 */
		public function set label_Pause(value:String):void
		{
			_label_Pause = value;
			arrPlayPauseLabels[0] = _label_Pause;
		}
		/**
		 * String default value: "  Stop"
		 */
		public function set label_Stop(value:String):void
		{
			_label_Stop = value;
		}
		/**
		 * String default value: "|<  Start Over"
		 */
		public function set label_StartOver(value:String):void
		{
			_label_StartOver = value;
		}
		/**
		 * String default value: "Mute"
		 */
		public function set label_Mute(value:String):void
		{
			_label_Mute = value;
			arrMuteUnmuteLabels[0] = _label_Mute;
		}
		/**
		 * String default value: "Unmute"
		 */
		public function set label_Unmute(value:String):void
		{
			_label_Unmute = value;
			arrMuteUnmuteLabels[1] = _label_Unmute;
		}
		/**
		 * String default value: "View Full Screen"
		 */
		public function set label_FullscreenOn(value:String):void
		{
			_label_FullscreenOn = value;
			arrFullscreenLabels[0] = _label_FullscreenOn;
		}
		/**
		 * String default value: "Exit Full Screen"
		 */
		public function set label_FullscreenOff(value:String):void
		{
			_label_FullscreenOff = value;
			arrFullscreenLabels[1] = _label_FullscreenOff;
		}
	}
}
