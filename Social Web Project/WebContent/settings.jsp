<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>

<jsp:include page="header.jsp"></jsp:include>

<script type="text/javascript">

function checkEmail(theForm) {
    if (theForm.newemail.value != theForm.email.value)
    {
    	if(theForm.newpassword.value != theForm.password.value)
    	{
    		alert('Those emails don\'t match! Those passwords don\'t match');
    	}
    	else
    	{
    		alert('Those emails don\'t match!');
    	}
    	return false;
        
    } else {
    	if(theForm.newpassword.value != theForm.password.value)
    	{
    		alert('Those passwords don\'t match');
    		return false;
    	}
    	
        return true;
    }
}

</script>

<div class="row">
  <div class="cardforsettings">

      <h1 align="center">Ρυθμίσεις</h1>
      
      <div align="center">
      
        <form action="UpdateSettings" method="post" onsubmit = "return checkEmail(this)">
		  <div style="width: 50%;">
		  	<h2>Αλλαγή email</h2>
		      <input type="text" name="newemail" placeholder="Πληκτρολογήστε το νέο email" required="required" class="rounded">
		      <input type="text" name="email" placeholder="Πληκτρολογήστε το νέο email ξανά" required="required" class="rounded">
		  </div>        
	      
		         
		  <div>
		        <h2>Αλλαγή Κωδικού Πρόσβασης</h2>    
		  <input type="password" name="newpassword" placeholder="Πληκτρολογήστε το νέο κωδικό" required="required" class="rounded">
		  <input type="password" name="password" placeholder="Πληκτρολογήστε το νέο κωδικό" required="required" class="rounded">
		  
		  </div>
      	 

    
    		<button class="profbutton" type="submit" name="submit">Αποθήκευση Αλλαγών</button>
    	</form>
    
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>

