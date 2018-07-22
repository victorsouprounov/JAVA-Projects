<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<%@ page import="java.sql.*"%>

<jsp:include page="header.jsp"></jsp:include>

<div class="row">
  <div class="cardforsettings">

      <h1 align="center">Προσωπικά Στοιχεία</h1>
      
      <div align="center">
      
      <div>
      
      <%
      
      Connection connection1 = null;
      Class.forName("com.mysql.jdbc.Driver");
      connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
      
	  PreparedStatement usersps = null;
	  usersps = connection1.prepareStatement("select * from users where id = ?");
      
      if(request.getParameter("id") == null)
      {
    	  
    	  usersps.setString(1, (String)session.getAttribute("user_id"));
          ResultSet usersr = usersps.executeQuery();  
          usersr.next();
       
      	%>     
       
       		<img src="GetImage?id=<%=(String)session.getAttribute("user_id")%>" width="115" border="0">
       		
       		<div>
      			<h3><%= usersr.getString("name") + " " + usersr.getString("surname")%></h3>
      		</div>
      
      		<div>
      			<h3><%= usersr.getString("email")%></h3>
      		</div> 
       
  		<%   
       
       
      }
      else
      {
    	  
    	  usersps.setString(1, request.getParameter("id"));
          ResultSet usersr = usersps.executeQuery();  
          usersr.next();
          
       	%>     
        
        	<img src="GetImage?id=<%=request.getParameter("id")%>" width="115" border="0">
        	
        	<div>
      			<h3><%= usersr.getString("name") + " " + usersr.getString("surname")%></h3>
      		</div>
      
      		<div>
      			<h3><%= usersr.getString("email")%></h3>
      		</div> 
        
   		<%  
       
      }
      
      
      
      
      
      
      //Request button
      
      if(request.getParameter("id") != null)
      {
      
      	%>
            
        <%-- Check if they are already connected --%>
       
        <% 
          
        String session_usrid = (String)session.getAttribute("user_id");
        String picked_usrid = request.getParameter("id");
       	PreparedStatement statement1 = null;
        
	   	statement1 = connection1.prepareStatement("Select * from connections where (sessionusrid= ? and pickedusrid= ?) or (pickedusrid= ? and sessionusrid= ?)");
	    statement1.setString(1,session_usrid);
	    statement1.setString(2,picked_usrid);
	    statement1.setString(3,picked_usrid);
	    statement1.setString(4,session_usrid);
           
        ResultSet r = statement1.executeQuery();                    
             
          if (r.next()) 
          { 
          
          %>     
             
             <%-- Don't show the button --%>
             
   		 <% 
   		 
   		  } 
          else 
          {
   		  
   		  %>
   
          <form action="Request?sid=<%=session.getAttribute("user_id")%>&pid=<%=request.getParameter("id")%>" method="post" id="my_form" name="my_form">
      		<div id="form-container">
          		<div class="sendreq">
           			<input type="submit" style="cursor: pointer;" value="Αίτημα Σύνδεσης" id="btn" name="btn"/>
          		</div>
      		</div>
     	</form>
                
   		  <% 
   		
          } 
          
        }
          
         %>       
     
     </div>   
           
      <form action="UpdatePersonalData" method=post style="border-width:5px;border-style:ridge; width:80%; " >
       
       
      <%
      
     
  		PreparedStatement statement2 = null;  
    	statement2 = connection1.prepareStatement("Select * from personaldata where per_sessionusrid = ?");
  		  		
      if(request.getParameter("id") == null)
      {
    	  
      	statement2.setString(1, (String)session.getAttribute("user_id"));
    	ResultSet sper = statement2.executeQuery();
    	if(sper.next())
    	{
    		
    		// --------------------------------- Data 1 ------------------------------------------------
    		
          	%>   
            
  		  <h3>Επαγγελματική Εμπειρία</h3>
  		        
  		       
  		  	 <textarea rows="4" cols="50" name="experience"><%= sper.getString("data1")%></textarea>
  		  	 
  		   <% 
  		   
  		   if(sper.getString("flag1").equals("public"))
  		   {
  			   
  			 %> 
  			 
  			 <div>		  	 
  		     	<input type="radio" name="experienceprivacy" id="experiencechoice" value="public" checked="checked"> Δημόσιο<br>
  		     	<input type="radio" name="experienceprivacy" id="experiencechoice" value="private"> Ιδιωτικό<br>
  		     </div>		
  		     
  		     <%	   
  			   
  		   }
  		   else
  		   {
  			   
    		 %> 
      			 
      		<div>		  	 
      		     <input type="radio" name="experienceprivacy" id="experiencechoice" value="public"> Δημόσιο<br>
      		     <input type="radio" name="experienceprivacy" id="experiencechoice" value="private" checked="checked"> Ιδιωτικό<br>
      		</div>		
      		     
      		 <%	  
  			   
  		   }
  		   
  		  // --------------------------------- Data 2 ------------------------------------------------

  		  %> 		  
  		  
  		  <h3>Εκπαίδευση</h3>
  		  
  		  			
  		  <textarea rows="4" cols="50" name="studies"><%= sper.getString("data2")%></textarea>
  		  
  		  <%
  		  
  		   if(sper.getString("flag2").equals("public"))
  		   {
  			   
  			 %> 
  			 
  			 <div>		  	 
  		     	<input type="radio" name="studiesprivacy" id="studieschoice" value="public" checked="checked"> Δημόσιο<br>
  		     	<input type="radio" name="studiesprivacy" id="studieschoice" value="private"> Ιδιωτικό<br>
  		     </div>		
  		     
  		     <%	   
  			   
  		   }
  		   else
  		   {
  			   
    		 %> 
      			 
      		<div>		  	 
      		     <input type="radio" name="studiesprivacy" id="studieschoice" value="public"> Δημόσιο<br>
      		     <input type="radio" name="studiesprivacy" id="studieschoice" value="private" checked="checked"> Ιδιωτικό<br>
      		</div>		
      		     
      		 <%	  
  			   
  		   }
  		  
  		  // --------------------------------- Data 3 ------------------------------------------------
  		  
  		  %>	 
  		      	       
  		  <h3>Δεξιότητες</h3>
  		  

  		   <textarea rows="4" cols="50" name="skills"><%= sper.getString("data3")%></textarea>
	  	 
  		   <%
  		  
  		   if(sper.getString("flag3").equals("public"))
  		   {
  			   
  			 %> 
  			 
  			 <div>		  	 
  		     	<input type="radio" name="skillsprivacy" id="skillschoice" value="public" checked="checked"> Δημόσιο<br>
  		     	<input type="radio" name="skillsprivacy" id="skillschoice" value="private"> Ιδιωτικό<br>
  		     </div>		
  		     
  		     <%	   
  			   
  		   }
  		   else
  		   {
  			   
    		 %> 
      			 
      		<div>		  	 
      		     <input type="radio" name="skillsprivacy" id="skillschoice" value="public"> Δημόσιο<br>
      		     <input type="radio" name="skillsprivacy" id="skillschoice" value="private" checked="checked"> Ιδιωτικό<br>
      		</div>		
      		     
      		 <%	  
  			   
  		   } 		 	
    		
    	} 
    	else //////////////////////////////////////////////////////////////////////////////////////////////////////////
    	{
    		
    		
          	%>   
            
  		  <h3>Επαγγελματική Εμπειρία</h3>
  		        
  		       
  		  <textarea rows="4" cols="50" name="experience"></textarea>
  		  
  		    			 
  			 <div>		  	 
  		     	<input type="radio" name="experienceprivacy" id="experiencechoice" value="public" > Δημόσιο<br>
  		     	<input type="radio" name="experienceprivacy" id="experiencechoice" value="private"> Ιδιωτικό<br>
  		     </div>	
  		  	 	  
  		  
  		  <h3>Εκπαίδευση</h3>
  		  
  		  			
  		  <textarea rows="4" cols="50" name="studies"></textarea>
  		  
  		    <div>		  	 
  		     	<input type="radio" name="studiesprivacy" id="studieschoice" value="public" > Δημόσιο<br>
  		     	<input type="radio" name="studiesprivacy" id="studieschoice" value="private"> Ιδιωτικό<br>
  		    </div>		
  		 	 
  		      	       
  		  <h3>Δεξιότητες</h3>
  		  

  		   <textarea rows="4" cols="50" name="skills"></textarea>
  		   
  		   <div>		  	 
  		     	<input type="radio" name="skillsprivacy" id="skillschoice" value="public" > Δημόσιο<br>
  		     	<input type="radio" name="skillsprivacy" id="skillschoice" value="private"> Ιδιωτικό<br>
  		    </div>
	  	 
		   <% 
		   
  		   } 	
              
      }      
      else if(request.getParameter("id") != null)
      {
    	  
        	statement2.setString(1, request.getParameter("id"));
        	ResultSet sper = statement2.executeQuery();
        	if(sper.next())
        	{
        		
   				 %>			 
			 	<h3>Επαγγελματική Εμπειρία</h3>	 
   			 	<% 
        		if(sper.getString("flag1").equals("public"))
        		{
        			 %>
        			 
        			 	<p><%= sper.getString("data1")%></p>
        			 	
        			 <%  
        		}
        		else
        		{
       			 	%>
    			 
 			 			<p>This information is private.</p>
 			 	
 			 		<%   			
        		}
        		
        		
  				 %>			 
			 	<h3>Εκπαίδευση</h3>
  			 	<%
        		if(sper.getString("flag2").equals("public"))
        		{
        			 %>
        			 
        			 	<p><%= sper.getString("data2")%></p>
        			 	
        			 <%  
        		}
        		else
        		{
       			 	%>
    			 
 			 			<p>This information is private.</p>
 			 	
 			 		<%   			
        		}
        		
        		
  				 %>			 
			 	<h3>Δεξιότητες</h3> 
  			 	<%
        		if(sper.getString("flag3").equals("public"))
        		{
        			 %>
        			 
        			 	<p><%= sper.getString("data3")%></p>
        			 	<div>
     		  			</div>
        			 	
        			 <%  
        		}
        		else
        		{
       			 	%>
    			 
 			 			<p>This information is private.</p>
 			 			<div>
     		  			</div>
 			 	
 			 		<% 
 			 		
        		}
  			 	
        	}
        	else
        	{
        		
  				%>			 
					<h3>Επαγγελματική Εμπειρία</h3>	
					<p>This user has no info.</p> 
	 
			 		<h3>Εκπαίδευση</h3>
			 		<p>This user has no info.</p> 
			 		
			 		<h3>Δεξιότητες</h3>
			 		<p>This user has no info.</p>
			 		
 			 	<%     		
        	}
        	
      }
      
      if(request.getParameter("id") == null)
      {
    	  

     	 %>
      
      		<button class="profbutton" type="submit" name="submit">Αποθήκευση Αλλαγών</button>
      
      	<% 
      
       }
       
      %>
            
  		</form>
       
    </div>
  </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>