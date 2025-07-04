//package com.company;
//
//import java.io.IOException;
//import java.io.PrintWriter;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
//import java.sql.ResultSet;
//import java.sql.SQLException;
//
//import javax.servlet.ServletException;
//import javax.servlet.annotation.WebServlet;
//import javax.servlet.http.HttpServlet;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//@WebServlet("/viewPassbookServlet")
//public class ViewPassbookServlet extends HttpServlet {
//	private static final long serialVersionUID = 1L;
//   
//	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		
//		response.setContentType("text/html");
//		PrintWriter pw = response.getWriter();
//		
//		int userAccountNumber;
//		
//		HttpSession session = request.getSession(false);
//	    if (session == null || session.getAttribute("customerusername") == null) {
//	        pw.println("Session expired. Please log in again.");
//	        return;
//	    }
//	    String username = (String) session.getAttribute("customerusername");
//	    
//	    Connection conn = null;
//	    try
//	    {
//	    	conn = DBConnection.getConnection();
//	    	PreparedStatement ps = conn.prepareStatement("SELECT account_no FROM customer WHERE user_name = ?");
//	    	ps.setString(1,username);
//	    	ResultSet rs = ps.executeQuery();
//	    	
//	    	if(rs.next())
//	    	{
//	    		userAccountNumber = rs.getInt("account_no");
//	    		showPassbook(conn,userAccountNumber,pw);
//	    	}
//	    }catch(Exception e)
//	    {
//	    	e.printStackTrace();
//			pw.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
//	    }
//		
//	}
//
//	private void showPassbook(Connection conn, int userAccountNumber,PrintWriter pw) 
//	{
//		PreparedStatement ps;
//		try {
//			ps = conn.prepareStatement("SELECT * FROM transaction WHERE sender_acc = ?");
//			ps.setInt(1, userAccountNumber);
//			ResultSet rs = ps.executeQuery();
//			pw.println("<h1>Passbook</h1>");
//			pw.println("<br><br>");
//			pw.println("<table border = '2'>");
//			pw.println("<tr><th>ID</th><th>SenderAccount</th><th>ReceiverAccount</th><th>Transaction Type</th><th>Amount</th><th>Date</th></tr>");
//			
//			while(rs.next())
//			{
//	            pw.println("<tr>");
//	            pw.println("<td>" + rs.getInt("id") + "</td>");
//	            pw.println("<td>" + rs.getInt("sender_acc") + "</td>");
//	            pw.println("<td>" + rs.getInt("receiver_acc") + "</td>");
//	            pw.println("<td>" + rs.getString("type_of_transaction") + "</td>");
//	            pw.println("<td>" + rs.getDouble("amount") + "</td>");
//	            pw.println("<td>" + rs.getTimestamp("date") + "</td>");
//	            pw.println("</tr>");
//
//			}
//			
//			pw.println("</table>");
//			
//		} catch (SQLException e) {
//			e.printStackTrace();
//			pw.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
//		}
//		
//		
//		
//		
//		
//		
//	}
//
//}
