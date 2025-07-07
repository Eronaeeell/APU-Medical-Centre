package medicalcentre;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/ManagerStaffServlet")
public class ManagerStaffServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("activePage", "staffManagement");

        List<Map<String, String>> staffList = new ArrayList<>();

        // Mock data (replace with DAO in production)
        Map<String, String> staff1 = new HashMap<>();
        staff1.put("id", "1");
        staff1.put("name", "Dr. Emily Johnson");
        staff1.put("email", "emily.johnson@apu.edu");
        staff1.put("phone", "012-3456789");
        staff1.put("role", "Doctor");
        staff1.put("department", "Cardiology");
        staff1.put("status", "Active");
        staff1.put("joinDate", "2023-01-15");

        Map<String, String> staff2 = new HashMap<>();
        staff2.put("id", "2");
        staff2.put("name", "John Doe");
        staff2.put("email", "john.doe@apu.edu");
        staff2.put("phone", "019-8765432");
        staff2.put("role", "Counter Staff");
        staff2.put("department", "Reception");
        staff2.put("status", "Inactive");
        staff2.put("joinDate", "2022-11-01");

        Map<String, String> staff3 = new HashMap<>();
        staff3.put("id", "3");
        staff3.put("name", "Sarah Lee");
        staff3.put("email", "sarah.lee@apu.edu");
        staff3.put("phone", "017-1234567");
        staff3.put("role", "Nurse");
        staff3.put("department", "General");
        staff3.put("status", "Active");
        staff3.put("joinDate", "2024-05-20");

        staffList.add(staff1);
        staffList.add(staff2);
        staffList.add(staff3);

        // ======= Compute Summary Counts from staffList =======
        int totalStaff = staffList.size();
        int activeStaff = 0;
        int inactiveStaff = 0;
        Set<String> departments = new HashSet<>();

        for (Map<String, String> staff : staffList) {
            if ("Active".equalsIgnoreCase(staff.get("status"))) {
                activeStaff++;
            } else {
                inactiveStaff++;
            }
            departments.add(staff.get("department"));
        }

        int totalDepartments = departments.size();

        // Set attributes for JSP
        request.setAttribute("staffList", staffList);
        request.setAttribute("totalStaff", totalStaff);
        request.setAttribute("activeStaff", activeStaff);
        request.setAttribute("inactiveStaff", inactiveStaff);
        request.setAttribute("totalDepartments", totalDepartments);

        request.getRequestDispatcher("managerStaff.jsp").forward(request, response);
    }
}
