package medicalcentre;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Mock users
        String[][] users = {
            {"manager@apu.edu", "manager123", "manager", "John Manager"},
            {"counter@apu.edu", "counter123", "counter", "Sarah Counter"},
            {"doctor@apu.edu", "doctor123", "doctor", "Dr. Smith"},
            {"customer@apu.edu", "customer123", "customer", "Jane Customer"}
        };

        boolean authenticated = false;
        String userName = "";

        for (String[] user : users) {
            if (user[0].equals(email) && user[1].equals(password) && user[2].equals(role)) {
                authenticated = true;
                userName = user[3];
                break;
            }
        }

        if (authenticated) {
            HttpSession session = request.getSession();
            session.setAttribute("userName", userName);
            session.setAttribute("userRole", role);

            switch (role) {
                case "manager":
                    response.sendRedirect("managerDashboard.jsp");
                    break;
                case "counter":
                    response.sendRedirect("counterDashboard.jsp");
                    break;
                case "doctor":
                    response.sendRedirect("doctorDashboard.jsp");
                    break;
                case "customer":
                    response.sendRedirect("customerDashboard.jsp");
                    break;
                default:
                    response.sendRedirect("login.jsp?error=Invalid role");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid credentials or role");
        }
    }
}
