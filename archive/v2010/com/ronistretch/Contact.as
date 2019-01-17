package com.ronistretch 
{
	import com.gskinner.motion.easing.Cubic;
	import com.gskinner.motion.GTween;
	import com.gskinner.motion.plugins.AutoHidePlugin;
	import com.ronistretch.ui.NavigationButton;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	/**
	 * ...
	 * @author Justin Benoit
	 */
	public class Contact extends MovieClip
	{
		public var txtEmail:TextField;
		public var txtYourName:TextField;
		public var txtYourEmail:TextField;
		public var txtMessage:TextField;
		
		public var btnEmail:NavigationButton;
		public var inputName:TextField;
		public var inputEmail:TextField;
		public var inputMessage:TextField;
		
		public var btnSend:NavigationButton;
		public var txtStatus:TextField;
		
		private var _xml:XML;
		private var _focus:Boolean = false;
		private var _tweenThis:GTween;
		
		private var urlRequest:URLRequest;
		private var urlLoader:URLLoader;
		private var urlVariables:URLVariables; 
		
		public function Contact() 
		{
			AutoHidePlugin.install();
			AutoHidePlugin.enabled = true;
			tweenThis = new GTween(this, 1, { y:stage.stageHeight / 2 }, { ease:Cubic.easeOut } );
			objectEnabler(btnSend, false);
			addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
			inputName.tabIndex = 1;
			inputEmail.tabIndex = 2;
			inputMessage.tabIndex = 3;
			//inputName.fo
			btnSend.buttonMode = true;
			btnSend.mouseChildren = false;
			btnSend.addEventListener(MouseEvent.ROLL_OVER, btnSendHandler);
			btnSend.addEventListener(MouseEvent.ROLL_OUT, btnSendHandler);
			btnSend.addEventListener(MouseEvent.CLICK, btnSendHandler);
		}
		
		private function btnSendHandler(e:MouseEvent):void 
		{
			if (e.type == MouseEvent.ROLL_OVER) 
			{
				//txt.textColor = _colorRollover;
			}else if (e.type == MouseEvent.ROLL_OUT) 
			{
				//txt.textColor = _colorNormal;
			}else if(e.type == MouseEvent.CLICK)			
			{
				e.target.selected = false;
				//txt.textColor = _colorSelected;
				var urlString:String = "name=" + inputName.text + "&email=" + inputEmail.text + "&message=" + inputMessage.text;
				//urlVariables.name = inputName.text;
				//urlVariables.email = inputEmail.text;
				//urlVariables.message = inputMessage.text;
				urlRequest = new URLRequest("email.php");
				urlRequest.method = URLRequestMethod.POST;
				urlLoader = new URLLoader(urlRequest);
				urlVariables = new URLVariables(urlString);
				trace(urlVariables.toString());
				urlLoader.dataFormat = URLLoaderDataFormat.VARIABLES;
				urlRequest.data = urlVariables;
				urlLoader.load(urlRequest);
				//urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				objectEnabler(btnSend, false);
				urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			}
		}
		
		private function urlLoaderCompleteHandler(e:Event):void 
		{
			objectEnabler(btnSend, true);
			var response:String = urlLoader.data.response;
			trace("urlLoaderCompleteHandler", response);
			if (response)
			{
				txtStatus.htmlText = response;
			}
		}
		
		private function httpStatusHandler(e:HTTPStatusEvent):void 
		{
			
		}
		
		private function keyUpHandler(e:KeyboardEvent):void 
		{
			if (inputName.text.length > 1 && validateEmail(inputEmail.text) == true && inputMessage.text.length > 3)
			{
				objectEnabler(btnSend, true);
			}else
			{
				objectEnabler(btnSend, false);
			}
		}
		
		private function validateEmail(email:String):Boolean
		{
			//trace("@", email.indexOf("@"));
			//trace(".", email.lastIndexOf("."));
			//trace(email.length);
			if (email.indexOf("@") > 2 && email.lastIndexOf(".") > email.indexOf("@") && email.length >= email.lastIndexOf(".") + 2)
			{
				return true;
			}else
			{
				return false;
			}
		}
		
		private function objectEnabler(displayObject:*, enabled:Boolean = false):void
		{
			if (enabled == true)
			{
				displayObject.mouseEnabled = true;
				displayObject.alpha = 1;
			}else
			{
				displayObject.mouseEnabled = false;
				displayObject.alpha = 0.5;
			}
		}
		
		private function populateInfo():void
		{
			//txt.htmlText = _xml..contact.text[0].text();
			//txt.autoSize = TextFieldAutoSize.LEFT;
			//txt.width = txt.textWidth + 8;
			//txt.x = -txt.width / 2;
			//txt.y = -txt.height / 2;
			btnEmail.text = xml..contact..btnEmail.text();
			btnEmail.link = xml..contact..btnEmail.@link;
			btnEmail.colorNormal = xml..navigation..colors.normal.text();
			btnEmail.colorRollover = xml..navigation..colors.rollover.text();
			btnEmail.colorSelected = xml..navigation..colors.selected.text();
			
			btnSend.text = xml..contact..btnSend.text();
			btnSend.colorNormal = xml..navigation..colors.normal.text();
			btnSend.colorRollover = xml..navigation..colors.rollover.text();
			btnSend.colorSelected = xml..navigation..colors.selected.text();
			
			resize();
		}
		
		public function resize():void
		{
			tweenThis.setValue("y", stage.stageHeight / 2);
		}
		//============== GETTERS AND SETTERS =============//
		public function get xml():XML { return _xml; }
		
		public function set xml(value:XML):void 
		{
			_xml = value;
			populateInfo();
		}
		
		public function get focus():Boolean { return _focus; }
		
		public function set focus(value:Boolean):void 
		{
			_focus = value;
		}
		
		public function get tweenThis():GTween { return _tweenThis; }
		
		public function set tweenThis(value:GTween):void 
		{
			_tweenThis = value;
		}
	}

}