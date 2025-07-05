package medicalcentre;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/CustomerFeedbackServlet")
public class CustomerFeedbackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext context = getServletContext();

        // Retrieve or initialize feedbackHistory
        List<Map<String, String>> feedbackHistory = (List<Map<String, String>>) context.getAttribute("feedbackHistory");
        if (feedbackHistory == null) {
            feedbackHistory = new ArrayList<>();

            Map<String, String> fb1 = new HashMap<>();
            fb1.put("id", UUID.randomUUID().toString());
            fb1.put("appointmentDate", "2024-10-15");
            fb1.put("doctorName", "Dr. Smith");
            fb1.put("counterStaff", "Sarah Counter");
            fb1.put("type", "Consultation");
            fb1.put("doctorRating", "5");
            fb1.put("counterStaffRating", "4");
            fb1.put("overallExperience", "Excellent");
            fb1.put("doctorFeedback", "Very professional and clear explanations.");
            fb1.put("counterStaffFeedback", "Friendly and efficient.");
            fb1.put("suggestions", "Extend operation hours.");
            fb1.put("dateSubmitted", "2024-10-15");
            fb1.put("status", "Reviewed");
            feedbackHistory.add(fb1);

            Map<String, String> fb2 = new HashMap<>();
            fb2.put("id", UUID.randomUUID().toString());
            fb2.put("appointmentDate", "2024-09-01");
            fb2.put("doctorName", "Dr. Lee");
            fb2.put("counterStaff", "John Counter");
            fb2.put("type", "Follow-up");
            fb2.put("doctorRating", "4");
            fb2.put("counterStaffRating", "5");
            fb2.put("overallExperience", "Good");
            fb2.put("doctorFeedback", "Helpful follow-up consultation.");
            fb2.put("counterStaffFeedback", "Fast payment processing.");
            fb2.put("suggestions", "More parking space would be helpful.");
            fb2.put("dateSubmitted", "2024-09-02");
            fb2.put("status", "Submitted");
            feedbackHistory.add(fb2);

            context.setAttribute("feedbackHistory", feedbackHistory);
        }

        // Retrieve or initialize pendingFeedback
        List<Map<String, String>> pendingFeedback = (List<Map<String, String>>) context.getAttribute("pendingFeedback");
        if (pendingFeedback == null) {
            pendingFeedback = new ArrayList<>();
            Map<String, String> pending1 = new HashMap<>();
            pending1.put("id", "1");
            pending1.put("date", "2024-12-01");
            pending1.put("doctorName", "Dr. Smith");
            pending1.put("counterStaff", "Sarah Counter");
            pending1.put("type", "Consultation");
            pendingFeedback.add(pending1);

            Map<String, String> pending2 = new HashMap<>();
            pending2.put("id", "2");
            pending2.put("date", "2024-12-05");
            pending2.put("doctorName", "Dr. Lee");
            pending2.put("counterStaff", "John Counter");
            pending2.put("type", "Follow-up");
            pendingFeedback.add(pending2);

            context.setAttribute("pendingFeedback", pendingFeedback);
        }

        // Pass to JSP
        request.setAttribute("feedbackHistory", feedbackHistory);
        request.setAttribute("pendingFeedback", pendingFeedback);

        RequestDispatcher dispatcher = request.getRequestDispatcher("customerFeedback.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ServletContext context = getServletContext();

        List<Map<String, String>> feedbackHistory = (List<Map<String, String>>) context.getAttribute("feedbackHistory");
        if (feedbackHistory == null) {
            feedbackHistory = new ArrayList<>();
            context.setAttribute("feedbackHistory", feedbackHistory);
        }

        List<Map<String, String>> pendingFeedback = (List<Map<String, String>>) context.getAttribute("pendingFeedback");
        if (pendingFeedback == null) {
            pendingFeedback = new ArrayList<>();
            context.setAttribute("pendingFeedback", pendingFeedback);
        }

        // Retrieve form data
        String id = request.getParameter("id");
        String date = request.getParameter("date");
        String doctorName = request.getParameter("doctorName");
        String counterStaff = request.getParameter("counterStaff");
        String type = request.getParameter("type");
        String doctorRating = request.getParameter("doctorRating");
        String counterStaffRating = request.getParameter("counterStaffRating");
        String overallExperience = request.getParameter("overallExperience");
        String doctorFeedback = request.getParameter("doctorFeedback");
        String counterStaffFeedback = request.getParameter("counterStaffFeedback");
        String suggestions = request.getParameter("suggestions");

        // Create feedback map
        Map<String, String> feedback = new HashMap<>();
        feedback.put("id", UUID.randomUUID().toString());
        feedback.put("appointmentDate", date);
        feedback.put("doctorName", doctorName);
        feedback.put("counterStaff", counterStaff);
        feedback.put("type", type);
        feedback.put("doctorRating", doctorRating);
        feedback.put("counterStaffRating", counterStaffRating);
        feedback.put("overallExperience", overallExperience);
        feedback.put("doctorFeedback", doctorFeedback);
        feedback.put("counterStaffFeedback", counterStaffFeedback);
        feedback.put("suggestions", suggestions != null ? suggestions : "-");
        feedback.put("dateSubmitted", java.time.LocalDate.now().toString());
        feedback.put("status", "Submitted");

        feedbackHistory.add(0, feedback);

        // Remove from pendingFeedback if ID matches
        if (id != null && !id.isEmpty()) {
            pendingFeedback.removeIf(apt -> id.equals(apt.get("id")));
        }

        // Redirect back to servlet
        response.sendRedirect("CustomerFeedbackServlet");
    }
}
