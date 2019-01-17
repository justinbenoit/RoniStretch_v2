package com.crewcreative 
{
	import com.gskinner.motion.GTween;
	import fl.motion.easing.Sine;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class SoundManager 
	{
		private var _muted:Boolean = false;
		private var _videoSection:Boolean = false;
		private var soundMixer:SoundMixer = new SoundMixer();
		private var musicSoundChannel:SoundChannel;
		private var soundChannel:SoundChannel = new SoundChannel();
		private var sndTransform:SoundTransform = new SoundTransform(1, 0);
		private var backgroundMusic:Sound;
		
		
		private var tweenBackgroundMusic:GTween;
		
		public function SoundManager() 
		{
			
		}
		
		public function playSound(sound:Sound, startTime:Number=0, loops:uint=0):void
		{
			//trace("playSound", !_muted, sound);
			if (_muted == false)
			{
				var channel:SoundChannel = sound.play(startTime, loops);
				//channel.soundTransform = soundTransform;
			}
		}
		
		public function playSoundURL(url:String):void
		{
			trace("playSoundURL", !_muted, url);
			if (_muted == false)
			{
				var snd:Sound = new Sound();
				snd.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				snd.load(new URLRequest(url));
				var channel:SoundChannel = snd.play(0, 0);
				//channel.soundTransform = soundTransform;
			}
		}
		
		public function startLoopMusic(url:String):void
		{
			trace("startLoopMusic", url);
			backgroundMusic = new Sound();
			backgroundMusic.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			backgroundMusic.load(new URLRequest(url));
			musicSoundChannel = backgroundMusic.play(0, 9999, sndTransform);
			tweenBackgroundMusic = new GTween(sndTransform, 0.6, { }, { ease:Sine.easeOut } );
		}
		
		public function fadeOutMusic():void
		{
			trace("fadeOutMusic");
			if (tweenBackgroundMusic != null)
			{
				//tweenBackgroundMusic.setProperty("volume", 0);
				sndTransform.volume = 0;
				musicSoundChannel.soundTransform = sndTransform;
			}
		}
		
		public function fadeInMusic():void
		{
			trace("fadeInMusic");
			if (tweenBackgroundMusic != null)
			{
				//tweenBackgroundMusic.setProperty("volume", 1);
				sndTransform.volume = 1;
				musicSoundChannel.soundTransform = sndTransform;
			}
		}
		
		public function deactivateSite():void
		{
			fadeOutMusic();
		}

		public function reactivateSite():void
		{
			if (_muted == false && _videoSection == false)
			{
				fadeInMusic();
			}
		}
		
		private function ioErrorHandler(e:IOErrorEvent):void 
		{
			trace(e);
		}
		//================== GETTERS AND SETTERS =====================
		public function get muted():Boolean { return _muted; }
		
		public function set muted(value:Boolean):void 
		{
			_muted = value;
			//trace("SoundManager.  muted=" + value, tweenBackgroundMusic);
			if (_muted == true)
			{
				sndTransform.volume = 0;
				fadeOutMusic();
			}else
			{
				sndTransform.volume = 1;
				if (_videoSection == false)
				{
					fadeInMusic();
				}
			}
		}
		
		public function set videoSection(value:Boolean):void 
		{
			_videoSection = value;
		}
		
	}
	
}