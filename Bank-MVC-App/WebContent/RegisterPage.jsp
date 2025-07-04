<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.company.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String myUserName = request.getParameter("username");
    String myPassword = request.getParameter("password");
    String myRole = request.getParameter("role");

    boolean usernameExists = false;
    boolean showForm = true;
    String errorMessage = "";

    if (myUserName != null && myPassword != null && myRole != null) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            // Check if username exists for Admin or Customer role
            if ("Admin".equalsIgnoreCase(myRole)) {
                String checkAdmin = "SELECT COUNT(*) FROM users WHERE user_name = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkAdmin)) {
                    ps.setString(1, myUserName);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            usernameExists = rs.getInt(1) > 0;
                        }
                    }
                }
            } else if ("Customer".equalsIgnoreCase(myRole)) {
                String checkCustomer = "SELECT COUNT(*) FROM customer WHERE user_name = ?";
                try (PreparedStatement ps = conn.prepareStatement(checkCustomer)) {
                    ps.setString(1, myUserName);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            usernameExists = rs.getInt(1) > 0;
                        }
                    }
                }
            }

            // If username already exists, show error message
            if (usernameExists) {
                errorMessage = "Username \"" + myUserName + "\" is already taken. Please try another one.";
            } else {
                // Insert new user into DB based on role
                if ("Admin".equalsIgnoreCase(myRole)) {
                    String insertQuery = "INSERT INTO users (user_name, password, role) VALUES (?, ?, ?)";
                    try (PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                        ps.setString(1, myUserName);
                        ps.setString(2, myPassword);
                        ps.setString(3, myRole);
                        int rowsInserted = ps.executeUpdate();
                        if (rowsInserted > 0) {
                            showForm = false;
%>
                            <h3 class="text-success text-center mt-4">Registration Successful!</h3>
                            <div class="text-center mt-3">
                                <a href="LandingPage.jsp" class="btn btn-outline-primary">Go back</a>
                            </div>
<%
                        } else {
                            errorMessage = "User not registered. Please try again.";
                        }
                    }
                } else if ("Customer".equalsIgnoreCase(myRole)) {
                    session.setAttribute("username", myUserName);
                    session.setAttribute("password", myPassword);
                    response.sendRedirect("CustomerRegister.jsp");
                    return;
                }
            }
        } catch (Exception e) {
            errorMessage = "Error: " + e.getMessage();
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="ISO-8859-1">
    <title>Register page</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-DQvkBjpPgn7RC31MCQoOeC9TI2kdqa4+BSgNMNj8v77fdC77Kj5zpWFTJaaAoMbC"
          crossorigin="anonymous">
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
<br>

<div class="container d-flex justify-content-center align-items-center mt-5">
    <div class="w-50 p-4 shadow rounded text-dark" style="background-color: #C0C0C0;">

        <h2 class="text-center mb-4 fw-bold">Register</h2>

        <% if (!errorMessage.isEmpty()) { %>
            <div class="alert alert-danger" role="alert">
                <%= errorMessage %>
            </div>
        <% } %>

        <% if (showForm) { %>
            <form action="Register.jsp" method="POST">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input type="text" class="form-control" placeholder="Enter Username" name="username" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" placeholder="Enter Email" name="email" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input type="password" class="form-control" placeholder="Enter Password" name="password" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <select class="form-select" name="role">
                        <option value="Customer">Customer</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>

                <div class="text-center mt-3">
                    <button type="submit" class="btn btn-outline-success">Register</button>
                </div>
            </form>
        <% } %>

        <div class="text-center mt-3">
            <a href="LandingPage.jsp" class="btn btn-outline-light">Home</a>
        </div>
    </div>
</div>

<div style="height: 30px;"></div>
<footer class="text-center text-muted py-3">
    &copy; 2025 BankApp | All Rights Reserved
</footer>
</body>
</html>
