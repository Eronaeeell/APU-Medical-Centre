<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
request.setAttribute("activePage", "charges");
%>
<%@ include file="sidebar_doctor.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor - Charges Entry</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { background-color: #f9fafb; }
        .action-btn { background: none; border: none; cursor: pointer; padding: 0.2rem; }
        .action-btn i { font-size: 1rem; color: #333; }
        .action-btn.add i { color: #198754; }
        .action-btn:hover i { opacity: 0.8; }
        .card-stat { border-radius: 0.5rem; }
        .card-stat .card-body { padding: 1.5rem 1rem; }
        .stat-icon { padding: 0.7rem; border-radius: 50%; font-size: 1.5rem; display: inline-block;}
        .bg-primary { background-color: #0d6efd !important; }
        .bg-success { background-color: #198754 !important; }
        .bg-purple { background-color: #6f42c1 !important; }
        .bg-warning { background-color: #fd7e14 !important; }
    </style>
</head>
<body>
<%
    List<Map<String, Object>> awaitingCharges = (List<Map<String, Object>>) request.getAttribute("completedAppointments");
    List<Map<String, Object>> submittedCharges = (List<Map<String, Object>>) request.getAttribute("charges");

    // ----------- Summary Card Data -------------
    int pendingCharges = 0;
    double todaysCharges = 0.0;
    int totalSubmitted = 0;
    int paidCharges = 0;
    String todayStr = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

    if (awaitingCharges != null) {
        for (Map<String, Object> a : awaitingCharges) {
            // If you store 'chargesEntered' in your backend, otherwise just count all
            if (a.get("chargesEntered") == null || !(Boolean.TRUE.equals(a.get("chargesEntered")))) {
                pendingCharges++;
            }
        }
    }

    if (submittedCharges != null) {
        totalSubmitted = submittedCharges.size();
        for (Map<String, Object> c : submittedCharges) {
            String dateEntered = c.get("dateEntered") != null ? c.get("dateEntered").toString() : "";
            // For today's charges
            if (todayStr.equals(dateEntered) && c.get("totalAmount") != null) {
                try {
                    todaysCharges += Double.parseDouble(c.get("totalAmount").toString());
                } catch(Exception e) {}
            }
            // For paid charges
            if ("Paid".equalsIgnoreCase((String) c.get("status"))) {
                paidCharges++;
            }
        }
    }
%>
<div class="container-fluid" style="margin-left: 260px; padding: 20px; max-width: 1100px;">
    <h2 class="font-weight-bold">Charges Entry</h2>
    <p class="text-muted mb-3">Enter charges for completed appointments and manage billing</p>

    <!-- --------- Summary Cards --------- -->
    <div class="row mb-4">
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-primary text-white"><i class="fas fa-file-invoice-dollar"></i></span>
                    <h6 class="text-muted mt-2">Pending Charges</h6>
                    <h4><%= pendingCharges %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-success text-white"><i class="fas fa-dollar-sign"></i></span>
                    <h6 class="text-muted mt-2">Today's Charges</h6>
                    <h4>RM <%= String.format("%.2f", todaysCharges) %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-purple text-white"><i class="fas fa-calculator"></i></span>
                    <h6 class="text-muted mt-2">Total Submitted</h6>
                    <h4><%= totalSubmitted %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-warning text-white"><i class="fas fa-check-circle"></i></span>
                    <h6 class="text-muted mt-2">Paid Charges</h6>
                    <h4><%= paidCharges %></h4>
                </div>
            </div>
        </div>
    </div>
    <!-- --------- End Summary Cards --------- -->

    <!-- Appointments Awaiting Charges Table -->
    <div class="card mb-4">
        <div class="card-header bg-light">
            <b>Appointments Awaiting Charges</b>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-sm table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Date & Time</th>
                            <th>Type</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (awaitingCharges != null && !awaitingCharges.isEmpty()) {
                            for (Map<String, Object> a : awaitingCharges) {
                    %>
                        <tr>
                            <td><%= a.get("patientName") %></td>
                            <td>
                                <div><%= a.get("appointmentDate") %></div>
                                <div class="text-muted small"><%= a.get("appointmentTime") %></div>
                            </td>
                            <td><%= a.get("appointmentType") %></td>
                            <td><%= a.get("reason") %></td>
                            <td><span class="badge badge-success"><%= a.get("status") %></span></td>
                            <td>
                                <button class="btn btn-success btn-sm open-charge-modal"
                                    data-id="<%= a.get("id") %>"
                                    data-patient="<%= a.get("patientName") %>"
                                    data-date="<%= a.get("appointmentDate") %>"
                                    data-type="<%= a.get("appointmentType") %>"
                                    data-reason="<%= a.get("reason") %>"
                                    data-toggle="modal"
                                    data-target="#addChargeModal">
                                    <i class="fas fa-plus mr-1"></i> Add Charges
                                </button>
                            </td>
                        </tr>
                    <% }
                        } else { %>
                        <tr>
                            <td colspan="6" class="text-center text-muted">No appointments awaiting charge entry</td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Submitted Charges Table -->
    <div class="card mb-4">
        <div class="card-header bg-light">
            <b>Submitted Charges</b>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-sm table-hover mb-0">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Date</th>
                            <th>Service</th>
                            <th>Fee</th>
                            <th>Status</th>
                            <th>Notes</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (submittedCharges != null && !submittedCharges.isEmpty()) {
                            for (Map<String, Object> c : submittedCharges) {
                                // Build service list string and total fee
                                StringBuilder serviceList = new StringBuilder();
                                double totalFee = 0.0;
                                List<Map<String, Object>> services = (List<Map<String, Object>>) c.get("services");
                                if (services != null && !services.isEmpty()) {
                                    for (int i = 0; i < services.size(); i++) {
                                        Map<String, Object> svc = services.get(i);
                                        serviceList.append(svc.get("name"));
                                        if (i < services.size() - 1) serviceList.append(", ");
                                        totalFee += (Double) svc.get("fee");
                                    }
                                }
                    %>
                        <tr>
                            <td><%= c.get("patientName") %></td>
                            <td><%= c.get("appointmentDate") %></td>
                            <td><%= serviceList.toString() %></td>
                            <td>RM <%= String.format("%.2f", totalFee) %></td>
                            <td>
                                <span class="badge badge-pill 
                                    <%= "Paid".equalsIgnoreCase((String)c.get("status")) ? "badge-success" :
                                        "Pending".equalsIgnoreCase((String)c.get("status")) ? "badge-warning text-dark" :
                                        "Submitted".equalsIgnoreCase((String)c.get("status")) ? "badge-primary" : "badge-secondary" %>">
                                    <%= c.get("status") %>
                                </span>
                            </td>
                            <td><%= c.get("notes") %></td>
                        </tr>
                    <%
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" class="text-center text-muted">No submitted charges</td>
                        </tr>
                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Add Charge Modal -->
    <div class="modal fade" id="addChargeModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <form method="post" action="DoctorChargesServlet" class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Enter Charges</h5>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label>Patient Name</label>
                        <input type="text" class="form-control" name="patientName" id="charge-patient" readonly>
                    </div>
                    <div class="form-group">
                        <label>Date</label>
                        <input type="date" class="form-control" name="date" id="charge-date" readonly>
                    </div>
                    <div class="form-group">
                        <label>Type</label>
                        <input type="text" class="form-control" name="chargeType" id="charge-type" readonly>
                    </div>
                    <div class="form-group">
                        <label>Reason</label>
                        <input type="text" class="form-control" name="reason" id="charge-reason" readonly>
                    </div>
                    <div class="form-group">
                        <label>Service</label>
                        <input type="text" class="form-control" name="serviceName" required>
                    </div>
                    <div class="form-group">
                        <label>Fee (RM)</label>
                        <input type="number" step="0.01" class="form-control" name="serviceFee" required>
                    </div>
                    <div class="form-group">
                        <label>Status</label>
                        <select class="form-control" name="status" required>
                            <option value="Submitted">Submitted</option>
                            <option value="Paid">Paid</option>
                            <option value="Pending">Pending</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Notes</label>
                        <textarea class="form-control" name="notes"></textarea>
                    </div>
                    <input type="hidden" name="appointmentId" id="charge-id">
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-dark">Submit Charges</button>
                </div>
            </form>
        </div>
    </div>
</div>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
<script>
$('.open-charge-modal').on('click', function() {
    $('#charge-id').val($(this).data('id'));
    $('#charge-patient').val($(this).data('patient'));
    $('#charge-date').val($(this).data('date'));
    $('#charge-type').val($(this).data('type'));
    $('#charge-reason').val($(this).data('reason'));
});
</script>
</body>
</html>
