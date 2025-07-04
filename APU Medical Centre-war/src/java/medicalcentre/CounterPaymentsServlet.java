package medicalcentre;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CounterPaymentsServlet")
public class CounterPaymentsServlet extends HttpServlet {

    @Override
    public void init() throws ServletException {
        if (getServletContext().getAttribute("payments") == null) {
            List<Map<String, String>> payments = new ArrayList<>();
            payments.add(createPayment("RCP-2024-001", "John Doe", "Dr. Smith", "Consultation, Blood Test", "250.00", "Cash", "Paid"));
            payments.add(createPayment("RCP-2024-002", "Jane Smith", "Dr. Johnson", "Follow-up, Prescription", "150.00", "Card", "Paid"));
            getServletContext().setAttribute("payments", payments);
        }

        if (getServletContext().getAttribute("pendingCharges") == null) {
            List<Map<String, String>> pendingCharges = new ArrayList<>();
            pendingCharges.add(createPendingCharge("1", "Alice Brown", "Dr. Smith", "2024-12-02", "Consultation, ECG", "280.00"));
            pendingCharges.add(createPendingCharge("2", "Bob Johnson", "Dr. Wong", "2024-12-02", "Skin Treatment, Medication", "195.00"));
            pendingCharges.add(createPendingCharge("3", "Charlie Lee", "Dr. Johnson", "2024-12-02", "Follow-up, Blood Test", "230.00"));
            getServletContext().setAttribute("pendingCharges", pendingCharges);
        }
    }

    private Map<String, String> createPayment(String receiptNo, String patientName, String doctorName, String services,
                                              String amount, String paymentMethod, String status) {
        Map<String, String> payment = new HashMap<>();
        payment.put("receiptNo", receiptNo);
        payment.put("patientName", patientName);
        payment.put("doctorName", doctorName);
        payment.put("services", services);
        payment.put("amount", amount);
        payment.put("paymentMethod", paymentMethod);
        payment.put("status", status);
        payment.put("date", "2024-12-01");
        payment.put("time", "10:30 AM");
        return payment;
    }

    private Map<String, String> createPendingCharge(String id, String patientName, String doctorName, String date,
                                                    String services, String totalAmount) {
        Map<String, String> charge = new HashMap<>();
        charge.put("id", id);
        charge.put("patientName", patientName);
        charge.put("doctorName", doctorName);
        charge.put("appointmentDate", date);
        charge.put("services", services);
        charge.put("totalAmount", totalAmount);
        charge.put("status", "Pending Payment");
        return charge;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !role.equals("counter")) {
            response.sendRedirect("login.jsp?error=Please login as counter staff.");
            return;
        }

        request.setAttribute("activePage", "payments");
        request.setAttribute("payments", getServletContext().getAttribute("payments"));
        request.setAttribute("pendingCharges", getServletContext().getAttribute("pendingCharges"));
        request.getRequestDispatcher("counterPayments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("collect".equals(action)) {
            String id = request.getParameter("id");
            String paymentMethod = request.getParameter("paymentMethod");

            List<Map<String, String>> pendingCharges =
                    (List<Map<String, String>>) getServletContext().getAttribute("pendingCharges");
            List<Map<String, String>> payments =
                    (List<Map<String, String>>) getServletContext().getAttribute("payments");

            Map<String, String> collectedCharge = null;
            for (Map<String, String> charge : pendingCharges) {
                if (charge.get("id").equals(id)) {
                    collectedCharge = charge;
                    break;
                }
            }

            if (collectedCharge != null) {
                pendingCharges.remove(collectedCharge);

                String receiptNo = "RCP-2024-" + String.format("%03d", payments.size() + 1);

                Map<String, String> payment = new HashMap<>();
                payment.put("receiptNo", receiptNo);
                payment.put("patientName", collectedCharge.get("patientName"));
                payment.put("doctorName", collectedCharge.get("doctorName"));
                payment.put("services", collectedCharge.get("services"));
                payment.put("amount", collectedCharge.get("totalAmount"));
                payment.put("paymentMethod", paymentMethod);
                payment.put("status", "Paid");
                payment.put("date", new java.text.SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                payment.put("time", new java.text.SimpleDateFormat("hh:mm a").format(new Date()));

                payments.add(0, payment); // add to top of list
            }
        }

        response.sendRedirect("CounterPaymentsServlet");
    }
}
