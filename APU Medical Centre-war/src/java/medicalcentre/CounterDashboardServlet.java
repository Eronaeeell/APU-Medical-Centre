package medicalcentre;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CounterDashboardServlet")
public class CounterDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session role validation
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");

        if (role == null || !role.equals("counter")) {
            response.sendRedirect("login.jsp?error=Please login as counter staff.");
            return;
        }

        // Mock dashboard data
        request.setAttribute("todaysCustomers", 32);
        request.setAttribute("appointmentsBooked", 18);
        request.setAttribute("paymentsCollected", "RM 2,450");
        request.setAttribute("pendingTasks", 5);

        request.getRequestDispatcher("counterDashboard.jsp").forward(request, response);
    }
}
