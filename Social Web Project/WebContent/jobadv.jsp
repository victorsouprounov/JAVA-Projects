<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    <%@ page import="java.sql.*" %>

<jsp:include page="header.jsp"></jsp:include>

<div class="containerjob">


<div class="row">

	<div class="leftcolumnjob">
	
	<%---------------------------------------  Get all job advertisements based on kNN Algorithm ----------------------------------------------%>
    
    <%--  Functionality: This algorithm has 2 levels. --%>
    <%--  Every job advertisement will have points based on conditions. --%>
    <%--  Job advertisements in 1st level,are those who are created from current user(sessionID) so they will get 1000 points. --%>
    <%--  Job advertisements in 2nd level,are those who match the most words and they get 0 points. --%>
    <%--  In 2nd level, job advertisements can get p + x points where p=0 base points and x is the number of word matching. --%>
    <%--  When all job advertisements have points,get the k posts with maximum points ( Assuming that we are at 0 point, the distance is calculated) --%>
	
		<%
	
    	// Connection string
 		Connection connection1 = null;
 		Class.forName("com.mysql.jdbc.Driver");
 		connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
 	
        //1. Get the job advertisements
        Statement stmt = connection1.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
        ResultSet rpre = stmt.executeQuery("select * FROM jobadv");
        
        String sessionusrID = (String)session.getAttribute("user_id");
        
        while(rpre.next())
        {
        	
        	//2. Level 1 validation
        	//Go to the job advertisements table.If job_sessionusrid == current userID(session) ,then 1000 points.
			if (rpre.getString("job_sessionusrid").equals(sessionusrID))
			{
				rpre.updateInt("job_points", 1000);
				rpre.updateRow();
				
			}
			else
			{
				//3. Level 2 validation
				//Go to personaldata table and select the row where per_sessionusrid == current userID(session).
				//Count how many words from job advertisement matches with fields data1,data2 and data3.
				//Store points.
				
		  		PreparedStatement statement2 = null;  
		    	statement2 = connection1.prepareStatement("Select * from personaldata where per_sessionusrid = ?");
		      	statement2.setString(1, sessionusrID);
		    	ResultSet sper = statement2.executeQuery();
		    	if(sper.next())
		    	{
		    		
		    		String job_text = rpre.getString("job_text");
		    		String[] jobtextwords = job_text.split(" ");
		    		
		    		int data1counter = 0;
		    		int data2counter = 0;
		    		int data3counter = 0;
		    		
		    		String data1 = sper.getString("data1");
		    		String data2 = sper.getString("data2");
		    		String data3 = sper.getString("data3");
		    		
		    		String[] data1words = data1.split(" ");
		    		String[] data2words = data2.split(" ");
		    		String[] data3words = data3.split(" ");
		    		
		    		//Count matches in data1.
		    		for(int i = 0; i < jobtextwords.length; i++)
		    		{		    			
			    		for(int j = 0; j < data1words.length; j++)
			    		{	    			
				   			if(data1words[j].equals(jobtextwords[i]))
				    		{
				   				data1counter++;				    			
				    		}		    			
			    		}		    					
		    		}
		    		
		    		//Count matches in data2.
		    		for(int i = 0; i < jobtextwords.length; i++)
		    		{		    			
			    		for(int j = 0; j < data2words.length; j++)
			    		{	    			
				   			if(data2words[j].equals(jobtextwords[i]))
				    		{
				   				data2counter++;				    			
				    		}		    			
			    		}		    					
		    		}
		    		
		    		//Count matches in data3.
		    		for(int i = 0; i < jobtextwords.length; i++)
		    		{		    			
			    		for(int j = 0; j < data3words.length; j++)
			    		{	    			
				   			if(data3words[j].equals(jobtextwords[i]))
				    		{
				   				data3counter++;				    			
				    		}		    			
			    		}		    					
		    		}
		    		
    				rpre.updateInt("job_points", data1counter + data2counter + data3counter);
    				rpre.updateRow();	
		    		
		    	}				
			}    	
        }
        
     	// DEFINE K HERE : 20
		PreparedStatement porigin = null;
		porigin = connection1.prepareStatement("select * from jobadv order by job_points desc,job_time desc limit 20");    
		ResultSet r = porigin.executeQuery(); 
	
    	while(r.next())
    	{
    		
    		PreparedStatement usersps = null;
    		usersps = connection1.prepareStatement("select * from users where id = ?");    
    		usersps.setString(1, r.getString("job_sessionusrid"));
            ResultSet usersr = usersps.executeQuery();  
            usersr.next();
    		
   		 %>
   		 
   		 <div class="card">
   		       	<img src="GetImage?id=<%=r.getString("job_sessionusrid")%>" height="60" width="60"/>
      			<h2><%= usersr.getString("name") + " " + usersr.getString("surname")%></h2> 
      			<h5><%= r.getString("job_time") %></h5>
      			
      			<p><%= r.getString("job_text") %></p> 
      			
      			<%
      			
      			if(!r.getString("job_sessionusrid").equals((String)session.getAttribute("user_id")))
      			{
      				
      				%>
      				
      				<form action="InsertRequest" method="post" >
      					<input type="submit" id="buttonpostjob" name="insertrequest" value="Αίτηση!">
      					<input type="hidden" name="btn_jobid" value=<%=r.getString("job_id")%> >
      					<input type="hidden" name="btn_jobusrid" value=<%=r.getString("job_sessionusrid")%> >
      				</form> 
      				
      				<%   				
      			}
      			
      			%>
		</div>
		 		  		 
   		 <% 				  			
    	}	
    	 %>
    	 
	</div>
	
		
	<div class="rightcolumnjob">
		<div class="card">	
		    <form action="InsertJobAdv" method="post">
      			<h3>Αναρτήστε μια αγγελία!</h3>
      			<textarea rows="6" cols="50" name="text" placeholder="Περιγράψτε αναλυτικά τι ακριβώς ψάχνετε..." style="width: 100% !important; font-size: 16px;"></textarea>
	  			<input type="submit" id="buttonpost" name="insertjob" value="Δημοσίευση">
	  		</form>
		</div>
		
		<div class="card">
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
		statement2 = connection2.prepareStatement("select * from requests inner join users on users.id = requests.req_sessionusrid inner join jobadv on jobadv.job_id = req_jobid  where req_usrid = ? order by req_time asc");
		statement2.setString(1,session_usrid1);
       
        ResultSet r1 = statement2.executeQuery();
  	  	       
        while(r1.next())
        {    
        	
        			%>
        			<tbody>
        			<tr>                  
                          <td><a><img src="./images/request.png" height=30 width=30></img></a></td>                          
                          <td> Ο χρήστης <b><%= r1.getString("name") + " " + r1.getString("surname")%></b> έκανε αίτηση στην αγγελία σας <i><%= r1.getString("job_text")%></i></td>
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
</div>


<jsp:include page="footer.jsp"></jsp:include>
