package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/DoctorHistoryServlet")
public class DoctorHistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // In a real app, you’d load this from a database
        List<Map<String, Object>> patientHistory = getMockPatientHistory();

        request.setAttribute("patientHistory", patientHistory);
        request.getRequestDispatcher("doctorHistory.jsp").forward(request, response);
    }

    private List<Map<String, Object>> getMockPatientHistory() {
        List<Map<String, Object>> patients = new ArrayList<>();

        // --- Patient 1
        Map<String, Object> p1 = new HashMap<>();
        p1.put("patientId", 1);
        p1.put("patientName", "John Doe");
        p1.put("patientAge", 35);
        p1.put("patientGender", "Male");
        p1.put("totalVisits", 8);
        p1.put("lastVisit", "2024-12-01");
        p1.put("totalCharges", 1250.0);
        List<Map<String, Object>> a1list = new ArrayList<>();
        a1list.add(createAppointment(1, "2024-12-01", "10:00 AM", "Consultation", "Regular checkup and blood pressure monitoring", "Completed", "Hypertension - controlled", "Continue current medication, lifestyle modifications", Arrays.asList(new String[]{"Consultation", "Blood Pressure Check"}, new String[]{"150", "30"}), 180, "Blood pressure well controlled. Patient compliant with medication."));
        a1list.add(createAppointment(2, "2024-10-15", "2:30 PM", "Follow-up", "Blood pressure follow-up", "Completed", "Hypertension", "Medication adjustment", Arrays.asList(new String[]{"Follow-up", "Prescription"}, new String[]{"100", "45"}), 145, "Adjusted medication dosage due to slightly elevated readings."));
        a1list.add(createAppointment(3, "2024-08-20", "11:00 AM", "Consultation", "Initial consultation for high blood pressure", "Completed", "Newly diagnosed hypertension", "Started on ACE inhibitor, dietary counseling", Arrays.asList(new String[]{"Consultation", "ECG", "Blood Test"}, new String[]{"150", "80", "120"}), 350, "New patient with elevated BP. Started treatment plan."));
        p1.put("appointments", a1list);

        // --- Patient 2
        Map<String, Object> p2 = new HashMap<>();
        p2.put("patientId", 2);
        p2.put("patientName", "Jane Smith");
        p2.put("patientAge", 28);
        p2.put("patientGender", "Female");
        p2.put("totalVisits", 5);
        p2.put("lastVisit", "2024-11-28");
        p2.put("totalCharges", 875.0);
        List<Map<String, Object>> a2list = new ArrayList<>();
        a2list.add(createAppointment(4, "2024-11-28", "11:30 AM", "Follow-up", "Follow-up for skin condition treatment", "Completed", "Eczema - improving", "Continue topical treatment, reduce frequency", Arrays.asList(new String[]{"Follow-up", "Prescription"}, new String[]{"100", "45"}), 145, "Significant improvement in skin condition. Reducing treatment frequency."));
        a2list.add(createAppointment(5, "2024-09-10", "3:00 PM", "Consultation", "Skin rash and irritation", "Completed", "Atopic dermatitis (Eczema)", "Topical corticosteroids, moisturizers, lifestyle advice", Arrays.asList(new String[]{"Consultation", "Skin Examination", "Prescription"}, new String[]{"150", "75", "45"}), 270, "Diagnosed with eczema. Started comprehensive treatment plan."));
        p2.put("appointments", a2list);

        // --- Patient 3
        Map<String, Object> p3 = new HashMap<>();
        p3.put("patientId", 3);
        p3.put("patientName", "Mike Wilson");
        p3.put("patientAge", 42);
        p3.put("patientGender", "Male");
        p3.put("totalVisits", 3);
        p3.put("lastVisit", "2024-11-30");
        p3.put("totalCharges", 650.0);
        List<Map<String, Object>> a3list = new ArrayList<>();
        a3list.add(createAppointment(6, "2024-11-30", "2:00 PM", "Consultation", "Chest pain and shortness of breath", "Completed", "Anxiety-related chest pain, rule out cardiac causes", "Stress management, follow-up with cardiologist if needed", Arrays.asList(new String[]{"Consultation", "ECG", "Chest X-Ray"}, new String[]{"150", "80", "200"}), 430, "Cardiac workup normal. Likely anxiety-related symptoms. Counseling provided."));
        p3.put("appointments", a3list);

        patients.add(p1); patients.add(p2); patients.add(p3);
        return patients;
    }

    private Map<String, Object> createAppointment(int id, String date, String time, String type, String reason, String status, String diagnosis, String treatment, List<String[]> serviceAndFees, double totalCharge, String notes) {
        Map<String, Object> a = new HashMap<>();
        a.put("id", id);
        a.put("date", date);
        a.put("time", time);
        a.put("type", type);
        a.put("reason", reason);
        a.put("status", status);
        a.put("diagnosis", diagnosis);
        a.put("treatment", treatment);

        List<Map<String, Object>> charges = new ArrayList<>();
        String[] services = serviceAndFees.get(0), fees = serviceAndFees.get(1);
        for (int i = 0; i < services.length; i++) {
            Map<String, Object> c = new HashMap<>();
            c.put("service", services[i]);
            c.put("fee", Double.parseDouble(fees[i]));
            charges.add(c);
        }
        a.put("charges", charges);
        a.put("totalCharge", totalCharge);
        a.put("notes", notes);
        return a;
    }
}
