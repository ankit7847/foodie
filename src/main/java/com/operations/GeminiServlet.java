package com.operations;
import java.io.*;
import java.net.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.json.*;

public class GeminiServlet extends HttpServlet {
    private static final String API_KEY = "AIzaSyBx3IftCMuNeXQ5OJKOalqeUFvae_0QlJM";
    private static final String GEMINI_URL = 
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + API_KEY;
    
    private static final String SYSTEM_PROMPT = 
        "You are a helpful AI assistant for FDelivery, a food delivery website. " +
        "Help users with menu, orders, delivery (30-45 mins, free above ₹199), " +
        "and payments (UPI, Cards, COD). Keep answers short and friendly.";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Access-Control-Allow-Origin", "*");

        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) sb.append(line);
        }

        JSONObject incoming = new JSONObject(sb.toString());
        JSONArray history = incoming.getJSONArray("contents");

        JSONObject body = new JSONObject();
        body.put("contents", history);

        JSONObject sysInstruction = new JSONObject();
        JSONArray sysParts = new JSONArray();
        JSONObject sysPart = new JSONObject();
        sysPart.put("text", SYSTEM_PROMPT);
        sysParts.put(sysPart);
        sysInstruction.put("parts", sysParts);
        body.put("system_instruction", sysInstruction);

        URL url = new URL(GEMINI_URL);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);
        conn.setConnectTimeout(10000);
        conn.setReadTimeout(15000);

        try (OutputStream os = conn.getOutputStream()) {
            os.write(body.toString().getBytes("UTF-8"));
        }

        int status = conn.getResponseCode();
        InputStream is = (status >= 200 && status < 300)
            ? conn.getInputStream()
            : conn.getErrorStream();

        StringBuilder result = new StringBuilder();
        try (BufferedReader br = new BufferedReader(new InputStreamReader(is, "UTF-8"))) {
            while ((line = br.readLine()) != null) result.append(line);
        }

        try {
            JSONObject geminiResponse = new JSONObject(result.toString());
            String replyText = geminiResponse
                .getJSONArray("candidates")
                .getJSONObject(0)
                .getJSONObject("content")
                .getJSONArray("parts")
                .getJSONObject(0)
                .getString("text");

            JSONObject out = new JSONObject();
            out.put("reply", replyText);
            response.getWriter().write(out.toString());
        } catch (Exception e) {
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Failed to parse Gemini response\"}");
        }
    }
}