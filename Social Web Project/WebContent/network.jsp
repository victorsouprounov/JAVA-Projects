<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.sql.*" %>

<jsp:include page="header.jsp"></jsp:include>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script>
$(document).ready(function  (){
	$(document).bind('keypress', function(e) {
		if(e.keyCode==13)
		{
		var fname = $("#fname").val();
    	$.post("loadusers.jsp",{FirstName: fname},function (data){
            		$("#userstpl").html(data);
            	});  
		}
             });
          });
</script>

<div class="row">
  <div class="leftcolumnnetwork">
  	    <div class="cardglobal">
  	    
  	    <h2 align="center">Συνδεδεμένοι Επαγγελματίες</h2>
  	    
  	   
  	    <div id="table-wrapper">
  			<div id="table-scroll">
 			
    		<table id="conntbl">
  		
  		<TR>
        	<TH>Όνομα</TH>
            <TH>Επώνυμο</TH>
            <TH>E-mail</TH>
            <TH>Τηλέφωνο</TH>
            <TH>Προβολή</TH>
            <TH>Συνομιλία</TH>
        </TR>
        
    	<%
    		
   		String session_usrid = (String)session.getAttribute("user_id");
 		PreparedStatement statement1 = null;
   	
       	Connection connection1 = null;
       	Class.forName("com.mysql.jdbc.Driver");
       	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
		statement1 = connection1.prepareStatement("select * FROM connections where status = 'accepted' and (pickedusrid = ? or sessionusrid = ?)");
		statement1.setString(1,session_usrid);
		statement1.setString(2,session_usrid);
       
        ResultSet r = statement1.executeQuery();
        
        while(r.next())
        {
        	
        	//Check which column(sessionusrid or pickedusrid) has the value of the current session.
        	//Get the proper information from users table.
        	        	
        	if(r.getString("sessionusrid").equals(session_usrid))
        	{
        		
        		PreparedStatement statement2 = null;
        		statement2 = connection1.prepareStatement("select * FROM users where id = ? ");
        		statement2.setString(1,r.getString("pickedusrid"));
        		ResultSet res = statement2.executeQuery();
        		res.next();
        		
                %>

    			<tr>
                      <td> <%= res.getString("name") %> </td>
                      <td> <%= res.getString("surname") %> </td>
                      <td> <%= res.getString("email") %> </td>
                      <td> <%= res.getString("phone") %> </td>
                      <td><a href="./personaldetails.jsp?id=<%= res.getString("id") %>"><img src="./images/note.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                      <td><a href="./messages.jsp?id=<%= res.getString("id") %>"><img src="./images/chat.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                 </tr>
                 
                <% 
        		
        	}
        	
        	if(r.getString("pickedusrid").equals(session_usrid))
        	{
        		
        		PreparedStatement statement3 = null;
        		statement3 = connection1.prepareStatement("select * FROM users where id = ? ");
        		statement3.setString(1,r.getString("sessionusrid"));
        		ResultSet res = statement3.executeQuery();
        		res.next();
        		
                %>

    			<tr>
                      <td> <%= res.getString("name") %> </td>
                      <td> <%= res.getString("surname") %> </td>
                      <td> <%= res.getString("email") %> </td>
                      <td> <%= res.getString("phone") %> </td>
                      <td><a href="./personaldetails.jsp?id=<%= res.getString("id") %>"><img src="./images/note.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                      <td><a href="./messages.jsp?id=<%= res.getString("id") %>"><img src="./images/chat.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                 </tr>
                 
                <% 
        	}
        	
        }
    	%>
    	
		</table>
		</div>
		</div>
		</div>

  </div>
  <div class="rightcolumnnetwork">
      <div class="cardglobal">

		<h2 align="center">Αναζήτηση</h2>
		
		<input type="text" name="fname" id="fname">

		<div id="userstpl">
		
		<div id="table-wrapper">
  			<div id="table-scroll">
		
		
  		<table id="userstbl">
  		
  		<TR>
        	<TH>Όνομα</TH>
            <TH>Επώνυμο</TH>
            <TH>E-mail</TH>
            <TH>Τηλέφωνο</TH>
            <TH>Προβολή</TH>
            
        </TR>
            	
		</table>
		</div>
		</div>
		</div>
		
		
		</div>

  </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>

