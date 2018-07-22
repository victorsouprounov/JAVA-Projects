<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <title>Linked</title>
    <link rel="stylesheet" href="./style.css">
</head>

<body>

    <header>
     
            <% if (session.getAttribute("user_id").equals("4")) { %> 
            
            
                  <div style="margin-left: 1%; margin-top: 2%;">
        			<a href="admin.jsp"><img src="./images/linked1.png" ></a>
      			 </div>    
            	
	
            	
			<% } else {%>
			
			      <div style="margin-left: 1%; margin-top: 2%;">
        			<a href="home.jsp"><img src="./images/linked1.png" ></a>
      			 </div> 
                
			<% } %>

      <div class="container">
      
        <nav>
          <ul>  
          
          	<% if (session.getAttribute("user_id").equals("4")) { %>     
            	
            	<li class="dropdown">
                        <a class="dropbtn">
                          <img src="./images/user.png" width="30" height="30">
                            <div style="display: block; float: right;"><%= session.getAttribute("user_name") %></div>
                        </a>
                              <div class="dropdown-content">
                                  <form action="Logout" method="get">
                                    <button type="submit" name="submit">Αποσύνδεση</button>
                                  </form>
                              </div>
                </li>  	
            	
			<% } else {
			
				
		        Connection connection1 = null;
		        Class.forName("com.mysql.jdbc.Driver");
		        PreparedStatement statement1 = null;
		        connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
				statement1 = connection1.prepareStatement("SELECT t1.sessionusrID,t1.pickedusrID,message,t1.Post_time FROM messages t1 INNER JOIN( SELECT LEAST(sessionusrID, pickedusrID) AS user_1,GREATEST(sessionusrID, pickedusrID) AS user_2,MAX(Post_time) AS latest FROM messages GROUP BY LEAST(sessionusrID, pickedusrID),GREATEST(sessionusrID, pickedusrID)) t2 ON LEAST(t1.sessionusrID, t1.pickedusrID) = t2.user_1 AND GREATEST(t1.sessionusrID, t1.pickedusrID) = t2.user_2 AND t1.Post_time = t2.latest");
					        
		        ResultSet rs = statement1.executeQuery();
		        
		        String id = null;
		        if(rs.next())
		        {
		        	
	        		if(rs.getString("sessionusrID").equals(session.getAttribute("user_id")))
	        		{			
			        	id = rs.getString("pickedusrID");
	        		}

	        		
	        		if(rs.getString("pickedusrID").equals(session.getAttribute("user_id")))
	        		{
	        			
			        	id = rs.getString("sessionusrID");
	        		}
		    
		        }
			
			%>
			
			    <li><a href="home.jsp">Αρχική Σελίδα</a></li>

            	<li><a href="network.jsp">Δίκτυο</a></li>

            	<li><a href="jobadv.jsp">Αγγελίες</a></li>

            	<li><a href="./messages.jsp?id=<%= id %>">Συζητήσεις</a></li>
            
            	<li><a href="notifications.jsp">Ειδοποιήσεις</a></li>
            
            	<li><a href="personaldetails.jsp">Προσωπικά Στοιχεία</a></li>
            
            	<li><a href="settings.jsp">Ρυθμίσεις</a></li> 
	
    			 <li class="dropdown">
                        <a class="dropbtn">
                          <img src="./images/user.png" width="30" height="30">
                            <div style="display: block; float: right;"><%= session.getAttribute("user_name") %></div>
                        </a>
                              <div class="dropdown-content">
                                  <form action="Logout" method="get">
                                    <button type="submit" name="submit">Αποσύνδεση</button>
                                  </form>
                              </div>
                </li>  	
                
			<% } %>
            
            

          </ul>
        </nav>
      </div>

    </header>


</body>
</html>