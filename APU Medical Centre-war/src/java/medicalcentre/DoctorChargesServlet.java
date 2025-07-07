package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/DoctorChargesServlet")
public class DoctorChargesServlet extends HttpServlet {
    private List<Map<String, Object>> completedAppointments;
    private List<Map<String, Object>> charges;
    private List<Map<String, Object>> predefinedServices;

    @Override
    public void init() throws ServletException {
        // Appointments awaiting charges
        completedAppointments = new ArrayList<>();
        completedAppointments.add(makeAppointment(1, "John Doe", "2024-12-01", "10:00 AM", "Consultation", "Regular checkup and blood pressure monitoring", "Completed", false));
        completedAppointments.add(makeAppointment(2, "Jane Smith", "2024-12-01", "11:30 AM", "Follow-up", "Follow-up for skin condition treatment", "Completed", false));

        // Existing charges
        charges = new ArrayList<>();
        charges.add(makeCharge(1, "Mike Wilson", "2024-11-30",
            Arrays.asList(
                makeService("Consultation", 150.0),
                makeService("ECG", 80.0),
                makeService("Blood Test", 120.0)
            ), 350.0, "Submitted", "Routine cardiac checkup with tests", "2024-11-30"));
        charges.add(makeCharge(2, "Sarah Johnson", "2024-11-29",
            Arrays.asList(
                makeService("Consultation", 150.0),
                makeService("Prescription", 45.0)
            ), 195.0, "Paid", "Follow-up consultation with medication", "2024-11-29"));

        // Predefined services
        predefinedServices = new ArrayList<>();
        predefinedServices.add(makeService("Consultation", 150.0));
        predefinedServices.add(makeService("Follow-up", 100.0));
        predefinedServices.add(makeService("ECG", 80.0));
        predefinedServices.add(makeService("Blood Test", 120.0));
        predefinedServices.add(makeService("X-Ray", 200.0));
        predefinedServices.add(makeService("Ultrasound", 250.0));
        predefinedServices.add(makeService("Prescription", 45.0));
        predefinedServices.add(makeService("Injection", 60.0));
        predefinedServices.add(makeService("Dressing", 35.0));
        predefinedServices.add(makeService("Minor Surgery", 500.0));
    }

    private Map<String, Object> makeAppointment(int id, String patient, String date, String time, String type, String reason, String status, boolean chargesEntered) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("patientName", patient);
        map.put("appointmentDate", date);
        map.put("appointmentTime", time);
        map.put("appointmentType", type);
        map.put("reason", reason);
        map.put("status", status);
        map.put("chargesEntered", chargesEntered);
        return map;
    }

    private Map<String, Object> makeCharge(int id, String patient, String date, List<Map<String, Object>> services, double total, String status, String notes, String dateEntered) {
        Map<String, Object> map = new HashMap<>();
        map.put("id", id);
        map.put("patientName", patient);
        map.put("appointmentDate", date);
        map.put("services", services);
        map.put("totalAmount", total);
        map.put("status", status);
        map.put("notes", notes);
        map.put("dateEntered", dateEntered);
        return map;
    }

    private Map<String, Object> makeService(String name, double fee) {
        Map<String, Object> map = new HashMap<>();
        map.put("name", name);
        map.put("fee", fee);
        return map;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        req.setAttribute("completedAppointments", completedAppointments);
        req.setAttribute("charges", charges);
        req.setAttribute("predefinedServices", predefinedServices);

        // Statistics
        int pendingCharges = 0, totalSubmitted = charges.size(), paidCharges = 0;
        double todaysCharges = 0;
        String today = "2024-12-01";
        for (Map<String, Object> c : charges) {
            if (today.equals(c.get("dateEntered"))) {
                todaysCharges += (Double) c.get("totalAmount");
            }
            if ("Paid".equals(c.get("status"))) paidCharges++;
        }
        for (Map<String, Object> apt : completedAppointments) {
            if (!(Boolean) apt.get("chargesEntered")) pendingCharges++;
        }

        req.setAttribute("pendingCharges", pendingCharges);
        req.setAttribute("todaysCharges", todaysCharges);
        req.setAttribute("totalSubmitted", totalSubmitted);
        req.setAttribute("paidCharges", paidCharges);

        req.setAttribute("activePage", "charges");
        req.getRequestDispatcher("doctorCharges.jsp").forward(req, resp);
    }
}
