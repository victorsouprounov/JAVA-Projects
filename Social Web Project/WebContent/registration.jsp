<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>   
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Linked</title>
<link rel="stylesheet" type="text/css" href="./registration.css">
</head>

<script type="text/javascript">

function checkPass(theForm) {

    if(theForm.password.value != theForm.confpassword.value)
    {
    	alert('Those passwords don\'t match');
    	return false;

    }
}

</script>

<body>
  <div class="container">

	<div class="login-box">
            <form action="Registration" method="post" enctype="multipart/form-data" onsubmit = "return checkPass(this)">
            <p>Όνομα</p>
            <input type="text" name="name" placeholder="Εισάγετε Όνομα" required="required">
            <p>Επώνυμο</p>
            <input type="text" name="surname" placeholder="Εισάγετε Επώνυμο" required="required">
            <p>E-mail</p>
            <input type="text" name="email" placeholder="Εισάγετε Email" required="required">
            <p>Κινητό</p>
            <input type="text" name="phone" placeholder="Εισάγετε Κινητό" required="required">
            <p>Κωδικός Πρόσβασης</p>
            <input type="password" name="password" placeholder="Εισάγετε Κωδικό Πρόσβασης" required="required">
            <p>Επιβεβαίωση Κωδικού Πρόσβασης</p>
            <input type="password" name="confpassword" placeholder="Εισάγετε Κωδικό Πρόσβασης Ξανά" required="required">
            <p>Φωτογραφία</p>
            <input type="file" name="photo" style="margin-top: 3px;">
            <input type="submit" name="signup" value="Εγγραφή">
            </form>   
	</div>
	
	<div class="footer">
  		<p>Copyright © 2018</p>
	</div>
	
</div>	
</body>
</html>