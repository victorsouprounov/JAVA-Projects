<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script>
    $(document).ready(function(){
        $("#conntbl td").click(function() {     
 
            var column_num = parseInt( $(this).index() ) + 1;
    		var id = $(this).parent().find('#tempid').text();
    		
    		$.post("loadrequests.jsp",{Pickedid: id, Column:column_num },function (data){
    	    	$("#requeststpl").html(data);
    	    });  
        });
    });
</script>
</head>
<body>

  	    <div id="table-wrapper">
  			<div id="table-scroll">
 			
    		<table id="conntbl">
  		<thead>
  		<TR>
        	<TH >Όνομα</TH>
            <TH>Επώνυμο</TH>
            <TH>Προβολή</TH>
            <TH>Αποδοχή</TH>
            <TH>Απόρριψη</TH>
        </TR>
        </thead>
        
    	<%
    	
    	String session_usrid = (String)session.getAttribute("user_id");	
    	int col_num = Integer.parseInt(request.getParameter("Column"));
    	
       	Connection connection1 = null;
       	Class.forName("com.mysql.jdbc.Driver");
       	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
       	
       	
		if(col_num == 4)
		{
	    	//User pressed accept - Update specific row from connections table and change pending to accepted.
	    	
	     	PreparedStatement statement = null;
	    	String pickedid = request.getParameter("Pickedid");
	 		statement = connection1.prepareStatement("update connections set status='accepted' where sessionusrid= ? and pickedusrid= ? " );
	 		statement.setString(1,pickedid); 
	 		statement.setString(2,session_usrid); 
	        statement.executeUpdate();	
			
		}
		
		if(col_num == 5)
		{
			
	    	//User pressed decline - Delete specific row from connections table.
	    	
	     	PreparedStatement statement = null;
	    	String pickedid = request.getParameter("Pickedid");
	 		statement = connection1.prepareStatement("delete from connections where sessionusrid= ? and pickedusrid= ? " );
	 		statement.setString(1,pickedid); 
	 		statement.setString(2,session_usrid); 
	        statement.executeUpdate();	
		}
    		        
    	
    	//Relad data with select query.
    	
    	PreparedStatement statement1 = null;
		statement1 = connection1.prepareStatement("select * FROM connections inner join users on users.id = connections.sessionusrid where pickedusrid = ? and status = 'pending'");
		statement1.setString(1,session_usrid);
       
        ResultSet r = statement1.executeQuery();
  	  	   
        
        while(r.next())
        {
            %>
			<tbody>
			<tr>
                  <td> <%= r.getString("name") %> </td>
                  <td> <%= r.getString("surname") %> </td>
                  <td><a href="./personaldetails.jsp?id=<%= r.getString("id") %>"><img src="./images/note.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                  <td><a><img src="./images/accept.jpg" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                  <td><a><img src="./images/decline.png" style="cursor: pointer;" height=30 width=30></img></a></td>
                  <td id="tempid" style="display: none;"><%= r.getString("id") %></td>
             </tr>
             </tbody>
            <% 
        }
    	%>
    	
		</table>
		</div>
		</div>

</body>
</html>