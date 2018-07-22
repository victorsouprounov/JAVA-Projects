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


@WebServlet("/InsertLike")
public class InsertLike extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public InsertLike() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try
		{
			
			String sessionusrid = (String) request.getSession(false).getAttribute("user_id");
			String post_id = request.getParameter("btn_postid");
			String post_usrid = request.getParameter("btn_postusrid");
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			
			//Step 1: Check if  exists in likes table.
			
			String checksql = "select count(*) as counter from likes where like_sessionusrid = ? and like_postid= ? ";
			PreparedStatement ps1 = conn.prepareStatement(checksql);
			ps1.setString(1, sessionusrid);
			ps1.setString(2, post_id);
			ResultSet r = ps1.executeQuery();
			r.next();
			
			if (r.getString("counter").equals("0") )
			{
				
				//Step 2: If counter == 0 , insert.
				
				String sql = "insert into likes (like_sessionusrid,like_postid) values(?,?) ";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, sessionusrid);
				ps.setString(2, post_id);
				ps.executeUpdate();
				
				//Step 3: Insert notification record.
				
				String sql1 = "insert into notifications (not_sessionusrid,not_postid,not_postusrid,not_like,not_time) values(?,?,?,?,CURRENT_TIMESTAMP) ";
				PreparedStatement ps2 = conn.prepareStatement(sql1);
				ps2.setString(1, sessionusrid);
				ps2.setString(2, post_id);
				ps2.setString(3, post_usrid);
				ps2.setString(4, "1");
				ps2.executeUpdate();
				
			}

			response.sendRedirect("home.jsp");
			
		} catch (ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}
