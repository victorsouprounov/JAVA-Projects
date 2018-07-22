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


@WebServlet("/InsertComment")
public class InsertComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public InsertComment() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try
		{
			
			String sessionusrid = (String) request.getSession(false).getAttribute("user_id");
			String post_id = request.getParameter("btnc_postid");
			String comment = request.getParameter("comment");
			String post_usrid = request.getParameter("btn_postcomusrid");
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
							
			String sql = "insert into comments (comm_sessionusrid,comm_postid,comm_text) values(?,?,?) ";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, sessionusrid);
			ps.setString(2, post_id);
			ps.setString(3, comment);
			ps.executeUpdate();
			
			//Insert notification record.
			
			String sql1 = "insert into notifications (not_sessionusrid,not_postid,not_postusrid,not_comment,not_text,not_time) values(?,?,?,?,?,CURRENT_TIMESTAMP) ";
			PreparedStatement ps2 = conn.prepareStatement(sql1);
			ps2.setString(1, sessionusrid);
			ps2.setString(2, post_id);
			ps2.setString(3, post_usrid);
			ps2.setString(4, "1");
			ps2.setString(5, comment);
			ps2.executeUpdate();
			
			response.sendRedirect("home.jsp");
			
		} catch (ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}
