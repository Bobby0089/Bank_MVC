<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Admin Add Bank Account</title>
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
                <img src="bank_logo.jpg" alt="Logo" width="60" height="60" class="me-3">
                <span class="fs-2 fw-bold">Swabhav Bank</span>
            </a>
        </div>
    </nav>
    <br>

    <div class="container d-flex justify-content-center align-items-center mt-5">
        <div class="w-50 p-4 shadow rounded text-dark" style="background-color: #C0C0C0;">
            <h2 class="text-center mb-4 fw-bold">Add Bank Account</h2>
            <form action="generateAccountNumberServlet" method="post">
                <div class="mb-3">
                    <label class="form-label">Customer ID</label>
                    <input type="text" class="form-control" name="customerId" placeholder="Enter Customer ID" required>
                </div>
                <div class="text-center mt-3">
                    <button type="submit" class="btn btn-outline-success">Search for Customer Details</button>
                    <a href="AdminDashboard.jsp" class="btn btn-outline-danger ms-2">Cancel</a>
                </div>
            </form>
        </div>
    </div>

    <div style="height: 30px;"></div>
    <footer class="text-center text-muted py-3">
        &copy; 2025 BankApp | All Rights Reserved
    </footer>
</body>
</html>
