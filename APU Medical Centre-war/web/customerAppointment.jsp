<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="sidebar_customer.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer - Appointments</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <style>
        body { background-color: #f9fafb; }
        .card { border-radius: 0.5rem; }
        .badge-status { font-size: 0.8rem; }
    </style>
</head>
<body>
<div class="container-fluid" style="margin-left: 260px; padding: 20px; max-width: 1000px;">
    <h2 class="font-weight-bold">My Medical History</h2>
    <p class="text-muted mb-4">View your appointment history and payment records</p>

    <%
        List<Map<String, String>> appointments = (List<Map<String, String>>) request.getAttribute("appointments");
        int completedCount = 0;
        int scheduledCount = 0;
        double totalPaid = 0;
        if (appointments != null) {
            for (Map<String, String> appt : appointments) {
                String status = appt.get("status");
                String paymentStatus = appt.get("paymentStatus");
                if ("Completed".equalsIgnoreCase(status)) completedCount++;
                if ("Scheduled".equalsIgnoreCase(status)) scheduledCount++;
                if ("Paid".equalsIgnoreCase(paymentStatus)) {
                    try {
                        totalPaid += Double.parseDouble(appt.get("totalCharge"));
                    } catch (Exception e) {}
                }
            }
        }
    %>

    <!-- Summary Cards with Icons -->
    <div class="row mb-4">
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-calendar-alt fa-2x text-primary mb-2"></i>
                    <h6 class="text-muted">Total Appointments</h6>
                    <h3><%= appointments.size() %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-check-circle fa-2x text-success mb-2"></i>
                    <h6 class="text-muted">Completed</h6>
                    <h3><%= completedCount %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-wallet fa-2x text-warning mb-2"></i>
                    <h6 class="text-muted">Total Paid</h6>
                    <h3>RM <%= String.format("%.2f", totalPaid) %></h3>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-hourglass-half fa-2x text-info mb-2"></i>
                    <h6 class="text-muted">Upcoming</h6>
                    <h3><%= scheduledCount %></h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Display Appointments -->
    <div class="row">
        <% if (appointments != null && !appointments.isEmpty()) { 
            for (Map<String, String> appt : appointments) { 
                String status = appt.get("status");
                String paymentStatus = appt.get("paymentStatus");
                String badgeClass =
                    "Completed".equalsIgnoreCase(status) ? "badge-success" :
                    "Scheduled".equalsIgnoreCase(status) ? "badge-primary" : "badge-secondary";
                String paymentBadgeClass =
                    "Paid".equalsIgnoreCase(paymentStatus) ? "badge-success" :
                    "Pending".equalsIgnoreCase(paymentStatus) ? "badge-warning text-dark" : "badge-secondary";
        %>

        <!-- Appointment Card -->
        <div class="card mb-3 p-3 col-md-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <strong><%= appt.get("date") %></strong> at <strong><%= appt.get("time") %></strong> with <strong><%= appt.get("doctorName") %></strong> (<%= appt.get("specialty") %>)
                </div>
                <span class="badge badge-status <%= badgeClass %>"><%= status %></span>
            </div>
            <hr>
            <p><strong>Type:</strong> <%= appt.get("type") %> | <strong>Reason:</strong> <%= appt.get("reason") %></p>
            <% if (appt.get("diagnosis") != null && !appt.get("diagnosis").isEmpty()) { %>
                <p><strong>Diagnosis:</strong> <%= appt.get("diagnosis") %></p>
            <% } %>
            <% if (appt.get("treatment") != null && !appt.get("treatment").isEmpty()) { %>
                <p><strong>Treatment:</strong> <%= appt.get("treatment") %></p>
            <% } %>
            <% if (appt.get("notes") != null && !appt.get("notes").isEmpty()) { %>
                <p><strong>Doctor's Notes:</strong> <%= appt.get("notes") %></p>
            <% } %>
            <% if (appt.get("totalCharge") != null && !"0.00".equals(appt.get("totalCharge"))) { %>
                <p><strong>Total Charge:</strong> RM <%= appt.get("totalCharge") %></p>
            <% } %>
            <p>
                <strong>Payment Status:</strong> 
                <span class="badge badge-status <%= paymentBadgeClass %>"><%= paymentStatus %></span>
            </p>
            <% if (appt.get("paymentDate") != null && !appt.get("paymentDate").isEmpty()) { %>
                <p><strong>Payment Date:</strong> <%= appt.get("paymentDate") %></p>
            <% } %>
            <% if (appt.get("receiptNo") != null && !appt.get("receiptNo").isEmpty()) { %>
                <a href="DownloadReceiptServlet?receipt=<%= appt.get("receiptNo") %>" class="btn btn-sm btn-outline-primary">Download Receipt</a>
            <% } %>
        </div>
        <% }} else { %>
        <div class="card mb-3">
            <div class="card-body text-center">
                <p class="text-muted">No appointments scheduled yet.</p>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Add Appointment Modal -->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form method="post" action="CustomerAppointmentServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Book Appointment</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="doctorName">Select Doctor</label>
                    <select class="form-control" id="doctorName" name="doctorName" required>
                        <option value="Dr. Smith">Dr. Smith (Cardiology)</option>
                        <option value="Dr. Johnson">Dr. Johnson (General Medicine)</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="date">Appointment Date</label>
                    <input type="date" class="form-control" id="date" name="date" required />
                </div>
                <div class="form-group">
                    <label for="time">Appointment Time</label>
                    <input type="time" class="form-control" id="time" name="time" required />
                </div>
                <div class="form-group">
                    <label for="type">Type of Appointment</label>
                    <select class="form-control" id="type" name="type" required>
                        <option value="Consultation">Consultation</option>
                        <option value="Follow-up">Follow-up</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="reason">Reason for Visit</label>
                    <textarea class="form-control" id="reason" name="reason" rows="3" required></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-dark">Book Appointment</button>
            </div>
        </form>
    </div>
</div>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
