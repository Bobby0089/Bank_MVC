<%@ page import="java.io.PrintWriter,java.sql.*, javax.servlet.http.*, javax.servlet.*, com.company.DBConnection" %>
<%
    response.setContentType("text/html");
    String myUserName = request.getParameter("username");
    String myPassword = request.getParameter("password");
    String myRole = request.getParameter("role");
    PrintWriter pw = response.getWriter();

    try {
        Connection conn = DBConnection.getConnection();

        if ("Admin".equalsIgnoreCase(myRole)) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM users WHERE user_name=? AND password=?");
            ps.setString(1, myUserName);
            ps.setString(2, myPassword);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                session.setAttribute("adminusername", myUserName);
                response.sendRedirect("AdminPage.jsp");
            } else {
                pw.println("<h3 style='color:red;'>User not found. Try again...</h3>");
                pw.println("<br><a href='LandingPage.jsp'>Go back</a>");
            }

        } else if ("Customer".equalsIgnoreCase(myRole)) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM customer WHERE user_name=? AND password=?");
            ps.setString(1, myUserName);
            ps.setString(2, myPassword);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                session.setAttribute("customerusername", myUserName);
                response.sendRedirect("CustomerPage.jsp");
            } else {
                pw.println("<h3 style='color:red;'>User not found. Try again...</h3>");
                pw.println("<br><a href='LoginPage.jsp'>Go back</a>");
            }
        }

    } catch (Exception e) {
        e.printStackTrace(pw);
        pw.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
    }
%>
