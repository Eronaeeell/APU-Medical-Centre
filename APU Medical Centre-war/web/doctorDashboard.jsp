<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Dashboard</title>
</head>
<body>
    <h1>Welcome, Doctor: <%= session.getAttribute("userName") %></h1>
    <p>This is the Doctor Dashboard.</p>
</body>
</html>
