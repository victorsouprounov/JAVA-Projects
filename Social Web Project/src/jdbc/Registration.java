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

@WebServlet("/Registration")
public class Registration extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public Registration() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			try
			{
				
				String name = request.getParameter("name");
				String surname = request.getParameter("surname");
				String email = request.getParameter("email");
				String phone = request.getParameter("phone");
				String password = request.getParameter("password");
				String confpassword = request.getParameter("confpassword");
				
				Part filePart = request.getPart("photo");
				InputStream inputStream = null;
				if (filePart != null)
				{
					inputStream = filePart.getInputStream();
				}

				
				String sql = "Insert into Users(name,password,surname,email,phone,confpassword,photo) values (?,?,?,?,?,?,?)";
				Class.forName("com.mysql.jdbc.Driver");
				Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, name);
				ps.setString(2, password);
				ps.setString(3, surname);
				ps.setString(4, email);
				ps.setString(5, phone);
				ps.setString(6, confpassword);
				ps.setBlob(7, inputStream);
				ps.executeUpdate();
				
				response.sendRedirect("welcome.jsp");
	
				
			} catch (ClassNotFoundException e){
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

}
