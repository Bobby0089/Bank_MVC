<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="com.company.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String myUserName = request.getParameter("username");
    String myPassword = request.getParameter("password");
    String myRole = request.getParameter("role");

    Connection conn = null;

    try {
        conn = DBConnection.getConnection();

        boolean usernameExists = false;

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

        if (usernameExists) {
%>
            <h3 style='color:red;'>Username already exists. Please choose another one.</h3>
            <br><a href='RegisterPage.jsp'>Go back</a>
<%
        } else {
            if ("Admin".equalsIgnoreCase(myRole)) {
                String insertQuery = "INSERT INTO users (user_name, password, role) VALUES (?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(insertQuery)) {
                    ps.setString(1, myUserName);
                    ps.setString(2, myPassword);
                    ps.setString(3, myRole);
                    int rowsInserted = ps.executeUpdate();
                    if (rowsInserted > 0) {
%>
                        <h3 style='color:green;'>Registration Successful!</h3>
                        <br><a href='LandingPage.jsp'>Go back</a>
<%
                    } else {
%>
                        <h3 style='color:red;'>User not registered. Please try again.</h3>
                        <br><a href='RegisterPage.jsp'>Go back</a>
<%
                    }
                }
            } else if ("Customer".equalsIgnoreCase(myRole)) {
                session.setAttribute("username", myUserName);
                session.setAttribute("password", myPassword);
                response.sendRedirect("CustomerRegister.jsp");
            }
        }
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    } 
%>
