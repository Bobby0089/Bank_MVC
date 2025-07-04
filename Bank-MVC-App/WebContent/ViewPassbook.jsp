<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String username = null;
    if (session != null) {
        username = (String) session.getAttribute("customerusername");
    }

    if (username == null) {
%>
    <script>
        alert("Session expired. Please log in again.");
        window.location.href = "Login.jsp";
    </script>
<%
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    int accountNo = -1;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Passbook</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body style="background-color: #F0F0F0;">
    <nav class="navbar" style="background-color: #606060;">
        <div class="container-fluid">
            <a class="navbar-brand d-flex align-items-center text-white" href="#">
                <img src="bank_logo.jpg" alt="Logo" width="60" height="60" class="me-3">
                <span class="fs-2 fw-bold">Swabhav Bank</span>
            </a>
        </div>
    </nav>

    <div class="container my-5">
        <h2 class="text-center mb-4">Your Transactions</h2>

        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mvcbank", "root", "Hell0Bobby");

                // Get account number using username
                ps = conn.prepareStatement("SELECT account_no FROM customer WHERE user_name = ?");
                ps.setString(1, username);
                rs = ps.executeQuery();

                if (rs.next()) {
                    accountNo = rs.getInt("account_no");
                    rs.close();
                    ps.close();

                    // Fetch transactions where customer is the sender only
                    ps = conn.prepareStatement("SELECT * FROM transaction WHERE sender_acc = ?");
                    ps.setInt(1, accountNo);
                    rs = ps.executeQuery();

                    boolean hasTransactions = false;
        %>

        <table class="table table-bordered table-striped">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>Sender Account</th>
                    <th>Receiver Account</th>
                    <th>Transaction Type</th>
                    <th>Amount</th>
                    <th>Date</th>
                </tr>
            </thead>
            <tbody>
                <%
                    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm a");

                    while (rs.next()) {
                        hasTransactions = true;
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getInt("sender_acc") %></td>
                    <td><%= rs.getInt("receiver_acc") %></td>
                    <td><%= rs.getString("type_of_transaction") %></td>
                    <td>₹ <%= rs.getDouble("amount") %></td>
                    <td><%= sdf.format(rs.getTimestamp("date")) %></td>
                </tr>
                <%
                    }

                    if (!hasTransactions) {
                %>
                    <tr>
                        <td colspan="6" class="text-center text-muted">No transactions found.</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <%
                } else {
        %>
            <p class="text-danger text-center">No account number found for the logged-in user.</p>
        <%
                }
            } catch (Exception e) {
        %>
            <div class="alert alert-danger text-center" role="alert">
                Error: <%= e.getMessage() %>
            </div>
        <%
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (ps != null) try { ps.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        %>

        <div class="text-center mt-4">
            <a href="CustomerDashboard.jsp" class="btn btn-outline-dark">Back to Dashboard</a>
        </div>
    </div>

    <footer class="text-center text-muted py-3">
        &copy; 2025 BankApp | All Rights Reserved
    </footer>
</body>
</html>
