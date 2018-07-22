<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.sql.*" %>

<jsp:include page="header.jsp"></jsp:include>

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

<div class="row">
  <div class="leftcolumnnetwork">
  	    <div class="cardglobal">
  	    
  	    <h2 align="center">Αιτήματα</h2>
  	    
  	    <div id="requeststpl">
  	    
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
 		PreparedStatement statement1 = null;
   	
       	Connection connection1 = null;
       	Class.forName("com.mysql.jdbc.Driver");
       	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
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
		</div>
		</div>

  </div>
  <div class="rightcolumnnetwork">
  
  <div class="cardglobal">
  
  <h2 align="center">Ειδοποιήσεις</h2>
  
    	    <div id="table-wrapper">
  			<div id="table-scroll">
 			
    	<table >
    	
    	<%
    		
    	String session_usrid1 = (String)session.getAttribute("user_id");
 		PreparedStatement statement2 = null;
   	
       	Connection connection2 = null;
       	Class.forName("com.mysql.jdbc.Driver");
       	connection2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
		statement2 = connection2.prepareStatement("select * from notifications inner join users on users.id = notifications.not_sessionusrid inner join posts on posts.post_id = not_postid  where not_postusrid = ? order by not_time asc");
		statement2.setString(1,session_usrid1);
       
        ResultSet r1 = statement2.executeQuery();
  	  	       
        while(r1.next())
        {
        	if(r1.getString("not_like") != null)
        	{
        		
            	if(r1.getString("not_like").equals("1"))
            	{
            		
                    %>
        			<tbody>
        			<tr>                  
                          <td><a><img src="./images/notif.png" height=30 width=30></img></a></td>
                          <td> Η δημοσίευση σας <i><%= r1.getString("post_text")%></i> αρέσει στον χρήστη <b><%= r1.getString("name") + " " + r1.getString("surname")%></b> </td>
                     </tr>
                     </tbody>
                    <% 		                            		
            	}     		   		
        	}   
        	
        	
        	
        	if(r1.getString("not_comment") != null)
        	{
        		
            	if(r1.getString("not_comment").equals("1"))
            	{
            		
                    %>
        			<tbody>
        			<tr>                  
                          <td><a><img src="./images/notmess.png" height=30 width=30></img></a></td>
                          <td>Ο χρήστης <b><%= r1.getString("name") + " " + r1.getString("surname")%></b> σχολίασε στη δημοσίευση σας <i><%= r1.getString("post_text")%></i> : <p><strong><%= r1.getString("not_text")%></strong></p> </td>
                     </tr>
                     </tbody>
                    <% 		
            	}      		
        	}
  
            
        }
        
    	%>
 	
		</table>
		</div>
		</div>
  
  </div>


  </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>

