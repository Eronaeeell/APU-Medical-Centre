package medicalcentre;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CounterAppointmentsServlet")
public class CounterAppointmentsServlet extends HttpServlet {

    private List<Map<String, String>> appointments;

    @Override
    public void init() throws ServletException {
        appointments = new ArrayList<>();
        appointments.add(createAppointment("1", "John Doe", "Dr. Smith", "2024-12-02", "10:00", "Consultation", "confirmed", "Regular checkup"));
        appointments.add(createAppointment("2", "Jane Smith", "Dr. Johnson", "2024-12-02", "11:30", "Follow-up", "pending", "Blood pressure monitoring"));
        appointments.add(createAppointment("3", "Mike Wilson", "Dr. Wong", "2024-12-02", "14:00", "Consultation", "completed", "Skin condition review"));
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
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !role.equals("counter")) {
            response.sendRedirect("login.jsp?error=Please login as counter staff.");
            return;
        }

        request.setAttribute("activePage", "appointments");
        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("counterAppointments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        String patientName = request.getParameter("patientName");
        String doctorName = request.getParameter("doctorName");
        String date = request.getParameter("date");
        String time = request.getParameter("time");
        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String notes = request.getParameter("notes");

        if ("edit".equals(action)) {
            String id = request.getParameter("id");
            for (Map<String, String> appointment : appointments) {
                if (appointment.get("id").equals(id)) {
                    appointment.put("patientName", patientName);
                    appointment.put("doctorName", doctorName);
                    appointment.put("date", date);
                    appointment.put("time", time);
                    appointment.put("type", type);
                    appointment.put("status", status);
                    appointment.put("notes", notes);
                    break;
                }
            }
        } else {
            // Generate new ID
            int newId = appointments.stream()
                    .mapToInt(a -> Integer.parseInt(a.get("id")))
                    .max()
                    .orElse(0) + 1;

            // Default status if not provided
            if (status == null || status.isEmpty()) {
                status = "confirmed";
            }

            appointments.add(createAppointment(
                    String.valueOf(newId),
                    patientName,
                    doctorName,
                    date,
                    time,
                    type,
                    status,
                    notes != null ? notes : ""
            ));
        }

        response.sendRedirect("CounterAppointmentsServlet");
    }
}
