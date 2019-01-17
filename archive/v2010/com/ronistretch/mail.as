import flash.events.Event;
import flash.net.*;

stop();

var contact_url:String = "contact.php"; //the name of our php file to contact the data base
var contactRequest:URLRequest = new URLRequest(contact_url);
var contactLoader:URLLoader = new URLLoader();
var contactVariables:URLVariables = new URLVariables();

send_btn.addEventListener(MouseEvent.CLICK, sendForm);

function sendForm(evt:MouseEvent):void
{
	// add the variables to our URLVariables
	contactVariables.action = "submitform";
	contactVariables.name = name_txt.text;
	contactVariables.email = email_txt.text;
	contactVariables.url = website_txt.text;
	contactVariables.comment = comment_txt.text;
	// send data via post
	contactRequest.method = URLRequestMethod.POST;
	contactRequest.data = contactVariables;
	// add listener
	contactLoader.addEventListener(Event.COMPLETE, onLoaded);
	contactLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	//send data
	contactLoader.load(contactRequest);
	//show sending message
	trace("sending");
}

function onLoaded(evt:Event):void
{
	var result_data:String = String(contactLoader.data);
	if (result_data == "ok")
	{
		trace("sended");
	}
	else if (result_data == "error")
	{
		trace("error");
	}
}

function ioErrorHandler(event:IOErrorEvent):void
{
	trace("ioErrorHandler: " + event);
