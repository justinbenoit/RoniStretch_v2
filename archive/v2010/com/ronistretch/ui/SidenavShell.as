package com.ronistretch.ui 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class SidenavShell extends Sprite
	{
		private var _subButtonNumber:uint = 0;
		private var _selectedButtonNumber:uint = 0;
		private var _arrButtons:Array = new Array();
		
		public function SidenavShell() 
		{
			
		}
		
		public function get subButtonNumber():uint { return _subButtonNumber; }
		
		public function set subButtonNumber(value:uint):void 
		{
			_subButtonNumber = value;
		}
		
		public function get selectedButtonNumber():uint { return _selectedButtonNumber; }
		
		public function set selectedButtonNumber(value:uint):void 
		{
			_selectedButtonNumber = value;
			for (var i:int = 0; i < _arrButtons.length; i++) 
			{
				_arrButtons[i].selected = false;
			}
			if (_arrButtons.length > 0)
			{
				_arrButtons[_selectedButtonNumber].selected = true;
			}
		}
		
		public function get arrButtons():Array { return _arrButtons; }
		
		public function set arrButtons(value:Array):void 
		{
			_arrButtons = value;
			
			for (var i:int = 0; i < _arrButtons.length; i++) 
			{
				_arrButtons[i].selected = false;
			}
			if (_arrButtons.length > 0)
			{
				_arrButtons[0].selected = true;
			}
		}
		
	}

}