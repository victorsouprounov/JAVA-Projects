<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="header.jsp"></jsp:include>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script>
$(document).ready(function()
    {
        $(document).bind('keypress', function(e) {
            if(e.keyCode==13){
                 $('#my_form').submit();
				 $('#comment').val("");
             }
        });
	});
</script>

<script type="text/javascript">
function post()
{
  var comment = document.getElementById("comment").value;
  var s_id = <%= session.getAttribute("user_id") %>;
  var p_id = <%= request.getParameter("id")%>;
  
    $.ajax
    ({
      type: 'post',
      url: 'MessagesImport',
      data: 
      {
         user_comm:comment,
	     sessionID:s_id,
	     pickedID:p_id
      },
      success: function (response) 
      {
	    document.getElementById("comment").value="";
      }
    });
  
  return false;
}
</script>

<script>
 function autoRefresh_div()
 {
      $("#resultglobal").load("loadchat.jsp?id=<%=request.getParameter("id")%>").show();
 }
 setInterval('autoRefresh_div()', 2000);
</script>

<div class="row">
  <div class="leftcolumnmessages">
   <div class="cardglobal">
   		<div id="result-wrappergloballeft">
			<div id="resultgloballeft">
   

		<h2 align="center">Μηνύματα</h2>

    	<%
    		
    	String sessionusrid = (String)session.getAttribute("user_id");
  		PreparedStatement statement1 = null;
    	
        Connection connection1 = null;
        Class.forName("com.mysql.jdbc.Driver");
        connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
		statement1 = connection1.prepareStatement("SELECT t1.sessionusrID,t1.pickedusrID,message,t1.Post_time FROM messages t1 INNER JOIN( SELECT LEAST(sessionusrID, pickedusrID) AS user_1,GREATEST(sessionusrID, pickedusrID) AS user_2,MAX(Post_time) AS latest FROM messages GROUP BY LEAST(sessionusrID, pickedusrID),GREATEST(sessionusrID, pickedusrID)) t2 ON LEAST(t1.sessionusrID, t1.pickedusrID) = t2.user_1 AND GREATEST(t1.sessionusrID, t1.pickedusrID) = t2.user_2 AND t1.Post_time = t2.latest");
			        
        ResultSet rs = statement1.executeQuery();
        
        while(rs.next())
        {
        	if(rs.getString("sessionusrID").equals(sessionusrid) || rs.getString("pickedusrID").equals(sessionusrid) )
        	{
        		
        		if(rs.getString("sessionusrID").equals(sessionusrid))
        		{
        			
            		PreparedStatement statement2 = null;
            		statement2 = connection1.prepareStatement("select * FROM users where id = ? ");
            		statement2.setString(1,rs.getString("pickedusrID"));
            		ResultSet res = statement2.executeQuery();
            		res.next();
            		
            		if(rs.getString("pickedusrID").equals(request.getParameter("id")))
            		{
                        %>

        					<div class="containermsg darker" style="cursor: pointer;">
        						<p><strong><%= res.getString("name") %></strong></p>						
          						<img src="GetImage?id=<%=res.getString("id")%>" alt="Avatar" style="width:100%;">
          						<p><%= rs.getString("message") %></p>
          						<span class="time-right"><%= rs.getString("Post_time") %></span>      						
        					</div>
                         
                        <%  
            			
            		}
            		else
            		{
                        %>

        					<div class="containermsg" style="cursor: pointer;">
        						<p><strong><%= res.getString("name") %></strong></p>						
          						<img src="GetImage?id=<%=res.getString("id")%>" alt="Avatar" style="width:100%;">
          						<p><%= rs.getString("message") %></p>
          						<span class="time-right"><%= rs.getString("Post_time") %></span>      						
        					</div>
                         
                        <%  
            		}
            		     		
        		}
        		
        		if(rs.getString("pickedusrID").equals(sessionusrid))
        		{
        			
            		PreparedStatement statement2 = null;
            		statement2 = connection1.prepareStatement("select * FROM users where id = ? ");
            		statement2.setString(1,rs.getString("sessionusrID"));
            		ResultSet res = statement2.executeQuery();
            		res.next();
            		
            		if(rs.getString("sessionusrID").equals(request.getParameter("id")))
            		{
                        %>

        					<div class="containermsg darker" style="cursor: pointer;">
        						<p><strong><%= res.getString("name") %></strong></p>						
          						<img src="GetImage?id=<%=res.getString("id")%>" alt="Avatar" style="width:100%;">
          						<p><%= rs.getString("message") %></p>
          						<span class="time-right"><%= rs.getString("Post_time") %></span>      						
        					</div>
                         
                        <%  
            			
            		}
            		else
            		{
                        %>

        					<div class="containermsg" style="cursor: pointer;">
        						<p><strong><%= res.getString("name") %></strong></p>						
          						<img src="GetImage?id=<%=res.getString("id")%>" alt="Avatar" style="width:100%;">
          						<p><%= rs.getString("message") %></p>
          						<span class="time-right"><%= rs.getString("Post_time") %></span>      						
        					</div>
                         
                        <%  
            		}
        		
        		}
        	      		

        		
 	
        	}
        	
        }
    	%>
    	</div>
		</div>
	</div>
  </div>
  
   <div class="rightcolumnmessages">
   
   <div class="cardglobal">
   
   	<h2 align="center">Συνομιλία</h2>

	<div id="container">

		<div id="result-wrapperglobal">
			<div id="resultglobal">
			</div>			
		</div>

	<form method='post' action="#" onsubmit="return post();" id="my_form" name="my_form">
		<div id="form-container">
			<div class="form-text">
    			<input type="text" style="display:none" id="username" value="<%= session.getAttribute("user_name") %>">
    			<textarea id="comment"></textarea>
    		</div>
    	<div class="form-btn">
    		<input type="submit" value="Send" id="btn" name="btn"/>
    	</div>
		</div>
	</form>

	</div>	
	
	</div>
   </div>

</div>

<jsp:include page="footer.jsp"></jsp:include>

