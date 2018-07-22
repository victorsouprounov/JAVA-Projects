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

@WebServlet("/MessagesImport")
public class MessagesImport extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public MessagesImport() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			
			String comment = request.getParameter("user_comm");
			String sessionusrid = request.getParameter("sessionID");
			String pickedusrid = request.getParameter("pickedID");
			
			String sql = "insert into messages (sessionusrid,pickedusrid,message,post_time) values(?,?,?,CURRENT_TIMESTAMP)";
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, sessionusrid);
			ps.setString(2, pickedusrid);
			ps.setString(3, comment);
			ps.executeUpdate();
			
		} catch (ClassNotFoundException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
	}

}
