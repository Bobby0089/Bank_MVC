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


@WebServlet("/customerServlet")
public class CustomerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		HttpSession session = request.getSession();
		String user = (String)session.getAttribute("username");
        String pass = (String)session.getAttribute("password");
        String firstname = request.getParameter("firstname");
        String lastname = request.getParameter("lastname");
        String email = request.getParameter("email");
        
        try
        {
        	Connection conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("INSERT INTO customer (user_name,password,first_name,last_name,email,account_no,balance) VALUES (?, ? , ? , ? , ? , ? ,?)");
			ps.setString(1, user);
			ps.setString(2, pass);
			ps.setString(3, firstname);
			ps.setString(4, lastname);
			ps.setString(5, email);
			ps.setString(6, null);
			ps.setInt(7, 0);
			
			int count = ps.executeUpdate();
			if(count>0)
			{
				 pw.println("<h3>Registration Successfully</h3>");
				 response.sendRedirect("LandingPage.jsp");;
			}
			else
			{
				pw.println("<h3>Registeration Unsuccessfull</h3>");
				response.sendRedirect("RegisterPage.jsp");
			}
        }
        catch(Exception e)
        {
        	e.printStackTrace();
			pw.println(e.getMessage());
        }
        
	}

}
