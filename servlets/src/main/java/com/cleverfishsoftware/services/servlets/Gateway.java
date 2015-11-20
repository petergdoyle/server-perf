/*
 */
package com.cleverfishsoftware.services.servlets;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import javax.servlet.ServletException;
import javax.servlet.ServletInputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author peter
 */
@WebServlet(name = "Gateway", urlPatterns = {"/Gateway"})
public class Gateway extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * more details
     * http://stackoverflow.com/questions/2793150/using-java-net-urlconnection-to-fire-and-handle-http-requests
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private final String USER_AGENT = "Mozilla/5.0";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        System.out.println(servletName + " Start::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId());

        String url = request.getParameter("proxy");
        if (url == null || url.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "missing request param 'proxy'. cannot process request");
            return;
        }

        URL proxy;
        try {
            proxy = new URL(url);
        } catch (MalformedURLException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid uri provided. check connections.");
            return;
        }

        HttpURLConnection con = (HttpURLConnection) proxy.openConnection();

        // pass the method through
        String method = request.getMethod();
        con.setRequestMethod(method);

        // set the agent
        con.setRequestProperty("User-Agent", USER_AGENT);

        // pass the params through
        String queryString = request.getQueryString();

        switch (method) {
            case "GET":

            case "POST":
                con.setDoOutput(true); // set it to POST...not enough by itself however, also need the getOutputStream call...
                con.connect();
                ServletInputStream requestBody = request.getInputStream();
                CommonUtils.copy(requestBody, con.getOutputStream());

            default:
        }

        int responseCode = con.getResponseCode();
        response.setStatus(responseCode);

        CommonUtils.copy(con.getInputStream(), response.getOutputStream());

        long endTime = System.currentTimeMillis();
        System.out.println(servletName + " End::Name="
                + Thread.currentThread().getName() + "::ID="
                + Thread.currentThread().getId() + "::Time Taken="
                + (endTime - startTime) + " ms.");
    }

// <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
