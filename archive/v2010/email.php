<?php
    $to = 'ronistretch@mac.com'; 
	//$to =trim($to);  
	$fromName = $_POST['name'];   
	$fromEmail = $_POST['email'];    
	$subject = "message from ronistretch.com";    
	$body = stripslashes($_POST['message']);
	$messageLength = strlen($_POST['message']);
	$body .= "\n\n" . "Mail sent by: $fromName <$fromEmail>\n";
	$headers = "From: " . "$fromName <$fromEmail>" . "\n";
	
	//$bodyOriginalLength = strlen($body
	
	//$header = "From: $fromEmail\n";    
	//$header = "Return-Path: lostpass@website.net\n";
	//$header .= "X-Sender: lostpass@website.net\n";
	//$header .= "From: This is my website <$fromEmail>\n";
	//$header .= "X-Mailer:PHP 5.1\n";
	//$header .= "MIME-Version: 1.0\n";

	//@mail('justinbenoit@sbcglobal.net', $subject, $body, $headers);
	
	if(strlen($fromName) > 1 && $messageLength > 1 && strlen($fromEmail) > 2)
	{
		if(mail($to, $subject, $body, $headers))
		{
			echo "response=Thank you.  Your message has been sent.";
		} else {
			echo "response=There was an error sending your message.  \n Please directly email the address above.";
		}
	}else
	{
?>		

<!--<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">-->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
	<head>
		<title>RONI STRETCH - art</title>
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <link rel="icon" type="image/vnd.microsoft.icon" href="images/icons/RS_16.ico"/>
        <link rel="SHORTCUT ICON" href="images/icons/favicon.ico"/>

        <style type="text/css">
		/* hide from ie on mac \*/
		html {
			height: 100%;
			overflow: auto;
			min-width:1000px;
			min-height:600px;
		}

		body
		{
			background-color:#797979;
			width:100%;
			height:100%;
			margin:0 0 0 0;
			font-family: Tahoma, Geneva, sans-serif;
			color: #FFF;
			font-size: 14px;
			min-width:1000px;
			min-height:600px;
			text-align:center;
		}
		img
		{
			display: block;
			margin-left: auto;
			margin-right: auto 
			}
		#content
		{
			width:100%;
			height:800px;
			min-width:1000px;
			min-height:600px;
			text-align:center;
		}

		.titleText 
		{
			font-family: "Times New Roman", Times, serif;
			color: #FFF;
			font-size: 36px;
			font-weight: bold;
		}
        .mainText 
		{
			font-family: Tahoma, Geneva, sans-serif;
			color: #FFF;
			font-size: 14px;
		}
        </style>
         <!-- Google Analytics -->
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-13277465-1");
pageTracker._trackPageview();
} catch(err) {}</script>
</head>
<body>
	<div id="content">
          <br /><br />
			<a href="http://ronistretch.com"><span class="titleText">RONI STRETCH</span></a>
          	<br />
            <a href="http://ronistretch.com"><img src="images/splash/splash.jpg" alt=""/></a>
			<br />
            You can contact Roni directly at: <a href="mailto:ronistretch@mac.com">ronistretch@mac.com</a>
            <br />
            <br />
	</div>
</body>
</html>
        
<?php                
	}
	//$fromName='';
	//$fromEmail='';
	//$subject='';
	//$body='';
?>
