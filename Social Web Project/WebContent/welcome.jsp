<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>   
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width">
<title>Linked</title>
<link rel="stylesheet" type="text/css" href="./welcome.css">
</head>

<body>
  <div class="container">
  
	<div class="login-box">
    	<img src="./images/avatar.png" class="avatar">
        <h1>Σύνδεση</h1>
            <form action="Login" method="post" >
            <p>E-mail</p>
            <input type="text" name="email" placeholder="Εισάγετε Email" required="required">
            <p>Κωδικός Πρόσβασης</p>
            <input type="password" name="password" placeholder="Εισάγετε Κωδικό Πρόσβασης" required="required">
            <input type="submit" name="submit" value="Είσοδος">
            <font color="white">Νέος Χρήστης;</font>
            <a href="registration.jsp"><font color="blue" size="4">Εγγραφή</font></a>
            </form>   
	</div>
	
	<div class="footer">
  		<p>Copyright © 2018</p>
	</div>
	
	</div>	
</body>
</html>