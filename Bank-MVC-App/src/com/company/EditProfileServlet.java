package com.company;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/editProfileServlet")
public class EditProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		
		String newFirstName = request.getParameter("firstname");
		String newLastName = request.getParameter("lastname");
		String newPassword = request.getParameter("password");
		
		HttpSession session = request.getSession(false);
	    if (session == null || session.getAttribute("customerusername") == null) {
	        pw.println("Session expired. Please log in again.");
	        return;
	    }
	    String username = (String) session.getAttribute("customerusername");
	    
	    Connection conn = null;
	    try
	    {
	    	conn = DBConnection.getConnection();
	    	PreparedStatement ps = conn.prepareStatement("UPDATE customer SET first_name = ?, last_name = ?, password = ? WHERE user_name = ?");
	    	ps.setString(1, newFirstName);
	    	ps.setString(2, newLastName);
	    	ps.setString(3, newPassword);
	    	ps.setString(4, username);
	    	
	    	int count = ps.executeUpdate();
	    	if(count>0)
	    	{
	    		pw.println("<h3 style='color:green;'>Profile Update Successful!</h3>");
				pw.println("<br><a href='CustomerPage.jsp'>Go back</a>");
	    	}else
	    	{
	    		pw.println("<h3 style='color:red;'>Profile not update Please try again.</h3>");
				pw.println("<br><a href='CustomerPage.jsp'>Go back</a>");
	    	}
	    	
	    }catch(Exception e)
	    {
	    	e.printStackTrace();
			pw.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
	    }	
	}
}
