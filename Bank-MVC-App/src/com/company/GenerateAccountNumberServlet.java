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

@WebServlet("/generateAccountNumberServlet")
public class GenerateAccountNumberServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter pw = response.getWriter();

        String customerId = request.getParameter("customerId");

        if (customerId == null || customerId.isEmpty()) {
            pw.println("<h3>Error: Customer ID is missing or invalid.</h3>");
            return;
        }

        Connection conn = null;

        try {
            int customerIdInt = Integer.parseInt(customerId);

            conn = DBConnection.getConnection();

            // Check if customer exists
            if (!isCustomerExists(conn, customerIdInt)) {
                pw.println("<h3>Error: Customer ID not found.</h3>");
                return;
            }

            // Check if the customer already has an account number
            if (hasAccountNumber(conn, customerIdInt)) {
                pw.println("<h3>Account already exists for this customer.</h3>");
                displayCustomerDetails(conn, customerIdInt, pw);
                return;
            }

            // Generate random 10-digit account number
            long randomNumber = (long) (Math.random() * 10000000000L + 1000000000L);

            // Update account number
            if (updateAccountNumber(conn, customerIdInt, randomNumber)) {
                pw.println("<h2>Account Number Generated and Updated Successfully</h2>");
                pw.println("<h3>Account Number: " + randomNumber + "</h3>");

                // ✅ Display customer details
                displayCustomerDetails(conn, customerIdInt, pw);
            } else {
                pw.println("<h3>Failed to update account number. Please try again.</h3>");
            }

        } catch (NumberFormatException e) {
            pw.println("<h3>Error: Invalid customer ID format.</h3>");
        } catch (SQLException e) {
            pw.println("<h3>Database error occurred:</h3> " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            pw.println("<h3>An unexpected error occurred:</h3> " + e.getMessage());
            e.printStackTrace();
        } 
    }

    // ✅ Check if customer exists
    private boolean isCustomerExists(Connection conn, int customerId) throws SQLException {
        String query = "SELECT 1 FROM customer WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

    // ✅ Check if customer already has an account number
    private boolean hasAccountNumber(Connection conn, int customerId) {
        String query = "SELECT account_no FROM customer WHERE customer_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();
            
            // Check if account_no is not null or 0
            if (rs.next()) {
                return rs.getLong("account_no") != 0;  // If account number exists, return true
            }
        } catch (SQLException e) {
			e.printStackTrace();
		}
        return false;
    }

 // ✅ Update account number
    private boolean updateAccountNumber(Connection conn, int customerId, long accountNumber) {
        String updateQuery = "UPDATE customer SET account_no = ? WHERE customer_id = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(updateQuery)) {
            stmt.setLong(1, accountNumber);
            stmt.setInt(2, customerId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();  // Log the exception for debugging
            return false;         // Return false if the update fails
        }
    }


 // ✅ Display customer details with validation for missing account number
    private void displayCustomerDetails(Connection conn, int customerId, PrintWriter pw) {
        String selectQuery = "SELECT customer_id, first_name, last_name, email, account_no, balance FROM customer WHERE customer_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(selectQuery)) {
            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                long accountNo = rs.getLong("account_no");

                pw.println("<h3>Customer Details</h3>");
                pw.println("<table border='1'>");
                pw.println("<tr><th>ID</th><th>First Name</th><th>Last Name</th><th>Email</th><th>Account No</th><th>Balance</th></tr>");
                pw.println("<tr>");
                pw.println("<td>" + rs.getInt("customer_id") + "</td>");
                pw.println("<td>" + rs.getString("first_name") + "</td>");
                pw.println("<td>" + rs.getString("last_name") + "</td>");
                pw.println("<td>" + rs.getString("email") + "</td>");

                // ✅ Display message if no account number exists
                if (accountNo == 0) {
                    pw.println("<td><b>No account number exists for this customer</b></td>");
                } else {
                    pw.println("<td>" + accountNo + "</td>");
                }

                pw.println("<td>" + rs.getDouble("balance") + "</td>");
                pw.println("</tr>");
                pw.println("</table>");
                pw.println("<br><a href='AdminPage.jsp'>Go back</a>");
            } else {
                pw.println("<h3>No customer details found for ID: " + customerId + "</h3>");
            }
        } catch (SQLException e) {
            e.printStackTrace();  // Log the exception for debugging
            pw.println("<h3>Error retrieving customer details.</h3>");
        }
    }

}
