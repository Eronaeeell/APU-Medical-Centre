package medicalcentre;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/CustomerAppointmentServlet")
public class CustomerAppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("userRole");

        if (role == null || !"customer".equals(role)) {
            response.sendRedirect("login.jsp?error=Please login as a customer to access appointments.");
            return;
        }

        // Simulated sample appointments, in real case, it would be retrieved from a database.
        List<Map<String, String>> appointments = new ArrayList<>();

        // Sample appointment 1
        Map<String, String> appt1 = new HashMap<>();
        appt1.put("id", "1");
        appt1.put("date", "2024-12-01");
        appt1.put("time", "10:00 AM");
        appt1.put("doctorName", "Dr. Smith");
        appt1.put("specialty", "Cardiology");
        appt1.put("type", "Consultation");
        appt1.put("reason", "Regular checkup and blood pressure monitoring");
        appt1.put("status", "Completed");
        appt1.put("diagnosis", "Hypertension - controlled");
        appt1.put("treatment", "Continue current medication, lifestyle modifications");
        appt1.put("notes", "Blood pressure well controlled. Patient compliant with medication.");
        appt1.put("totalCharge", "180.00");
        appt1.put("paymentStatus", "Paid");
        appt1.put("paymentDate", "2024-12-01");
        appt1.put("receiptNo", "RCP-2024-001");
        appointments.add(appt1);

        // Sample appointment 2
        Map<String, String> appt2 = new HashMap<>();
        appt2.put("id", "2");
        appt2.put("date", "2024-12-05");
        appt2.put("time", "3:00 PM");
        appt2.put("doctorName", "Dr. Johnson");
        appt2.put("specialty", "General Medicine");
        appt2.put("type", "Consultation");
        appt2.put("reason", "Annual health screening");
        appt2.put("status", "Scheduled");
        appt2.put("diagnosis", "");
        appt2.put("treatment", "");
        appt2.put("notes", "");
        appt2.put("totalCharge", "0.00");
        appt2.put("paymentStatus", "Pending");
        appt2.put("paymentDate", "");
        appt2.put("receiptNo", "");
        appointments.add(appt2);

        request.setAttribute("appointments", appointments);
        request.getRequestDispatcher("customerAppointment.jsp").forward(request, response);
    }
}
