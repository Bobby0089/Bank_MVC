<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Transaction Passbook</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>
	<nav class="navbar" style="background-color: #606060;">
		<div class="container-fluid">
			<a class="navbar-brand d-flex align-items-center text-white" href="#">
				<img src="bank_logo.jpg" alt="Logo" width="60" height="60"
				class="me-3"> <span class="fs-2 fw-bold">Swabhav Bank</span>
			</a>
		</div>
	</nav>

	<div class="container my-5">
		<h2 class="text-center mb-4">Transaction Passbook</h2>

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
					Connection conn = null;
				PreparedStatement ps = null;
				ResultSet rs = null;

				try {
					Class.forName("com.mysql.cj.jdbc.Driver");
					conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mvcbank", "root", "Hell0Bobby");

					ps = conn.prepareStatement("SELECT * FROM transaction");
					rs = ps.executeQuery();

					while (rs.next()) {
						int id = rs.getInt("id");
						int sender = rs.getInt("sender_acc");
						int receiver = rs.getInt("receiver_acc");
						String type = rs.getString("type_of_transaction");
						double amount = rs.getDouble("amount");
						Timestamp date = rs.getTimestamp("date");
				%>
				<tr>
					<td><%=id%></td>
					<td><%=sender%></td>
					<td><%=receiver%></td>
					<td><%=type%></td>
					<td>₹ <%=amount%></td>
					<td><%=date%></td>
				</tr>
				<%
					}
				} catch (Exception e) {
				%>
				<tr>
					<td colspan="6" class="text-danger text-center">Error: <%=e.getMessage()%></td>
				</tr>
				<%
					} finally {
					if (rs != null)
						rs.close();
					if (ps != null)
						ps.close();
					if (conn != null)
						conn.close();
				}
				%>
			</tbody>
		</table>

		<div class="text-center mt-4">
			<a href="AdminPage.jsp" class="btn btn-outline-dark">Go back to
				Home</a>
		</div>
	</div>
</body>
</html>