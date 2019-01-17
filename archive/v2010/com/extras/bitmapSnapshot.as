package com.crewcreative.utilities
{
	import flash.display.DisplayObject;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * ...
	 * @author Jeremy Tani
	 */
	public function bitmapSnapshot(obj:DisplayObject):Bitmap
	{
		
		var bd:BitmapData = new BitmapData(obj.width+8, obj.height+8, true, 0x000000);
		bd.draw(obj);
		var newBitmap:Bitmap = new Bitmap(bd);
		
		return newBitmap;
	}
}