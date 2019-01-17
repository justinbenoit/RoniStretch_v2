package com.extras.contextMenus
{
	public interface ICustomContextMenuControllable
	{
		function addNavigationItem(label:String, functionToCall:Function, parameters:Array = null):void;
		function removeNavigationItem(label:String):void;
		function addExternalURL(url:String, label:String = null, functionToCall:Function = null):void;
		function setContactInformation(title:String = null, address1:String = null, address2:String = null, phoneNumber:String = null, faxNumber:String = null, emailAddress:String = null):void;
		function addToggleItem(label1:String, label2:String, function1:Function, function2:Function):void;
		function setFullscreenLabels(goFullscreenLabel:String, exitFullscreenLabel:String):void;
	}
}