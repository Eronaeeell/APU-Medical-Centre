package medicalcentre;

import java.io.IOException;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CounterCustomersServlet")
public class CounterCustomersServlet extends HttpServlet {

    private Map<String, String> createCustomer(String id, String name, String email, String phone, String age, String gender, String address, String joinDate, String lastVisit, String status) {
        Map<String, String> c = new HashMap<>();
        c.put("id", id);
        c.put("name", name);
        c.put("email", email);
        c.put("phone", phone);
        c.put("age", age);
        c.put("gender", gender);
        c.put("address", address);
        c.put("joinDate", joinDate);
        c.put("lastVisit", lastVisit);
        c.put("status", status);
        return c;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");
        if (role == null || !role.equals("counter")) {
            response.sendRedirect("login.jsp?error=Please login as counter staff.");
            return;
        }

        List<Map<String, String>> customers = (List<Map<String, String>>) session.getAttribute("customers");

        if (customers == null) {
            customers = new ArrayList<>();
            customers.add(createCustomer("1", "John Doe", "john.doe@email.com", "+60123456789", "35", "Male", "123 Jalan Bukit Bintang, KL", "2023-01-15", "2024-11-20", "active"));
            customers.add(createCustomer("2", "Jane Smith", "jane.smith@email.com", "+60123456790", "28", "Female", "456 Jalan Ampang, KL", "2023-03-20", "2024-11-25", "active"));
            customers.add(createCustomer("3", "Mike Wilson", "mike.wilson@email.com", "+60123456791", "42", "Male", "789 Jalan Tun Razak, KL", "2023-02-10", "2024-10-15", "inactive"));
            session.setAttribute("customers", customers);
        }

        String deleteId = request.getParameter("deleteId");
        if (deleteId != null) {
            customers.removeIf(c -> c.get("id").equals(deleteId));
        }

        String search = request.getParameter("search");
        List<Map<String, String>> filteredCustomers = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            for (Map<String, String> c : customers) {
                if (c.get("name").toLowerCase().contains(search.toLowerCase()) ||
                        c.get("email").toLowerCase().contains(search.toLowerCase()) ||
                        c.get("phone").contains(search)) {
                    filteredCustomers.add(c);
                }
            }
        } else {
            filteredCustomers = customers;
        }

        request.setAttribute("customers", filteredCustomers);
        request.setAttribute("activePage", "customers");
        request.getRequestDispatcher("counterCustomers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        List<Map<String, String>> customers = (List<Map<String, String>>) session.getAttribute("customers");

        String action = request.getParameter("action");
        if ("edit".equals(action)) {
            String id = request.getParameter("id");
            for (Map<String, String> c : customers) {
                if (c.get("id").equals(id)) {
                    c.put("name", request.getParameter("name"));
                    c.put("email", request.getParameter("email"));
                    c.put("phone", request.getParameter("phone"));
                    c.put("age", request.getParameter("age"));
                    c.put("gender", request.getParameter("gender"));
                    c.put("address", request.getParameter("address"));
                    break;
                }
            }
        } else {
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String age = request.getParameter("age");
            String gender = request.getParameter("gender");
            String address = request.getParameter("address");

            String id = String.valueOf(customers.stream().mapToInt(c -> Integer.parseInt(c.get("id"))).max().orElse(0) + 1);
            String joinDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());

            customers.add(createCustomer(id, name, email, phone, age, gender, address, joinDate, "Never", "active"));
        }

        session.setAttribute("customers", customers);
        response.sendRedirect("CounterCustomersServlet");
    }
}
