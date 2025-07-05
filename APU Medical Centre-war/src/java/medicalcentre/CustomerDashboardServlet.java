package medicalcentre;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/CustomerDashboardServlet")
public class CustomerDashboardServlet extends HttpServlet {

    private List<Map<String, String>> appointments = new ArrayList<>();

    @Override
    public void init() throws ServletException {
        // Sample appointments (this should eventually be from a database)
        appointments.add(createAppointment("1", "John Doe", "Dr. Smith", "2024-12-02", "10:00", "Consultation", "confirmed", "Regular checkup"));
        appointments.add(createAppointment("2", "Jane Smith", "Dr. Johnson", "2024-12-02", "11:30", "Follow-up", "pending", "Blood pressure monitoring"));
    }

    private Map<String, String> createAppointment(String id, String patientName, String doctorName, String date, String time, String type, String status, String notes) {
        Map<String, String> appointment = new HashMap<>();
        appointment.put("id", id);
        appointment.put("patientName", patientName);
        appointment.put("doctorName", doctorName);
        appointment.put("date", date);
        appointment.put("time", time);
        appointment.put("type", type);
        appointment.put("status", status);
        appointment.put("notes", notes);
        return appointment;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("userRole");

        if (role == null || !"customer".equals(role)) {
            response.sendRedirect("login.jsp?error=Please login as a customer to access the dashboard.");
            return;
        }

        // Set active page for navigation
        request.setAttribute("activePage", "dashboard");

        // Set mock upcoming appointments
        request.setAttribute("appointments", appointments);

        request.getRequestDispatcher("customerDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String patientName = "Jane Doe"; // Replace with the session user or actual name
        String doctorName = request.getParameter("doctorName");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String type = request.getParameter("type");
        String reason = request.getParameter("reason");

        // Generate new ID
        int newId = appointments.stream()
                .mapToInt(a -> Integer.parseInt(a.get("id")))
                .max()
                .orElse(0) + 1;

        // Create a new appointment
        Map<String, String> newAppointment = createAppointment(
                String.valueOf(newId),
                patientName,
                doctorName,
                date,
                time,
                type,
                "Scheduled",  // Default status
                reason
        );

        // Add the new appointment to the list
        appointments.add(newAppointment);

        // After booking, redirect to the customer dashboard or appointments page
        response.sendRedirect("customerDashboard.jsp");
    }
}
