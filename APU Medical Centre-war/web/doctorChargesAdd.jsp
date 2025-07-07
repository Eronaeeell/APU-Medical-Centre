<%@ page import="java.util.*" %>
<%
    // These values come from the servlet when opening the modal, or are empty for new charge
    String patientName = (String) request.getAttribute("modalPatientName");
    String appointmentDate = (String) request.getAttribute("modalDate");
    String appointmentType = (String) request.getAttribute("modalType");
    String reason = (String) request.getAttribute("modalReason");
%>
<div class="form-group">
    <label>Patient Name</label>
    <input type="text" class="form-control" name="patientName" value="<%= patientName != null ? patientName : "" %>" readonly>
</div>
<div class="form-group">
    <label>Date</label>
    <input type="date" class="form-control" name="date" value="<%= appointmentDate != null ? appointmentDate : "" %>" readonly>
</div>
<div class="form-group">
    <label>Type</label>
    <input type="text" class="form-control" name="chargeType" value="<%= appointmentType != null ? appointmentType : "" %>" readonly>
</div>
<div class="form-group">
    <label>Reason</label>
    <input type="text" class="form-control" name="reason" value="<%= reason != null ? reason : "" %>" readonly>
</div>
<!-- You can add service rows here, or just a generic field for demo -->
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
<input type="hidden" name="appointmentId" value="<%= request.getAttribute("modalId") != null ? request.getAttribute("modalId") : "" %>">
