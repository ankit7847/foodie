package com.operations;
import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.*;

@WebServlet("/ChatbotServlet")
public class ChatbotServlet extends HttpServlet {
    // 1. IMPORTANT: GO TO https://aistudio.google.com/ AND GET A NEW KEY. 
    // The key below is public now and will not work reliably.
    private static final String API_KEY = "AIzaSyCJnx2XvcLOC04fVv3BHuyJcsBb9YK4N-U"; 

    // 2. UPDATED URL: Changed 'v1beta' to 'v1' and using 'gemini-1.5-flash'
 // Using the model confirmed in your list
    private static final String API_URL = 
    	    "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String userMessage = request.getParameter("message");
        response.setContentType("text/plain;charset=UTF-8");

        if (userMessage == null || userMessage.trim().isEmpty()) {
            response.getWriter().write("Error: Message is empty.");
            return;
        }

        try {
            // Build JSON Request Body
            JSONObject textPart = new JSONObject();
            textPart.put("text", userMessage);

            JSONArray parts = new JSONArray();
            parts.put(textPart);

            JSONObject content = new JSONObject();
            content.put("parts", parts);

            JSONArray contents = new JSONArray();
            contents.put(content);

            JSONObject body = new JSONObject();
            body.put("contents", contents);

            // Setup Connection
            URL url = new URL(API_URL + API_KEY);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);

            // Send Request
            try (OutputStream os = conn.getOutputStream()) {
                os.write(body.toString().getBytes("UTF-8"));
            }

            // Handle Response
            int status = conn.getResponseCode();
            InputStream is = (status >= 200 && status < 300) ? conn.getInputStream() : conn.getErrorStream();
            
            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) {
                    sb.append(line);
                }
            }

            // Log Response for Debugging
            System.out.println("Status Code: " + status);
            System.out.println("API Response: " + sb.toString());

            JSONObject result = new JSONObject(sb.toString());

            // Handle API Errors
            if (result.has("error")) {
                response.getWriter().write("API Error: " + result.getJSONObject("error").getString("message"));
                return;
            }

            // Parse and return the chatbot's reply
            String reply = result
                    .getJSONArray("candidates")
                    .getJSONObject(0)
                    .getJSONObject("content")
                    .getJSONArray("parts")
                    .getJSONObject(0)
                    .getString("text");

            response.getWriter().write(reply);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Server Error: " + e.getMessage());
        }
    }
}