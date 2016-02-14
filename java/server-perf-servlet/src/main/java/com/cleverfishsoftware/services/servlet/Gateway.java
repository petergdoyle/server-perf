/*
 */
package com.cleverfishsoftware.services.servlet;

import com.cleverfishsoftware.services.common.CommonUtils;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Enumeration;
import javax.servlet.ServletException;
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
    private final String USER_AGENT = "User-Agent";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        String servletName = getServletName();
        long startTime = System.currentTimeMillis();
        //System.out.println(servletName + " Start::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId());

        //write(request.getInputStream(), System.out);
        String url = request.getParameter("proxy");
        if (url == null || url.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "missing request param 'proxy'. cannot process request");
            return;
        }

        URL proxyURL;
        try {
            proxyURL = new URL(url);
        } catch (MalformedURLException ex) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "invalid uri provided. check connections.");
            return;
        }

        HttpURLConnection remote = (HttpURLConnection) proxyURL.openConnection();

        Enumeration<String> parameterNames = request.getParameterNames();
        while (parameterNames.hasMoreElements()) {
            String key = parameterNames.nextElement();
            if (!key.equals("proxy")) {
                remote.setRequestProperty(key, request.getParameter(key));
            }
        }
        
        String method = request.getMethod();
        remote.setRequestMethod(method);
        
        String userAgent = request.getHeader(USER_AGENT);
        remote.setRequestProperty(USER_AGENT, userAgent);
        
        remote.connect();
        response.setStatus(remote.getResponseCode());
        response.setContentType(remote.getContentType());
        response.setContentLength(remote.getContentLength());
        response.setCharacterEncoding(remote.getContentEncoding());
        CommonUtils.copy(remote.getInputStream(), response.getOutputStream());

        long endTime = System.currentTimeMillis();
        //System.out.println(servletName + " End::Name="
//                + Thread.currentThread().getName() + "::ID="
//                + Thread.currentThread().getId() + "::Time Taken="
//                + (endTime - startTime) + " ms.");
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
