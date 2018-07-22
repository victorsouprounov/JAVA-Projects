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
import javax.servlet.http.HttpSession;


@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public Login() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			
			String email = request.getParameter("email");
			String password = request.getParameter("password");
			String dbName = null;
			String dbPassword = null;
			String user_id = null;
			String user_name = null;		
			String sql = "	Select * from Users where email=? and password=?";
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, password);
			ResultSet rs = ps.executeQuery();
			while(rs.next())
			{
				dbName = rs.getString("email");
				dbPassword = rs.getString("password");
				user_id = rs.getString("id");
				user_name = rs.getString("name");
			}
			
			if(email.equals(dbName) && password.equals(dbPassword))
			{
				
				HttpSession session=request.getSession();  
				session.setAttribute("user_id",user_id); 
				session.setAttribute("user_name",user_name);
				
				if(user_id.equals("4"))
				{
					response.sendRedirect("admin.jsp");
				}
				else
				{
					response.sendRedirect("home.jsp");
				}
				
			}
			else
			{
				response.sendRedirect("welcome.jsp");
			}
				
			
		} catch (ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

}
