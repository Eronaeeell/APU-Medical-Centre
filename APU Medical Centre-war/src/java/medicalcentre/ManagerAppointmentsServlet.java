package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/ManagerAppointmentsServlet")
public class ManagerAppointmentsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Sidebar highlight
        request.setAttribute("activePage", "appointments");

        // Mock appointments data
        List<Map<String, Object>> appointments = new ArrayList<>();

        appointments.add(createAppointment(
                "John Doe", "Dr. Smith", "Sarah Counter",
                "2024-12-01", "10:00 AM", "Consultation", "Completed",
                180.00, "Paid",
                createFeedback(5, 4, "Excellent")
        ));
        appointments.add(createAppointment(
                "Jane Smith", "Dr. Johnson", "Mike Counter",
                "2024-12-01", "11:30 AM", "Follow-up", "Completed",
                145.00, "Paid",
                createFeedback(5, 5, "Excellent")
        ));
        appointments.add(createAppointment(
                "Mike Wilson", "Dr. Wong", "Sarah Counter",
                "2024-12-02", "02:00 PM", "Consultation", "Completed",
                430.00, "Paid",
                createFeedback(4, 3, "Good")
        ));
        appointments.add(createAppointment(
                "Alice Brown", "Dr. Smith", "Sarah Counter",
                "2024-12-02", "09:00 AM", "Check-up", "Scheduled",
                0.00, "Pending",
                null
        ));
        appointments.add(createAppointment(
                "Bob Johnson", "Dr. Wong", "Mike Counter",
                "2024-11-30", "03:30 PM", "Consultation", "Completed",
                195.00, "Paid",
                createFeedback(2, 2, "Poor")
        ));

        // Statistics calculations
        int totalAppointments = appointments.size();
        int completedAppointments = (int) appointments.stream()
                .filter(a -> "Completed".equals(a.get("status")))
                .count();
        int appointmentsWithFeedback = (int) appointments.stream()
                .filter(a -> a.get("feedback") != null)
                .count();
        double averageRating = appointments.stream()
                .filter(a -> a.get("feedback") != null)
                .mapToInt(a -> (int) ((Map<String, Object>) a.get("feedback")).get("doctorRating"))
                .average()
                .orElse(0.0);

        // Pass data to JSP
        request.setAttribute("appointments", appointments);
        request.setAttribute("totalAppointments", totalAppointments);
        request.setAttribute("completedAppointments", completedAppointments);
        request.setAttribute("appointmentsWithFeedback", appointmentsWithFeedback);
        request.setAttribute("averageRating", averageRating);

        // Forward to JSP
        request.getRequestDispatcher("managerAppointments.jsp").forward(request, response);
    }

    private Map<String, Object> createAppointment(
            String patientName, String doctorName, String counterStaff,
            String date, String time, String type, String status,
            double charges, String paymentStatus, Map<String, Object> feedback
    ) {
        Map<String, Object> appointment = new HashMap<>();
        appointment.put("patientName", patientName);
        appointment.put("doctorName", doctorName);
        appointment.put("counterStaff", counterStaff);
        appointment.put("date", date);
        appointment.put("time", time);
        appointment.put("type", type);
        appointment.put("status", status);
        appointment.put("charges", charges);
        appointment.put("paymentStatus", paymentStatus);
        appointment.put("feedback", feedback);
        return appointment;
    }

    private Map<String, Object> createFeedback(int doctorRating, int counterStaffRating, String overallExperience) {
        Map<String, Object> feedback = new HashMap<>();
        feedback.put("doctorRating", doctorRating);
        feedback.put("counterStaffRating", counterStaffRating);
        feedback.put("overallExperience", overallExperience);
        return feedback;
    }
}
