import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet("/ManagerReportServlet")
public class ManagerReportServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get or create recent reports in session (for demo; use DB for production)
        HttpSession session = request.getSession();
        List<Map<String, Object>> recentReports =
                (List<Map<String, Object>>) session.getAttribute("recentReports");

        if (recentReports == null) {
            recentReports = getSampleReports();
            session.setAttribute("recentReports", recentReports);
        }

        request.setAttribute("recentReports", recentReports);
        request.setAttribute("activePage", "report");
        request.getRequestDispatcher("managerReport.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("type");
        String period = request.getParameter("period");
        String format = request.getParameter("format");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        HttpSession session = request.getSession();
        List<Map<String, Object>> recentReports =
                (List<Map<String, Object>>) session.getAttribute("recentReports");

        if (recentReports == null) {
            recentReports = new ArrayList<>();
        }

        // Generate report name
        String typeName = getReportTypeName(type);
        String periodName = getPeriodName(period);
        String today = new SimpleDateFormat("yyyy-MM-dd").format(new Date());

        String reportName = typeName + " - " + periodName + " " + today;
        if ("custom".equals(period) && dateFrom != null && dateTo != null && !dateFrom.isEmpty() && !dateTo.isEmpty()) {
            reportName = typeName + " - Custom Range (" + dateFrom + " to " + dateTo + ")";
        }

        // Generate size (random for demo)
        double sizeMB = Math.round((new Random().nextDouble() * 3 + 1) * 10.0) / 10.0;
        int newId = recentReports.stream().mapToInt(r -> (int) r.get("id")).max().orElse(0) + 1;

        Map<String, Object> newReport = new HashMap<>();
        newReport.put("id", newId);
        newReport.put("name", reportName);
        newReport.put("date", today);
        newReport.put("type", typeName);
        newReport.put("status", "Generated");
        newReport.put("size", String.format("%.1f MB", sizeMB));
        newReport.put("format", format);

        // Insert at the top
        recentReports.add(0, newReport);

        session.setAttribute("recentReports", recentReports);

        // Set feedback or success message if needed
        request.setAttribute("activePage", "report");
        request.setAttribute("recentReports", recentReports);
        request.setAttribute("success", "Report \"" + reportName + "\" has been generated successfully!");
        request.getRequestDispatcher("managerReport.jsp").forward(request, response);
    }

    private List<Map<String, Object>> getSampleReports() {
        List<Map<String, Object>> sample = new ArrayList<>();
        sample.add(createReport(1, "Monthly Financial Report - December 2024", "2024-12-06", "Financial", "Generated", "2.3 MB"));
        sample.add(createReport(2, "Staff Performance Q4 2024", "2024-11-28", "Staff", "Generated", "1.8 MB"));
        sample.add(createReport(3, "Patient Satisfaction Survey Results", "2024-11-25", "Patient", "Generated", "3.1 MB"));
        sample.add(createReport(4, "Appointment Efficiency Report", "2024-11-20", "Operations", "Generated", "1.5 MB"));
        sample.add(createReport(5, "Revenue Analysis October 2024", "2024-11-01", "Financial", "Generated", "2.7 MB"));
        return sample;
    }

    private Map<String, Object> createReport(int id, String name, String date, String type, String status, String size) {
        Map<String, Object> m = new HashMap<>();
        m.put("id", id);
        m.put("name", name);
        m.put("date", date);
        m.put("type", type);
        m.put("status", status);
        m.put("size", size);
        return m;
    }

    private String getReportTypeName(String type) {
        if ("financial".equals(type)) return "Financial Report";
        if ("staff".equals(type)) return "Staff Performance Report";
        if ("appointments".equals(type)) return "Appointment Analytics Report";
        if ("patients".equals(type)) return "Patient Demographics Report";
        return "Unknown Report";
    }

    private String getPeriodName(String period) {
        if ("week".equals(period)) return "Weekly";
        if ("month".equals(period)) return "Monthly";
        if ("quarter".equals(period)) return "Quarterly";
        if ("year".equals(period)) return "Annual";
        if ("custom".equals(period)) return "Custom Range";
        return "";
    }
}
