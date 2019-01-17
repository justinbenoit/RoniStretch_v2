package com.extras.color
{
	import flash.display.DisplayObject;
	import fl.motion.Color;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	
	/**
	 *
	 * @param	mc
	 * @param	colorNum
	 * @param	alphaSet
	 */
	public function tintColor(mc:*, colorNum:Number, alphaSet:Number = 1)
	{
		var cTint:Color = new Color();
		cTint.setTint(colorNum, alphaSet);
		(mc as DisplayObject).transform.colorTransform = cTint;
	}
}