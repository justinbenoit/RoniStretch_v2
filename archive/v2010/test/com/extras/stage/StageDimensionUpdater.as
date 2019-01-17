package com.extras.stage
{
	//import com.crewcreative.utils.stage.IStageDimensionUpdater;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class StageDimensionUpdater implements IStageDimensionUpdater
	{
		private var _stageWidthOffset:int = 0;
		private var _stageHeightOffset:int = 0;
		private var _stageLeft:int = 0;
		private var _stageRight:int;
		private var _stageTop:int = 0;
		private var _stageBottom:int;
		private var stage:Stage;
		private var MIN_WIDTH:uint;
		private var MIN_HEIGHT:uint;
		
		public function StageDimensionUpdater(stage:Stage, originalStageWidth:uint, originalStageHeight:uint):void
		{
			MIN_WIDTH = originalStageWidth;
			MIN_HEIGHT = originalStageHeight;
			trace("MIN_WIDTH = " + MIN_WIDTH, "MIN_HEIGHT = " + MIN_HEIGHT);
			this.stage = stage;
			stage.addEventListener(Event.RESIZE, updateStageDimensions, false, 0, true);
			updateStageDimensions(new Event(Event.RESIZE));
		}
		
		public function updateStageDimensions(e:Event = null):void
		{
			_stageWidthOffset = (stage.stageWidth - MIN_WIDTH);
			_stageHeightOffset = (stage.stageHeight - MIN_HEIGHT);
			_stageLeft = (0 - _stageWidthOffset/2);
			_stageRight = (MIN_WIDTH + _stageWidthOffset/2);
			_stageTop = 0;// (0 - _stageHeightOffset / 2);
			_stageBottom = stage.stageHeight;// (MIN_HEIGHT + _stageHeightOffset / 2);
			//trace("stageLeft=" + _stageLeft, "stageRight="+ _stageRight, "stageTop="+ _stageTop, "stageBottom="+ _stageBottom);
		}
		
		public function destroy():void
		{
			//MIN_HEIGHT = null;
			//MIN_WIDTH = null;
			stage = null;
			stage.removeEventListener( Event.RESIZE, updateStageDimensions, false );
		}
		
		//================= GETTERS AND SETTERS =======================
		public function get stageLeft():int
		{ return _stageLeft; }
		public function set stageLeft(value:int):void
		{
			_stageLeft = value;
		}
		
		public function get stageRight():int
		{ return _stageRight; }
		public function set stageRight(value:int):void
		{
			_stageRight = value;
		}
		
		public function get stageTop():int
		{ return _stageTop; }
		public function set stageTop(value:int):void
		{
			_stageTop = value;
		}
		
		public function get stageBottom():int
		{ return _stageBottom; }
		public function set stageBottom(value:int):void
		{
			_stageBottom = value;
		}
		
		public function get stageRectangle():Rectangle
		{
			return new Rectangle( _stageLeft, _stageTop, _stageRight - _stageLeft, _stageBottom - _stageTop );
		}
		
		public function get stageWidthOffset():int { return _stageWidthOffset; }
		
		public function set stageWidthOffset(value:int):void
		{
			_stageWidthOffset = value;
		}
		
		public function get stageHeightOffset():int { return _stageHeightOffset; }
		
		public function set stageHeightOffset(value:int):void
		{
			_stageHeightOffset = value;
		}
		
		
	}
}