package com.company;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/addNewCustomerServlet")
public class AddNewCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private int fk_userid;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();

        String myUserName = request.getParameter("username");
        String myFirstName = request.getParameter("firstname");
        String myLastName = request.getParameter("lastname");
        String myEmail = request.getParameter("email");
        String myPassword = request.getParameter("password");

        Connection conn = null;
        try {
        	 Class.forName("com.mysql.cj.jdbc.Driver");
             conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mvcbank", "root", "Hell0Bobby");
        	PreparedStatement ps = conn.prepareStatement("INSERT INTO Users (user_name, password, role) VALUES (?, ?, ?)");
            ps.setString(1, myUserName);
            ps.setString(2, myPassword);
            ps.setString(3, "Customer");
            
            int count = ps.executeUpdate();

            if (count > 0) {
                pw.println("<h3>Customer Added</h3>");
                pw.println("<br><a href='LandingPage.jsp'>Go back</a>");
            } else {
                pw.println("<h3>User not registered </h3>");
                pw.println("<br><a href='AddNewCustomer.jsp'>Go back</a>");
            }

            // Insert into Customer table/
            ps = conn.prepareStatement("INSERT INTO Customer (first_name, last_name, email,user_name) VALUES (?, ?, ?, ?)");
            ps.setString(1, myFirstName);
            ps.setString(2, myLastName);
            ps.setString(3, myEmail);
            ps.setString(4, myUserName);

            int count2 = ps.executeUpdate();


        } catch (Exception e) {
            e.printStackTrace();
            pw.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
}
