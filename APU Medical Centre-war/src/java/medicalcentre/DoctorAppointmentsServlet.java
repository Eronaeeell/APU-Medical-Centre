package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/DoctorAppointmentsServlet")
public class DoctorAppointmentsServlet extends HttpServlet {
    private List<Map<String, Object>> appointments;

    @Override
    public void init() throws ServletException {
        // -- Set up mock data for demonstration --
        appointments = new ArrayList<>();
        appointments.add(makeAppt(1, "John Doe", 35, "Male", "+60123456789", "john.doe@email.com",
                "123 Jalan Bukit Bintang, KL", "2024-12-02", "10:00 AM", "Consultation",
                "Regular checkup and blood pressure monitoring", "Confirmed",
                "Patient has history of hypertension",
                Arrays.asList("Hypertension", "Diabetes Type 2"),
                Arrays.asList("Penicillin"),
                Arrays.asList("Metformin 500mg", "Lisinopril 10mg")
        ));
        appointments.add(makeAppt(2, "Jane Smith", 28, "Female", "+60123456790", "jane.smith@email.com",
                "456 Jalan Ampang, KL", "2024-12-02", "11:30 AM", "Follow-up",
                "Follow-up for skin condition treatment", "In Progress",
                "Skin condition improving, continue current treatment",
                Arrays.asList("Eczema"),
                Arrays.asList("None known"),
                Arrays.asList("Hydrocortisone cream")
        ));
        appointments.add(makeAppt(3, "Mike Wilson", 42, "Male", "+60123456791", "mike.wilson@email.com",
                "789 Jalan Tun Razak, KL", "2024-12-02", "2:00 PM", "Consultation",
                "Chest pain and shortness of breath", "Scheduled",
                "Urgent consultation required",
                Arrays.asList("High cholesterol"),
                Arrays.asList("Aspirin"),
                Arrays.asList("Atorvastatin 20mg")
        ));
        appointments.add(makeAppt(4, "Sarah Johnson", 31, "Female", "+60123456792", "sarah.johnson@email.com",
                "321 Jalan Raja Chulan, KL", "2024-12-03", "9:00 AM", "Check-up",
                "Annual health screening", "Scheduled",
                "Routine annual checkup",
                Arrays.asList("None"),
                Arrays.asList("None known"),
                Arrays.asList("Multivitamin")
        ));
    }

    private Map<String, Object> makeAppt(int id, String name, int age, String gender, String phone, String email, String addr,
                                         String date, String time, String type, String reason, String status, String notes,
                                         List<String> history, List<String> allergies, List<String> meds) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("patientName", name);
        map.put("patientAge", age);
        map.put("patientGender", gender);
        map.put("patientPhone", phone);
        map.put("patientEmail", email);
        map.put("patientAddress", addr);
        map.put("appointmentDate", date);
        map.put("appointmentTime", time);
        map.put("appointmentType", type);
        map.put("reason", reason);
        map.put("status", status);
        map.put("notes", notes);
        map.put("medicalHistory", history);
        map.put("allergies", allergies);
        map.put("currentMedications", meds);
        return map;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Handle AJAX details modal (optional)
        String detailsIdx = request.getParameter("details");
        String tab = request.getParameter("tab");
        if (detailsIdx != null && tab != null) {
            int idx = Integer.parseInt(detailsIdx);
            List<Map<String, Object>> list;
            if ("today".equals(tab)) list = filterByDate(appointments, "2024-12-02");
            else if ("upcoming".equals(tab)) list = filterUpcoming(appointments, "2024-12-02");
            else list = appointments;

            if (idx >= 0 && idx < list.size()) {
                Map<String, Object> apt = list.get(idx);
                request.setAttribute("apt", apt);
                request.getRequestDispatcher("doctorAppointmentDetailsModal.jsp").forward(request, response);
                return;
            }
        }

        // --- Tab Filtering ---
        List<Map<String, Object>> today = filterByDate(appointments, "2024-12-02");
        List<Map<String, Object>> upcoming = filterUpcoming(appointments, "2024-12-02");
        List<Map<String, Object>> all = appointments;

        request.setAttribute("todayAppointments", today);
        request.setAttribute("upcomingAppointments", upcoming);
        request.setAttribute("allAppointments", all);

        // Stats
        request.setAttribute("todayCount", today.size());
        request.setAttribute("completedTodayCount", (int) today.stream().filter(a -> "Completed".equals(a.get("status"))).count());
        request.setAttribute("inProgressTodayCount", (int) today.stream().filter(a -> "In Progress".equals(a.get("status"))).count());
        request.setAttribute("upcomingCount", upcoming.size());

        request.setAttribute("activePage", "appointments");

        request.getRequestDispatcher("doctorAppointments.jsp").forward(request, response);
    }

    private List<Map<String, Object>> filterByDate(List<Map<String, Object>> appts, String date) {
        List<Map<String, Object>> filtered = new ArrayList<>();
        for (Map<String, Object> apt : appts) {
            if (date.equals(apt.get("appointmentDate"))) {
                filtered.add(apt);
            }
        }
        return filtered;
    }
    private List<Map<String, Object>> filterUpcoming(List<Map<String, Object>> appts, String date) {
        List<Map<String, Object>> filtered = new ArrayList<>();
        for (Map<String, Object> apt : appts) {
            String aptDate = (String) apt.get("appointmentDate");
            if (aptDate.compareTo(date) > 0) filtered.add(apt);
        }
        return filtered;
    }
}
