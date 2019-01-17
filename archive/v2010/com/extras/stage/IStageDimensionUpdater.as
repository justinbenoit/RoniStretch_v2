package com.extras.stage
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface IStageDimensionUpdater
	{
		function destroy():void;
		
		function get stageLeft():int;
		
		function get stageRight():int;
		
		function get stageTop():int;
		
		function get stageBottom():int;
		
		function get stageRectangle():Rectangle;
		
		function get stageWidthOffset():int;
		
		function get stageHeightOffset():int;
	}
}