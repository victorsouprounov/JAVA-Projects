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


@WebServlet("/InsertJobAdv")
public class InsertJobAdv extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public InsertJobAdv() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try
		{
			
			String sessionusrid = (String) request.getSession(false).getAttribute("user_id");
			String text = request.getParameter("text");
			
			String sql = "insert into jobadv (job_sessionusrid,job_text,job_time) values(?,?,CURRENT_TIMESTAMP)";
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, sessionusrid);
			ps.setString(2, text);
			ps.executeUpdate();
			response.sendRedirect("jobadv.jsp");
			
		} catch (ClassNotFoundException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
