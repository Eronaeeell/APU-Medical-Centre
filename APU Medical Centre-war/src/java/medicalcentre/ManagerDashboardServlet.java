package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ManagerDashboardServlet")
public class ManagerDashboardServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Sidebar highlight
        request.setAttribute("activePage", "dashboard");

        // Mock data - replace with DAO calls later
        int totalStaff = 24;
        int todaysAppointments = 18;
        String monthlyRevenue = "RM 45,230";
        int reportsGenerated = 8;

        int activeDoctors = 8;
        int counterStaff = 6;
        int registeredCustomers = 342;
        int pendingAppointments = 12;

        // Attach to request
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("todaysAppointments", todaysAppointments);
        request.setAttribute("monthlyRevenue", monthlyRevenue);
        request.setAttribute("reportsGenerated", reportsGenerated);

        request.setAttribute("activeDoctors", activeDoctors);
        request.setAttribute("counterStaff", counterStaff);
        request.setAttribute("registeredCustomers", registeredCustomers);
        request.setAttribute("pendingAppointments", pendingAppointments);

        // Forward to JSP
        request.getRequestDispatcher("managerDashboard.jsp").forward(request, response);
    }
}
