<?
    $to = 'ronistretch@mac.com'; 
	//$to =trim($to);  
	$fromName = $_POST['name'];   
	$fromEmail = $_POST['email'];    
	$subject = "message from ronistretch.com";    
	$body = stripslashes($_POST['message']);
	$body .= "\n\n" . "Mail sent by: $fromName <$fromEmail>\n";
	$headers = "From: " . "$fromName <$fromEmail>" . "\n";
	//$header = "From: $fromEmail\n";    
	//$header = "Return-Path: lostpass@website.net\n";
	//$header .= "X-Sender: lostpass@website.net\n";
	//$header .= "From: This is my website <$fromEmail>\n";
	//$header .= "X-Mailer:PHP 5.1\n";
	//$header .= "MIME-Version: 1.0\n";

	//@mail('justinbenoit@sbcglobal.net', $subject, $body, $headers);
	
	if(mail($to, $subject, $body, $headers))
    {
        echo "response=Thank you.  Your message has been sent.";
    } else {
        echo "response=There was an error sending your message.  \n Please directly email the address above.";
    }
	//$fromName='';
	//$fromEmail='';
	//$subject='';
	//$body='';
?>
