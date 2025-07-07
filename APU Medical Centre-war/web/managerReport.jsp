<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="sidebar_manager.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager - Reports & Analytics</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { background-color: #f9fafb; }
        .table td, .table th { vertical-align: middle; font-size: 0.9rem; }
        .badge-pill { border-radius: 9999px; padding: 0.35em 0.65em; font-size: 0.75rem; }
        .recent-report-row { background-color: #f6f8fa; border-radius: 0.5rem; margin-bottom: 0.75rem; }
        .recent-report-row:hover { background-color: #e7eef7; }
        .form-select {
            border-radius: 0.45rem;
            border: 1.5px solid #d6e2f6;
            box-shadow: 0 2px 4px rgba(23,82,221,0.04);
            background-color: #f7fbff;
            transition: border-color 0.2s, box-shadow 0.2s;
            font-size: 1rem;
            font-weight: 500;
            color: #23395d;
        }
        .form-select:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.12rem rgba(13,110,253,.13);
            background-color: #fff;
        }
        label.form-label {
            font-weight: 600;
            color: #1d3557;
            margin-bottom: 0.4rem;
            letter-spacing: 0.01em;
        }
        .badge-report-status {
            background: #198754;
            color: #fff !important;
            font-weight: 600;
            padding: 0.32em 0.7em;
            border-radius: 2em;
            font-size: 0.85em;
            letter-spacing: 0.02em;
        }
        .metrics-label { color: #7280a7; }
    </style>
</head>
<body>
<div class="container-fluid" style="margin-left: 260px; padding: 20px; max-width: 1000px;">
    <div class="mb-3">
        <h4 class="mb-0 text-primary">
            <i class="bi bi-bar-chart-line mr-2"></i> Reports & Analytics
        </h4>
        <p class="text-muted">Generate comprehensive reports and analyze medical center performance</p>
    </div>

    <!-- Report Generation -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-white d-flex align-items-center">
            <i class="bi bi-file-earmark-text-fill text-primary mr-2"></i>
            <span class="h6 mb-0 ml-2">Generate New Report</span>
        </div>
        <div class="card-body">
            <form method="post" action="ManagerReportServlet">
    <div class="card-body p-3">
        <div class="form-group mb-3">
            <label for="type" class="form-label">Report Type *</label>
            <select id="type" name="type" class="form-select" required>
                <option value="" disabled selected>Select report type</option>
                <option value="financial">Financial Report</option>
                <option value="staff">Staff Performance</option>
                <option value="appointments">Appointment Analytics</option>
                <option value="patients">Patient Demographics</option>
            </select>
        </div>
        <div class="form-group mb-3">
            <label for="period" class="form-label">Time Period *</label>
            <select id="period" name="period" class="form-select" required onchange="toggleCustomDate(this.value)">
                <option value="" disabled selected>Select period</option>
                <option value="week">This Week</option>
                <option value="month">This Month</option>
                <option value="quarter">This Quarter</option>
                <option value="year">This Year</option>
                <option value="custom">Custom Range</option>
            </select>
        </div>
        <div id="custom-date-range" style="display:none;">
            <div class="form-group mb-3">
                <label for="dateFrom" class="form-label">Start Date</label>
                <input type="date" class="form-control" id="dateFrom" name="dateFrom">
            </div>
            <div class="form-group mb-3">
                <label for="dateTo" class="form-label">End Date</label>
                <input type="date" class="form-control" id="dateTo" name="dateTo">
            </div>
        </div>
        <div class="form-group mb-3">
            <label for="format" class="form-label">Format *</label>
            <select id="format" name="format" class="form-select" required>
                <option value="" disabled selected>Select format</option>
                <option value="pdf">PDF</option>
                <option value="excel">Excel</option>
                <option value="csv">CSV</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary w-100 mt-2">
            <i class="bi bi-file-earmark-text mr-2"></i>
            Generate Report
        </button>
    </div>
</form>

        </div>
    </div>

    <!-- Recent Reports -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-white">
            <span class="h6 mb-0">Recent Reports</span>
            <p class="text-muted mb-0" style="font-size: 0.9rem;">Previously generated reports available for download</p>
        </div>
        <div class="card-body">
            <%
                List<Map<String, Object>> recentReports = (List<Map<String, Object>>) request.getAttribute("recentReports");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            %>
            <div>
            <%
                if (recentReports != null && !recentReports.isEmpty()) {
                    for (Map<String, Object> report : recentReports) {
            %>
                <div class="d-flex justify-content-between align-items-center p-3 recent-report-row">
                    <div class="d-flex align-items-center">
                        <div class="d-flex align-items-center justify-content-center bg-primary bg-opacity-10 rounded-circle" style="width: 40px; height: 40px;">
                            <i class="bi bi-file-earmark-text text-primary" style="font-size: 1.4rem;"></i>
                        </div>
                        <div class="ml-3">
                            <div class="fw-semibold"><%= report.get("name") %></div>
                            <div class="text-muted" style="font-size: 0.92em;">
                                Generated on <%= report.get("date") %>
                                &nbsp;•&nbsp; <%= report.get("type") %>
                                &nbsp;•&nbsp; <%= report.get("size") %>
                            </div>
                        </div>
                    </div>
                    <div class="d-flex align-items-center gap-2">
                        <span class="badge badge-report-status me-2"><%= report.get("status") %></span>
                        <form action="DownloadReportServlet" method="get" class="mb-0">
                            <input type="hidden" name="reportId" value="<%= report.get("id") %>">
                            <button class="btn btn-link btn-sm p-0 text-primary" type="submit" title="Download Report">
                                <i class="bi bi-download" style="font-size:1.2rem;"></i>
                            </button>
                        </form>
                    </div>
                </div>
            <%
                    }
                } else {
            %>
                <div class="text-muted text-center py-3">No reports generated yet.</div>
            <%
                }
            %>
            </div>
        </div>
    </div>

    <!-- Key Metrics Summary -->
    <div class="row">
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span class="h6 mb-0">This Month's Highlights</span>
                    <i class="bi bi-graph-up-arrow text-success"></i>
                </div>
                <div class="card-body">
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Total Revenue</span>
                        <span class="fw-bold">RM 45,230</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">New Patients</span>
                        <span class="fw-bold">28</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Appointments</span>
                        <span class="fw-bold">342</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Reports Generated</span>
                        <span class="fw-bold"><%= recentReports != null ? recentReports.size() : 0 %></span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span class="h6 mb-0">Staff Efficiency</span>
                    <i class="bi bi-people-fill text-primary"></i>
                </div>
                <div class="card-body">
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Avg. Consultation Time</span>
                        <span class="fw-bold">18 min</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Patient Satisfaction</span>
                        <span class="fw-bold">4.8/5</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">No-show Rate</span>
                        <span class="fw-bold">3.2%</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Staff Utilization</span>
                        <span class="fw-bold">87%</span>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <span class="h6 mb-0">System Health</span>
                    <i class="bi bi-bar-chart-line-fill text-purple"></i>
                </div>
                <div class="card-body">
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Active Users</span>
                        <span class="fw-bold">24</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">System Uptime</span>
                        <span class="fw-bold text-success">99.9%</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Data Backup</span>
                        <span class="fw-bold text-success">Current</span>
                    </div>
                    <div class="mb-2 d-flex justify-content-between">
                        <span class="metrics-label">Storage Used</span>
                        <span class="fw-bold">67%</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
function toggleCustomDate(val) {
    document.getElementById("custom-date-range").style.display = (val === "custom") ? "flex" : "none";
}
</script>
</body>
</html>
