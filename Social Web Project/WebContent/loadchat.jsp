<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="stylesheet" href="./style.css">
</head>
<body>

    	<%
    		
   		String session_usrid = (String)session.getAttribute("user_id");
    	String pickedusrid = request.getParameter("id");
 		PreparedStatement statement1 = null;
   	
       	Connection connection1 = null;
       	Class.forName("com.mysql.jdbc.Driver");
       	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
		statement1 = connection1.prepareStatement("select * from messages where (pickedusrid = ? or sessionusrid = ? ) and (pickedusrid = ? or sessionusrid = ?)");
		statement1.setString(1,session_usrid);
		statement1.setString(2,session_usrid);
		statement1.setString(3,pickedusrid);
		statement1.setString(4,pickedusrid);
        
        ResultSet r = statement1.executeQuery();
        
        while(r.next())
        {
        	
        	//Get the sessionusrid from results and get the information from users table.
        	
        	PreparedStatement statement2 = null;
        	statement2 = connection1.prepareStatement("select * FROM users where id = ? ");
        	statement2.setString(1,r.getString("sessionusrid"));
        	ResultSet res = statement2.executeQuery();
        	res.next();
        	 	
            %>

             <div class="chats">
             	<strong><%= res.getString("name") %></strong>  
					<div style="display: inline;"><%= r.getString("message") %></div>
					<div style="display: inline;  font-size:14px; color:#aaa; float:right;"><%= r.getString("post_time") %></div>
             </div>
             
            <% 
            

        }
        

        connection1.close();
        
    	%>


</body>
</html>