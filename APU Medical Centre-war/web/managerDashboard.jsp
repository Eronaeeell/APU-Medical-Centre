<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ include file="sidebar_manager.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager - Dashboard</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" crossorigin="anonymous" />
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body { background-color: #f9fafb; }
        .card { border-radius: 0.5rem; }
        .card-header { background: none; border-bottom: none; }
        .stat-icon {
            padding: 0.5rem;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .timeline-border { border-left: 4px solid; padding-left: 1rem; }
    </style>
</head>
<body>
<div class="container-fluid" style="margin-left: 260px; padding: 20px; max-width: 1000px;">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h4 class="mb-0 d-flex align-items-center">
            <i class="fas fa-tachometer-alt fa-lg text-primary mr-2"></i>
            Manager Dashboard
        </h4>
    </div>
    <p class="text-muted mb-4">Welcome back! Here's what's happening at APU Medical Centre.</p>

    <!-- Summary Cards -->
    <div class="row mb-4">
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <div class="stat-icon bg-primary bg-opacity-10 mb-2">
                        <i class="fas fa-users fa-lg text-primary"></i>
                    </div>
                    <h6 class="text-muted">Total Staff</h6>
                    <h4>24</h4>
                    <small class="text-success">+2 from last month</small>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <div class="stat-icon bg-success bg-opacity-10 mb-2">
                        <i class="fas fa-calendar-check fa-lg text-success"></i>
                    </div>
                    <h6 class="text-muted">Today's Appointments</h6>
                    <h4>18</h4>
                    <small class="text-success">+5 from yesterday</small>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <div class="stat-icon bg-purple bg-opacity-10 mb-2" style="background-color: #f3e8ff;">
                        <i class="fas fa-coins fa-lg text-purple" style="color: #6f42c1;"></i>
                    </div>
                    <h6 class="text-muted">Monthly Revenue</h6>
                    <h4>RM 45,230</h4>
                    <small class="text-success">+12% from last month</small>
                </div>
            </div>
        </div>
        <div class="col-md-3 mb-2">
            <div class="card shadow-sm text-center">
                <div class="card-body">
                    <div class="stat-icon bg-warning bg-opacity-10 mb-2">
                        <i class="fas fa-file-alt fa-lg text-warning"></i>
                    </div>
                    <h6 class="text-muted">Reports Generated</h6>
                    <h4>8</h4>
                    <small class="text-muted">This month</small>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Activities and System Overview -->
    <div class="row">
        <div class="col-lg-6 mb-3">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">Recent Staff Activities</h5>
                    <small class="text-muted">Latest staff registrations and updates</small>
                </div>
                <div class="card-body">
                    <div class="timeline-border border-success mb-3">
                        <div class="font-weight-bold">Dr. Emily Johnson registered</div>
                        <small class="text-muted">2 hours ago</small>
                    </div>
                    <div class="timeline-border border-primary mb-3">
                        <div class="font-weight-bold">Counter Staff profile updated</div>
                        <small class="text-muted">4 hours ago</small>
                    </div>
                    <div class="timeline-border border-warning">
                        <div class="font-weight-bold">New manager account created</div>
                        <small class="text-muted">1 day ago</small>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-lg-6 mb-3">
            <div class="card shadow-sm">
                <div class="card-header">
                    <h5 class="mb-0">System Overview</h5>
                    <small class="text-muted">Key metrics and system health</small>
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Active Doctors</span>
                        <span class="font-weight-bold">8</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Counter Staff</span>
                        <span class="font-weight-bold">6</span>
                    </div>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Registered Customers</span>
                        <span class="font-weight-bold">342</span>
                    </div>
                    <div class="d-flex justify-content-between">
                        <span class="text-muted">Pending Appointments</span>
                        <span class="font-weight-bold">12</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.bundle.min.js"></script>
</body>
</html>
