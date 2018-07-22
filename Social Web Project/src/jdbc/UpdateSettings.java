package jdbc;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/UpdateSettings")
public class UpdateSettings extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public UpdateSettings() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		
		try {
			
		String nemail = request.getParameter("newemail");
		String npassword = request.getParameter("newpassword");			
		String nid = (String) request.getSession(false).getAttribute("user_id");

    	
       	Connection connection1 = null;
       	Class.forName("com.mysql.jdbc.Driver");
       	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
	    	
	     	PreparedStatement statement = null;
	 		statement = connection1.prepareStatement("update users set password = ? , email = ? where id= ?" );
	 		statement.setString(1,npassword); 
	 		statement.setString(2,nemail); 
	 		statement.setString(3,nid); 
	        statement.executeUpdate();	
	        response.sendRedirect("settings.jsp");
		}	
		catch (ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
	}

}
