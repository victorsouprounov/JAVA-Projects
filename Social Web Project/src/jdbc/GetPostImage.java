package jdbc;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/GetPostImage")
public class GetPostImage extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public GetPostImage() {
        super();
        // TODO Auto-generated constructor stub
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try
		{
			
			String post_id = request.getParameter("post_id");
			Blob photo = null;
			ServletOutputStream out = response.getOutputStream();
			
			String sql = "	Select * from posts where post_id=?";
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, post_id);
			ResultSet rs = ps.executeQuery();
			if(rs.next())
			{
				photo = rs.getBlob("post_photo");
				
			}
				response.setContentType("image/gif");
				
			    InputStream in = photo.getBinaryStream();
			    int length = (int) photo.length();

			    int bufferSize = 1024;
			    byte[] buffer = new byte[bufferSize];

			    while ((length = in.read(buffer)) != -1)
			    {
			        out.write(buffer, 0, length);
			    }
			
				
			
		} catch (ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

}
