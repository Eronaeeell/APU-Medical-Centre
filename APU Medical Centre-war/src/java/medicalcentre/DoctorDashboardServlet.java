package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/DoctorDashboardServlet")
public class DoctorDashboardServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set active page for sidebar highlight
        request.setAttribute("activePage", "dashboard");


        request.setAttribute("todayAppointments", 5);
        request.setAttribute("totalPatients", 47);
        request.setAttribute("pendingReports", 2);
        request.setAttribute("recentFeedback", 8);


        List<Map<String, String>> appointments = new ArrayList<>();
        Map<String, String> appt1 = new HashMap<>();
        appt1.put("patient", "John Doe");
        appt1.put("reason", "Chest Pain");
        appt1.put("datetime", "Today, 10:00 AM");
        appt1.put("type", "Consultation");
        appointments.add(appt1);

        Map<String, String> appt2 = new HashMap<>();
        appt2.put("patient", "Alice Brown");
        appt2.put("reason", "Diabetes Checkup");
        appt2.put("datetime", "Today, 2:00 PM");
        appt2.put("type", "Follow-up");
        appointments.add(appt2);

        request.setAttribute("appointments", appointments);


        List<Map<String, String>> notes = new ArrayList<>();
        Map<String, String> note1 = new HashMap<>();
        note1.put("title", "Follow-up Advice Given");
        note1.put("desc", "Patient Alice - Diabetes management plan updated");
        note1.put("time", "10 minutes ago");
        note1.put("color", "success");
        notes.add(note1);

        Map<String, String> note2 = new HashMap<>();
        note2.put("title", "Prescription Issued");
        note2.put("desc", "Patient John Doe - Prescribed new medication");
        note2.put("time", "30 minutes ago");
        note2.put("color", "primary");
        notes.add(note2);

        Map<String, String> note3 = new HashMap<>();
        note3.put("title", "Lab Result Reviewed");
        note3.put("desc", "Patient Mike - Blood test reviewed");
        note3.put("time", "1 hour ago");
        note3.put("color", "warning");
        notes.add(note3);

        request.setAttribute("notes", notes);


        request.getRequestDispatcher("doctorDashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String patientName = request.getParameter("patientName");
        String noteType = request.getParameter("noteType");
        String details = request.getParameter("details");

        response.sendRedirect("DoctorDashboardServlet");
    }
}
