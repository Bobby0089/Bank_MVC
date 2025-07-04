<%@ page import="java.sql.*"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>Customer List</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background-color: #f4f4f4;
}

.table th, .table td {
	vertical-align: middle;
}

.text-red {
	color: red;
	font-weight: bold;
}
</style>
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
		<h2 class="text-center mb-4">Customer List</h2>

		<!-- Search & Sort Row -->
		<div class="row mb-3">
			<div class="col-md-6">
				<form method="get" action="">
					<div class="input-group">
						<input type="text" name="search" class="form-control"
							placeholder="Search by Username">
						<button class="btn btn-outline-secondary" type="submit">Search</button>
					</div>
				</form>
			</div>
			<div class="col-md-4 offset-md-2">
				<form method="get" action="">
					<div class="input-group">
						<select class="form-select" name="sort">
							<option value="">Sort By</option>
							<option value="first_name">First Name</option>
							<option value="email">Email</option>
							<option value="balance">Balance</option>
						</select>
						<button class="btn btn-outline-secondary" type="submit">Sort</button>
					</div>
				</form>
			</div>
		</div>

		<!-- Table -->
		<table class="table table-bordered table-striped">
			<thead class="table-dark">
				<tr>
					<th>User ID</th>
					<th>Username</th>
					<th>Email</th>
					<th>Bank Accounts</th>
				</tr>
			</thead>
			<tbody>
				<%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/mvcbank","root","Hell0Bobby");

                String query = "SELECT * FROM customer";
                String search = request.getParameter("search");
                String sort = request.getParameter("sort");

                if (search != null && !search.trim().isEmpty()) {
                    query += " WHERE first_name LIKE ?";
                }

                if (sort != null && !sort.trim().isEmpty()) {
                    query += (search != null && !search.trim().isEmpty()) ? " ORDER BY " + sort : " ORDER BY " + sort;
                }

                ps = conn.prepareStatement(query);

                if (search != null && !search.trim().isEmpty()) {
                    ps.setString(1, "%" + search + "%");
                }

                rs = ps.executeQuery();
                while (rs.next()) {
                    int id = rs.getInt("customer_id");
                    String fname = rs.getString("first_name");
                    String email = rs.getString("email");
                    String accNo = rs.getString("account_no");
                    String balance = rs.getString("balance");
        %>
				<tr>
					<td><%= id %></td>
					<td><%= fname %></td>
					<td><%= email %></td>
					<td>
						<% if (accNo == null || accNo.trim().equals("")) { %> <span
						class="text-red">No Account Available</span> <% } else { %> Account
						Number: <%= accNo %>, Balance: <%= balance %> <% } %>
					</td>
				</tr>
				<%
                }
            } catch (Exception e) {
        %>
				<tr>
					<td colspan="4" class="text-danger text-center">Error: <%= e.getMessage() %></td>
				</tr>
				<%
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
			</tbody>
		</table>

		<div class="text-center mt-4">
			<a href="AdminPage.jsp" class="btn btn-outline-dark">Go back to Home</a>
		</div>
	</div>
</body>
</html>
