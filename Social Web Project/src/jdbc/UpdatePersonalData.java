package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/UpdatePersonalData")
public class UpdatePersonalData extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public UpdatePersonalData() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		
		try {
			   
			  String exp = request.getParameter("experience");
			  String exppriv = request.getParameter("experienceprivacy");
			  String stud = request.getParameter("studies");
			  String studpriv = request.getParameter("studiesprivacy");
			  String ski = request.getParameter("skills");
			  String skipriv = request.getParameter("skillsprivacy");
			  String nid = (String) request.getSession(false).getAttribute("user_id");
			  
			     
			  Class.forName("com.mysql.jdbc.Driver");
			  Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			
			  
			  //Step 1: Check if  exists in likes table.
			  String checksql = "select count(*) as counter from personaldata where per_sessionusrid = ?";
			  PreparedStatement ps1 = conn.prepareStatement(checksql);
			  ps1.setString(1, nid);
			  ResultSet r = ps1.executeQuery();
			  r.next();
			  
			  if (r.getString("counter").equals("0") )
			  {
				  //Insert 
				  String sql = "Insert into personaldata(per_sessionusrid,data1,flag1,data2,flag2,data3,flag3) values (?,?,?,?,?,?,?)";
				  PreparedStatement ps = conn.prepareStatement(sql);
				  ps.setString(1,nid); 
				  ps.setString(2,exp); 
				  ps.setString(3,exppriv); 
				  ps.setString(4,stud); 
				  ps.setString(5,studpriv); 
				  ps.setString(6,ski); 
				  ps.setString(7,skipriv); 
				  ps.executeUpdate(); 
				  
			  }
			  else
			  {
				  //Update
				  String sql = "Update personaldata set data1=? ,flag1=? ,data2=? ,flag2=? ,data3=? ,flag3=? where per_sessionusrid=?";
				  PreparedStatement ps = conn.prepareStatement(sql);			   
				  ps.setString(1,exp); 
				  ps.setString(2,exppriv); 
				  ps.setString(3,stud); 
				  ps.setString(4,studpriv); 
				  ps.setString(5,ski); 
				  ps.setString(6,skipriv); 
				  ps.setString(7,nid);
				  ps.executeUpdate(); 
				  	  
			  }

			    response.sendRedirect("personaldetails.jsp");
			    
			  } 
			  catch (ClassNotFoundException e){
			   e.printStackTrace();
			  } catch (SQLException e) {
			   e.printStackTrace();
			  }
		
	}

}
