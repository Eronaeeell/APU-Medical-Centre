<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Dashboard</title>
</head>
<body>
    <h1>Welcome, Customer: <%= session.getAttribute("userName") %></h1>
    <p>This is the Customer Dashboard.</p>
</body>
</html>
