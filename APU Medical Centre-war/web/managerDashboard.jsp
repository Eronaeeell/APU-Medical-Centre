<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard</title>
</head>
<body>
    <h1>Welcome, Manager: <%= session.getAttribute("userName") %></h1>
    <p>This is the Manager Dashboard.</p>
</body>
</html>
