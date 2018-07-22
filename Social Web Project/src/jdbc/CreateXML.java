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

import java.io.File;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;


@WebServlet("/CreateXML")
public class CreateXML extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public CreateXML() {
        super();

    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			
			String usrid = request.getParameter("demo");					

			DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

			Document doc = docBuilder.newDocument();
			Element rootElement = doc.createElement("Linked");
			doc.appendChild(rootElement);
			
	        // Connection string
	     	Connection connection1 = null;
	     	Class.forName("com.mysql.jdbc.Driver");
	     	connection1 = DriverManager.getConnection("jdbc:mysql://localhost:3306/portal", "root", "");

			
			// -------------------------- USERS TABLE --------------------------------- //
			
    		PreparedStatement ps = null;
    		ps = connection1.prepareStatement("select * from users where id = ?");    
    		ps.setString(1, usrid);
            ResultSet r = ps.executeQuery();  
            r.next();

			// User element
			
			Element user = doc.createElement("User");
			rootElement.appendChild(user);

			// User properties
			
			Element id = doc.createElement("ID");
			id.appendChild(doc.createTextNode(r.getString("id")));
			user.appendChild(id);
			
			Element name = doc.createElement("Name");
			name.appendChild(doc.createTextNode(r.getString("name")));
			user.appendChild(name);
			
			Element surname = doc.createElement("Surname");
			surname.appendChild(doc.createTextNode(r.getString("surname")));
			user.appendChild(surname);
			
			Element email = doc.createElement("Email");
			email.appendChild(doc.createTextNode(r.getString("email")));
			user.appendChild(email);
			
			Element phone = doc.createElement("Phone");
			phone.appendChild(doc.createTextNode(r.getString("phone")));
			user.appendChild(phone);
			
			Element password = doc.createElement("Password");
			password.appendChild(doc.createTextNode(r.getString("password")));
			user.appendChild(password);
			
			// -------------------------- CONNECTIONS TABLE --------------------------------- //
			
	 		PreparedStatement ps1 = null;
			ps1 = connection1.prepareStatement("select * FROM connections where status = 'accepted' and (pickedusrid = ? or sessionusrid = ?)");
			ps1.setString(1,usrid);
			ps1.setString(2,usrid);
			ResultSet r1 = ps1.executeQuery(); 
			
			Element GlobalFriend = doc.createElement("Friends");
			rootElement.appendChild(GlobalFriend);
			
			int i = 1;
			while(r1.next())			
			{
				//Friend element
				
				Element friend = doc.createElement("Friend");
				GlobalFriend.appendChild(friend);				
				friend.setAttribute("no", String.valueOf(i));

				// Friend properties
				
				Element fid = doc.createElement("ID");
				fid.appendChild(doc.createTextNode(r1.getString("recid")));
				friend.appendChild(fid);
				
        		PreparedStatement ps2 = null;
        		ResultSet r2 = null;
        		ps2 = connection1.prepareStatement("select * FROM users where id = ? ");
        		ps2.setString(1,r1.getString("pickedusrid"));
        		r2 = ps2.executeQuery();
        		r2.next();
				
				Element ffid = doc.createElement("ID");
				ffid.appendChild(doc.createTextNode(r2.getString("id")));
				friend.appendChild(ffid);
        		
				Element fname = doc.createElement("Name");
				fname.appendChild(doc.createTextNode(r2.getString("name")));
				friend.appendChild(fname);
				
				Element fsurname = doc.createElement("Surname");
				fsurname.appendChild(doc.createTextNode(r2.getString("surname")));
				friend.appendChild(fsurname);
				
				Element femail = doc.createElement("Email");
				femail.appendChild(doc.createTextNode(r2.getString("email")));
				friend.appendChild(femail);
				
				Element fphone = doc.createElement("Phone");
				fphone.appendChild(doc.createTextNode(r2.getString("phone")));
				friend.appendChild(fphone);
				
				Element fpassword = doc.createElement("Password");
				fpassword.appendChild(doc.createTextNode(r2.getString("password")));
				friend.appendChild(fpassword);	
				
				i++;
				
			}
			
			// -------------------------- POSTS TABLE --------------------------------- //
			
