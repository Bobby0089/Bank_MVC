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
import javax.servlet.http.HttpSession;

@WebServlet("/transactionServlet")
public class TransactionServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    response.setContentType("text/html");
	    PrintWriter pw = response.getWriter();
	    

	    String typeOfTransaction = request.getParameter("type");
	    String amountStr = request.getParameter("amount");
	    String receverAccountNumberStr = request.getParameter("accountno");
	    HttpSession session = request.getSession(false);

	    if (session == null || session.getAttribute("customerusername") == null) {
	        pw.println("Session expired. Please log in again.");
	        return;
	    }

	    String username = (String) session.getAttribute("customerusername");

	    double amount = stringToDouble(amountStr,pw);
	    int receverAccountNumber = stringToInteger(receverAccountNumberStr,pw);

	    Connection conn = null;
	    try {
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);  // Disable auto-commit for transaction management

	        // Retrieve customer balance
	        PreparedStatement ps = conn.prepareStatement("SELECT account_no, balance FROM customer WHERE user_name = ?");
	        ps.setString(1, username);
	        ResultSet rs = ps.executeQuery();

	        if (rs.next()) {
	            int selfAccNo = rs.getInt("account_no");
	            double balance = rs.getDouble("balance");

	            if ("debit".equalsIgnoreCase(typeOfTransaction)) {
	                if (balance < amount) {
	                    pw.println("Insufficient Balance.");
	                } else {
	                    balance -= amount;
	                    updateBalance(conn, balance, username, pw);
	                    insertTransaction(conn, selfAccNo, selfAccNo, "Debit", amount, pw);
	                }
	            } else if ("credit".equalsIgnoreCase(typeOfTransaction)) {
	                balance += amount;
	                updateBalance(conn, balance, username, pw);
	                insertTransaction(conn, selfAccNo, selfAccNo, "Credit", amount, pw);
	            } else if ("transfer".equalsIgnoreCase(typeOfTransaction)) {
	                if (balance < amount) {
	                    pw.println("Insufficient Balance.");
	                } else {
	                	
	                	//update in self account
	                	balance -= amount;
	                	updateBalance(conn, balance, username, pw);
	                	insertTransaction(conn, selfAccNo, receverAccountNumber, "Transfer", amount, pw);
	                	
	                	//update in recever's Account
	                	double receverBalance = getReceverBalance(conn,receverAccountNumber);
	                	receverBalance += amount;
	                	String receverUsername = getReceverUserName(conn,receverAccountNumber);
	                	updateBalance(conn, receverBalance, receverUsername, pw);   
	                }
	            } else {
	                pw.println("Invalid transaction type.");
	            }

	            conn.commit();  // Commit transaction
	        } else {
	            pw.println("User not found.");
	        }

	    } catch (Exception e) {
	        if (conn != null) {
	            try {
	                conn.rollback();  // Rollback in case of failure
	            } catch (Exception ex) {
	                ex.printStackTrace();
	            }
	        }
	        e.printStackTrace();
	        pw.println("Error: " + e.getMessage());
	    } 
	}

	
	private String getReceverUserName(Connection conn, int receverAccountNumber) {
		try {
			PreparedStatement ps = conn.prepareStatement("SELECT user_name FROM customer WHERE account_no = ?");
			ps.setInt(1, receverAccountNumber);
	        ResultSet rs = ps.executeQuery();
	        
	        if(rs.next())
	        {
	        	return rs.getString("user_name");
	        }
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		return null;
	}

	private double getReceverBalance(Connection conn, int receverAccountNumber) {
		try {
			PreparedStatement ps = conn.prepareStatement("SELECT balance FROM customer WHERE account_no = ?");
			ps.setInt(1, receverAccountNumber);
	        ResultSet rs = ps.executeQuery();
	        
	        if(rs.next())
	        {
	        	return rs.getDouble("balance");
	        }
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		return -1;
	}

	private double stringToDouble(String amountStr, PrintWriter pw) {
		double amount =0;
		 if (amountStr == null || amountStr.isEmpty()) {
		        pw.println("Amount is missing.");
		    }
		 
		 try {
		        amount = Double.parseDouble(amountStr);
		        return amount;
		    } catch (NumberFormatException e) {
		        pw.println("Invalid amount format.");
		       
		    }
		return -1.0;
	}

	private int stringToInteger(String receverAccountNumberStr, PrintWriter pw) {
		int number =0;
		 if (receverAccountNumberStr == null || receverAccountNumberStr.isEmpty()) {
		        pw.println("Account number is missing.");
		        
		    }
		 try {
			 number = Integer.parseInt(receverAccountNumberStr);
			 return number;
		    } catch (NumberFormatException e) {
		        pw.println("Invalid Account Number format.");
		    }

		 return -1;
	}

	private void insertTransaction(Connection conn, int sender, int receiver, String type, double amount, PrintWriter pw) {
	    try {
	        PreparedStatement pst = conn.prepareStatement(
	            "INSERT INTO transaction (sender_acc, receiver_acc, type_of_transaction, amount) VALUES (?, ?, ?, ?)"
	        );
	        pst.setInt(1, sender);
	        pst.setInt(2, receiver);
	        pst.setString(3, type);
	        pst.setDouble(4, amount);

	        int rows = pst.executeUpdate();
	        if (rows > 0) {
	            pw.println("Transaction recorded successfully.");
	        } else {
	            pw.println("Failed to record transaction.");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        pw.println("Error: " + e.getMessage());
	    }
	}

	private void updateBalance(Connection conn, double balance, String username, PrintWriter pw) throws Exception {
	    PreparedStatement updatePs = conn.prepareStatement("UPDATE customer SET balance = ? WHERE user_name = ?");
	    updatePs.setDouble(1, balance);
	    updatePs.setString(2, username);
	    int rowsUpdated = updatePs.executeUpdate();

	    if (rowsUpdated > 0) {
	        pw.println("Balance updated successfully.");
	    } else {
	        pw.println("Failed to update balance.");
	    }
	}
}