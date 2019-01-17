package com.ronistretch.ui 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class NavigationButton extends MovieClip
	{
		public var txt:TextField;
				
		private var _text:String;
		private var _number:int;
		private var _section:String;
		private var _link:String;
		private var _subnav:Boolean;
		private var _sidenav:Boolean;
		private var _yPosition:int;
		
		private var _colorNormal:uint;
		private var _colorRollover:uint;
		private var _colorSelected:uint;
		
		private var _selected:Boolean = false;
		private var _expandedHeight:uint = 0;
		private var _contractedHeight:uint = 0;
		
		private var _arrSubnavButtons:Array = new Array();
		private var _numberSubsection:uint = 0;
		private var _tween:GTween;
		
		public function NavigationButton(text:String = "", number:int=0, link:String=null, colorNormal:uint = 0xFFFFFF, colorRollover:uint = 0x999999, colorSelected:uint = 0xFF0000, subnav:Boolean = false, sidenav:Boolean = false, yPosition:int = 0) 
		{
			this.text = text;
			this.number = number;
			this.link = link;
			this.subnav = subnav;
			this.sidenav = sidenav;
			this.yPosition = yPosition;
			
			this.colorNormal = colorNormal;
			this.colorRollover = colorRollover;
			this.colorSelected = colorSelected;
			
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.mouseEnabled = false;
			
			this.buttonMode = true;
			this.mouseChildren = false;
			this.addEventListener(MouseEvent.ROLL_OVER, btnHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, btnHandler);
			this.addEventListener(MouseEvent.CLICK, btnHandler);
			
			_contractedHeight = txt.height;
			
			_tween = new GTween(this, 0.5, { }, { ease:Cubic.easeIn } );
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			//trace(this, this.height, this.txt.height);
			
		}
		
		private function btnHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				if (selected == false)
				{
					txt.textColor = _colorRollover;
				}
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				if (selected == false)			
				{
					txt.textColor = _colorNormal;
				}
			}else if(e.type == MouseEvent.CLICK)	
			{
				if (link == null)
				{
					txt.textColor = _colorSelected;
					selected = true;
				}else
				{
					navigateToURL(new URLRequest(_link), "_blank");
				}
				
			}
		}
		
		public function addSubnavButton(button:NavigationButton, yPosition:uint):void
		{
			_arrSubnavButtons.push(button);
			button._yPosition = yPosition;
			button.y = yPosition;
			_expandedHeight = this.height;
			button.subnav = true;
		}
		public function expand():void
		{
			for (var i:int = 0; i < _arrSubnavButtons.length; i++) 
			{
				//trace(_arrSubnavButtons[i].txt.text, _arrSubnavButtons[i].yPosition);
				_arrSubnavButtons[i].tween.setValues( { y:_arrSubnavButtons[i].yPosition, alpha:1 } );
				_arrSubnavButtons[i].selected = false;
			}
			this.mouseChildren = true;
			this.mouseEnabled = false;
			this.selected = true;
		}
		public function contract():void
		{
			trace(this, this.text, "contract()");
			for (var i:int = 0; i < _arrSubnavButtons.length; i++) 
			{
				_arrSubnavButtons[i].tween.setValues( { y:0, alpha:0 } );
			}
			this.mouseChildren = false;
			this.mouseEnabled = true;
			this.selected = false;
		}
		
		//============== GETTERS AND SETTERS =============//	
		public function get number():int { return _number; }
		
		public function set number(value:int):void 
		{
			_number = value;
		}
		
		public function get text():String { return _text; }
		
		public function set text(value:String):void 
		{
			_text = value;
			trace("set nav button text to:", _text);
			txt.htmlText = _text;
			txt.width = txt.textWidth + 8;
		}
		
		public function get link():String { return _link; }
		
		public function set link(value:String):void 
		{
			_link = value;
		}
		
		public function get colorNormal():Number { return _colorNormal; }
		
		public function set colorNormal(value:Number):void 
		{
			_colorNormal = value;
			txt.textColor = _colorNormal;
		}
		
		public function get colorRollover():Number { return _colorRollover; }
		
		public function set colorRollover(value:Number):void 
		{
			_colorRollover = value;
		}
		
		public function get colorSelected():Number { return _colorSelected; }
		
		public function set colorSelected(value:Number):void 
		{
			_colorSelected = value;
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			if (_selected == true)
			{
				this.mouseEnabled = false;
				txt.textColor = colorSelected;
			}else
			{
				this.mouseEnabled = true;
				txt.textColor = colorNormal;
			}
		}
		
		public function get expandedHeight():uint { return _expandedHeight; }
		
		public function set expandedHeight(value:uint):void 
		{
			_expandedHeight = value;
		}
		
		public function get arrSubnavButtons():Array { return _arrSubnavButtons; }
		
		public function set arrSubnavButtons(value:Array):void 
		{
			_arrSubnavButtons = value;
		}
		
		public function get subnav():Boolean { return _subnav; }
		
		public function set subnav(value:Boolean):void 
		{
			_subnav = value;
		}
		
		public function get yPosition():int { return _yPosition; }
		
		public function set yPosition(value:int):void 
		{
			_yPosition = value;
			trace(this, text, "set yPosition", yPosition);
		}
		
		public function get tween():GTween { return _tween; }
		
		public function set tween(value:GTween):void 
		{
			_tween = value;
		}
		
		public function get sidenav():Boolean { return _sidenav; }
		
		public function set sidenav(value:Boolean):void 
		{
			_sidenav = value;
		}
		
		public function get numberSubsection():uint { return _numberSubsection; }
		
		public function set numberSubsection(value:uint):void 
		{
			_numberSubsection = value;
			for (var i:int = 0; i < _arrSubnavButtons.length; i++) 
			{
				_arrSubnavButtons[i].selected = false;
			}
			_arrSubnavButtons[_numberSubsection].selected = true;
		}
		
	}

}