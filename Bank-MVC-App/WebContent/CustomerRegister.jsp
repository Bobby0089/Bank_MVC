<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<form action="customerServlet" method="post">
<% String username = (String)session.getAttribute("username"); 
 String password = (String)session.getAttribute("password"); %>
Username: <input type="text" value=<%= username%>><br><br>
Password: <input type="text" value=<%= password%>><br><br>
FirstName: <input type="text" name="firstname"><br><br>
LastName: <input type="text" name="lastname"><br><br>
Email: <input type="text" name="email"><br><br>
<button name="submitbtn">Submit</button>
</form>
</body>
</html>