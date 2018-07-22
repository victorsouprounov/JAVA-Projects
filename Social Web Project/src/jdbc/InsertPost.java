package jdbc;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@MultipartConfig(maxFileSize = 1699999999)

@WebServlet("/InsertPost")
public class InsertPost extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public InsertPost() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try
		{
			
			String sessionusrid = (String) request.getSession(false).getAttribute("user_id");
			String text = request.getParameter("text");
			String video = request.getParameter("video");
		
			Part filePart = request.getPart("photo");
			InputStream inputStream = null;
			if (filePart != null)
			{
				inputStream = filePart.getInputStream();
			}
			
			String sql = "insert into posts (post_sessionusrid,post_text,post_photo,post_video,post_time) values(?,?,?,?,CURRENT_TIMESTAMP)";
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, sessionusrid);
			ps.setString(2, text);
			ps.setBlob(3, inputStream);
			ps.setString(4, video);
			ps.executeUpdate();
			response.sendRedirect("home.jsp");
			
		} catch (ClassNotFoundException e){
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}
