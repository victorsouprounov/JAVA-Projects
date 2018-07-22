<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

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
        
    	<%
    		
    	String username = request.getParameter("FirstName");
  		PreparedStatement statement1 = null;
    	
        Connection connection1 = null;
        Class.forName("com.mysql.jdbc.Driver");
        connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
		statement1 = connection1.prepareStatement("Select * from Users where name like ? ");
		statement1.setString(1,"%" + username +  "%");
        
        ResultSet rs = statement1.executeQuery();
        
        while(rs.next())
        {
            %>

			<tr>
                  <td> <%= rs.getString("name") %> </td>
                  <td> <%= rs.getString("surname") %> </td>
                  <td> <%= rs.getString("email") %> </td>
                  <td> <%= rs.getString("phone") %> </td>
                  <td><a href="./personaldetails.jsp?id=<%= rs.getString("id") %>"><img src="./images/note.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
             </tr>
             
            <% 
        }
    	%>
    	
		</table>
		</div>
		</div>

</body>
</html>