	 		PreparedStatement ps3 = null;
			ps3 = connection1.prepareStatement("select * from posts where post_sessionusrid = ?");
			ps3.setString(1,usrid);
			ResultSet r3 = ps3.executeQuery(); 
			
			Element GlobalPost = doc.createElement("Posts");
			rootElement.appendChild(GlobalPost);

			int j = 1;
			while(r3.next())			
			{
				//Post element
				
				Element post = doc.createElement("Post");
				GlobalPost.appendChild(post);				
				post.setAttribute("no", String.valueOf(j));

				// Post properties
				
				Element pid = doc.createElement("PostID");
				pid.appendChild(doc.createTextNode(r3.getString("post_id")));
				post.appendChild(pid);
				
				Element ptext = doc.createElement("PostText");
				ptext.appendChild(doc.createTextNode(r3.getString("post_text")));
				post.appendChild(ptext);
				
				Element ptime = doc.createElement("PostTime");
				ptime.appendChild(doc.createTextNode(r3.getString("post_time")));
				post.appendChild(ptime);
				
				
				j++;
				
			}
			
			// -------------------------- NOTIFICATIONS TABLE --------------------------------- //
			
			
	 			PreparedStatement ps4 = null;
	 			ps4 = connection1.prepareStatement("select * from notifications where not_sessionusrid = ? and not_like = 1");
	 			ps4.setString(1,usrid);
	 			ResultSet r4 = ps4.executeQuery(); 
	 			
				Element GlobalLike = doc.createElement("Likes");
				rootElement.appendChild(GlobalLike);
	 			
	 			int likecounter = 1;
	 			while(r4.next())
	 			{
	 				
 					//Like element
 					
 					Element like = doc.createElement("Like");
 					GlobalLike.appendChild(like);				
 					like.setAttribute("no", String.valueOf(likecounter));

 					// Like properties
 					
 					Element lid = doc.createElement("LikeID");
 					lid.appendChild(doc.createTextNode(r4.getString("not_id")));
 					like.appendChild(lid);
 					
 					Element lpostid = doc.createElement("PostID");
 					lpostid.appendChild(doc.createTextNode(r4.getString("not_postid")));
 					like.appendChild(lpostid);
 										
 					likecounter++;
	 			}
	 			
	 			
	 			PreparedStatement ps5 = null;
	 			ps5 = connection1.prepareStatement("select * from notifications where not_sessionusrid = ? and not_comment = 1");
	 			ps5.setString(1,usrid);
	 			ResultSet r5 = ps5.executeQuery(); 
	 			
				Element GlobalComment = doc.createElement("Comments");
				rootElement.appendChild(GlobalComment);
	 			int commcounter = 1;

	 			while(r5.next())
	 			{

	 				//Comment element
	 					
	 				Element comm = doc.createElement("Comment");
	 				GlobalComment.appendChild(comm);				
	 				comm.setAttribute("no", String.valueOf(commcounter));

	 				// Comment properties
	 					
	 				Element cid = doc.createElement("CommentID");
	 				cid.appendChild(doc.createTextNode(r5.getString("not_id")));
	 				comm.appendChild(cid);
	 					
	 				Element ctext = doc.createElement("CommentText");
	 				ctext.appendChild(doc.createTextNode(r5.getString("not_text")));
	 				comm.appendChild(ctext);
	 					
	 				Element cpostid = doc.createElement("PostID");
	 				cpostid.appendChild(doc.createTextNode(r5.getString("not_postid")));
	 				comm.appendChild(cpostid);
	 						 						 					
	 				commcounter++;
	 			}
	 							
			// --------------------------------------------------------------------------- //


			TransformerFactory transformerFactory = TransformerFactory.newInstance();
			Transformer transformer = transformerFactory.newTransformer();
			DOMSource source = new DOMSource(doc);
				
			StreamResult result = new StreamResult(new File("C:\\file.xml"));

			transformer.transform(source, result);
			response.sendRedirect("admin.jsp");

		  } catch (ParserConfigurationException pce) {
			pce.printStackTrace();
		  } catch (TransformerException tfe) {
			tfe.printStackTrace();
		  } catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

}
