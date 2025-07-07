<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%
request.setAttribute("activePage", "history");
%>
<%@ include file="sidebar_doctor.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor - Patient History</title>
    <link rel="stylesheet" href="css/bootstrap.min.css" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { background-color: #f9fafb; }
        .card-stat { border-radius: 0.5rem; }
        .card-stat .card-body { padding: 1.5rem 1rem; }
        .stat-icon { padding: 0.7rem; border-radius: 50%; font-size: 1.5rem; display: inline-block;}
        .modal-lg { max-width: 900px; }
        .searchbox { max-width: 350px; }
        .badge { font-size: 0.88em; }
    </style>
</head>
<body>
<%
    List<Map<String, Object>> patientHistory = (List<Map<String, Object>>) request.getAttribute("patientHistory");
    int totalPatients = patientHistory != null ? patientHistory.size() : 0;
    int totalAppointments = 0;
    double totalCharges = 0;
    int totalVisits = 0;
    for (Map<String, Object> p : patientHistory) {
        totalAppointments += ((List<Map<String, Object>>)p.get("appointments")).size();
        totalCharges += (Double)p.get("totalCharges");
        totalVisits += (Integer)p.get("totalVisits");
    }
    double avgVisits = totalPatients > 0 ? (double) totalVisits / totalPatients : 0;
%>
<div class="container-fluid" style="margin-left: 260px; padding: 20px; max-width: 1100px;">
    <h2 class="font-weight-bold">Patient History</h2>
    <p class="text-muted mb-3">Access complete appointment and charge history for all patients</p>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-primary text-white"><i class="fas fa-user"></i></span>
                    <h6 class="text-muted mt-2">Total Patients</h6>
                    <h4><%= totalPatients %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-success text-white"><i class="fas fa-calendar-alt"></i></span>
                    <h6 class="text-muted mt-2">Total Appointments</h6>
                    <h4><%= totalAppointments %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-purple text-white"><i class="fas fa-dollar-sign"></i></span>
                    <h6 class="text-muted mt-2">Total Charges</h6>
                    <h4>RM <%= String.format("%.2f", totalCharges) %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card card-stat shadow-sm text-center">
                <div class="card-body">
                    <span class="stat-icon bg-warning text-white"><i class="fas fa-file-medical-alt"></i></span>
                    <h6 class="text-muted mt-2">Avg. Visits/Patient</h6>
                    <h4><%= String.format("%.1f", avgVisits) %></h4>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient List Table -->
    <div class="card mb-4">
        <div class="card-header bg-light d-flex justify-content-between align-items-center">
            <b>Patient History</b>
            <input class="form-control form-control-sm searchbox" type="text" id="searchInput" placeholder="Search patients...">
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="patientTable">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Total Visits</th>
                            <th>Last Visit</th>
                            <th>Total Charges</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <%
                        if (patientHistory != null && !patientHistory.isEmpty()) {
                            for (Map<String, Object> p : patientHistory) {
                    %>
                        <tr class="patient-row" data-name="<%= ((String)p.get("patientName")).toLowerCase() %>">
                            <td>
                                <div>
                                    <span class="font-weight-bold"><%= p.get("patientName") %></span><br>
                                    <small class="text-muted"><%= p.get("patientAge") %>y, <%= p.get("patientGender") %></small>
                                </div>
                            </td>
                            <td><%= p.get("totalVisits") %></td>
                            <td><%= p.get("lastVisit") %></td>
                            <td>RM <%= String.format("%.2f", (Double)p.get("totalCharges")) %></td>
                            <td>
                                <button class="btn btn-link btn-sm view-history" data-pid="<%= p.get("patientId") %>">
                                    <i class="fas fa-eye mr-1"></i> View History
                                </button>
                                <!-- Modal for patient history -->
                                <div class="modal fade" id="modal-<%= p.get("patientId") %>" tabindex="-1" role="dialog">
                                  <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content">
                                      <div class="modal-header">
                                        <h5 class="modal-title">Patient History - <%= p.get("patientName") %></h5>
                                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                                      </div>
                                      <div class="modal-body">
                                        <div class="row mb-3">
                                          <div class="col-md-3 text-center">
                                            <div class="p-2">
                                              <span class="h4 text-primary font-weight-bold"><%= p.get("totalVisits") %></span><br>
                                              <small class="text-muted">Total Visits</small>
                                            </div>
                                          </div>
                                          <div class="col-md-3 text-center">
                                            <div class="p-2">
                                              <span class="h4 text-success font-weight-bold"><%= p.get("lastVisit") %></span><br>
                                              <small class="text-muted">Last Visit</small>
                                            </div>
                                          </div>
                                          <div class="col-md-3 text-center">
                                            <div class="p-2">
                                              <span class="h4 text-purple font-weight-bold">RM <%= String.format("%.2f", (Double)p.get("totalCharges")) %></span><br>
                                              <small class="text-muted">Total Charges</small>
                                            </div>
                                          </div>
                                          <div class="col-md-3 text-center">
                                            <div class="p-2">
                                              <span class="h4 text-warning font-weight-bold"><%= ((List)p.get("appointments")).size() %></span><br>
                                              <small class="text-muted">Appointments</small>
                                            </div>
                                          </div>
                                        </div>
                                        <!-- Appointment History -->
                                        <div>
                                            <h5>Appointment History</h5>
                                            <div style="max-height:320px; overflow-y:auto;">
                                            <% List<Map<String,Object>> appointments = (List<Map<String,Object>>)p.get("appointments");
                                               for (Map<String,Object> apt : appointments) { %>
                                                <div class="card mb-3">
                                                    <div class="card-body">
                                                        <div class="row">
                                                            <div class="col-md-6">
                                                                <strong>Date:</strong> <%= apt.get("date") %> <span class="ml-3"><i class="fas fa-clock"></i> <%= apt.get("time") %></span><br>
                                                                <strong>Type:</strong> <span class="badge badge-info"><%= apt.get("type") %></span><br>
                                                                <strong>Reason:</strong> <%= apt.get("reason") %><br>
                                                                <strong>Diagnosis:</strong> <%= apt.get("diagnosis") %><br>
                                                                <strong>Treatment:</strong> <%= apt.get("treatment") %><br>
                                                                <strong>Notes:</strong> <%= apt.get("notes") %><br>
                                                            </div>
                                                            <div class="col-md-6">
                                                                <strong>Charges:</strong>
                                                                <table class="table table-sm">
                                                                    <tbody>
                                                                        <% List<Map<String,Object>> charges = (List<Map<String,Object>>)apt.get("charges");
                                                                           for (Map<String,Object> c : charges) { %>
                                                                        <tr>
                                                                            <td><%= c.get("service") %></td>
                                                                            <td>RM <%= String.format("%.2f", (Double)c.get("fee")) %></td>
                                                                        </tr>
                                                                        <% } %>
                                                                        <tr>
                                                                            <td><strong>Total</strong></td>
                                                                            <td><strong>RM <%= String.format("%.2f", (Double)apt.get("totalCharge")) %></strong></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            <% } %>
                                            </div>
                                        </div>
                                      </div>
                                      <div class="modal-footer">
                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                      </div>
                                    </div>
                                  </div>
                                </div>
                            </td>
                        </tr>
                    <%   }
                        } else { %>
                        <tr><td colspan="5" class="text-center text-muted">No patient history available.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
<script>
    // Search filter for patient table
    $('#searchInput').on('keyup', function() {
        var term = $(this).val().toLowerCase();
        $('#patientTable tbody tr').each(function() {
            var row = $(this);
            var name = row.data('name');
            if (name && name.indexOf(term) !== -1) {
                row.show();
            } else {
                row.hide();
            }
        });
    });
    // Show modal for each patient
    $('.view-history').on('click', function() {
        var pid = $(this).data('pid');
        $('#modal-' + pid).modal('show');
    });
</script>
</body>
</html>
