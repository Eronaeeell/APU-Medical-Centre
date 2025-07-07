<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="sidebar_manager.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager - Staff Management</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { background-color: #f9fafb; }
        .table thead { background-color: #f0f2f5; }
        .table td, .table th { vertical-align: middle; font-size: 0.9rem; }
        .badge-pill { border-radius: 9999px; padding: 0.35em 0.65em; font-size: 0.75rem; }
        .action-btn { background: none; border: none; cursor: pointer; padding: 0.2rem; }
        .action-btn i { font-size: 1rem; color: #333; }
        .action-btn.edit i { color: #0d6efd; }
        .action-btn.delete i { color: #dc3545; }
        .action-btn:hover i { opacity: 0.8; }
    </style>
</head>
<body>
<div class="container-fluid" style="margin-left: 260px; padding: 20px; max-width: 1000px;">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0">
            <i class="fas fa-users-cog mr-2"></i> Staff Management
        </h4>
        <button class="btn btn-dark" data-toggle="modal" data-target="#addStaffModal">
            <i class="fas fa-user-plus mr-1"></i> Add Staff
        </button>
    </div>
    <p class="text-muted mb-3">Manage all staff records in the system below.</p>

    <!-- Staff Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-users fa-2x text-primary mb-2"></i>
                    <h6 class="text-muted">Total Staff</h6>
                    <h4><%= request.getAttribute("totalStaff") != null ? request.getAttribute("totalStaff") : "0" %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-user-check fa-2x text-success mb-2"></i>
                    <h6 class="text-muted">Active Staff</h6>
                    <h4><%= request.getAttribute("activeStaff") != null ? request.getAttribute("activeStaff") : "0" %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-user-slash fa-2x text-danger mb-2"></i>
                    <h6 class="text-muted">Inactive Staff</h6>
                    <h4><%= request.getAttribute("inactiveStaff") != null ? request.getAttribute("inactiveStaff") : "0" %></h4>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <i class="fas fa-building fa-2x text-warning mb-2"></i>
                    <h6 class="text-muted">Departments</h6>
                    <h4><%= request.getAttribute("totalDepartments") != null ? request.getAttribute("totalDepartments") : "0" %></h4>
                </div>
            </div>
        </div>
    </div>

    <!-- Staff Table -->
    <div class="card shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0">
                    <thead>
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Department</th>
                        <th>Status</th>
                        <th>Join Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Map<String, String>> staffList = (List<Map<String, String>>) request.getAttribute("staffList");
                        if (staffList != null && !staffList.isEmpty()) {
                            for (Map<String, String> staff : staffList) {
                    %>
                    <tr>
                        <td><%= staff.get("name") %></td>
                        <td><%= staff.get("email") %></td>
                        <td><%= staff.get("phone") %></td>
                        <td><%= staff.get("role") %></td>
                        <td><%= staff.get("department") %></td>
                        <td>
                            <% if ("Active".equals(staff.get("status"))) { %>
                            <span class="badge badge-success badge-pill">Active</span>
                            <% } else { %>
                            <span class="badge badge-secondary badge-pill">Inactive</span>
                            <% } %>
                        </td>
                        <td><%= staff.get("joinDate") %></td>
                        <td>
                            <button class="action-btn edit" 
                                    data-toggle="modal" 
                                    data-target="#editStaffModal"
                                    data-id="<%= staff.get("id") %>"
                                    data-name="<%= staff.get("name") %>"
                                    data-email="<%= staff.get("email") %>"
                                    data-phone="<%= staff.get("phone") %>"
                                    data-role="<%= staff.get("role") %>"
                                    data-department="<%= staff.get("department") %>"
                                    data-status="<%= staff.get("status") %>"
                                    data-joindate="<%= staff.get("joinDate") %>">
                                <i class="fas fa-edit"></i>
                            </button>
                            <form action="DeleteStaffServlet" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="<%= staff.get("id") %>">
                                <button type="submit" class="action-btn delete" onclick="return confirm('Are you sure you want to delete this staff?');">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="8" class="text-center text-muted">No staff found.</td>
                    </tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Add Staff Modal -->
<div class="modal fade" id="addStaffModal">
    <div class="modal-dialog">
        <form method="post" action="AddStaffServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Staff</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <%@ include file="managerStaffAdd.jsp" %>
        </form>
    </div>
</div>

<!-- Edit Staff Modal -->
<div class="modal fade" id="editStaffModal">
    <div class="modal-dialog">
        <form method="post" action="EditStaffServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Edit Staff</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <%@ include file="managerStaffEdit.jsp" %>
        </form>
    </div>
</div>

<script>
$('#editStaffModal').on('show.bs.modal', function (event) {
    var button = $(event.relatedTarget);
    $('#editId').val(button.data('id'));
    $('#editName').val(button.data('name'));
    $('#editEmail').val(button.data('email'));
    $('#editPhone').val(button.data('phone'));
    $('#editRole').val(button.data('role'));
    $('#editDepartment').val(button.data('department'));
    $('#editStatus').val(button.data('status'));
    $('#editJoinDate').val(button.data('joindate'));
});
</script>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
