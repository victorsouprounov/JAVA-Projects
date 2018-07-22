<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.sql.*" %>

<jsp:include page="header.jsp"></jsp:include>

<div class="container">
  <div class="leftcolumn">
  
      <div class="card">
    <form action="InsertPost" method="post" enctype="multipart/form-data">
      <h3>Τι σκέφτεστε;</h3>
      <input type="file" name="photo" style="margin-bottom:6px;">
      <input type="text" name="video" placeholder="Εισάγετε ένα βίντεο..."/>
      <textarea rows="6" cols="50" name="text" placeholder="Γράψτε ένα σχόλιο..." style="width: 100% !important; font-size: 16px;"></textarea>
	  <input type="submit" id="buttonpost" name="insertpost" value="Δημοσίευση">
	  </form>
    </div>
    
    <%---------------------------------------  Get all posts based on kNN Algorithm ----------------------------------------------%>
    
    <%--  Functionality: This algorithm has 3 levels. --%>
    <%--  Every post will have points based on conditions. --%>
    <%--  Posts in 1st level,are posts created from current user(sessionID) so they will get 1000 points. --%>
    <%--  Posts in 2nd level,are posts created from friends of current user(sessionID), so they will get 999 points. --%>
    <%--  Posts in 3rd level,are posts created from users that are not friends with current user but they get likes from friends of current user(sessionID), so they will get 0 points. --%>
    <%--  In 3rd level, posts can get p + x points where p=0 base points and x is the number of likes from current user's friends. --%>
    <%--  When all posts have points,get the k posts with maximum points ( Assuming that we are at 0 point, the distance is calculated) --%>
  
   
      <%
      
  	//---------------------------------------------------------		START	--------------------------------------------------------------------------------
 	
        // Connection string
     	Connection connection1 = null;
     	Class.forName("com.mysql.jdbc.Driver");
     	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
     	
        
        //1. Get the posts
        Statement stmt = connection1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
        ResultSet rpre = stmt.executeQuery("select * FROM posts");
        
        String sessionusrID = (String)session.getAttribute("user_id");
        
        while(rpre.next())
        { 	
        	//2. Level 1 validation
        	//Go to posts table.If post_sessionusrid == current userID(session) ,then 1000 points.
			if (rpre.getString("post_sessionusrid").equals(sessionusrID))
			{
				rpre.updateInt("post_points", 1000);
				rpre.updateRow();
				
			}
			else
			{
				//3. Level 2 validation
				//Go to connections table.If status == accepted and post_sessionusrid,current userID(session) match ,then 999 points.
				PreparedStatement ps1 = null;
    			ps1 = connection1.prepareStatement("select count(*) as counter FROM connections where status = 'accepted' and (pickedusrid = ? and sessionusrid = ?) or (pickedusrid = ? and sessionusrid = ?)");    
    			ps1.setString(1, rpre.getString("post_sessionusrid"));
    			ps1.setString(2, sessionusrID);
    			ps1.setString(3, sessionusrID);
    			ps1.setString(4, rpre.getString("post_sessionusrid"));
            	ResultSet r1 = ps1.executeQuery();  
            	r1.next();
            	
            	if( r1.getString("counter").equals("1"))
            	{
            		rpre.updateInt("post_points", 999);
            		rpre.updateRow();
            	}
            	else
            	{
            		//4. Level 3 validation
            		//Go to notifications table.Select the rows that not_sessionusrid != not_postusrid and not_like==1 or not_comment==1.
            		//Then,check for every row,if not_sessionusrid is friend with current userID(session).
            		//In order to do that,go to connections table and check is status == accepted and post_sessionusrid,current userID(session) match ->
            		//(Parameters: sessionusrID , not_sessionusrid)
            		//Update the counter for likes/comments  and update the posts table with the points.
            		
            		PreparedStatement ps2 = null;
            		ps2 = connection1.prepareStatement("select * from notifications where not_postusrid = ? ");    
    				ps2.setString(1, rpre.getString("post_sessionusrid"));
            		ResultSet r2 = ps2.executeQuery(); 
            		
            		int pointcounter = 0;
            		
            		while (r2.next())
            		{
						
        				PreparedStatement ps3 = null;
            			ps3 = connection1.prepareStatement("select count(*) as counter FROM connections where status = 'accepted' and (pickedusrid = ? and sessionusrid = ?) or (pickedusrid = ? and sessionusrid = ?)");    
            			ps3.setString(1, r2.getString("not_sessionusrid"));
            			ps3.setString(2, sessionusrID);
            			ps3.setString(3, sessionusrID);
            			ps3.setString(4, r2.getString("not_sessionusrid"));
                    	ResultSet r3 = ps3.executeQuery();  
                    	r3.next();
                    	if( r3.getString("counter").equals("1"))
                    	{
							pointcounter++;
                    	}
            			   			
            		}
            		
    				rpre.updateInt("post_points", pointcounter);
    				rpre.updateRow();    		
            	}				
			}    	
        }
        
        
        // DEFINE K HERE : 20
		PreparedStatement porigin = null;
		porigin = connection1.prepareStatement("select * from posts where post_points <> 0 order by post_points desc,post_time desc limit 20");    
    	ResultSet r = porigin.executeQuery();  
    	
      	//---------------------------------------------------------		END		--------------------------------------------------------------------------------
  
        
        while(r.next())
        {
        	
    		PreparedStatement usersps = null;
    		usersps = connection1.prepareStatement("select * from users where id = ?");    
    		usersps.setString(1, r.getString("post_sessionusrid"));
            ResultSet usersr = usersps.executeQuery();  
            usersr.next();
        	
            %>

     		<div class="card">
      			<img src="GetImage?id=<%=r.getString("post_sessionusrid")%>" height="60" width="60"/>
      			<h2><%= usersr.getString("name") + " " + usersr.getString("surname")%></h2> 
      			<h5><%= r.getString("post_time") %></h5>
      			
      		<%------------------------------ Display text/video/photo -------------------------------------------------------%>
      			 			
      		<% 
      		//If post_text is not null display text.
      		if( !r.getString("post_text").isEmpty())
      		{
                %>
          	    	<p><%= r.getString("post_text") %></p>    	          			
          		<% 
      		}					
      		%>
      		
      		<% 
      		//If post_photo is not null display photo.
      		if( !r.getString("post_photo").isEmpty())
      		{
                %>
                	<div style="width: 800x; height: 400px;">
          	    	<img src="GetPostImage?post_id=<%=r.getString("post_id")%>" width="100%" height="100%" /> 
          	    	</div>  	          			
          		<% 
      		}     					
      		%>
      		
      		<% 
      		//If post_video is not null display video.
      		if( !r.getString("post_video").isEmpty())
      		{
      			
      			String video = r.getString("post_video").replace("https://www.youtube.com/watch?v=", "https://www.youtube.com/embed/");
                %>
                	<div style="width: 800x; height: 400px;">
          	    	<iframe  width="100%" height="100%" src="<%=video%>"></iframe>  	
          	    	</div>           			
          		<% 
      		}					
      		%>
      		
      		<%------------------------------------Insert like and notification record-------------------------------------------------%>
      		
      		<form action="InsertLike" method="post" >
      			<input type="submit" id="buttonpostlike" name="insertlike" value="Μου αρέσει!">
      			<input type="hidden" name="btn_postid" value=<%=r.getString("post_id")%> >
      			<input type="hidden" name="btn_postusrid" value=<%=r.getString("post_sessionusrid")%> >
      		</form> 
      			
      			
      		<%-------------------------------------Select likes------------------------------------------------%>
      		
      		
      		<% 
      		
      		//Foreach post, select from likes table.
      		
      		PreparedStatement statement2 = null;
			statement2 = connection1.prepareStatement("select count(*) as counter from likes where like_postid = ? ");
			statement2.setString(1, r.getString("post_id"));    
        	ResultSet res = statement2.executeQuery();
        	res.next();      		
      		
      		%>
      			
      		<p>Αρέσει σε <b><%=res.getString("counter")%></b> άτομα.</p>
      			
      			
      		<%--------------------------------- Select comments ----------------------------------------------------%>
      		
      		<% 
      		
      		//Check if post has comments in order to display the comment region.
      		
      		PreparedStatement statement4 = null;
			statement4 = connection1.prepareStatement("select count(*) as counter from comments where comm_postid = ? ");
			statement4.setString(1, r.getString("post_id"));    
        	ResultSet res2 = statement4.executeQuery();
        	res2.next();
        	
        	if(!res2.getString("counter").equals("0"))
        	{
        		    		
          	%>
      				    		       		
        	<div id="resultforposts">
 		
      			<% 
      		
      				//Foreach post, select from comments table.
      		
      				PreparedStatement statement3 = null;
					statement3 = connection1.prepareStatement("select * from comments inner join users on users.id = comments.comm_sessionusrid where comm_postid = ? ");
					statement3.setString(1, r.getString("post_id"));    
        			ResultSet res1 = statement3.executeQuery();
        			while(res1.next())   
        			{
        		
          				%>
      						<div class="chats">
             				<strong><%= res1.getString("name") %></strong>  
							<div style="display: inline;"><%= res1.getString("comm_text") %></div>
							</div> 
							
						<% 
							
					}
        			
        		%>
        		      	                	     
            </div>
            
            <%
            
            }
            
        	%>
 		 		
 
            <%-------------------------------------------------------------------------------------------------------%>
            
      			<div ><img src="GetImage?id=<%=(String)session.getAttribute("user_id")%>" id="profpic" style="margin-top: 5px;" height="30" width="30"/></div>
	  			
	  		<%----------------------------------Insert comment and notification record -------------------------------------------------------%>
            
            
            <form action="InsertComment" method="post" >
            	<div ><textarea name="comment" rows="2" cols="50"style="width: 100% !important; margin-top: 5px;" placeholder="Γράψτε ένα σχόλιο..."></textarea></div>
      			<input type="submit" id="buttonpostcomm" name="insertcomm" value="Σχολιάστε">
      			<input type="hidden" name="btnc_postid" value=<%=r.getString("post_id")%> >
      			<input type="hidden" name="btn_postcomusrid" value=<%=r.getString("post_sessionusrid")%> >
      		</form> 
      		
      		<%-------------------------------------------------------------------------------------------------------%>
      		
	
    	</div>   
    	
        <% 
            
        }
        	
      %>

  </div>
  
  
  <div class="rightcolumn">
    <div class="card">      
      <div id="list8">
          <ul>
            <li ><a  href="network.jsp">Δίκτυο</a></li>
            <li><a  href="personaldetails.jsp">Προσωπικά Στοιχεία</a></li>    
          </ul>
     </div>   
    </div>
  </div>
  
</div>

<jsp:include page="footer.jsp"></jsp:include>

