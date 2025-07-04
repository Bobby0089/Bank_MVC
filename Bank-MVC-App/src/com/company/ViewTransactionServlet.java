package com.company;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/viewTransactionServlet")
public class ViewTransactionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter pw = response.getWriter();
		
		Connection conn = null;
		try
		{
			conn = DBConnection.getConnection();
			PreparedStatement ps = conn.prepareStatement("SELECT * FROM transaction");
			
			ResultSet rs = ps.executeQuery();
			pw.println("<h1>Passbook</h1>");
			pw.println("<br><br>");
			pw.println("<table border = '2'>");
			pw.println("<tr><th>ID</th><th>SenderAccount</th><th>ReceiverAccount</th><th>Transaction Type</th><th>Amount</th><th>Date</th></tr>");
			
			while(rs.next())
			{
	            pw.println("<tr>");
	            pw.println("<td>" + rs.getInt("id") + "</td>");
	            pw.println("<td>" + rs.getInt("sender_acc") + "</td>");
	            pw.println("<td>" + rs.getInt("receiver_acc") + "</td>");
	            pw.println("<td>" + rs.getString("type_of_transaction") + "</td>");
	            pw.println("<td>" + rs.getDouble("amount") + "</td>");
	            pw.println("<td>" + rs.getTimestamp("date") + "</td>");
	            pw.println("</tr>");

			}
			
			pw.println("</table>");
			
			
		}catch(Exception e)
		{
			e.printStackTrace();
			pw.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
		}
	}
}
