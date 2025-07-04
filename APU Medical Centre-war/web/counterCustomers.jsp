<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="sidebar_counter.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Counter - Customer Management</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />

    <style>
        body { background-color: #f9fafb; }
        .table td, .table th { vertical-align: middle; padding: 0.5rem; font-size: 0.9rem; }
        .badge-pill { border-radius: 9999px; padding: 0.35em 0.65em; font-size: 0.75rem; }
        .action-btn { background: none; border: none; cursor: pointer; padding: 0.2rem; }
        .action-btn i { font-size: 1rem; color: #333; }
        .action-btn.delete i { color: #dc3545; }
        .action-btn:hover i { color: #0d6efd; }
    </style>
</head>
<body>
<div class="container-fluid" style="margin-left: 260px; padding-top: 20px; max-width: 1000px;">
    <h2 class="font-weight-bold">Customer Management</h2>
    <p class="text-muted mb-3">Manage customer information and records</p>

    <!-- Search -->
    <form method="get" action="CounterCustomersServlet" class="form-inline mb-3">
        <input type="text" name="search" class="form-control mr-2" placeholder="Search customers..." style="flex:1; max-width:250px;">
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <!-- Add Button -->
    <button class="btn btn-dark mb-3" data-toggle="modal" data-target="#addModal">
        <i class="fas fa-plus mr-1"></i> Add Customer
    </button>

    <!-- Customer Table -->
    <div class="table-responsive">
        <table class="table table-sm table-hover">
            <thead class="thead-light">
            <tr>
                <th>Name & Address</th>
                <th>Contact</th>
                <th>Age/Gender</th>
                <th>Last Visit</th>
                <th>Status</th>
                <th style="width: 12%; min-width: 90px;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<Map<String, String>> customers = (List<Map<String, String>>) request.getAttribute("customers");
                if (customers != null) {
                    for (Map<String, String> c : customers) {
            %>
            <tr>
                <td>
                    <strong><%= c.get("name") %></strong><br>
                    <small class="text-muted"><%= c.get("address") %></small>
                </td>
                <td>
                    <div><i class="fas fa-envelope text-muted mr-1"></i><small><%= c.get("email") %></small></div>
                    <div><i class="fas fa-phone text-muted mr-1"></i><small><%= c.get("phone") %></small></div>
                </td>
                <td><%= c.get("age") %> years<br><small class="text-muted"><%= c.get("gender") %></small></td>
                <td><%= c.get("lastVisit") %></td>
                <td>
                    <span class="badge badge-pill <%= "active".equals(c.get("status")) ? "badge-dark" : "badge-light" %>">
                        <%= c.get("status") %>
                    </span>
                </td>
                <td>
                    <div class="d-flex align-items-center">
                        <button type="button"
                                class="action-btn editBtn"
                                data-toggle="modal"
                                data-target="#editModal"
                                data-id="<%= c.get("id") %>"
                                data-name="<%= c.get("name") %>"
                                data-email="<%= c.get("email") %>"
                                data-phone="<%= c.get("phone") %>"
                                data-age="<%= c.get("age") %>"
                                data-gender="<%= c.get("gender") %>"
                                data-address="<%= c.get("address") %>">
                            <i class="fas fa-edit"></i>
                        </button>
                        <a href="CounterCustomersServlet?deleteId=<%= c.get("id") %>"
                           class="action-btn delete"
                           onclick="return confirm('Are you sure you want to delete this customer?');">
                            <i class="fas fa-trash-alt"></i>
                        </a>
                    </div>
                </td>
            </tr>
            <%
                    }
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Customer Modal -->
<div class="modal fade" id="addModal">
    <div class="modal-dialog">
        <form method="post" action="CounterCustomersServlet" class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Add Customer</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <%@ include file="counterCustomersAdd.jsp" %>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-dark">Add Customer</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Customer Modal -->
<div class="modal fade" id="editModal">
    <div class="modal-dialog">
        <form method="post" action="CounterCustomersServlet" class="modal-content">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="id" id="edit-id">
            <div class="modal-header">
                <h5 class="modal-title">Edit Customer</h5>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <%@ include file="counterCustomersEdit.jsp" %>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="submit" class="btn btn-primary">Update Customer</button>
            </div>
        </form>
    </div>
</div>

<!-- Scripts -->
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
<script>
    $('.editBtn').on('click', function () {
        $('#edit-id').val($(this).data('id'));
        $('#edit-name').val($(this).data('name'));
        $('#edit-email').val($(this).data('email'));
        $('#edit-phone').val($(this).data('phone'));
        $('#edit-age').val($(this).data('age'));
        $('#edit-gender').val($(this).data('gender'));
        $('#edit-address').val($(this).data('address'));
    });
</script>
</body>
</html>
