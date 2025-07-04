<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Customer DashBoard</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.4/dist/css/bootstrap.min.css"
	rel="stylesheet"
	integrity="sha384-DQvkBjpPgn7RC31MCQoOeC9TI2kdqa4+BSgNMNj8v77fdC77Kj5zpWFTJaaAoMbC"
	crossorigin="anonymous">
</head>
<body style="background-color: #F0F0F0;">
	<nav class="navbar" style="background-color: #606060;">
		<div class="container-fluid">
			<a class="navbar-brand d-flex align-items-center text-white" href="#">
				<img src="bank_logo.jpg" alt="Logo" width="60" height="60"
				class="me-3"> <span class="fs-2 fw-bold">Swabhav Bank</span>
			</a>
		</div>
	</nav>

	<nav class="navbar navbar-expand-lg bg-body-tertiary"
		style="background-color: #C0C0C0;">
		<div class="container-fluid">
			<a class="navbar-brand fs-2 fw-bold" href="#">Welcome to Customer
				DashBoard</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav me-auto mb-2 mb-lg-0">
					<li class="nav-item me-2"><a href="LandingPage.jsp"
						class="btn btn-outline-secondary">Home</a>
					<li class="nav-item me-2"><a href="LoginPage.jsp"
						class="btn btn-outline-success">Login</a>
					<li class="nav-item me-2"><a href="Login.jsp"
						class="btn btn-outline-secondary">About</a>
				</ul>
				<a href="LandingPage.jsp" class="btn btn-outline-danger">Logout</a>
			</div>
		</div>
	</nav>
	<br>

	<div align="center">

		<!-- ViewPassbook -->
		<div class="col-md-4 mb-4">
			<div class="card text-center shadow p-4"
				style="background-color: #C0C0C0;">
				<div class="card-body text-center">
					<h5 class="card-title fw-bold">ViewPassbook</h5>
					<br>
					<form action="ViewPassbook.jsp" method="POST"
						style="display: inline;">
						<button type="submit" class="btn btn-outline-light">View</button>
					</form>
				</div>
			</div>
		</div>

		<!-- NewTransaction -->
		<div class="col-md-4 mb-4">
			<div class="card text-center shadow p-4"
				style="background-color: #C0C0C0;">
				<div class="card-body text-center">
					<h5 class="card-title fw-bold">NewTransaction</h5>
					<br> <a href="NewTransaction.jsp"
						class="btn btn-outline-light">Transaction</a>
				</div>
			</div>
		</div>

		<!-- EditProfile -->
		<div class="col-md-4 mb-4">
			<div class="card text-center shadow p-4"
				style="background-color: #C0C0C0;">
				<div class="card-body text-center">
					<h5 class="card-title fw-bold">EditProfile</h5>
					<br> <a href="EditProfile.jsp" class="btn btn-outline-light">Edit</a>
				</div>
			</div>
		</div>


	</div>


	<div style="height: 50px;"></div>
	<footer class="text-center text-muted py-3"> &copy; 2025
		BankApp | All Rights Reserved </footer>



</body>
</html>