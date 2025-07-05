package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/CustomerPaymentServlet")
public class CustomerPaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String role = (String) session.getAttribute("userRole");
        if (role == null || !"customer".equals(role)) {
            response.sendRedirect("login.jsp?error=Please login as a customer to access payments.");
            return;
        }

        request.setAttribute("activePage", "payments");

        // Mock paid payments
        List<Map<String, String>> payments = new ArrayList<>();
        payments.add(createPayment("RCP-2024-001", "John Doe", "Dr. Smith", "Consultation, Blood Test", "250.00", "Cash", "Paid", "2024-12-01", "10:30 AM"));
        payments.add(createPayment("RCP-2024-002", "Jane Smith", "Dr. Johnson", "Follow-up, Prescription", "150.00", "Card", "Paid", "2024-12-01", "2:15 PM"));
        payments.add(createPayment("RCP-2024-003", "Mike Wilson", "Dr. Wong", "Consultation, X-Ray", "320.00", "Cash", "Pending", "2024-12-02", "9:00 AM"));

        request.setAttribute("payments", payments);

        // Mock pending charges
        List<Map<String, String>> pendingCharges = new ArrayList<>();
        pendingCharges.add(createPending("Alice Brown", "Dr. Smith", "2024-12-02", "Consultation, ECG", "280.00"));
        pendingCharges.add(createPending("Bob Johnson", "Dr. Wong", "2024-12-02", "Skin Treatment, Medication", "195.00"));

        request.setAttribute("pendingCharges", pendingCharges);

        request.getRequestDispatcher("customerPayment.jsp").forward(request, response);
    }

    private Map<String, String> createPayment(String receipt, String patient, String doctor, String services, String amount, String method, String status, String date, String time) {
        Map<String, String> map = new HashMap<>();
        map.put("receiptNo", receipt);
        map.put("patientName", patient);
        map.put("doctorName", doctor);
        map.put("services", services);
        map.put("amount", amount);
        map.put("method", method);
        map.put("status", status);
        map.put("date", date);
        map.put("time", time);
        return map;
    }

    private Map<String, String> createPending(String patient, String doctor, String date, String services, String amount) {
        Map<String, String> map = new HashMap<>();
        map.put("patientName", patient);
        map.put("doctorName", doctor);
        map.put("date", date);
        map.put("services", services);
        map.put("amount", amount);
        return map;
    }
}
