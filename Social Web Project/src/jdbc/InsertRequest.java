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

@WebServlet("/InsertRequest")
public class InsertRequest extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public InsertRequest() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try
		{
			
			String sessionusrid = (String) request.getSession(false).getAttribute("user_id");
			String job_id = request.getParameter("btn_jobid");
			String job_usrid = request.getParameter("btn_jobusrid");
			
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");
			
			//Step 1: Check if  exists in requests table.
			
			String checksql = "select count(*) as counter from requests where req_sessionusrid = ? and req_jobid= ? ";
			PreparedStatement ps1 = conn.prepareStatement(checksql);
			ps1.setString(1, sessionusrid);
			ps1.setString(2, job_id);
			ResultSet r = ps1.executeQuery();
			r.next();
			
			if (r.getString("counter").equals("0") )
			{
				
				//Step 2: If counter == 0 , insert.
				
				String sql = "insert into requests (req_sessionusrid,req_jobid,req_usrid) values(?,?,?) ";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, sessionusrid);
				ps.setString(2, job_id);
				ps.setString(3, job_usrid);
				ps.executeUpdate();				
				
			}

			response.sendRedirect("jobadv.jsp");
			
		} catch (ClassNotFoundException e){
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}
