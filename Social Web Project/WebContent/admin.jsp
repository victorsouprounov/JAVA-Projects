<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="java.sql.*" %>

<jsp:include page="header.jsp"></jsp:include>



<script>
function GetValue(x)
{
 	document.getElementById("dummy").value = document.getElementById("userstbl").rows[x.rowIndex].cells[6].innerHTML;
 	document.getElementById("myForm").submit();
}
</script>

<div class = "container">

<form id="myForm" action="CreateXML" method="post" >

<h1 align="center">Χρήστες</h1>

<div id="table-wrapper">
  <div id="table-scroll">

  		<table id="userstbl">
  		
  		<TR>
        	<TH>Όνομα</TH>
            <TH>Επώνυμο</TH>
            <TH>E-mail</TH>
            <TH>Τηλέφωνο</TH>
            <TH>Προβολή</TH>
            <TH>Αρχείο XML</TH>
        </TR>
        
    	<%
    		
        Connection connection = null;
        Class.forName("com.mysql.jdbc.Driver");
        connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
        Statement statement = connection.createStatement();
        ResultSet r = statement.executeQuery("Select * from Users order by name");
        
        while(r.next())
        {
            %>

			<tr onClick="GetValue(this)">
                  <td> <%= r.getString("name") %> </td>
                  <td> <%= r.getString("surname") %> </td>
                  <td> <%= r.getString("email") %> </td>
                  <td> <%= r.getString("phone") %> </td>
                  <td><a href="./personaldetails.jsp?id=<%= r.getString("id") %>"><img src="./images/note.png" style="cursor: pointer;" height=30 width=30 ></img></a></td>
                  <td><a><img src="./images/xml.png"  style="cursor: pointer;" height=30 width=30 ></img></a></td>
                  <td style="display:none;"><%= r.getString("id") %> </td>
                  
             </tr>
             
            <% 

        }
    	%>
    	
		</table>
		
		<input type="hidden" id="dummy" name="demo" value=" " >
		
		</div>
	</div>
	</form>
		
		</div>
		
<jsp:include page="footer.jsp"></jsp:include>

